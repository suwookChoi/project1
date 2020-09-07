<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />
<script type="text/javascript">
checkPageRole("${USER_SESSION.ROLE_ID}",["ADMIN"]);//ADMIN ROLE_ID권한 허용
var mygrid<c:out value='_${pageMap.GRID_ID}'/>;

//데이터 로드
function getGridData<c:out value='_${pageMap.GRID_ID}'/>(){
	var data = jQuery("#searchForm").serialize();
	var url = "<c:url value="/admin/airport/getAirportList.json"/>";
	var sid = "search";
	
	ajax_sendData(sid, url, data);
}

//찾기
function doSearch(){
	jQuery("#loader").show();
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	jQuery("#loader").hide();
}

function ajax_callback(sid, json){
	if(sid == "search"){
		mygrid<c:out value='_${pageMap.GRID_ID}'/>.setImagePath('<c:url value="/resources/dhtmlx/imgs/"/>');
		mygrid<c:out value='_${pageMap.GRID_ID}'/>.saveFilterData(["ARP"]);
		mygrid<c:out value='_${pageMap.GRID_ID}'/>.clearAll();
		
		var data = json.gridData;
		mygrid<c:out value='_${pageMap.GRID_ID}'/>.parse(data,"json");
		
		var count = mygrid<c:out value='_${pageMap.GRID_ID}'/>.getRowsNum();
		
		if(count != 0){
			jQuery("#totalCnt").text(toNumberFormat(count));
		}
		
		mygrid<c:out value='_${pageMap.GRID_ID}'/>.initMultiSort();
		mygrid<c:out value='_${pageMap.GRID_ID}'/>.loadFilterData(["ARP"]);
	} else if(sid == "delete"){
		var result = json.result;
		
		if(result == "success"){
			getGridData<c:out value='_${pageMap.GRID_ID}'/>();
		}else{
			alert("삭제가 실패하였습니다.");
		}
	}
}

jQuery("document").ready(function() {
	jQuery("#loader").hide();
	
	viewGrid<c:out value='_${pageMap.GRID_ID}'/>();
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	
	// create 버튼 클릭
	jQuery("#btn_new").click(function(event){
		doCreate();
	}).css("cursor", "pointer");
	
	jQuery("#btn_filter").click(function(event){
		commGridFilter('${pageMap.GRID_ID}');
	}).css("cursor", "pointer");
	
	//삭제버튼 클릭
	jQuery("#btn_delete").click(function(event){
		deleteSfsGridCheck();
	}).css("cursor", "pointer");
	
	$(window).resize();
});

function doCreate(){
	var url = '';
	
	jQuery("#popStat").val("create");
	
	url = '<c:url value="/admin/airport/codAirportCreatePopup.popup"/>';
	showWindowPopup2(jQuery("#popUpForm"), url, 550, 640, "CreateAirport");
}

// 초기화
function doRefresh(){
	//데이터 리로드
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
}

//더블 클릭 이벤트
function doOnRowDblClickSelected<c:out value='_${pageMap.GRID_ID}'/>(row, cell){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var arp = grid.cells(row,grid.getColIndexById("ARP")).getValue();
	doDetailPopUp(arp);
}

//상세보기 팝업 호출
function doDetailPopUp(arp){
	var url = '';
	
	if(arp == null || arp == '') return;
	
	jQuery("#popArp").val(arp);
	jQuery("#popupWidth").val('580');
	jQuery("#popupHeight").val('810');
	jQuery("#popStat").val("detail");
	
	url = '<c:url value="/admin/airport/codAirportCreatePopup.popup"/>';
	
	showWindowPopup2(jQuery("#popUpForm"), url, 550, 640, "DetailAirport");
}

$(window).resize(function(){
	var p = $("#${pageMap.GRID_ID}").offset();
	var h = $("body").height() - p.top - 30;
	var w = $("body").width() - p.left - 30;
	
	$(".chart").height(h);
	$("#${pageMap.GRID_ID}").width(w);
	$("#${pageMap.GRID_ID}").height(h);
});

//체크 이벤트
function doOnCheck<c:out value='_${pageMap.GRID_ID}'/> (rId, cInd, state){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	
	if(state){
		grid.cells(rId, grid.getColIndexById("CHECK_YN")).setValue("1");
	}else{
		grid.cells(rId, grid.getColIndexById("CHECK_YN")).setValue("0");
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

//전체 체크 박스 해제
function doAllCheckNot(){
	//필터 클릭 시 체크박스 전체해제
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var count = parseInt(jQuery("#totalCnt").text());
	
	for(var i = 1; i <= count; i++){
		grid.cells(i, grid.getColIndexById("CHECK_YN")).setValue('0');
	}
	
	jQuery("#allCheck").attr("checked", false);
	//필터 클릭 시 체크박스 전체해제
}

//체크 선택 삭제
function deleteSfsGridCheck(){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var count = grid.getRowsNum();
	var flag = true;
	
	for(var i = 1; i <= count; i++){ //2배수로 체크박스 점검
		var checkYn = grid.cells(i, grid.getColIndexById("CHECK_YN")).getValue();
		
		if(checkYn == "1"){
			flag = false;
			break;
		}
	}
	
	if(flag){
		alert("삭제할 공항을 선택하세요.");
		return;
	}
	
	if(!confirm("삭제하시겠습니까?")){
		return;
	}
	
	var data = {"extractList" : extractData()};
	var url = "<c:url value="/admin/airport/deleteAirport.json"/>";
	var sid = "delete";
	
	ajax_sendData(sid, url, data);
}

function extractData(){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var list = grid.getAllRowIds().split(",");
	var listSize = list.length;
	var extractList = new HashMap();
	var idx = 0;
	
	for(var i = 0; i < listSize ; i++){
		var checkYn = grid.cells(list[i], grid.getColIndexById("CHECK_YN")).getValue();
		
		if(checkYn != '0'){
			var arp = grid.cells(list[i], grid.getColIndexById("ARP")).getValue();
			var extractDataMap = new HashMap();
			extractDataMap.put("ARP", arp);
			extractList.put(idx++, extractDataMap.toString());
		}
	}
	
	return extractMaptoString(extractList);
}

function extractMaptoString(map){
	var res = '';
	
	for(key in map.getKeys()){
		if(res.length > 0) res += ',';
		res += '"' + key + '": ' + map.get(key);
	}
	
	return '{' + res + '}';
}

</script>
<div id="contents" class="contWrap">
	<form id="popUpForm" method="post">
		<input type="hidden" id="popStat" name="stat">
		<input type="hidden" id="popArp" name="ARP">
	</form>
	<!-- contents title start-->
	<div class="content-top fix titWrap">
		<h3>공항 관리</h3>
	</div>
	<!-- contents title end-->
	<!-- contents search start-->
	<form name="searchForm" id="searchForm" method="post" onsubmit="return false;">
		<input type="hidden" name="GRID_ID" value="${pageMap.GRID_ID }">
		<input type="hidden" id="airportCd" name="ARP">
		<div class="content-search schCon clear seachWrap">
			<ul class="schCon clear">
				<li>
					<label>타입</label>
					<select id="searchType" name="searchType">
						<option value="ARP" selected>공항</option>
						<option value="ICAO">공항ICAO</option>
						<option value="NTC">국가 코드</option>
						<option value="NTNM">국가</option>
					</select>
				</li>
				<li>
					<input type="text" id="searchText" name="searchText">
				</li>
			</ul>
			<div class="schBtnWrap">
				<button type="button" class="btn" onclick="javascript:doSearch();" id="btn_refresh" title="refresh">조회</button>
				<button type="button" class="btn" id="btn_new" title="new">신규</button>
				<button type="button" class="btn btnOrange" id="btn_delete" title="delete">삭제</button>
			</div>
		</div>
	</form>
	<!-- contents search end-->
	<!-- contents start -->
	<div class="chart listWrap">
		<div id="${pageMap.GRID_ID}" class="tbWrap">${COD_AIRPORT_TAG}</div>
	</div>
	<!-- contents end -->
</div>
