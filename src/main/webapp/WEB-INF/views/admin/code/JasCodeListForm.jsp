<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />

<script type="text/javascript">
checkPageRole("${USER_SESSION.ROLE_ID}",["ADMIN"]);//ADMIN ROLE_ID권한 허용

//그리드 변수
var mygrid<c:out value='_${pageMap.GRID_ID}'/>;
//Ajax CallBack 함수
function ajax_callback(sid,json) {
	if(sid =="sid_getGridData"){
		try {
			//JSON 처리 시 세션이 정상일 경우 처리 [파라미터:json리턴변수]
			if(!sessionCheckJSON(json)) return;
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.setImagePath('<c:url value="/resources/dhtmlx/imgs/"/>');
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.clearAll();
			var data = json.gridData;
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.parse(data,"json");
			var count = mygrid<c:out value='_${pageMap.GRID_ID}'/>.getRowsNum();
			
			if(count != 0){
				jQuery("#totalCnt").text(toNumberFormat(count));
			}
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.initMultiSort();
			getGridData<c:out value='_${pageMap.GRID_ID}'/>();
		} catch (e) {Logger.debug(e);jQuery("#loader").hide();}
	}else if(sid =="doDelete"){
		try {
			//JSON 처리 시 세션이 정상일 경우 처리  [파라미터:json리턴변수]
			if(!sessionCheckJSON(json)) return;
			var result = json.result;
			if(result == "success") {
				alert("삭제되었습니다");
				jQuery("#searchUserName").val("");
				getGridData<c:out value='_${pageMap.GRID_ID}'/>();
			}else{
				alert("삭제가 실패하였습니다.");
			}
		} catch (e) {Logger.debug(e);}
	}
}
//그리드 data
function getGridData<c:out value='_${pageMap.GRID_ID}'/>(){
	jQuery("#loader").show();
	jQuery("#allCheck").attr("checked", false);
	var data = jQuery("#searchForm").serialize();
	var sid = "sid_getGridData";
	var url =  "<c:url value="/code/JasCodeGridData.json"/>";
	ajax_sendData(sid,url,data);
}

//체크 이벤트
function doOnCheck<c:out value='_${pageMap.GRID_ID}'/> (row, cInd, state){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	if(state){
		grid.cells(row, grid.getColIndexById("CHECK_YN")).setValue("1");
	}else{
		grid.cells(row, grid.getColIndexById("CHECK_YN")).setValue("0");
	}
}

// 체크 삭제 이벤트
function deleteGridCheck(){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var count = parseInt(jQuery("#totalCnt").text());
	var checkCount=0;
	var COD_ID;
	var CDCLASS_ID;
	var flag = true;
	var USE_YN;
	
	if(!confirm("삭제하시겠습니까?")){
		return;
	}
	
	if(0 != count){
		var array = new Array();
		var sid ="doDelete";
		var url = "<c:url value="/code/codeDelete.json" />";
		
		for(var i = 1; i <= count; i++){
			// 삭제할 데이터 
			var checkYn = grid.cells(i, grid.getColIndexById("CHECK_YN")).getValue();
			COD_ID = grid.cells(i, grid.getColIndexById("COD_ID")).getValue();
			CDCLASS_ID = grid.cells(i, grid.getColIndexById("CDCLASS_ID")).getValue();
			USE_YN= grid.cells(i, grid.getColIndexById("USE_YN")).getValue();
			
			if(USE_YN == "Y" && checkYn =="1") checkCount++;
			if(checkYn == "1"){
				flag = false;
				var data = {"COD_ID" : COD_ID,"CDCLASS_ID":CDCLASS_ID,"USE_YN":USE_YN};
				array.push(data);
			}
		}
		
		if(flag){
			alert("삭제할 코드를 선택하세요.");
			return;
		}
		
		if(checkCount == 0){
			// 데이터 배열로 넘기기
			var sendData = { "saveData" : JSON.stringify(array) };
			ajax_sendData(sid,url,sendData);
		}else{
			alert("사용중인 코드는 삭제가 불가능 합니다. 사용여부를 변경해 주세요");
			return;
		}
	}
}
//전체 체크
function doAllCheck(obj){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var ids = grid.getAllRowIds().split(",");
	
	for(var i = 0; i < ids.length; i++){
		if(jQuery(obj).is(":checked")){
			grid.cells(ids[i], grid.getColIndexById("CHECK_YN")).setValue('1');
		}else{
			grid.cells(ids[i], grid.getColIndexById("CHECK_YN")).setValue('0');
		}
	}
}

//더블 클릭 이벤트
function doOnRowDblClickSelected<c:out value='_${pageMap.GRID_ID}'/>(row, cell){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	doDetailPopUp(grid.cells(row,grid.getColIndexById("COD_ID")).getValue());
}
//상세보기 팝업 호출
function doDetailPopUp(COD_ID){
	var url = '';
	
	if(COD_ID == null || COD_ID == '') return;
	
	url = '<c:url value="/code/JasCodeModifyPopup.popup" />';
	jQuery("#popCOD_ID").val(COD_ID);
	$("#target").val("detail");
	$("#popupForm").attr("target","detail");
	showWindowPopup3(jQuery("#popUpForm"), url, 600, 640, "detail","yes","yes");
}
//새로만들기 팝업 호출
function doNew(){
	try {
		var url ='';
		url = '<c:url value="/code/JasCodeModifyPopup.popup" />';
		$("#target").val("new"); 
		showWindowPopup2(jQuery("#popUpForm"), url,600, 640, "new");
	} catch(e) {
		alert(e);
	}
};

var filter;
//selectbox 변경
function changeSelectBox(){
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
}

//초기화
function doRefresh(){
	//데이터 리로드
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
}

//on click event 
function doOnRowSelected<c:url value='_${pageMap.GRID_ID}'/>(row,ind){
	if($("#totalCnt").text() == '0' || $("#totalCnt").text() == '')	return ;
	$("#selectCOD_ID").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('COD_ID')).getValue());
	$("#selectUSE_YN").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('USE_YN')).getValue());
};
 
//Enter key 막기
function captureReturnKey(e) {
	if(e.keyCode==13&& e.srcElement.type !='textarea'){
		return false;
	}
}

/*
 * 페이지 ROLE_ID 체크
 * 설명 : 권한 불일치시 대시보드창으로 이동. 팝업에서 사용시 팝업 Close / 일치하면 로딩진행 
 * 매개변수 : ("세션 롤아이디", [페이지 허가 롤아이디 리스트])
 * 
 */
checkPageRole("${USER_SESSION.ROLE_ID}",["ADMIN"]);

jQuery("document").ready(function(){
	
	viewGrid<c:out value='_${pageMap.GRID_ID}'/>();
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	
	jQuery("#btn_filter").click(function(event){
		commGridFilter('${pageMap.GRID_ID}');
	}).css("cursor", "pointer");
	
	//필터에 이벤트 발생시 체크박스 초기화
	jQuery(".hdr > tbody tr:eq(2) input").on("keydown",function(){Logger.debug("change-input");doAllCheckNot();});
	jQuery(".hdr > tbody tr:eq(2) select").change(function(){Logger.debug("change-select");doAllCheckNot();});
	
	$(window).resize();
});

$(window).resize(function(){
	var p = $("#${pageMap.GRID_ID}").offset();
	var h = $("body").height() - p.top - 30;
	var w = $("body").width() - p.left - 30;
	
	$(".chart").height(h);
	$(".chart").width(w);
	
	$("#${pageMap.GRID_ID}").width(w);
	$("#${pageMap.GRID_ID}").height(h);
});

</script>
<div id="contents" class="contWrap">
	<form id="popUpForm" method="post">
		<input type="hidden" id="popCol" name="col">
		<input type="hidden" id="popColId" name="colId">
		<input type="hidden" id="popCOD_ID" name="COD_ID" >
		<input type="hidden" id="target" name="target" >
		<input type="hidden" id="popSubType" name="subType" value="">
		<input type="hidden" name="width" id="popupWidth" value=""/>
		<input type="hidden" name="height" id="popupHeight" value=""/>
		<input type="hidden" name="ACCESS_CHECK" value="${ACCESS_CHECK}"/>
	</form>
	<form id="deleteFrom" method="post">
		<input type="hidden" id="selectCOD_ID" name="selectCOD_ID">
		<input type="hidden" id="selectUSE_YN" name="selectUSE_YN">
	</form>
	<!-- contents title start-->
	<div class="titWrap">
		<h3>코드 관리</h3>
		<input type="hidden" id="totalCnt">
	</div>
	<!-- contents title end-->
	<!-- contents search start-->
	<div class="schCon clear seachWrap">
		<form name="searchForm" id="searchForm" method="post" onkeydown="return captureReturnKey(event)">
			<input type="hidden" name="GRID_ID" value="${pageMap.GRID_ID}">
			<ul class="schCon">
				<li>
					<label for="searchUserKeyType">타입</label>
					<select id="searchUserKeyType" name="searchUserKeyType">
						<option value="">전체</option>
						<option value="CDCLASS_TYPE">코드분류</option>
						<option value="CDCLASS_ID">공통 코드 ID</option>
						<option value="COD_ID">코드 ID</option>
						<option value="COD_NM">코드 명</option>
						<option value="USE_YN">사용유무</option>
					</select>
				</li>
				<li>
					<input type="text" id="searchUserName" name="searchUserName"> 
				</li>
			</ul>
			<div class="schBtnWrap">
				<button type="button" class="btn" id="btn_refresh" title="refresh" onclick="doRefresh();">조회</button>
				<c:if test="${USER_SESSION.ROLE_ID eq 'ADMIN'}">
					<button type="button" class="btn" id="btn_new" title="new" onclick="doNew();">신규</button>
					<button type="button" class="btn btnOrange" id="btn_delete" title="delete" onclick="deleteGridCheck();" >삭제</button>
				</c:if>
			</div>
		</form>
	</div>
	<!-- contents search end-->
	<!-- contents start -->
	<div class="chart listWrap">
		<div id="${pageMap.GRID_ID}" class="tbWrap">${COD_CODE_LIST_TAG}</div>
	</div>
	<!-- contents end -->
</div>
