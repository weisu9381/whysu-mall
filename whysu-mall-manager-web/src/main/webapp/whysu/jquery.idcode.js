/**
 * idcode 1.0 - validate user.
 * Version 1.0
 * @requires jQuery v1.2
 * author ehong[idehong@gmail.com]
 **/

/**
 * @example: $.idcode.setCode();	
 * @desc: Make a validate code append to the element that id is idcode.
 *
 * @example $.idcode.validateCode();	
 * @desc return true if user input value equal idcode. 
 **/
 
(function($){
	var settings = {
			e	 		: 'idcode',
			len: 4, //len是修改验证码长度的
			codeTip		: ' 刷新验证码',
			inputID		: 'Txtidcode'//验证元素的ID
		};
	
	var _set = {
		storeLable  : 'codeval', //保存验证码value的key
		store		: '#ehong-code-input',
		codeval		: '#ehong-code'
	};
	$.idcode = {
		getCode:function(){
			return _storeData(_set.storeLable, null);
		},
		setCode:function(){
			setCodeStyle("#"+settings.e, settings.len);
		},
		validateCode:function(){
			var inputV;
			if(settings.inputID){
				inputV=$('#' + settings.inputID).val();
			}else{
				inputV=$(_set.store).val();
			}
			if(inputV.toUpperCase() == _storeData(_set.storeLable, null).toUpperCase()){//修改的不区分大小写
				return true;
			}else{
				setCodeStyle("#"+settings.e , settings.len);
				return false;
			}
		}
	};

	function _storeData(dataLabel, data){
		var store = $(_set.codeval).get(0);
		if(data){
			$.data(store, dataLabel, data);
		}else{
			return $.data(store, dataLabel);
		}
	}

	function setCodeStyle(id, len){
		var codeObj = createCode(len);
		var randNum = Math.floor(Math.random()*6);
		var htmlCode='';
		if(!settings.inputID){
			htmlCode='<span><input id="ehong-code-input" type="text" maxlength="4" /></span>';
		}
		htmlCode+='<div id="ehong-code" class="ehong-idcode-val ehong-idcode-val';
		htmlCode+=String(randNum);
		htmlCode+='" href="#" onclick="$.idcode.setCode()">' + setStyle(codeObj) + '</div>' + '<span id="ehong-code-tip-ck" class="ehong-code-val-tip" onclick="$.idcode.setCode()">'+ settings.codeTip +'</span>';
		$(id).html(htmlCode);
		_storeData(_set.storeLable, codeObj);
	}

	function setStyle(codeObj){
		var fnCodeObj = new Array();
		var col = new Array('#BF0C43', '#E69A2A','#707F02','#18975F','#BC3087','#73C841','#780320','#90719B','#1F72D8','#D6A03C','#6B486E','#243F5F','#16BDB5');
		var charIndex;
	   	for(var i=0;i<codeObj.length;i++){		
			charIndex = Math.floor(Math.random()*col.length);
			fnCodeObj.push('<font color="' + col[charIndex] + '">' + codeObj.charAt(i) + '</font>');
		}
		return fnCodeObj.join('');		
	}

	 function createCode(codeLength){
	   var code = "";
	   var selectChar = new Array('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
		
	   for(var i=0;i<codeLength;i++){
		   var charIndex = Math.floor(Math.random()*selectChar.length);
		   if(charIndex % 2 == 0){
			   code+=selectChar[charIndex].toLowerCase();
		   }else{
			   code +=selectChar[charIndex];
		   }
	   }
	   return code;
	 }
   
})(jQuery);