package top.whysu.front.service.impl;

import com.google.gson.Gson;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.TransportAddress;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.front.service.SearchService;
import top.whysu.manager.dto.front.SearchItem;
import top.whysu.manager.dto.front.SearchResult;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.List;

import static org.elasticsearch.index.query.QueryBuilders.matchQuery;

@Service
public class SearchServiceImpl implements SearchService{

    @Value("${ES_CONNECT_IP}")
    private String ES_CONNECT_IP;

    @Value("${ES_CLUSTER_NAME}")
    private String ES_CLUSTER_NAME;

    @Value("${ITEM_INDEX}")
    private String ITEM_INDEX;

    @Value("${ITEM_TYPE}")
    private String ITEM_TYPE;


    /**
     * 使用QueryBuilder
     * termQuery("key", obj) 完全匹配
     * termsQuery("key", obj1, obj2..)   一次匹配多个值
     * matchQuery("key", Obj) 单个匹配, field不支持通配符, 前缀具高级特性
     * multiMatchQuery("text", "field1", "field2"..);  匹配多个字段, field有通配符忒行
     */
    @Override
    public SearchResult search(String key, int page, int size, String sortType, int priceGt, int priceLte) {
        try{
            Settings settings = Settings.builder().put("cluster.name",ES_CLUSTER_NAME).build();

            TransportClient client = new PreBuiltTransportClient(settings)
                    .addTransportAddress(new TransportAddress(InetAddress.getByName(ES_CONNECT_IP), 9300));
            SearchResult searchResult=new SearchResult();
            //设置查询条件，单字段索引
            QueryBuilder qb = matchQuery("productName",key);
            //分页
            if(page <= 0){
                page = 1;
            }
            int start  =(page - 1) * size;
            //确保sort是 desc或者asc
            String sort;
            if(sortType.equals("1")){
                sort = "desc";
            }else{
                sort = "asc";
            }

            //设置高亮显示
            HighlightBuilder hiBuilder=new HighlightBuilder();
            hiBuilder.preTags("<a style=\"color: #e4393c\">");
            hiBuilder.postTags("</a>");
            hiBuilder.field("productName");

            //执行搜索
            SearchResponse searchResponse = null;

            if(priceGt>=0&&priceLte>=0){
                searchResponse=client.prepareSearch(ITEM_INDEX)
                        .setTypes(ITEM_TYPE)
                        .setSearchType(SearchType.DFS_QUERY_THEN_FETCH)
                        .setQuery(qb)	// Query
                        .setFrom(start).setSize(size).setExplain(true)	//从第几个开始，显示size个数据
                        .highlighter(hiBuilder)//设置高亮显示
                        .setPostFilter(QueryBuilders.rangeQuery("salePrice").gt(priceGt).lt(priceLte))	//过滤条件
                        /*因为Elasticsearch对 text字段默认关闭 fieldData ,据说开启的话很昂贵，我又不懂该怎么开启，于是把这行注释掉就好*/
                        /*.addSort("salePrice", SortOrder.fromString(sort))*/
                        .get();
            }else if((priceGt<0||priceLte<0)){
                searchResponse=client.prepareSearch(ITEM_INDEX)
                        .setTypes(ITEM_TYPE)
                        .setSearchType(SearchType.DFS_QUERY_THEN_FETCH)
                        .setQuery(qb)	// Query
                        .setFrom(start).setSize(size).setExplain(true)	//从第几个开始，显示size个数据
                        .highlighter(hiBuilder)		//设置高亮显示
                        /*.addSort("salePrice",SortOrder.fromString(sort))*/
                        .get();
            }

            SearchHits hits = searchResponse.getHits();
            searchResult.setRecordCount(hits.totalHits);
            List<SearchItem> list = new ArrayList<>();
            if(hits.totalHits > 0){
                for(SearchHit hit : hits){
                    //总页数
                    int totalPage=(int) (hit.getScore()/size);
                    if((hit.getScore()%size)!=0){
                        totalPage++;
                    }
                    //返回结果总页数
                    searchResult.setTotalPages(totalPage);
                    //设置高亮字段
                    SearchItem searchItem=new Gson().fromJson(hit.getSourceAsString(),SearchItem.class);
                    String productName = hit.getHighlightFields().get("productName").getFragments()[0].toString();
                    searchItem.setProductName(productName);
                    //返回结果
                    list.add(searchItem);
                }
            }
            searchResult.setItemList(list);
            return searchResult;
        }catch (Exception e){
            e.printStackTrace();
            throw new WhysuMallException("查询ES索引库失败");
        }

    }
}
