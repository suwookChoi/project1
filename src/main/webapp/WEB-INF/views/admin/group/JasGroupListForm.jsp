<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />
<% String ctxPath = request.getContextPath(); %>
<script type="text/javascript">
//그리드 변수
var mygrid<c:out value='_${pageMap.GRID_ID}'/>;

//Ajax Callback
function ajax_callback(sid,json) {
	if(sid =='gridData'){
		try {		
			//JSON 처리 시 세션이 정상일 경우 처리 [파라미터:json리턴변수]
			if(!sessionCheckJSON(json)) return;
			
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.setImagePath('<c:url value="/resources/dhtmlx/imgs/"/>');
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.clearAll();		
			
			var data = json.gridData;
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.parse(data,"json");
			
			var count = mygrid<c:out value='_${pageMap.GRID_ID}'/>.getRowsNum();	
			
			if(count == 0){
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.enableColSpan(true);
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.addRow(0, [_TEXT_NOROW]);
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.setColspan(0, 0, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColumnsNum());
			}
			
			if(count != 0){					
			
				jQuery("#totalCnt").text(toNumberFormat(count));
				
			}	
			
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.initMultiSort();
			
			jQuery("#loader").hide();
			
		} catch (e) {Logger.debug(e);jQuery("#loader").hide();
		}	
	}else if( sid == 'doDelete'){
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
				return;
			}
		} catch (e) {Logger.debug(e);} 
	}
}

//그리드 data
function getGridData<c:out value='_${pageMap.GRID_ID}'/>(){
	
	var sid;
	var url;
	var data;	 
	
	sid='gridData';
	url='<c:url value="/group/JasGroupListGridData.json"/>';
	data =jQuery("#searchForm").serialize();
	
	ajax_sendData(sid,url,data);
}

// 그룹 삭제
function doDelete(){		
	
	var sid;
	var url;
	var data;
	var DEPT_CD = $("#selectDEPTCD").val();
	
	sid='doDelete';
	url='<c:url value="/group/deleteGroup.json"/>';
	data ={"DEPT_CD" : DEPT_CD};	
	
	var checkUse = $("#selectUSEYN").val();
	
	if(confirm("삭제하시겠습니까?\n 삭제 시 하위부서들의 사용여부는 'N' 으로 변경됩니다.") == true){
		
		if(checkUse == 'Y') {
			
			alert("사용중인 회사는 삭제가 불가능 합니다. 사용여부를 변경해 주세요");
			return;
			
		}
		
		else ajax_sendData(sid,url,data);			
	} 			
	
};

//더블 클릭 이벤트
function doOnRowDblClickSelected<c:out value='_${pageMap.GRID_ID}'/>(row, cell){
	
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var DEPT_CD = grid.cells(row,grid.getColIndexById("DEPT_CD")).getValue();
	
	doDetailPopUp(DEPT_CD);
	
}

//상세보기 팝업 호출
function doDetailPopUp(DEPT_CD){
	var url = '';	
	
	if(DEPT_CD == null || DEPT_CD == '') return;
	
	jQuery("#popupWidth").val('500');
	jQuery("#popupHeight").val('500');
	jQuery("#popStat").val("detail");
	$("#popDEPT_CD_EDIT").val(DEPT_CD);		
	url = '<c:url value="/group/JasGroupRegisterPopup.popup"/>';
	showWindowPopup2(jQuery("#popUpForm"), url, 500, 640, "detail");
}

//신규 그룹 등록
function doNew(){
	try {				
		var url = '<c:url value="/group/JasGroupRegisterPopup.popup"/>'; 
		$("#popupForm").attr("target" , 'Popup_UserRegistPopup');
		window.open(url , 'Popup_GroupRegistPopup' , "width=500,height=640, scrollbars=yes").focus();
	} catch(e) {
		alert(e);
	}
};

var filter;

//초기화
function doRefresh(){
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
}

//on click event 
function doOnRowSelected<c:url value='_${pageMap.GRID_ID}'/>(row,ind){
	if($("#totalCnt").text() == '0' || $("#totalCnt").text() == '')	return ;
	$("#selectDEPTCD").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('DEPT_CD')).getValue());
	$("#selectUSEYN").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('USE_YN')).getValue());
};

//Enter key 막기
function captureReturnKey(e) {
	if(e.keyCode==13&& e.srcElement.type !='textarea')
		return false;
}
 
jQuery("document").ready(function(){

	viewGrid<c:out value='_${pageMap.GRID_ID}'/>();
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	
	// create 버튼 클릭
	
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
	var w = $("body").width() - p.left - 40;
	
	$(".chart").height(h);
	$("#${pageMap.GRID_ID}").width(w);
	$("#${pageMap.GRID_ID}").height(h);
});
</script>
<div id="contents" class="contWrap" onkeydown="return captureReturnKey(event)">
	<form id="popUpForm" method="post">
		<input type="hidden" id="popCol" name="col">
		<input type="hidden" id="popColId" name="colId">
		<input type="hidden" id="popDEPT_CD_EDIT" name="DEPT_CD_EDIT">
		<input type="hidden" id="popSubType" name="subType" value="">
		<input type="hidden" name="width" id="popupWidth" value=""/>
		<input type="hidden" name="height" id="popupHeight" value=""/>
		<input type="hidden" name="ACCESS_CHECK" value="${ACCESS_CHECK}"/>
	</form>
	<form id="deleteFrom" method="post">
		<input type="hidden" id="selectDEPTCD" name="col">
		<input type="hidden" id="selectUSEYN" name="col">
	</form>
	<!-- contents title start-->
	<div class="titWrap">
		<h3>조직 관리</h3>
		<input id="totalCnt" type="hidden"/>
	</div>
	<!-- contents title end-->
	<!-- contents search start-->
	
	<div class="schCon clear seachWrap">
		<form name="searchForm" id="searchForm" method="post" onkeydown="return captureReturnKey(event)">
			<input type="hidden" name="GRID_ID" value="${pageMap.GRID_ID}">
			<ul class="schCon clear">
				<li>
					<label for="searchUserKeyType"> 타입</label>
					<select id="searchUserKeyType" name="searchUserKeyType">
						<option value="">전체</option>
						<option value="COMPANY_NM">회사명</option>
						<option value="ARP_NM">지점</option>
						<option value="USE_YN">사용여부</option>
					</select>
				</li>
				<li>
					<input type="text" id="searchUserName" name="searchUserName" >
				</li>
			</ul>
			<div class="schBtnWrap">
				<button type="button" id="btn_refresh" class="btn" onclick="doRefresh();">조회</button>
				<c:if test="${USER_SESSION.ROLE_ID eq 'ADMIN'}">
					<button type="button" id="btn_new" class="btn" onclick="doNew();">신규</button>
					<button type="button" id="btn_delete" class="btn btnOrange" onclick="doDelete();">삭제</button>
				</c:if>
			</div>
		</form>
	</div>
	<!-- contents search end-->
	<!-- contents start -->
	<div class="chart listWrap">
		<div class="grid_box">
			<div id="${pageMap.GRID_ID}" class="tbWrap">${GRP_LIST_TAG}</div>
		</div> 
	</div>
	<!-- contents end -->
	<form id="goDetailFrom">
		<input type="hidden" id="goDetailID" name="goDetailID" />
	</form>
</div>
