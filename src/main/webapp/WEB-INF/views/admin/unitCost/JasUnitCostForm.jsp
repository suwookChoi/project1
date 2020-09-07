<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
		mygrid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
		mygrid.enableRowspan(true);
		
		mygrid.clearAll();
		mygrid.parse(json.gridData,"json");
		
		setGridRowSpan(mygrid, 1);
		setGridRowSpan(mygrid, 2, 1);
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

//그리드 데이터 병합 (그리드, 병합할 컬럼 인덱스, 컬럼 나누는 서브 컬럼 인덱스)
function setGridRowSpan(grid, col, subCol1){
	var rowCnt = grid.getRowsNum();
	var size = 0;
	var bef_colVal=null;
	var col2 = fn_isEmpty(subCol1) ? col : subCol1;
	
	$("#totalCnt").val(rowCnt);
	
	for(rowNum=1; rowNum<=rowCnt; rowNum++){
		var colVal = grid.cells(rowNum,col).getValue();
		var colVal2 = grid.cells(rowNum,col2).getValue();
		
		if(bef_colVal != null){
			if(rowNum == rowCnt){
				if(bef_colVal == colVal){
					grid.setRowspan(rowNum-size, col, size+1);
				}else{
					grid.setRowspan(rowNum-size, col, size);
				}
			}else{
				if(bef_colVal != colVal || colVal != colVal2){
					grid.setRowspan(rowNum-size, col, size);
					size = 0;
				}
			}
		}
		size++;
		bef_colVal = colVal;
	}
}

// 그리드 데이터 불러오기
function getGridData<c:out value='_${pageMap.GRID_ID}'/>() {
	var data = jQuery("#searchForm").serialize();
	var sid = "sid_getGridData";
	var url = "<c:url value="/unitCost/UnitCostGridData.json"/>";
	ajax_sendData(sid,url,data);
}

function doOnRowSelected<c:url value='_${pageMap.GRID_ID}'/>(row,ind){
	$("#selectAIRCRAFT").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('HIDARIRCRAFT')).getValue());
	$("#selectARP").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('ARP_NM')).getValue());
	$("#selectCOD_ID").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('COD_ID')).getValue());
};

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
	var checkUse = $("#selectUSEYN").val();
	if(confirm("삭제하시겠습니까?") == false){
		return;
	} else{
		var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
		var count = parseInt($("#totalCnt").val());
		var flag = true;
		var checkYn;
		var END_DT;
		var AIRCRAFT;
		var ARP;
		var GHTYPE;
		var START_DT;
		
		if(0 != count){
			var array = new Array();
			var sid ="doDelete";
			var url = "<c:url value="/unitCost/deleteunitCost.json"/>";
			
			for(var i = 1; i <= count; i++){
				// 삭제할 데이터
				var checkYn = grid.cells(i, grid.getColIndexById("CHECK_YN")).getValue();
				AIRCRAFT = grid.cells(i, grid.getColIndexById("HIDARIRCRAFT")).getValue();
				ARP = grid.cells(i, grid.getColIndexById("ARP_NM")).getValue();
				COD_ID= grid.cells(i, grid.getColIndexById("COD_ID")).getValue();
				START_DT = grid.cells(i, grid.getColIndexById("START_DT")).getValue().replace(/\./g,'');
				END_DT = grid.cells(i, grid.getColIndexById("END_DT")).getValue().replace(/\./g,'');
				
				if(checkYn == "1"){
					flag = false;
					
					var data = {"AIRCRAFT" : AIRCRAFT,"ARP":ARP,"COD_ID":COD_ID,"START_DT":START_DT,"END_DT":END_DT};
					array.push(data);
				}
			}
			
			if(flag){
				alert("삭제할 데이터를 체크하세요.");
				return;
			}
			// 데이터 배열로 넘기기
			var sendData = { "saveData" : JSON.stringify(array) };
			ajax_sendData(sid,url,sendData);
		}
	}
}

//더블 클릭 이벤트
function doOnRowDblClickSelected<c:out value='_${pageMap.GRID_ID}'/>(row, cell){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var mm = grid.cells(row, grid.getColIndexById("START_DT_MM")).getValue();
	
	if(mm < 10) mm= 0+mm;
	// 상세보기 팝업 호출
	doDetailPopUp(grid.cells(row, grid.getColIndexById("HIDARIRCRAFT")).getValue(),grid.cells(row, grid.getColIndexById("ARP_NM")).getValue(),grid.cells(row, grid.getColIndexById("COD_ID")).getValue(),grid.cells(row, grid.getColIndexById("START_DT_YY")).getValue(),mm);
}

//상세보기 팝업 호출
function doDetailPopUp(AIRCRAFT,ARP,COD_ID,START_DT_YY,START_DT_MM){
	var url = '';
	
	if(AIRCRAFT == null || AIRCRAFT == '' || ARP== null || ARP == '') return;
	
	jQuery("#popupWidth").val('600');
	jQuery("#popupHeight").val('600');
	jQuery("#popSubType").val('detail');
	$("#popAIRCRAFT").val(AIRCRAFT);
	$("#popARP").val(ARP);
	$("#popCOD_ID").val(COD_ID);
	$("#popSTART_DT_YY").val(START_DT_YY);
	$("#popSTART_DT_MM").val(START_DT_MM);
	
	url = '<c:url value="/unitCost/UnitCostDetailPopup.popup"/>';
	showWindowPopup2(jQuery("#popUpForm"), url, 600, 640, "detail");
}

// 새 항목 추가 팝업 호출
function doNew(){
	jQuery("#popARP").val('');
	jQuery("#popGHTYPE").val('');
	jQuery("#popAIRCRAFT").val('');
	jQuery("#popupWidth").val('600');
	jQuery("#popupHeight").val('600');
	jQuery("#popSubType").val('new');
	
	url = '<c:url value="/unitCost/UnitCostDetailPopup.popup"/>';
	showWindowPopup2(jQuery("#popUpForm"), url, 600, 640, "new");
};

//찾기
function doSearch(){
	jQuery("#loader").show();
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	jQuery("#loader").hide();
}

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
	var curDate = new Date();
	
	$("#START_DT_YY").val(curDate.getFullYear());
	$("#START_DT_MM").val(curDate.getMonth()+1);
	
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
	<form id="popUpForm" method="post" >
		<input type="hidden" id="popARP" name="ARP">
		<input type="hidden" id="popAIRCRAFT" name="AIRCRAFT">
		<input type="hidden" id="popCOD_ID" name="COD_ID">
		<input type="hidden" id="popSubType" name="subType">
		<input type="hidden" id="popSTART_DT_YY" name="START_DT_YEAR">
		<input type="hidden" id="popSTART_DT_MM" name="START_DT_MM">
		<input type="hidden" name="width" id="popupWidth" value=""/>
		<input type="hidden" name="height" id="popupHeight" value=""/>
		<input type="hidden" name="ACCESS_CHECK" value="${ACCESS_CHECK}"/>
	</form>
	<form id="deleteFrom" method="post">
		<input type="hidden" id="selectAIRCRAFT" name="AIRCRAFT">
		<input type="hidden" id="selectARP" name="ARP">
		<input type="hidden" id="selectCOD_ID" name="COD_ID">
		<input type="hidden" id="selectSTART_DT" name="START_DT">
		<input type="hidden" id="selectEND_DT" name="END_DT">
	</form>
	<!-- contents title start-->
	<div class="content-top fix titWrap">
		<h3>기본 조업요율</h3>
		<input type="hidden" id="totalCnt">
	</div>
	<!-- contents title end-->
	<!-- contents search start-->
	<div class="content-search schCon clear seachWrap">
		<form name="searchForm" id="searchForm" method="post" onkeydown="return captureReturnKey(event)">
			<input type="hidden" name="GRID_ID" value="${pageMap.GRID_ID}">
			<ul class="schCon clear">
				<li>
					<label>항공사</label>
					<select id="AIRCRAFT" name="AIRCRAFT">
						<option value="">전체</option>
						<c:forEach items="${getSearchAirCraftData}" var="data">
							<option value="${data.AIRCRAFT}">${data.AIRCRAFT}</option>
						</c:forEach>
					</select>
				</li>
				<li>
					<label>지점</label>
					<select id="ARP" name="ARP">
						<c:choose>
							<c:when test="${fn:indexOf(arpList,USER_SESSION.ARP) gt -1}">
								<c:forEach items="${arpList}" var="arp">
									<c:if test="${USER_SESSION.ARP eq arp.CD}">
										<option value="${arp.CD }" selected="selected">${arp.CD}</option>
									</c:if>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<option value="">전체</option>
								<c:forEach items="${arpList}" var="arp">
									<option value="${arp.CD }" >${arp.CD}</option>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</select>
				</li>
				<li>
					<label>년도</label>
					<select id="START_DT_YY" name="START_DT_YEAR">
						<c:forEach var="i" begin="${getSearchDateData_MIN}" end="${getSearchDateData_MAX}" step="1">
							<option value="${i}">${i}</option>
						</c:forEach>
					</select>
					
				</li>
				<li>
					<label>월</label>
					<select id="START_DT_MM" name="START_DT_MM">
						<c:forEach begin="1" end="9" var="i" step="1">
							<option value="<c:out value='0${i}'/>">0<c:out value='${i}' /></option>
						</c:forEach>
						<c:forEach begin="10" end="12" var="i" step="1">
							<option value="<c:out value='${i}'/>"><c:out value='${i}' /></option>
						</c:forEach>
					</select>
				</li>
			</ul>
			<div class="schBtnWrap">
				<button type="button" id="btn_refresh" class="btn" onclick="doSearch();">조회</button>
				<c:if test="${USER_SESSION.ROLE_ID eq 'ADMIN'}">
					<button type="button" id="btn_new" class="btn" onclick="doNew();">신규</button>
					<button type="button" id="btn_delete" class="btn btnOrange" onclick="deleteGridCheck();">삭제</button>
				</c:if>
			</div>
		</form>
	</div>
	<!-- contents search end-->
	<!-- contents start --> 
	<div class="chart listWrap">
		<div id="${pageMap.GRID_ID}" class="tbWrap">${UCR_LIST_TAG}</div>
	</div>
</div>
