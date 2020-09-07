<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<script type="text/javascript" charset="utf-8" src="<c:url value="/resources/js/pak/smart.date.js"/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />
<script type="text/javascript" charset="utf-8" src="<c:url value="/resources/dhtmlx/dhtmlxcombo.js"/>"></script>

<meta name="viewport" content="user-scalable=no,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,width=device-width">
<title>JAS | RC Check List</title>
<link rel="shortcut icon" type="image/x-icon" href="./images/favicon/favicon.ico">
<link rel="manifest" href="../images/favicon/manifest.json">
<meta name="msapplication-TileColor" content="#ffffff">
<meta name="msapplication-TileImage" content="../images/favicon/ms-icon-144x144.png">
<meta name="theme-color" content="#ffffff">

<link rel="stylesheet" href="../css/vendor/jquery-ui.css">
<link rel="stylesheet" href="../css/vendor/daterangepicker.css">
<link rel="stylesheet" href="../css/webfont.css">
<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/style.css">

<script type="text/javascript" src="../js/vendor/jquery-2.2.4.min.js"></script>
<script type="text/javascript" src="../js/vendor/jquery-ui.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="../js/style.js"></script>

<script type="text/javascript">
var accessCheck = '${ACCESS_CHECK}';
var RMSROLE = '${USER_SESSION.rmsRole}';
var ROLEID = '${USER_SESSION.rolegroup_id}';

function ajax_callback(sid,json) {
	if(sid == "doSave"){
		if(!sessionCheckJSON(json)) return;
	}
}

// 저장하기
function doSave() {
	var sid="doSave";
	var url = "/main/RC/JasRCSave.json";
	var data = {
			  "BSP "    : $("#BSP").val()
			, "ARP "    : $("#ARP").val()
			, "STA"    : $("#STA").val()
			, "ARP"    : $("#ARP").val()
			, "STA"    : $("#STA").val()
			, "DEP"    : $("#DEP").val()
			, "SDT"    : $("#SDT").val()
			, "REG"    : $("#REG").val()
			, "TYP"    : $("#TYP").val()
			, "SPOT"   : $("#SPOT").val()
			, "WTDATE" : $("#WTDATE").val()
			, "ATA"    : $("#ATA").val()
			, "ATD"    : $("#ATD").val()
			, "ROUTE1" : $("#ROUTE1").val()
			, "ROUTE2" : $("#ROUTE2").val()
			, "ROUTE3" : $("#ROUTE3").val()
			, "RCNAME" : $("#RCNAME").val()
			, "RAMPSUPERVISOR" :$("#RAMPSUPERVISOR").val()
			, "GTRCP" :   $("#GTRCP").val()
			, "CHECK11" : $("input:radio[name=CHECK11]:checked").val()
			, "CHECK12"   :  $("input:radio[name=CHECK12]:checked").val()
			, "CHECK13"   :  $("input:radio[name=CHECK13]:checked").val()
			, "CHECK14"   :  $("input:radio[name=CHECK14]:checked").val()
			, "CHECK15"   :  $("input:radio[name=CHECK15]:checked").val()
			, "CHECK16"   :  $("input:radio[name=CHECK16]:checked").val()
			, "CHECK17"   :  $("input:radio[name=CHECK17]:checked").val()
			, "CHECK18"   :  $("input:radio[name=CHECK18]:checked").val()
			, "CHECK19"   :  $("input:radio[name=CHECK19]:checked").val()
			, "CHECK21"   :  $("input:radio[name=CHECK21]:checked").val()
			, "CHECK22"   :  $("input:radio[name=CHECK22]:checked").val()
			, "CHECK31"   :  $("input:radio[name=CHECK31]:checked").val()
			, "CHECK32"   :  $("input:radio[name=CHECK32]:checked").val()
			, "CHECK33"   :  $("input:radio[name=CHECK33]:checked").val()
			, "CHECK34"   :  $("input:radio[name=CHECK34]:checked").val()
			, "CHECK41"   :  $("input:radio[name=CHECK41]:checked").val()
			, "CHECK42"   :  $("input:radio[name=CHECK42]:checked").val()
			, "CHECK43"   :  $("input:radio[name=CHECK43]:checked").val()
			, "CHECK44"   :  $("input:radio[name=CHECK44]:checked").val()
			, "CHECK45"   :  $("input:radio[name=CHECK45]:checked").val()
			, "CHECK46"   :  $("input:radio[name=CHECK46]:checked").val()
			, "CHECK51"   :  $("input:radio[name=CHECK51]:checked").val()
			, "CHECK52"   :  $("input:radio[name=CHECK52]:checked").val()
			, "CHECK53"   :  $("input:radio[name=CHECK53]:checked").val()
			, "CHECK54"   :  $("input:radio[name=CHECK54]:checked").val()
			, "BG_ARRPCS" : $("#BG_ARRPCS").val()
			, "BG_ARRKG"  : $("#BG_ARRKG").val()
			, "BG_DEPPCS" : $("#BG_DEPPCS").val()
			, "BG_DEPKG"  : $("#BG_DEPKG").val()
			, "BG_OFF"    : $("#BG_OFF").val()
			, "FRE_ARRPCS": $("#FRE_ARRPCS").val()
			, "FRE_ARRKG" : $("#FRE_ARRKG").val()
			, "FRE_DEPPCS": $("#FRE_DEPPCS").val()
			, "FRE_DEPKG" : $("#FRE_DEPKG").val()
			, "FRE_ULD"   : $("#FRE_ULD").val()
			, "FRE_OFF" : $("#FRE_OFF").val()
			, "COM1_ARR" : COM1_ARR
			, "COM2_ARR" : COM2_ARR
			, "COM3_ARR" : COM3_ARR
			, "COM4_ARR" : COM4_ARR
			, "COM1_DEP" : COM1_DEP
			, "COM2_DEP" : COM2_DEP
			, "COM3_DEP" : COM3_DEP
			, "COM4_DEP" : COM4_DEP
	};
	
	ajax_sendData(sid,url,data);
}

//부모창의 새로고침/닫기/앞으로/뒤로 시 팝업 닫기
$(this).one('load', function() {
	// 부모창의 새로고침/닫기/앞으로/뒤로
	$(opener).one('beforeunload', function() {
		window.close();
	});
});

$("document").ready(function() {
	$('input[name="radioTxt"]:checked').val();
	
	var curDate = new Date();
	
	jQuery(".enter").keydown(function(event){
		if(event.keyCode == 13) {
			event.preventDefault();
		}
	});	
	
	$("#btnClose").click(function () {
		window.close();
		opener.parent.location.reload();
	});
	
	// 저장하기
	$("#btnSave").click(function(){
		doSave();
	}).css("cursor", "pointer");
	
	$( window ).resize();
});

</script>
<div class="popupWrap">
	<div class="contWrap rcChkLitWrap">
	<form name="updateForm" id="updateForm" method="post">
		<div class="titWrap">
			<h3>Ramp Coordinator(RC) Checklist</h3>
		</div>
		<!-- contents start -->
		<div class="popConWrap scrPop">
			<div class="tbWrap nFtb vtbWrap">
				<table>
					<tr>
						<th>FLT No./Date</th>
						<td><input id="FLT" name="FLT" value="${DATA.FLT}" readonly="readonly"> /<input id="WTDATE" name="WTDATE" value="${DATA.WTDATE}" readonly="readonly"></td>
						<th>STA / ATA</th>
						<td><input id="STA" name="STA" value="${DATA.STA}"> / <input id="ATA" name="ATA" value="${DATA.ATA}"> </td>
						<th>STD / ATD</th>
						<td><input id="STD" name="STD" value="${DATA.STD}"> / <input id="ATD" name="ATD" value="${DATA.ATD}"> </td>
					</tr>
					<tr>
						<th>Route</th>
						<td><input id="ROUTE1" name="ROUTE1" value="${DATA.ROUTE1}"> / <input id="ROUTE2" name="ROUTE2" value="${DATA.ROUTE2}"> / <input id="ROUTE3" name="ROUTE3" value="${DATA.ROUTE3}"> </td>
						<th>REG No</th>
						<td><input id="REG" name="REG" value="${DATA.REG}"> </td>
						<th>기종 / SPOT</th>
						<td><input id="TYP" name="TYP" value="${DATA.TYP}"> /<input id="SPOT" name="SPOT" value="${DATA.SPOT}"> </td>
					</tr>
					<tr>
						<th>R/C name</th>
						<td><input id="RCNAME" name="RCNAME" value="${DATA.RCNAME}"> </td>
						<th>Ramp Supervisor</th>
						<td><input id="RAMPSUPERVISOR" name="RAMPSUPERVISOR" value="${DATA.RAMPSUPERVISOR}"> </td>
						<th>GATE 수령자</th>
						<td><input id="GTRCP" name="GTRCP" value="${DATA.GTRCP}"> </td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sbTitWrap">
			<h4>1. 점검사항</h4>
		</div>
		<div class="tbWrap nFtb">
			<table>
				<colgroup>
					<col style="width:10%">
					<col style="width:66%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
				</colgroup>
				<tbody>
					<tr>
						<th rowspan="2">구분</th>
						<th rowspan="2">점검내용</th>
						<th colspan="2">점검결과</th>
						<th rowspan="2">비고</th>
					</tr>
					<tr>
						<th>Yes</th><tr>
						<th>No</th>
					</tr>
					<tr>
						<th rowspan="9" class="subTh">사전조업<br>준비점검</th>
					</tr>
					<tr>
						<td>1) ETA, REG Number, Parking Spot 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y1" name="CHECK11" value="Y" <c:out value="${DATA.CHECK11 eq 'Y' ? 'checked' : '' }" /> >
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N1" name="CHECK11" value="N" <c:out value="${DATA.CHECK11 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc11" name="desc11" ></td>
					</tr>
					<tr>
						<td>2) GPU, ACU, ASU 요청 장비 준비 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y2" name="CHECK12" value="Y" <c:out value="${DATA.CHECK12 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N2" name="CHECK12" value="N" <c:out value="${DATA.CHECK12 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc12" name="desc12" ></td>
					</tr>
					<tr>
						<td>3) Interphone, Safety Cone, Chock 준비확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y3" name="CHECK13" value="Y" <c:out value="${DATA.CHECK13 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N3" name="CHECK13" value="N" <c:out value="${DATA.CHECK13 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc13" name="desc13" ></td>
					</tr>
					<tr>
						<td>4) 도착 주기장내 안전확인 (FOD제거확인)</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y4" name="CHECK14" value="Y" <c:out value="${DATA.CHECK14 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N4" name="CHECK14" value="N" <c:out value="${DATA.CHECK14 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc14" name="desc14" ></td>
					</tr>
					<tr>
						<td>5) OUT Bound 수하물 및 화물 정시 도착 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y5" name="CHECK15" value="Y" <c:out value="${DATA.CHECK15 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N5" name="CHECK15" value="N" <c:out value="${DATA.CHECK15 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc15" name="desc15" ></td>
					</tr>
					<tr>
						<td>6) IN Bound 용 DOLLY 및 기타 조업장비 사전준비 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y6" name="CHECK16" value="Y" <c:out value="${DATA.CHECK16 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N6" name="CHECK16" value="N" <c:out value="${DATA.CHECK16 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc16" name="desc16" ></td>
					</tr>
					<tr>
						<td>7) 적정 조업지원 인원 확인 (연결편 지연 여부 확인)</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y7" name="CHECK17" value="Y" <c:out value="${DATA.CHECK17 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N7" name="CHECK17" value="N" <c:out value="${DATA.CHECK17 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc17" name="desc17" ></td>
					</tr>
					<tr>
						<td>8) 조업인원/장비 정위치 확인(유도원, Wing guarder, 인터폰맨, 램프버스 등)</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y8" name="CHECK18" value="Y" <c:out value="${DATA.CHECK18 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N8" name="CHECK18" value="N" <c:out value="${DATA.CHECK18 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc18" name="desc18" ></td>
					</tr>
					<tr>
						<td>9) 수출화물 ULD별 작업상황 확인 후 탑재계획 수립 (아래 2번 항목 기입)</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y9" name="CHECK19" value="Y" <c:out value="${DATA.CHECK19 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N9" name="CHECK19" value="N" <c:out value="${DATA.CHECK19 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc19" name="desc19" ></td>
					</tr>
					 <tr>
						<th rowspan="2" class="subTh">Compartment<br>Door점검(도착)</th>
						 <td>1) Door Open 전 Door 상태 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y10" name="CHECK21" value="Y" <c:out value="${DATA.CHECK21 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N10" name="CHECK21" value="N" <c:out value="${DATA.CHECK21 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc21" name="desc21" ></td>
					</tr>
					<tr>
						<td>2) Compartment 내부 및 Netting, Tie Down 상태 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y11" name="CHECK22" value="Y" <c:out value="${DATA.CHECK22 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N11" name="CHECK22" value="N" <c:out value="${DATA.CHECK22 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc22" name="desc22" ></td>
					</tr>
					<tr>
						<th rowspan="4" class="subTh">UNLOADING<br>(하기작업)</th>
						<td>1) 하기할 화물/수하물 및 탑재위치 파악(DoorSide/유모차/수하물/특송화물 등)</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y12" name="CHECK31" value="Y" <c:out value="${DATA.CHECK31 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N12" name="CHECK31" value="N" <c:out value="${DATA.CHECK31 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc31" name="desc31" ></td>
					</tr>
					<tr>
						<td>2) IN Bound 수하물/화물 전량 하기 확인.</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y13" name="CHECK32" value="Y" <c:out value="${DATA.CHECK32 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N13" name="CHECK32" value="N" <c:out value="${DATA.CHECK32 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc32" name="desc32" ></td>
					</tr>
					<tr>
						<td>3) 각 Compartment 별 잔여물, 잔재여부 청소 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y14" name="CHECK33" value="Y" <c:out value="${DATA.CHECK33 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N14" name="CHECK33" value="N" <c:out value="${DATA.CHECK33 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc33" name="desc33" ></td>
					</tr>
					<tr>
						<td>4) 각 Compartment 내부 손상(파손) 여부 확인</td>	
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y15" name="CHECK34" value="Y" <c:out value="${DATA.CHECK34 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N15" name="CHECK34" value="N" <c:out value="${DATA.CHECK34 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc34" name="desc34" ></td>
					</tr>
					<tr>
						<th rowspan="6" class="subTh">LOADING<br>(탑재작업)</th>
						<td>1) 탑재지시서(L.I.R)에 의한 탑재 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y16" name="CHECK41" value="Y" <c:out value="${DATA.CHECK41 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N16" name="CHECK41" value="N" <c:out value="${DATA.CHECK41 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc41" name="desc41" ></td>
					</tr>
					<tr>
						<td>2) IN Bound 수하물/화물 전량 하기 확인. </td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y17" name="CHECK42" value="Y" <c:out value="${DATA.CHECK42 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N17" name="CHECK42" value="N" <c:out value="${DATA.CHECK42 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc42" name="desc42" ></td>
					</tr>
					<tr>
						<td>3) 탑재조업 직원의 수하물/화물 SOFT핸들링 확인 </td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y17" name="CHECK43" value="Y" <c:out value="${DATA.CHECK43 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N17" name="CHECK43" value="N" <c:out value="${DATA.CHECK43 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc43" name="desc43" ></td>
					</tr>
					<tr>
						<td>4) 카운터 최종마감 수하물 개수와 최종탑재 수하물 개수 일치 확인 </td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y44" name="CHECK44" value="Y" <c:out value="${DATA.CHECK44 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N44" name="CHECK44" value="N" <c:out value="${DATA.CHECK44 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc44" name="desc44" ></td>
					</tr>
					<tr>
						<td>5) 탑재 시 Damage 수하물/화물 여부 확인 </td>	
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y45" name="CHECK45" value="Y" <c:out value="${DATA.CHECK45 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N45" name="CHECK45" value="N" <c:out value="${DATA.CHECK45 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc45" name="desc45" ></td>
					</tr>
					<tr>
						<td>6) 탑재완료 후 Compartment 별 탑재 상황 operation(W/B)팀과 재확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y46" name="CHECK46" value="Y" <c:out value="${DATA.CHECK46 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N46" name="CHECK46" value="N" <c:out value="${DATA.CHECK46 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc46" name="desc46" ></td>
					</tr>
					<tr>
						<th rowspan="4" class="subTh">Compartment<br>Door점검(출발)</th>
						<td>1) 탑재완료 후 최종 Tie Down, Netting, 내부파손여부 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y51" name="CHECK51" value="Y" <c:out value="${DATA.CHECK51 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N51" name="CHECK51" value="N" <c:out value="${DATA.CHECK51 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc51" name="desc51" ></td>
					</tr>
					<tr>
						<td>2) 각 Compartment 내부 손상(파손) 여부 확인</td>	
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y52" name="CHECK52" value="Y" <c:out value="${DATA.CHECK52 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N52" name="CHECK52" value="N" <c:out value="${DATA.CHECK52 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc52" name="desc52" ></td>
					</tr>
					<tr>
						<td>3) 앞 뒤 Door Close 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y53" name="CHECK53" value="Y" <c:out value="${DATA.CHECK53 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N53" name="CHECK53" value="N" <c:out value="${DATA.CHECK53 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc53" name="desc53" ></td>
					</tr>
					<tr>
						<td>4) TOWING TRACTOR 및 BYPASS PIN 정 위치 확인</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2">
								<input type="radio" id="Y54" name="CHECK54" value="Y" <c:out value="${DATA.CHECK54 eq 'Y' ? 'checked' : '' }" />>
							</div>
						</td>
						<td class="rdoWrap">
							<div class="rdoBox rdoBox2 on">
								<input type="radio" id="N54" name="CHECK54" value="N" <c:out value="${DATA.CHECK54 eq 'N' ? 'checked' : '' }" />>
							</div>
						</td>
						<td><input type="text" id="desc54" name="desc54" ></td>
					</tr>
				</table>
			</div>
			<div class="uiCont">
				<h4>수하물 & 화물 탑재정보</h4>
				<div class="tbWrap nFtb">
					<table>
						<tr>
							<th colspan="2">수하물</th>
							<th colspan="2">화물</th>
						</tr>
						<tr>
							<th>ARRIVAL</th>
							<td> <input type="text" > PCS/ <input type="text" > KG</td>
							<th>ARRIVAL</th>
							<td> <input type="text" > PCS/ <input type="text" > KG</td>
						</tr>
						<tr>
							<th>DEPARTURE</th>
							<td> <input type="text" > PCS/ <input type="text" > KG</td>
							<th>DEPARTURE</th>
							<td> <input type="text" > PCS/ <input type="text" > KG</td>
						</tr>
						<tr>
							<th rowspan="2">OFF-LOAD</th>
							<td rowspan="2"> <input type="text" > (PCS,TAG NO)</td>
							<th>ULD Number</th>
							<td> <input type="text" >(ex. SHP-0123/ PCS)</td>
							<th>OFF-LOAD</th>
							<td> <input type="text" >(ex. SHP-0123/ PCS)</td>
						</tr>
						
					</table>
				</div>
			</div>
			<div class="popBtnWrap" title="save" id="btnSave">
				<button>저장</button>
			</div>
		</form>
	</div>
</div>