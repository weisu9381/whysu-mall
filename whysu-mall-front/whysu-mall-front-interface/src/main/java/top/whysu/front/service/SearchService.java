package top.whysu.front.service;


import top.whysu.manager.dto.front.SearchResult;

public interface SearchService {

	/**
	 * ES商品搜索
	 * @param key
	 * @param page
	 * @param size
	 * @param sort
	 * @param priceGt
	 * @param priceLte
	 * @return
	 */
	SearchResult search(String key, int page, int size, String sort, int priceGt, int priceLte);
}
