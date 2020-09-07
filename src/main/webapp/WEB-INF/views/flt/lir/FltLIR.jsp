<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />
<script type="text/javascript" charset="utf-8" src="<c:url value="/resources/js/ajaxfileupload.js"/>"></script>
 
<script type="text/javascript">
var myCalendar1 = null;
//그리드 변수
var mygrid<c:out value='_${pageMap.GRID_ID}'/>;

function initCalendar() {
	//캘린더 설정
	myCalendar1 = new dhtmlXCalendarObject({input : "SDT", button : "calendar_icon_sdt"});
	myCalendar1.setDate(new Date());
	myCalendar1.setDateFormat("%Y.%m.%d");
	jQuery("#calendar_icon_sdt").css("cursor", "pointer");
}

function addDate(id, type) {
	var date = jQuery("#" + id).val();
	var sDate = dateCalculation(date, type);
	jQuery("#" + id).val(sDate);
}

//그리드 data
function getGridData<c:out value='_${pageMap.GRID_ID}'/>(){
	jQuery("#loader").show();
	jQuery("#allCheck").attr("checked", false);
	var data = jQuery("#searchForm").serialize();
	var sid = "sid_getGridData";
	var url =  "<c:url value="/flt/LIRList.json"/>";
	ajax_sendData(sid,url,data);
}

//초기화
function doRefresh(){
	//데이터 리로드
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
}

function ajax_callback(sid, json) {
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
			}else if(count == 0){
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.enableColSpan(true);
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.addRow(0, [_TEXT_NOROW]);
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.setColspan(0, 0, mygrid<c:url value='_${pageMap.GRID_ID}'/>.getColumnsNum());
			}
			
			for(var i=1;i<count+1;i++){
				$("#hiddenFileDiv").append("<input id='filePDF"+ i+ "' type='file' accept='.pdf' name='filePDF"+ i+ "' style='display : none;' onchange='savePDF("+ i + ",\"LIR\")'/>");
			}
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.initMultiSort();
		} catch (e) {Logger.debug(e);jQuery("#loader").hide();}
	}else if (sid == "savePDF") {
		var result = json.result;
		
		if (result == "1") {
			getGridData<c:out value='_${pageMap.GRID_ID}'/>();
		} else {
			doRefresh();
		}
	}
	//파일 삭제
	else if (sid == "pdfFileDelete") {
		var result = json.result;
		var row = $("#selectRow").val();
		
		if (result == true) {
			alert("파일이 삭제되었습니다.");
			getGridData<c:out value='_${pageMap.GRID_ID}'/>();
			$("#filePDF"+row).val("");
			
		} else if (result == "noFile") {
			alert("파일이 경로에 존재하지 않습니다.");
			getGridData<c:out value='_${pageMap.GRID_ID}'/>();
			doRefresh();
		} else {
			alert("파일 삭제가 실패되었습니다.");
			getGridData<c:out value='_${pageMap.GRID_ID}'/>();
			doRefresh();
		}
	}
}

function doOnClickButton<c:out value='_${pageMap.GRID_ID}'/>(row,col){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	
	$("#selectRow").val(row);
	$("#selectFLT").val(grid.cells(row, grid.getColIndexById('FLT')).getValue());
	$("#selectREG").val(grid.cells(row, grid.getColIndexById('REG')).getValue());
	$("#selectTYP").val(grid.cells(row, grid.getColIndexById('TYPE')).getValue());
	$("#selectST").val(grid.cells(row, grid.getColIndexById('ST')).getValue());
	$("#selectSOBT").val(grid.cells(row, grid.getColIndexById('SOBT')).getValue());
	$("#selectAFS_ID").val(grid.cells(row, grid.getColIndexById('AFS_ID')).getValue());
	
	var type = "";
	if (col == 7 || col == 8 ) {
		type = "LIR";
		$("#selectPDF_PATH").val(grid.cells(row, grid.getColIndexById('IMGPATH')).getValue());
		$("#selectPDF_NAME").val(grid.cells(row, grid.getColIndexById('IMGFILENAME')).getValue());
	}
	
	if (col == 7) checkPDF(row, type);
	else if (col == 8){
		var name = grid.cells(row, grid.getColIndexById('IMGFILENAME')).getValue();
		
		if(name == null || name == ""){
			alert("파일이 없습니다. 파일을 업로드하세요.");
			return;
		}else {
			openLIR(row, col);
		}
	}
	else return;
}

$(document).ready(function() {
	initCalendar();
	viewGrid<c:out value='_${pageMap.GRID_ID}'/>();
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	
	jQuery("#btn_sdt_minus").click(function(event) {
		addDate("SDT", "minus");
	}).css("cursor", "pointer");
	
	jQuery("#btn_sdt_now").click(function(event) {
		jQuery("#SDT").val(getNowDate());
			getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	}).css("cursor", "pointer");
	
	jQuery("#btn_sdt_plus").click(function(event) {
		addDate("SDT", "plus");
	}).css("cursor", "pointer");
	
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

//PDF 파일 유무 확인
function checkPDF(row, type) {
	var mygrid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var pdf_path = "";
	var pdf_name = "";
	$("#selectPDF_TYPE").val("");
	
	if (type == "LIR") {
		pdf_path = mygrid.cells(row, mygrid.getColIndexById('IMGPATH')).getValue();
		pdf_name = mygrid.cells(row, mygrid.getColIndexById('IMGFILENAME')).getValue();
		$("#selectPDF_TYPE").val(type);
	}
			
	if (pdf_name != "") {
		if (!confirm("PDF 파일을 업로드 하시면 기존 PDF 파일이 삭제됩니다. \n 파일을 삭제하시겠습니까?")){
			return;
		} else {
			var data = {
				"type" : type,
				"pdf_path" : pdf_path,
				"pdf_name" : pdf_name
			};
			var url = "<c:url value="/flt/pdfDelete.json"/>";
			var sid = "pdfFileDelete";
			
			ajax_sendData(sid, url, data);
		}
	} else {
		if (type == "LIR"){
			$("#filePDF" + row).click();
		}
	}
}

//파일 업로드 callback
function callbackFileUpload(inputId, resultData) {
	var type = $("#selectPDF_TYPE").val();
	var url;
	
	if (resultData != undefined && resultData != '') {
		if (resultData.RESULT == 'SUCCESS') {
			if (type == "LIR") {
				url = "<c:url value='/flt/savePDFPath.json'/>";
			}
			
			alert("저장에 성공하였습니다.");
			
			$("#TARGET_PATH").text(resultData.TARGET_PATH);
			$("#KEY_TARGET_REAL_PATH").val(resultData.KEY_TARGET_REAL_PATH);
			$("#KEY_FILE_NAME").val(resultData.KEY_FILE_NAME);
			
			//PDF 파일 SQL 경로 저장 
			var data = jQuery("#uploadForm").serialize();
			var sid = "savePDF";
			
			ajax_sendData(sid, url, data);
		} else{
			return;
		}
	} else {
		$("#file_path").text("");
		$("#fileName").val("");
	}
}

//PDF파일 업로드
function savePDF(row, type) {
	var id;
	var type;
	var requestData;
	var fileSize;
	
	if (type == 'LIR') {
		fileSize = document.getElementById("filePDF"+row).files[0].size;
		
		if(fileSize >1024*1024*10){
			alert("파일용량이 초과하였습니다.");
			return;
		}else{
			id = "filePDF" + row;
			type = "filePDF" + row;
			requestData = { "INPUTFILE_NAME" : id,"FILE_NAME_PREFIX" : "LIR","type":type };
		}
	} else {
		return;
	}
	
	if ($("#filePDF" + row).val() != null) {
		var ext = $("#" + id).val();
		var index = ext.lastIndexOf(".");
		var pdf = ext.substr(index + 1, 3);
		var uploadUrl = "<c:url value="/flt/uploadPDFFile.json"/>";
		
		if (ext != "") {
			if (pdf != "pdf") {
				alert("pdf파일만 업로드 해주세요");
				return;
			}
			
			try {
				commonFileUpload(type, requestData, uploadUrl,callbackFileUpload);
			} catch (e) {Logger.error(e);}
		}
	} else return;
}

function openLIR(row, ind) {
	var url = "<c:url value='/pdf/pdf-canvas.popup' />";
	showWindowPopup2($("#uploadForm"), url, 1170, 827, "pdffile");
}
</script>
<div id="hiddenFileDiv"></div>
<form id="uploadForm" name="uploadForm" method="post" enctype="multipart/form-data">
	<input type="hidden" id="selectRow" name="row">
	<input type="hidden" id="TARGET_PATH" name="TARGET_PATH">
	<input type="hidden" id="KEY_TARGET_REAL_PATH" name="KEY_TARGET_REAL_PATH">
	<input type="hidden" id="KEY_FILE_NAME" name="KEY_FILE_NAME">
	<input type="hidden" id="selectFLT" name="FLT"> 
	<input type="hidden" id="selectREG" name="REG"> 
	<input type="hidden" id="selectTYP" name="TYP"> 
	<input type="hidden" id="selectST"name="ST">
	<input type="hidden" id="selectAFS_ID" name="AFS_ID">
	<input type="hidden" id="selectSOBT" name="SOBT">
	<input type="hidden" id="selectPDF_PATH" name="pdf_path"> 
	<input type="hidden" id="selectPDF_TYPE" name="PDF_TYPE">
	<input type="hidden" id="selectPDF_NAME"name="pdf_name">
</form>
<div id="contents" class="contWrap">
<!-- contents title start-->
	<div class="titWrap">
		<h3>LIR</h3>
	</div>
<!-- contents search start-->
	<div class="seachWrap clear">
		<form name="searchForm" id="searchForm" method="post" onsubmit="return false;">
			<ul class="schCon clear">
				<li>
					<label for="FLC">항공사</label>
					<select id="FLC" name="FLC">
						<option value="">전체</option>
						<c:forEach items="${flcList}" var="listflc">
							<option value="${listflc.FLC}">${listflc.FLC}</option>
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
					<label>일자</label>
					<button type="button" id="btn_sdt_minus" class="btn oneBtn mins">1일 앞으로</button>
					<button type="button" id="btn_sdt_now" class="btn oneBtn zero">오늘</button>
						<div class="dateWrap">
							<div class="dateBox">
								<input type="text" name="SDT" id="SDT" class="val" size="9" value="${pageMap.searchDate }"/>
							</div>
						</div>
					<button type="button" id="btn_sdt_plus" class="btn oneBtn plus">1일 뒤로</button>
				</li>
				<li>
					<label>A/C No</label>
					<input type="text" name="findTextReg" id="findTextReg" onkeyup="javascript:engNumCheck(this);">
				</li>
				<li>
					<label>FLT No</label>
					<input type="text" name="findTextFlt" id="findTextFlt" onkeyup="javascript:engNumCheck(this);">
				</li>
			</ul>
			<div class="schBtnWrap">
				<button type="button" id="btn_refresh" class="btn"onclick="doRefresh();">조회</button>
			</div>
		</form>
	</div>
	<div class="chart listWrap">
		<div id="${pageMap.GRID_ID}" class="tbWrap">${LIR_LIST_TAG}</div>
	</div>
</div>