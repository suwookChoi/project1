<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />

<script type="text/javascript">
checkPageRole("${USER_SESSION.ROLE_ID}",["ADMIN"]);//ADMIN ROLE_ID권한 허용

//그리드 변수
var mygrid<c:out value='_${pageMap.GRID_ID}'/>;
var accessCheck = '${ACCESS_CHECK}';
var ROLEID = '${ROLE_ID}';

function ajax_callback(sid,json) {
	if(sid=="getGridData"){
		try {
			//JSON 처리 시 세션이 정상일 경우 처리 [파라미터:json리턴변수]
			if(!sessionCheckJSON(json)) return;
			var data = json.gridData;
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.setImagePath('<c:url value="/resources/dhtmlx/imgs/"/>');
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.clearAll();
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.parse(data,"json");
			
			var count = mygrid<c:out value='_${pageMap.GRID_ID}'/>.getRowsNum();
			
			if(count != 0){
				jQuery("#totalCnt").text(toNumberFormat(count));
			}
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.initMultiSort();
		} catch (e) {Logger.debug(e);}
	}else if(sid=="doDelete"){
		try {
			//JSON 처리 시 세션이 정상일 경우 처리  [파라미터:json리턴변수]
			if(!sessionCheckJSON(json)) return;
			var result = json.result;
			if(result == "success") {
				alert("삭제되었습니다.");
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
	var data = $("#searchForm").serialize();
	var sid = "getGridData";
	var url = "<c:url value="/commonCode/JasCommonCodeListJson.json"/>";
	ajax_sendData(sid,url,data);
}

//더블 클릭 이벤트
function doOnRowDblClickSelected<c:out value='_${pageMap.GRID_ID}'/>(row, cell){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var CDCLASS_ID = grid.cells(row,grid.getColIndexById("CDCLASS_ID")).getValue();
	
	if(CDCLASS_ID == null || CDCLASS_ID == '') return;
	
	$("#popCDCLASS_ID").val(CDCLASS_ID);
	$("#target").val("detail");
	//상세보기 팝업 호출
	var url = '<c:url value="/commonCode/JasCommonCodeModifyPopup.popup" />';
	showWindowPopup2(jQuery("#popUpForm"), url, 500,640, "detail");
}

function doNew(){
	var url = '<c:url value="/commonCode/JasCommonCodeModifyPopup.popup" />';
	$("#target").val("new");
	showWindowPopup3(jQuery("#popUpForm"), url, 500, 640, "new","yes","yes");
}

//체크 이벤트
function doOnCheck<c:out value='_${pageMap.GRID_ID}'/> (row, cInd, state){
	flag = true;
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	
	if(state){
		grid.cells(row, grid.getColIndexById("CHECK_YN")).setValue("1");
	}else{
		grid.cells(row, grid.getColIndexById("CHECK_YN")).setValue("0");
	}
}

// 체크 삭제 이벤트
function deleteGridCheck(){
	if(confirm("삭제하시겠습니까?\n 삭제 시 코드분류는 ETC로 변경 되며, 하위부서들의 사용여부는 'N' 으로 변경됩니다.") == false){
		return;
	} else {
		var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
		var count = parseInt(jQuery("#totalCnt").text());
		var checkCount=0;
		var CDCLASS_ID;
		var USE_YN;
		var flag = true;
		if(0 != count){
			var array = new Array();
			var sid ="doDelete";
			var url = "<c:url value="/commonCode/JasCommonCodeDeleteJson.json"/>";
			
			for(var i = 1; i <= count; i++){ 
				// 삭제할 데이터 
				var checkYn = grid.cells(i, grid.getColIndexById("CHECK_YN")).getValue();
				CDCLASS_ID = grid.cells(i, grid.getColIndexById("CDCLASS_ID")).getValue();
				USE_YN= grid.cells(i, grid.getColIndexById("USE_YN")).getValue();
				if(USE_YN == "Y" && checkYn =="1") checkCount++;
				if(checkYn == "1"){
					flag = false;
					var data = {"CDCLASS_ID":CDCLASS_ID,"USE_YN":USE_YN};
					array.push(data);
				}
			}
			
			if(flag){
				alert("삭제할 데이터를 체크하세요.");
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
	$("#selectCDCLASS_ID").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('CDCLASS_ID')).getValue());
	$("#selectUSE_YN").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('USE_YN')).getValue());
};

//Enter key 막기
function captureReturnKey(e) {
	if(e.keyCode==13&& e.srcElement.type !='textarea'){
		return false;
	}
}

jQuery("document").ready(function(){
	viewGrid<c:out value='_${pageMap.GRID_ID}'/>();
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	
	jQuery("#btn_filter").click(function(event){
		commGridFilter('${pageMap.GRID_ID}');
	}).css("cursor", "pointer");
	
	// 권한에 따라 화면 숨김 처리.
	if(ROLEID != "ADMIN"){
		mygrid<c:out value='_${pageMap.GRID_ID}'/>.setColumnHidden(mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById("CHECK_YN"), true);
	}
	
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
		<input type="hidden" id="popCDCLASS_ID" name="CDCLASS_ID" >
		<input type="hidden" id="target" name="target" >
		<input type="hidden" id="popSubType" name="subType" value="">
		<input type="hidden" name="width" id="popupWidth" value=""/>
		<input type="hidden" name="height" id="popupHeight" value=""/>
		<input type="hidden" name="ACCESS_CHECK" value="${ACCESS_CHECK}"/>
	</form>
	<form id="deleteFrom" method="post">
		<input type="hidden" id="selectCDCLASS_ID" name="selectCDCLASS_ID">
		<input type="hidden" id="selectUSE_YN" name="selectUSE_YN">
	</form>
	<!-- contents title start-->
	<div class="titWrap">
		<h3>공통 코드 관리</h3>
		<input type="hidden" id="totalCnt">
	</div>
	<!-- contents title end-->
	<!-- contents search start-->
	<div class="content-search schCon clear seachWrap">
		<form name="searchForm" id="searchForm" method="post" onkeydown="return captureReturnKey(event)">
			<input type="hidden" name="GRID_ID" value="${pageMap.GRID_ID}">
			<input type="hidden" id="fillerOpr">
			<input type="hidden" id="fillerField">
			<input type="hidden" id="fillerCon">
			<input type="hidden" id="fillerVal">
			<input type="hidden" id="fillerCol">
			<ul class="schCon clear">
				<li>
					<label>타입</label>
					<select id="searchUserKeyType" name="searchUserKeyType">
						<option value="">전체</option>
						<option value="CDCLASS_ID">코드분류ID</option>
						<option value="CDCLASS_NM">코드분류명</option>
						<option value="CDCLASS_TYPE">코드분류타입</option>
					</select>
				</li>
				<li class="">
					<input type="text" id="searchUserName" name="searchUserName"> 
				</li>
			</ul>
			<div class="schBtnWrap">
				<button id="btn_refresh" type="button" title="refresh" class="btn" onclick="javascript:doRefresh();">조회</button>
				<button id="btn_new" type="button" title="new" class="btn" onclick="doNew();">신규</button>
				<button id="btn_delete" type="button" class="btn btnOrange" onclick="deleteGridCheck();">삭제</button>
			</div>
		</form>
	</div>
	<!-- contents search end-->
	<!-- contents start -->
	<div class="chart listWrap">
		<div id="${pageMap.GRID_ID}" class="tbWrap">${COD_COMMON_CODE_LIST_TAG}</div>
	</div>
	<!-- contents end -->
</div>
