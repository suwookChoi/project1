<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript">
$(document).ready(function() {
	$("#btnClose").click(function(event) {
		event.preventDefault();
		doClosePopup('M');
	});
});

function imgOpen(path, type) {
	$('#pdf_path').val("");
	$('#pdf_name').val("");
	
	if (path == '') {
		if(type=='LIR'){
			alert('등록된 ' + type + ' 없습니다.');
			return;
		}else{
			var url = "<c:url value='/pdf/pdf-canvas.popup' />";
			showWindowPopup2($("#pdfForm"), url, 1170, 827, "unitWork2");
		}
	} else {
		$('#pdf_path').val(path);
		var name = path.split('//');
		var pdf_name ='';
		
		for(var i=0;i<name.length;i++){
		 	pdf_name = name[i];
		}
		
		$('#pdf_path').val(path.replaceAll('.png','.pdf'));
		$('#pdf_name').val(pdf_name.replaceAll('.png','.pdf'));
		var url = "<c:url value='/pdf/pdf-canvas.popup' />";
		showWindowPopup2($("#pdfForm"), url, 1170, 827, "unitWork2");
	}
}

//작업정보 팝업
function callLoadPopup(UNIT_ID , UNIT_NM){
	$('#popUNIT_ID').val(UNIT_ID);
	$('#popUNIT_NM').val(UNIT_NM);
	var url = ''
	//LOADING(UNIT002) , UN-LOADING(UNIT003) FORM
	if(UNIT_ID == "UNIT003" || UNIT_ID =="UNIT004"){
		url = '<c:url value="/main/dashLoadPopupForm.popup"/>';
		showWindowPopup2($('#popUpForm'), url ,1262 ,640 ,'unitWork2');
	// RAMP-IN(UNIT001) , DOOR-CLOSE(UNIT005) FORM
	}else if(UNIT_ID =="UNIT001" || UNIT_ID =="UNIT002"){
		url = '<c:url value="/main/dashRampDoorPopupForm.popup"/>';
		showWindowPopup2($('#popUpForm'), url ,700 ,640 ,'unitWork2');
	//PushBack (UNIT005) FORM
	}else if(UNIT_ID =="UNIT005"){
		url = '<c:url value="/main/dashPushBackPopupForm.popup"/>';
		showWindowPopup2($('#popUpForm'), url ,963 ,640 ,'unitWork2');
	}else{
		url = '<c:url value="/main/dashDefaultPopupForm.popup"/>';
		showWindowPopup2($('#popUpForm'), url ,723 ,640 ,'unitWork2');
	}
	//FUEL (UNIT004) FORM
	/* }else if(UNIT_ID =="UNIT004"){ 추후 추가예정
	url = '<c:url value="/main/dashFuelPopupForm.popup"/>';
	showWindowPopup2($('#popUpForm'), url ,1500 ,700 ,'unitWork');
	 */
}
	
function rcOpen(){
	url = '';
};

function popOpen(str){
	var height ;
	var width ;
	var url;
	if(str == 1) {url ='<c:url value="/main/dashEQRegisterPopupForm.popup"/>'; height=640; width=1623;}
	if(str == 2) {url = '<c:url value="/main/dashEMRPopupForm.popup"/>'; height=640; width=1200;}
	if(str == 3) {url = '<c:url value="/main/dashRMKPopupForm.popup"/>'; height=640; width=1200;}
	if(str == 4) {url = '<c:url value="/main/dashRcLirButton.popup"/>'; height=640; width=1200;}
	if(str != 4) showWindowPopup2($('#popUpForm'), url, width, height, 'unitWork2');
	if(str == 4) showWindowPopup2($('#flightForm'), url, width, height, 'unitWork2');
}
</script>
<body onunload="doClosePopup('M')">
	<form id="popForm" method="post">
		<input type="hidden" id="IMG_PATH" name="IMG_PATH">
	</form>
	<form id="popUpForm" method="post">
		<input type="hidden" id="popFLC" name="FLC" value="${pageMap.FLC}">
		<input type="hidden" id="popSDT" name="SDT" value="${pageMap.SDT}">
		<input type="hidden" id="popARP" name="ARP" value="${pageMap.ARP}"> 
		<input type="hidden" id="popFLT" name="FLT" value="${pageMap.FLT}"> 
		<input type="hidden" id="popLKT" name="LKT" value="${pageMap.LKT}"> 
		<input type="hidden" id="popETA" name="ETA" value="${pageMap.ETA}">
		<input type="hidden" id="popETD" name="ETD" value="${pageMap.ETD}">
		<input type="hidden" id="popIN_SPOT" name="IN_SPOT" value="${pageMap.IN_SPOT}">
		<input type="hidden" id="popOUT_SPOT" name="OUT_SPOT" value="${pageMap.OUT_SPOT}">
		<input type="hidden" id="popIN_ACNO" name="IN_ACNO" value="${pageMap.IN_ACNO}">
		<input type="hidden" id="popOUT_ACNO" name="OUT_ACNO" value="${pageMap.OUT_ACNO}">
		<input type="hidden" id="popUNIT_ID" name="UNIT_ID" value="${pageMap.UNIT_ID}">
		<input type="hidden" id="popUNIT_NM" name="UNIT_NM" value="${pageMap.UNIT_NM}">
		<input type="hidden" id="popSTA" name="STA" value="${pageMap.STA}">
		<input type="hidden" id="popSTD" name="STD" value="${pageMap.STD}">
		<input type="hidden" id="FLAG" name="FLAG" value="${pageMap.FLAG }">
		<input type="hidden" id="popIN_USER" name="IN_USER" value="${pageMap.IN_USER}">
		<input type="hidden" id="popOUT_USER" name="OUT_USER" value="${pageMap.OUT_USER }">
		<input type="hidden" id="popOUT_GROUP_ID" name="OUT_GROUP_ID" value="${pageMap.OUT_GROUP_ID}">
		<input type="hidden" id="popIN_GROUP_ID" name="IN_GROUP_ID" value="${pageMap.IN_GROUP_ID}">
		<input type="hidden" id="popSOBT" name="SOBT" value="${pageMap.SOBT}">
		<input type="hidden" id="popPOP_FLAG" name="POP_FLAG" value="${pageMap.POP_FLAG}">
	</form>
	<form id="pdfForm" method="post">
		<input type="hidden" id="pdf_path" name="pdf_path">
		<input type="hidden" id="pdf_name" name="pdf_name">
		<input type="hidden" id="popPDFSOBT" name="SOBT" value="${pageMap.SOBT}">
		<input type="hidden" id="popPDFFLT" name="FLT" value="${pageMap.LKT}">
		<input type="hidden" id="popPDFREG" name="REG" value="${pageMap.OUT_ACNO}">
		<input type="hidden" id="popPDFAFSID" name="AFS_ID" value="">
		<input type="hidden" id="popPDFAFSID" name="POP_FLAG" value="${pageMap.POP_FLAG}">
	</form>
	<form id="flightForm" method="post">
		<input type="hidden" name="ARP" value="${FLIGHT.ARP}">
		<input type="hidden" name="SDT" value="${FLIGHT.SDT}">
		<input type="hidden" name="BSP" value="${FLIGHT.BSP}">
		<input type="hidden" name="BEP" value="${FLIGHT.BEP}">
		<input type="hidden" name="SEQ" value="${FLIGHT.SEQ}">
		<input type="hidden" name="FLC" value="${FLIGHT.FLC}">
		<input type="hidden" name="IN_TYS" value="${FLIGHT.IN_TYS}">
		<input type="hidden" name="OUT_TYS" value="${FLIGHT.OUT_TYS}">
		<input type="hidden" name="IN_REG" value="${FLIGHT.IN_REG}">
		<input type="hidden" name="STA" value="${FLIGHT.STA}">
		<input type="hidden" name="STD" value="${FLIGHT.STD}">
		<input type="hidden" name="ETA" value="${FLIGHT.ETA}">
		<input type="hidden" name="ETD" value="${FLIGHT.ETD}">
		<input type="hidden" name="ATA" value="${FLIGHT.ATA}">
		<input type="hidden" name="ATD" value="${FLIGHT.ATD}">
		<input type="hidden" name="ORG" value="${FLIGHT.ORG}">
		<input type="hidden" name="DES" value="${FLIGHT.DES}">
		<input type="hidden" name="SOBT" value="${FLIGHT.SOBT}">
		<input type="hidden" name="IN_PAK" value="${FLIGHT.IN_PAK}">
		<input type="hidden" name="OUT_PAK" value="${FLIGHT.OUT_PAK}">
		<input type="hidden" name="OUT_REG" value="${FLIGHT.OUT_REG}">
		<input type="hidden" name="DAFSID" value="${FLIGHT.DAFSID}">
		<input type="hidden" name="AAFSID" value="${FLIGHT.AAFSID}">
	</form>
	<div class="lrcWrap"><!--  LIR /  RC 선택시 div 활성화 -->
		<c:if test="${not empty FLIGHT.BSP}">
			<div class="titWrap"><h3>(IN) ${FLIGHT.BSP} ${FLIGHT.IN_REG}-${FLIGHT.IN_TYS} (${FLIGHT.ETA}) #${FLIGHT.IN_PAK} </h3></div>
		</c:if>
		<c:if test="${ not empty FLIGHT.BEP}">
			<div class="titWrap"><h3>(OUT) ${FLIGHT.BEP} ${FLIGHT.OUT_REG}-${FLIGHT.OUT_TYS} (${FLIGHT.ETD}) #${FLIGHT.OUT_PAK} </h3></div>
		</c:if>
		<div class="lrcbtnWrap">
			<c:choose>
				<c:when test="${IMG_INFO.LIRPATH ne 'N' && not empty IMG_INFO.LIRPATH}">
					<button class="btn unRegBtn" onclick="imgOpen('${IMG_INFO.LIRPATH}','LIR')">LIR</button>
				</c:when>
				<c:when test="${IMG_INFO.LIRPATH eq 'N' || empty IMG_INFO.LIRPATH}">
					<button class="btn unRegBtn" onclick="imgOpen('','LIR')">LIR</button>
				</c:when>
			</c:choose>
			<c:choose>
				<c:when test="${IMG_INFO.RCPATH ne 'N' && not empty IMG_INFO.RCPATH}">
					<button class="btn btnOrange" onclick="popOpen(4);">RC</button>
				</c:when>
				<c:when test="${IMG_INFO.RCPATH eq 'N' || empty IMG_INFO.RCPATH}">
					<button class="btn btnOrange" onclick="popOpen(4);">RC</button>
				</c:when>
			</c:choose>
			<c:forEach items="${WORKUNITLIST}" var ="list">
				<button class="btn" onclick="callLoadPopup('${list.UNIT_ID}','${list.UNIT_NM}')">${list.UNIT_NM}</button>
			</c:forEach>
			<button class="btn" onclick="popOpen('1')">특수장비</button>
			<button class="btn" onclick="popOpen('2')">비정상</button>
			<button class="btn" onclick="popOpen('3')">전달사항</button>
		</div>
	</div>
</body>

