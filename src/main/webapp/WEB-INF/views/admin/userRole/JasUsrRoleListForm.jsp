<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />
<% String ctxPath = request.getContextPath(); %>
<script type="text/javascript">
checkPageRole("${USER_SESSION.ROLE_ID}",["ADMIN"]);//ADMIN ROLE_ID권한 허용
//그리드 변수
var mygrid<c:out value='_${pageMap.GRID_ID}'/>;
// Ajax CallBack 함수
function ajax_callback(sid,json) {
	// 그리드 데이터
	if(sid == 'sid_getGridData'){
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
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.addRow(0, ["1","No data found."]);
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.setColspan(0, 1, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColumnsNum()-1);
			}
			if(count != 0){
				jQuery("#totalCnt").text(toNumberFormat(count));
			}
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.initMultiSort();
			jQuery("#loader").hide();
		} catch (e) {Logger.debug(e);jQuery("#loader").hide();}
	}else if(sid == 'doDelete'){	//삭제하기
		if(!sessionCheckJSON(json)) return;
		var result = json.result;
		if(result == "success") {
			alert("삭제되었습니다.");
			jQuery("#searchUserName").val("");
			getGridData<c:out value='_${pageMap.GRID_ID}'/>();
		}else{
			alert("삭제가 실패하였습니다.");
			getGridData<c:out value='_${pageMap.GRID_ID}'/>();
		}
	}
}

// 그리드 데이터 불러오기
function getGridData<c:out value='_${pageMap.GRID_ID}'/>() {
	var data = jQuery("#searchForm").serialize();
	var sid = "sid_getGridData";
	var url = "<c:url value="/role/RoleData.json"/>";
	
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
	if(confirm("삭제하시겠습니까?") == false){
		return;
	} else{
		var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
		var count = parseInt(jQuery("#totalCnt").text());
		var flag = true;
		var checkCount=0;
		var ROLE_ID;
		var USE_YN;
		
		if(0 != count){
			var array = new Array();
			var sid ="doDelete";
			var url = "<c:url value="/role/roleDelete.json"/>";
			
			for(var i = 1; i <= count; i++){
				// 삭제할 데이터
				var checkYn = grid.cells(i, grid.getColIndexById("CHECK_YN")).getValue();
				ROLE_ID = grid.cells(i, grid.getColIndexById("ROLE_ID")).getValue();
				USE_YN= grid.cells(i, grid.getColIndexById("USE_YN")).getValue();
				
				if(USE_YN == "Y" && checkYn =="1") checkCount++;
				
				if(checkYn == "1"){
					flag = false;
					var data = {"ROLE_ID" : ROLE_ID,"USE_YN":USE_YN};
					array.push(data);
				}
			}
			
			if(flag){
				alert("삭제할 권한을 선택하세요.");
				return;
			}
			
			if(checkCount == 0){
				// 데이터 배열로 넘기기
				var sendData = { "saveData" : JSON.stringify(array) };
				ajax_sendData(sid,url,sendData);
			}else{
				alert("사용중인 권한은 삭제가 불가능 합니다. 사용여부를 변경해 주세요");
				return;
			}
		}
	}
}

//더블 클릭 이벤트
function doOnRowDblClickSelected<c:out value='_${pageMap.GRID_ID}'/>(row, cell){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	// 상세보기 팝업 호출
	doDetailPopUp(grid.cells(row, grid.getColIndexById("ROLE_ID")).getValue());
}

//상세보기 팝업 호출
function doDetailPopUp(roleid){
	var url = '';
	
	if(roleid == null || roleid == '' ) return;
	
	jQuery("#popSubType").val('detail');
	$("#popROLE_ID").val(roleid);
	
	url = '<c:url value="/role/RoleDetailPopup.popup"/>';
	showWindowPopup2(jQuery("#popUpForm"), url, 600, 640, "detail");
}

// 새 항목 추가 팝업 호출
function doNew(){
	jQuery("#popROLE_ID").val('');
	jQuery("#popSubType").val('new');
	
	url = '<c:url value="/role/RoleDetailPopup.popup"/>';
	showWindowPopup2(jQuery("#popUpForm"), url, 600, 640, "new");
};

var filter;

//초기화
function doRefresh(){
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
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
		<input type="hidden" id="popROLE_ID" name="ROLE_ID">
		<input type="hidden" id="popSubType" name="subType">
		<input type="hidden" name="ACCESS_CHECK" value="${ACCESS_CHECK}"/>
	</form>
	<form id="deleteFrom" method="post">
		<input type="hidden" id="popROLE_ID" name="ROLE_ID">
	</form>
	<!-- contents title start-->
	<div class="titWrap">
		<h3>권한 관리 </h3>
		<input type="hidden" id="totalCnt">
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
						<option value="ROLE_NM">권한명</option>
						<option value="ROLE_ID">권한 ID</option>
						<option value="USE_YN">사용여부</option>
					</select>
					</li>
					<li>
					<input type="text" id="searchUserName" name="searchUserName" >
				</li>
			</ul>
			<div class="schBtnWrap">
				<c:if test="${USER_SESSION.ROLE_ID eq 'ADMIN'}">
					<button type="button" id="btn_refresh" class="btn" onclick="doRefresh();">조회</button>
					<button type="button" id="btn_new" class="btn" onclick="doNew();">신규</button>
					<button type="button" id="btn_delete" class="btn btnOrange" onclick="deleteGridCheck();">삭제</button>
				</c:if>
			</div>
		</form>
	</div>
	<!-- contents search end-->
	<!-- contents start -->
	<div class="chart listWrap">
		<div class="grid_box">
			<div id="${pageMap.GRID_ID}" class="tbWrap">${USR_USRROLE_LIST_TAG}</div>
		</div>
	</div>
	<!-- contents end -->
	<form id="goDetailFrom">
		<input type="hidden" id="goDetailID" name="goDetailID" />
	</form>
</div>
