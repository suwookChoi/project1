<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<script type="text/javascript" charset="utf-8" src="<c:url value="/resources/js/pak/smart.date.js"/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />
<script type="text/javascript" charset="utf-8" src="<c:url value="/resources/dhtmlx/dhtmlxcombo.js"/>"></script>

<script type="text/javascript">

function ajax_callback(sid,json) {
	var type="${type}";
	//저장하기
	if(sid == "doSave"){
		if(!sessionCheckJSON(json)) return;
		var result = json.result;
		if(result == "success"){
			alert("저장에 성공하였습니다.");
	 		opener.doRefresh(); 
			window.close();
		}else{
			alert("저장에 실패하였습니다.");
			return;
		}
	}else if(sid=="idCheck"){//공통코드 ID 중복검사
		var result = json.result;
		if(result == 0){
			doSave();
		}else{
			alert("이미 사용중인 코드 ID 입니다.");
			return;
		}
	}	
}

//코드 ID 중복검사
function idCheck() {
	var data;
	var url;
	var sid = "idCheck";	
	var type = "${type}";
	if(type=="new"){
		data = {"CDCLASS_ID" : $("#NEW_CDCLASS_ID").val()};
		url = "<c:url value="/commonCode/CommoneCodeIdCheck.json"/>";
		ajax_sendData(sid, url, data);	
	}else{
		doSave();
	}	
}
// 저장하기
function doSave() {
	var type = "${type}";
	var sid ="doSave";
	var data;
	if(type == 'new'){
		data = {"saveType" : type,
				"CDCLASS_ID" : $("#NEW_CDCLASS_ID").val(),
				"CDCLASS_NM" : $("#CDCLASS_NM").val(),
				"CDCLASS_TYPE" : $("#CDCLASS_TYPE").val(),
				"DSC" : $("#DSC").val(),
				"USE_YN" : $("#USE_YN").val()					
			}
	}else{
		data = {"saveType" : type,
				"CDCLASS_ID" : $("#CDCLASS_ID").val(),
				"CDCLASS_NM" : $("#CDCLASS_NM").val(),
				"CDCLASS_TYPE" : $("#CDCLASS_TYPE").val(),
				"DSC" : $("#DSC").val(),
				"USE_YN" : $("#USE_YN").val()					
			};
	}
	var url = "<c:url value="/commonCode/JascommonCodeModifySave.json"/>";
	ajax_sendData(sid, url, data);	
}

$("document").ready(function() { 
	var type = "${type}";
 	 if(type == 'detail'){
		$('#USE_YN').val('${SELECTDATA.USE_YN}');
	}else{
		$('#USE_YN').val('Y');
	}  
	jQuery(".enter").keydown(function(event){
		if(event.keyCode == 13) {
			event.preventDefault();
		}
	});	
 	$("#btn_save").click(function(){
 		var CDCLASS_ID;
 		if(type == 'new'){ CDCLASS_ID =$("#NEW_CDCLASS_ID").val(); }
 		else{ CDCLASS_ID =$("#CDCLASS_ID").val(); }
 		
 		var CDCLASS_NM=$("#CDCLASS_NM").val();
 		var CDCLASS_TYPE=$("#CDCLASS_TYPE").val();
 		var USE_YN=$("#USE_YN").val(); 		
 		CDCLASS_ID = $.trim(CDCLASS_ID);
 		CDCLASS_NM = $.trim(CDCLASS_NM);
 		CDCLASS_TYPE = $.trim(CDCLASS_TYPE);
 		
 		if(CDCLASS_ID == null || CDCLASS_NM == null || CDCLASS_TYPE == null || USE_YN==null || CDCLASS_ID== ''|| CDCLASS_NM==''|| CDCLASS_TYPE == ''|| USE_YN==''){
 			alert("필수 항목을 확인해 하세요");
 			return;
 		}else{
 			idCheck();	
 		} 		
	}).css("cursor", "pointer");

});	


</script>
<div class="popupWrap">
	<div class="contWrap">
		<form id="popUpForm" name="popUpForm" method="post">
			<input type="hidden" id="imgUrl" name="imgUrl"/>
		</form>
	<!-- contents title start--> 
	<!-- contents title end-->
	<div class="titWrap">
		<c:if test="${SELECTDATA.CDCLASS_ID ne null}">
			<h3>공통 코드 상세보기</h3>
		</c:if>
		<c:if test="${SELECTDATA.CDCLASS_ID eq null}">
			<h3>공통 코드 등록</h3>
		</c:if>
	</div>
	<!-- contents start -->
	<div class="popConWrap scrPop">	
		<form name="updateForm" id="updateForm" method="post">
			
				<ul class="pIptWrap w150">
					<li>
						<label class="rq">코드분류 ID</label>
						<c:if test="${type eq 'detail'}">
							<input type="text" id="CDCLASS_ID" name="CDCLASS_ID" readonly="readonly" disabled="disabled" value="${SELECTDATA.CDCLASS_ID}"/>
						</c:if>									
						<c:if test="${type eq 'new'}">
							<input type="text" id="NEW_CDCLASS_ID" maxlength="15" onkeyup="javascript:engCheck2(this)" fname=" " name="CDCLASS_ID" />
						</c:if>
					</li>
					<li>
						<label class="rq">코드분류 명</label>
						<input type="text" id="CDCLASS_NM" maxlength="50" name="CDCLASS_NM" value="${SELECTDATA.CDCLASS_NM}"/>
					</li>
					<li>
						<label class="rq">코드분류 타입</label>
						<input type="text" id="CDCLASS_TYPE"  maxlength="10" onkeyup="javascript:engCheck2(this)" fname=" " name="CDCLASS_TYPE" value="${SELECTDATA.CDCLASS_TYPE}"/>
					</li>				
					<li>			
						<label>기타</label>
						<textarea id="DSC" name="DSC" maxlength="350"><c:out value="${SELECTDATA.DSC}" /></textarea>
					</li>
					<li>					
						<label class="rq">사용여부</label>
						<select id="USE_YN" name="USE_YN" >	
							<option value="Y">Y</option>
							<option value="N">N</option>																																			
						</select>
					</li>
				</ul>
			<!-- //double_box -->
		</form>
	</div>
		<div class="popBtnWrap" title="save"><!-- 버튼이 2개일때 클래스 추가 class="popBtn" -->
				<button id="btn_save">저장</button>
		</div>
	</div>
</div>
