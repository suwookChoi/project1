<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript">
$(document).ready(function() {
	$("#btnClose").click(function(event) {
		event.preventDefault();
		doClosePopup('M');
	});
	var WTDATE = "${pageMap.STD}";
	var STA = "${pageMap.STA}";
	var ATA = "${pageMap.ATA}";
	var ATD = "${pageMap.ATD}";
	var STD = "${pageMap.STD}";
	
	STA = STA.substr(11,5);
	ATA = ATA.substr(11,5);
	ATD = ATD.substr(11,5);
	STD = STD.substr(11,5);
	WTDATE = WTDATE.substr(0,10);
	
	$('input:radio[name=CHECK11]:input[value="${DATA.CHECK11}"]').attr("checked", true);
	$('input:radio[name=CHECK11]:input[value="${DATA.CHECK11}"]').attr("checked", false);
	
	$("#STA").val(STA);
	$("#ATA").val(ATA);
	$("#ATD").val(ATD);
	$("#STD").val(STD);
	$("#WTDATE").val(WTDATE);
	var data = "${DATA}";
	if(data !=null){
		$('input:checkbox[name=CHECK11]:input[value="${DATA.CHECK11}"]').attr("checked", true);
		$('input:checkbox[name=CHECK11]:input[value="${DATA.CHECK11}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK12]:input[value="${DATA.CHECK12}"]').attr("checked", true);
		$('input:checkbox[name=CHECK12]:input[value="${DATA.CHECK12}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK13]:input[value="${DATA.CHECK13}"]').attr("checked", true);
		$('input:checkbox[name=CHECK13]:input[value="${DATA.CHECK13}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK14]:input[value="${DATA.CHECK14}"]').attr("checked", true);
		$('input:checkbox[name=CHECK14]:input[value="${DATA.CHECK14}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK15]:input[value="${DATA.CHECK15}"]').attr("checked", true);
		$('input:checkbox[name=CHECK15]:input[value="${DATA.CHECK15}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK16]:input[value="${DATA.CHECK16}"]').attr("checked", true);
		$('input:checkbox[name=CHECK16]:input[value="${DATA.CHECK16}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK17]:input[value="${DATA.CHECK17}"]').attr("checked", true);
		$('input:checkbox[name=CHECK17]:input[value="${DATA.CHECK17}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK18]:input[value="${DATA.CHECK18}"]').attr("checked", true);
		$('input:checkbox[name=CHECK18]:input[value="${DATA.CHECK18}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK19]:input[value="${DATA.CHECK19}"]').attr("checked", true);
		$('input:checkbox[name=CHECK19]:input[value="${DATA.CHECK19}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK21]:input[value="${DATA.CHECK21}"]').attr("checked", true);
		$('input:checkbox[name=CHECK21]:input[value="${DATA.CHECK21}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK22]:input[value="${DATA.CHECK22}"]').attr("checked", true);
		$('input:checkbox[name=CHECK22]:input[value="${DATA.CHECK22}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK31]:input[value="${DATA.CHECK31}"]').attr("checked", true);
		$('input:checkbox[name=CHECK31]:input[value="${DATA.CHECK31}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK32]:input[value="${DATA.CHECK32}"]').attr("checked", true);
		$('input:checkbox[name=CHECK32]:input[value="${DATA.CHECK32}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK33]:input[value="${DATA.CHECK33}"]').attr("checked", true);
		$('input:checkbox[name=CHECK33]:input[value="${DATA.CHECK33}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK34]:input[value="${DATA.CHECK34}"]').attr("checked", true);
		$('input:checkbox[name=CHECK34]:input[value="${DATA.CHECK34}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK41]:input[value="${DATA.CHECK41}"]').attr("checked", true);
		$('input:checkbox[name=CHECK41]:input[value="${DATA.CHECK41}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK42]:input[value="${DATA.CHECK42}"]').attr("checked", true);
		$('input:checkbox[name=CHECK42]:input[value="${DATA.CHECK42}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK43]:input[value="${DATA.CHECK43}"]').attr("checked", true);
		$('input:checkbox[name=CHECK43]:input[value="${DATA.CHECK43}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK44]:input[value="${DATA.CHECK44}"]').attr("checked", true);
		$('input:checkbox[name=CHECK44]:input[value="${DATA.CHECK44}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK45]:input[value="${DATA.CHECK45}"]').attr("checked", true);
		$('input:checkbox[name=CHECK45]:input[value="${DATA.CHECK45}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK46]:input[value="${DATA.CHECK46}"]').attr("checked", true);
		$('input:checkbox[name=CHECK46]:input[value="${DATA.CHECK46}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK51]:input[value="${DATA.CHECK51}"]').attr("checked", true);
		$('input:checkbox[name=CHECK51]:input[value="${DATA.CHECK51}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK52]:input[value="${DATA.CHECK52}"]').attr("checked", true);
		$('input:checkbox[name=CHECK52]:input[value="${DATA.CHECK52}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK53]:input[value="${DATA.CHECK53}"]').attr("checked", true);
		$('input:checkbox[name=CHECK53]:input[value="${DATA.CHECK53}"]').parent().addClass("on");
		$('input:checkbox[name=CHECK54]:input[value="${DATA.CHECK54}"]').attr("checked", true);
		$('input:checkbox[name=CHECK54]:input[value="${DATA.CHECK54}"]').parent().addClass("on");
		init_allCheck("${DATA.CHECK54}");
	}
	
	jQuery("#chkAll1_1").click(function(){
		allCheck('Y');
	});
	jQuery("#chkAll1_2").click(function(){
		allCheck('N');
	});
});
function init_allCheck(flag){
	var a = 0;
	var b = 0;
	var chkValue = flag;
	
	$("input:checkbox[name^='CHECK']:input[value='"+chkValue+"']").each(function(){
		b++;
		if($(this).attr("checked") == "checked"){
			a++;
		}
	});
	
	if(a != b){
		$("input:checkbox[id^='chkAll1_']:input[value!='"+chkValue+"']").parent().removeClass('on');
	}else{
		$("input:checkbox[id^='chkAll1_']:input[value='"+chkValue+"']").parent().addClass('on');
	}
}

function allCheck(flag){
	$("input:checkbox[name^='CHECK']").attr("checked", false);
	if(flag == 'Y'){
		if($("input:checkbox[id^='chkAll1_']:input[value='Y']").parent().hasClass('on')){
			$("input:checkbox[name^='CHECK']:input[value='N']").parent().removeClass('on');
			$("input:checkbox[id^='chkAll1_']:input[value='N']").parent().removeClass('on');
			$("input:checkbox[name^='CHECK']:input[value='Y']").attr("checked", true);
		}else{
			$("input:checkbox[name^='CHECK']:input[value='Y']").parent().removeClass('on');
			$("input:checkbox[id^='chkAll1_']:input[value='Y']").parent().removeClass('on');
		}
	}else{
		if($("input:checkbox[id^='chkAll1_']:input[value='N']").parent().hasClass('on')){
			$("input:checkbox[name^='CHECK']:input[value='Y']").parent().removeClass('on');
			$("input:checkbox[id^='chkAll1_']:input[value='Y']").parent().removeClass('on');
			$("input:checkbox[name^='CHECK']:input[value='N']").attr("checked", true);
		}else{
			$("input:checkbox[name^='CHECK']:input[value='N']").parent().removeClass('on');
			$("input:checkbox[id^='chkAll1_']:input[value='N']").parent().removeClass('on');
		}
	}
}

function onchangeCheck(check){
	var chkValue = check.value;
	var chkName = check.name;
	
<<<<<<< .mine
	var chkValue = $(check).children().children().val();
	var chkId = $(check).children().children().attr('id');	
	var chkName = $(check).children().children().attr('name');	
	
	
	console.log(chkId,',',chkName,',',$("input:checkbox[name="+chkName+"]").is(":checked"));
	
	// 체크여부 확인
	if($("input:checkbox[id="+chkId+"]").is(":checked") == true) {
		$('input:checkbox[id='+chkId+']').prop('checked', false);
		$('input:checkbox[id='+chkId+']').attr('checked', false);
		
		console.log("하하하");
	}else{
		console.log("호호호");
		$('input:checkbox[id='+chkId+']').prop('checked', true);
		$('input:checkbox[id='+chkId+']').attr('checked', true);
	}

	/* 
	$("input:radio[name='"+$(check).children().children().attr('name')+"']").attr("checked", false);
	$("input:radio[name='"+$(check).children().children().attr('name')+"']:input[value='"+ chkValue + "']").attr("checked", true);
||||||| .r14044
	var chkValue = $(check).children().children().val();
	$("input:radio[name='"+$(check).children().children().attr('name')+"']").attr("checked", false);
	$("input:radio[name='"+$(check).children().children().attr('name')+"']:input[value='"+ chkValue + "']").attr("checked", true);
=======
	$("input:checkbox[name='"+chkName+"']:input[value='"+ chkValue + "']").attr("checked", true);
	$("input:checkbox[name='"+chkName+"']:input[value!='"+ chkValue + "']").attr("checked", false);
	$("input:checkbox[name='"+chkName+"']:input[value!='"+ chkValue + "']").parent().removeClass("on");
>>>>>>> .r14194
	 */
	init_allCheck(chkValue);
}

function ajax_callback(sid, json) {
	var data = json.DATA;
	if (sid == "doSave") {
		var result =json.result;
		if(result=='success'){
			alert('저장에 성공하였습니다.');
			self.close();
		}else{
			alert('저장에 실패하였습니다.');
			return;
		}
	}
}

function openPdf(){
	var data = {'BEP':"${pageMap.BEP}", 'STD_RO':"${pageMap.STD_RO}", 'ARP':"${pageMap.ARP}", 'FLAG':'RC'};
	
	data = JSON.stringify(data);
	
	$("#hiddenFrame2").attr("src", "<c:url value="/main/BriefingPDFDownLoad.pdf"/>?data="+encodeURI(data));
	$("#hiddenFrame2").submit();
}

//저장하기
function doSave() {
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-+<>@\#$%&\\\=\(\'\"]/gi;
	var STD="${pageMap.STD}";
	var STA="${pageMap.STA}";
	var ATD="${pageMap.ATD}";
	var ATA="${pageMap.ATA}";
	
	STD=STD.replace(regExp,"");
	STD=STD.replace(/\s/g,"");
	STA=STA.replace(regExp,"");
	STA=STA.replace(/\s/g,"");
	ATD=ATD.replace(regExp,"");
	ATD=ATD.replace(/\s/g,"");
	ATA=ATA.replace(regExp,"");
	ATA=ATA.replace(/\s/g,"");
	
	var CHECK11 = fn_isEmpty($("#Y11").attr("checked")) || $("#Y11").attr("checked")==false ? fn_isEmpty($("#N11").attr("checked")) || $("#N11").attr("checked")==false ? "" : "N" : "Y";
	var CHECK12 = fn_isEmpty($("#Y12").attr("checked")) || $("#Y12").attr("checked")==false ? fn_isEmpty($("#N12").attr("checked")) || $("#N12").attr("checked")==false ? "" : "N" : "Y";
	var CHECK13 = fn_isEmpty($("#Y13").attr("checked")) || $("#Y13").attr("checked")==false ? fn_isEmpty($("#N13").attr("checked")) || $("#N13").attr("checked")==false ? "" : "N" : "Y";
	var CHECK14 = fn_isEmpty($("#Y14").attr("checked")) || $("#Y14").attr("checked")==false ? fn_isEmpty($("#N14").attr("checked")) || $("#N14").attr("checked")==false ? "" : "N" : "Y";
	var CHECK15 = fn_isEmpty($("#Y15").attr("checked")) || $("#Y15").attr("checked")==false ? fn_isEmpty($("#N15").attr("checked")) || $("#N15").attr("checked")==false ? "" : "N" : "Y";
	var CHECK16 = fn_isEmpty($("#Y16").attr("checked")) || $("#Y16").attr("checked")==false ? fn_isEmpty($("#N16").attr("checked")) || $("#N16").attr("checked")==false ? "" : "N" : "Y";
	var CHECK17 = fn_isEmpty($("#Y17").attr("checked")) || $("#Y17").attr("checked")==false ? fn_isEmpty($("#N17").attr("checked")) || $("#N17").attr("checked")==false ? "" : "N" : "Y";
	var CHECK18 = fn_isEmpty($("#Y18").attr("checked")) || $("#Y18").attr("checked")==false ? fn_isEmpty($("#N18").attr("checked")) || $("#N18").attr("checked")==false ? "" : "N" : "Y";
	var CHECK19 = fn_isEmpty($("#Y19").attr("checked")) || $("#Y19").attr("checked")==false ? fn_isEmpty($("#N19").attr("checked")) || $("#N19").attr("checked")==false ? "" : "N" : "Y";
	var CHECK21 = fn_isEmpty($("#Y21").attr("checked")) || $("#Y21").attr("checked")==false ? fn_isEmpty($("#N21").attr("checked")) || $("#N21").attr("checked")==false ? "" : "N" : "Y";
	var CHECK22 = fn_isEmpty($("#Y22").attr("checked")) || $("#Y22").attr("checked")==false ? fn_isEmpty($("#N22").attr("checked")) || $("#N22").attr("checked")==false ? "" : "N" : "Y";
	var CHECK31 = fn_isEmpty($("#Y31").attr("checked")) || $("#Y31").attr("checked")==false ? fn_isEmpty($("#N31").attr("checked")) || $("#N31").attr("checked")==false ? "" : "N" : "Y";
	var CHECK32 = fn_isEmpty($("#Y32").attr("checked")) || $("#Y32").attr("checked")==false ? fn_isEmpty($("#N32").attr("checked")) || $("#N32").attr("checked")==false ? "" : "N" : "Y";
	var CHECK33 = fn_isEmpty($("#Y33").attr("checked")) || $("#Y33").attr("checked")==false ? fn_isEmpty($("#N33").attr("checked")) || $("#N33").attr("checked")==false ? "" : "N" : "Y";
	var CHECK34 = fn_isEmpty($("#Y34").attr("checked")) || $("#Y34").attr("checked")==false ? fn_isEmpty($("#N34").attr("checked")) || $("#N34").attr("checked")==false ? "" : "N" : "Y";
	var CHECK41 = fn_isEmpty($("#Y41").attr("checked")) || $("#Y41").attr("checked")==false ? fn_isEmpty($("#N41").attr("checked")) || $("#N41").attr("checked")==false ? "" : "N" : "Y";
	var CHECK42 = fn_isEmpty($("#Y42").attr("checked")) || $("#Y42").attr("checked")==false ? fn_isEmpty($("#N42").attr("checked")) || $("#N42").attr("checked")==false ? "" : "N" : "Y";
	var CHECK43 = fn_isEmpty($("#Y43").attr("checked")) || $("#Y43").attr("checked")==false ? fn_isEmpty($("#N43").attr("checked")) || $("#N43").attr("checked")==false ? "" : "N" : "Y";
	var CHECK44 = fn_isEmpty($("#Y44").attr("checked")) || $("#Y44").attr("checked")==false ? fn_isEmpty($("#N44").attr("checked")) || $("#N44").attr("checked")==false ? "" : "N" : "Y";
	var CHECK45 = fn_isEmpty($("#Y45").attr("checked")) || $("#Y45").attr("checked")==false ? fn_isEmpty($("#N45").attr("checked")) || $("#N45").attr("checked")==false ? "" : "N" : "Y";
	var CHECK46 = fn_isEmpty($("#Y46").attr("checked")) || $("#Y46").attr("checked")==false ? fn_isEmpty($("#N46").attr("checked")) || $("#N46").attr("checked")==false ? "" : "N" : "Y";
	var CHECK51 = fn_isEmpty($("#Y51").attr("checked")) || $("#Y51").attr("checked")==false ? fn_isEmpty($("#N51").attr("checked")) || $("#N51").attr("checked")==false ? "" : "N" : "Y";
	var CHECK52 = fn_isEmpty($("#Y52").attr("checked")) || $("#Y52").attr("checked")==false ? fn_isEmpty($("#N52").attr("checked")) || $("#N52").attr("checked")==false ? "" : "N" : "Y";
	var CHECK53 = fn_isEmpty($("#Y53").attr("checked")) || $("#Y53").attr("checked")==false ? fn_isEmpty($("#N53").attr("checked")) || $("#N53").attr("checked")==false ? "" : "N" : "Y";
	var CHECK54 = fn_isEmpty($("#Y54").attr("checked")) || $("#Y54").attr("checked")==false ? fn_isEmpty($("#N54").attr("checked")) || $("#N54").attr("checked")==false ? "" : "N" : "Y";
	
/* 	if(  CHECK11 == "" 
	  && CHECK12 == ""
	  && CHECK13 == ""
	  && CHECK14 == ""
	  && CHECK15 == ""
	  && CHECK16 == ""
	  && CHECK17 == ""
	  && CHECK18 == ""
	  && CHECK19 == ""
	  && CHECK21 == ""
	  && CHECK22 == ""
	  && CHECK31 == ""
	  && CHECK32 == ""
	  && CHECK33 == ""
	  && CHECK34 == ""
	  && CHECK41 == ""
	  && CHECK42 == ""
	  && CHECK43 == ""
	  && CHECK44 == ""
	  && CHECK45 == ""
	  && CHECK46 == ""
	  && CHECK51 == ""
	  && CHECK52 == ""
	  && CHECK53 == ""
	  && CHECK54 == "" ){
		alert("체크 항목을 확인하세요.");
		return;
	} */
	
	var sid;
	var url;
	var data;
	data={
		"BEP" :"${pageMap.BEP}"
		,"SEQ":"${pageMap.SEQ}"
		,"WR_DT":$("#WTDATE").val()
		,"SIBT" :STA
		,"AIBT" :ATA
		,"SOBT" :STD
		,"AOBT" :ATD
		,"REG"  :"${pageMap.OUT_REG}"
		,"PAK"  :"${pageMap.OUT_PAK}"
		,"ARP"  :"${pageMap.ARP}"
		,"TYS"  :"${pageMap.OUT_TYS}"
		,"FLC"  :"${pageMap.FLC}"
		,"CHECK11" :CHECK11
		,"CHECK12" :CHECK12,"CHECK13" :CHECK13,"CHECK14" :CHECK14
		,"CHECK15" :CHECK15,"CHECK16" :CHECK16,"CHECK17" :CHECK17
		,"CHECK18" :CHECK18,"CHECK19" :CHECK19,"CHECK21" :CHECK21
		,"CHECK22" :CHECK22,"CHECK31" :CHECK31,"CHECK32" :CHECK32
		,"CHECK33" :CHECK33,"CHECK34" :CHECK34,"CHECK41" :CHECK41
		,"CHECK42" :CHECK42,"CHECK43" :CHECK43,"CHECK44" :CHECK44
		,"CHECK45" :CHECK45,"CHECK46" :CHECK46,"CHECK51" :CHECK51
		,"CHECK52" :CHECK52,"CHECK53" :CHECK53,"CHECK54" :CHECK54
	};
	
	sid="doSave";
	url = '<c:url value="/main/RCCheckSave.json"/>';
	ajax_sendData(sid, url, data);
}
</script>
<style>
.nFtb table tr input{
	color: #494e57;font-size: 18px; background: none;border: none;text-align: left;
}
.tbWrap table td input[type=text]{
	width: 31%;
}
</style>
<c:if test="${pageMap.POP_FLAG eq 'M'}">
<body onunload="doClosePopup('M');">
</c:if>
<c:if test="${pageMap.POP_FLAG ne 'M'}">
<body onunload="doClosePopup('S');">
</c:if>
<div class="popupWrap">
	<div class="contWrap rcChkLitWrap">
		<div class="titWrap"><h3>Ramp Coordinator(RC) Checklist</h3></div>
		<div class="popConWrap scrPop">
			<div class="tbWrap nFtb vtbWrap">
				<table>
					<tr>
						<th>FLT No./ Date</th>
						<td>${pageMap.BEP}/</br>&nbsp;<input id="WTDATE" name="WTDATE" readonly="readonly"></td>
						<th>STA / ATA</th>
						<td><input type="text" id="STA" readonly="readonly">/<input type="text" id="ATA" readonly="readonly"></td>
						<th>STD / ATD</th>
						<td><input type="text" id="STD" readonly="readonly">/<input type="text" id="ATD" readonly="readonly"></td>
					</tr>
					<tr>
						<th>Reg No.</th>
						<td>${pageMap.OUT_REG}</td>
						<th>기종 / SPOT</th>
						<td>${pageMap.OUT_TYS}/${pageMap.OUT_PAK} </td>
						<td colspan="2"></td>
					</tr>
				</table>
			</div>
			<div class="sbTitWrap"><h4>점검사항</h4></div>
			<div class="tbWrap nFtb">
				 <table class="chkWrap chkTbi">
					<colgroup>
						<col style="width:10%">
						<col style="width:66%">
						<col style="width:8%">
						<col style="width:8%">
					</colgroup>
					<tr>
						<th rowspan="2" style="border-bottom:1px solid #ccc;">구분</th>
						<th rowspan="2">점검내용</th>
						<th colspan="2" style="border-bottom:1px solid #ccc;">점검결과</th>
					</tr>
					<tr>
						<th>
							<div class="chkBox all al1">
								<input type="checkbox" id="chkAll1_1" class="ipt" value="Y">
								<label for="chkAll1_1">Yes</label>
		                    </div>
						</th>
						<th>
							<div class="chkBox all al2">
								<input type="checkbox" id="chkAll1_2" class="ipt" value="N">
								<label for="chkAll1_2">No</label>
							</div>
						</th>
					</tr>
					<tr>
						<th rowspan="9" class="subTh" style="border-bottom:1px solid #ccc;">사전조업<br>준비점검</th>
						<td>1) ETA, REG Number, Parking Spot 확인</td>
<<<<<<< .mine
						<td class="rdoConBox">
							<div class="rdoBox <c:out value="${DATA.CHECK11 eq 'Y' ? 'on' : '' }"/>" >
								<!-- <input type="radio" class="ipt" id="Y11" name="CHECK11" value="Y" > -->
								<input type="checkbox" class="ipt" id="Y11" name="CHECK11" value="Y" >
||||||| .r14044
						<td class="rdoConBox">
							<div class="rdoBox <c:out value="${DATA.CHECK11 eq 'Y' ? 'on' : '' }"/>" >
								<input type="radio" class="ipt" id="Y11" name="CHECK11" value="Y" >
=======
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y11" class="ipt" name="CHECK11" value="Y" onclick="onchangeCheck(this);">
>>>>>>> .r14194
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N11" class="ipt" name="CHECK11" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>2) GPU, ACU, ASU 요청 장비 준비 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y12" class="ipt" name="CHECK12" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N12" class="ipt" name="CHECK12" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>3) Interphone, Safety Cone, Chock 준비확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y13" class="ipt" name="CHECK13" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N13" class="ipt" name="CHECK13" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>4) 도착 주기장내 안전확인 (FOD제거확인)</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y14" class="ipt" name="CHECK14" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N14" class="ipt" name="CHECK14" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>5) OUT Bound 수하물 및 화물 정시 도착 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y15" class="ipt" name="CHECK15" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N15" class="ipt" name="CHECK15" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>6) IN Bound 용 DOLLY 및 기타 조업장비 사전준비 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y16" class="ipt" name="CHECK16" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N16" class="ipt" name="CHECK16" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>7) 적정 조업지원 인원 확인 (연결편 지연 여부 확인)</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y17" class="ipt" name="CHECK17" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N17" class="ipt" name="CHECK17" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>8) 조업인원/장비 정위치 확인(유도원, Wing guarder, 인터폰맨, 램프버스 등)</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y18" class="ipt" name="CHECK18" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N18" class="ipt" name="CHECK18" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>9) 수출화물 ULD별 작업상황 확인 후 탑재계획 수립 (아래 2번 항목 기입)</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y19" class="ipt" name="CHECK19" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N19" class="ipt" name="CHECK19" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<th rowspan="2" class="subTh" style="border-bottom:1px solid #ccc;">Compartment<br>Door점검(도착)</th>
						<td>1) Door Open 전 Door 상태 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y21" class="ipt" name="CHECK21" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N21" class="ipt" name="CHECK21" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>2) Compartment 내부 및 Netting, Tie Down 상태 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y22" class="ipt" name="CHECK22" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N22" class="ipt" name="CHECK22" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<th rowspan="4" class="subTh" style="border-bottom:1px solid #ccc;">UNLOADING<br>(하기작업)</th>
						<td>1) 하기할 화물/수하물 및 탑재위치 파악(DoorSide/유모차/수하물/특송화물 등)</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y31" class="ipt" name="CHECK31" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N31" class="ipt" name="CHECK31" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>2) IN Bound 수하물/화물 전량 하기 확인.</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y32" class="ipt" name="CHECK32" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N32" class="ipt" name="CHECK32" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>3) 각 Compartment 별 잔여물, 잔재여부 청소 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y33" class="ipt" name="CHECK33" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
 						<td>
	 						<div class="chkBox st2">
								<input type="checkbox" id="N33" class="ipt" name="CHECK33" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>4) 각 Compartment 내부 손상(파손) 여부 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y34" class="ipt" name="CHECK34" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N34" class="ipt" name="CHECK34" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<th rowspan="6" class="subTh" style="border-bottom:1px solid #ccc;">LOADING<br>(탑재작업)</th>
						<td>1) 탑재지시서(L.I.R)에 의한 탑재 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y41" class="ipt" name="CHECK41" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N41" class="ipt" name="CHECK41" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>2) FAK, OOG, Gate Bag, COMAT, 유모차, Door Side, Heavy Cargo 등 확인</td>
						<td>
							<div class="chkBox st1">
 								<input type="checkbox" id="Y42" class="ipt" name="CHECK42" value="Y" onclick="onchangeCheck(this);">
 							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N42" class="ipt" name="CHECK42" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>3) 탑재조업 직원의 수하물/화물 SOFT핸들링 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y43" class="ipt" name="CHECK43" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N43" class="ipt" name="CHECK43" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>4) 카운터 최종마감 수하물 개수와 최종탑재 수하물 개수 일치 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y44" class="ipt" name="CHECK44" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N44" class="ipt" name="CHECK44" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>5) 탑재 시 Damage 수하물/화물 여부 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y45" class="ipt" name="CHECK45" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N45" class="ipt" name="CHECK45" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>6) 탑재완료 후 Compartment 별 탑재 상황 operation(W/B)팀과 재확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y46" class="ipt" name="CHECK46" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N46" class="ipt" name="CHECK46" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<th rowspan="4" class="subTh">Compartment<br>Door점검(출발)</th>
						<td>1) 탑재완료 후 최종 Tie Down, Netting, 내부파손여부 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y51" class="ipt" name="CHECK51" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N51" class="ipt" name="CHECK51" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>2) 각 Compartment 내부 손상(파손) 여부 확인</td>
<<<<<<< .mine
						<td class="rdoConBox">
							<div class="rdoBox <c:out value="${DATA.CHECK52 eq 'Y' ? 'on' : '' }" /> ">
								<input type="checkbox" id="Y52" class="ipt" name="CHECK52" value="Y">
							</div>
						</td>
						<td class="rdoConBox">
							<div class="rdoBox <c:out value="${DATA.CHECK52 eq 'N' ? 'on' : '' }" /> ">
								<input type="checkbox" id="N52" class="ipt" name="CHECK52" value="N" >
							</div>
						</td>
					</tr>
					<tr class="rdoWrap">
						<td>3) 앞 뒤 Door Close 확인</td>
						<td class="rdoConBox" onclick="onchangeRadio(this);" >
							<div class="rdoBox <c:out value="${DATA.CHECK53 eq 'Y' ? 'on' : '' }" />">
								<input type="checkbox" id="Y53" name="CHECK53" value="Y" >
							</div>
						</td>
						<td class="rdoConBox" onclick="onchangeRadio(this);">
							<div class="rdoBox <c:out value="${DATA.CHECK53 eq 'N' ? 'on' : '' }" /> ">
								<input type="checkbox" id="N53" name="CHECK53" value="N" >
							</div>
						</td>
					</tr>
					<tr class="rdoWrap">
						<td>4) TOWING TRACTOR 및 BYPASS PIN 정 위치 확인</td>
						<td class="rdoConBox" onclick="onchangeRadio(this);">
							<div class="rdoBox <c:out value="${DATA.CHECK54 eq 'Y' ? 'on' : '' }" /> ">
								<input type="checkbox" id="Y54" name="CHECK54" value="Y">
							</div>
						</td>
						<td class="rdoConBox" onclick="onchangeRadio(this);">
							<div <c:out value="${DATA.CHECK54 eq 'N' ? 'on' : '' }" /> ">
								<input type="checkbox" id="N54" name="CHECK54" value="N" >
							</div>
						</td>
					</tr>
<%-- 					<tr class="rdoWrap">
						<th rowspan="4" class="subTh">Compartment<br>Door점검(출발)</th>
						<td>1) 탑재완료 후 최종 Tie Down, Netting, 내부파손여부 확인</td>
						<td class="rdoConBox">
							<div class="rdoBox <c:out value="${DATA.CHECK51 eq 'Y' ? 'on' : '' }" /> ">
								<input type="radio" id="Y51" class="ipt" name="CHECK51" value="Y">
							</div>
						</td>
						<td class="rdoConBox">
							<div class="rdoBox <c:out value="${DATA.CHECK51 eq 'N' ? 'on' : '' }" /> ">
								<input type="radio" id="N51" class="ipt" name="CHECK51" value="N" >
							</div>
						</td>
					</tr>
					<tr class="rdoWrap">
						<td>2) 각 Compartment 내부 손상(파손) 여부 확인</td>
						<td class="rdoConBox">
							<div class="rdoBox <c:out value="${DATA.CHECK52 eq 'Y' ? 'on' : '' }" /> ">
								<input type="radio" id="Y52" class="ipt" name="CHECK52" value="Y">
||||||| .r14044
						<td class="rdoConBox">
							<div class="rdoBox <c:out value="${DATA.CHECK52 eq 'Y' ? 'on' : '' }" /> ">
								<input type="radio" id="Y52" class="ipt" name="CHECK52" value="Y">
=======
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y52" class="ipt" name="CHECK52" value="Y" onclick="onchangeCheck(this);">
>>>>>>> .r14194
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N52" class="ipt" name="CHECK52" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>3) 앞 뒤 Door Close 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y53" class="ipt" name="CHECK53" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N53" class="ipt" name="CHECK53" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr>
					<tr>
						<td>4) TOWING TRACTOR 및 BYPASS PIN 정 위치 확인</td>
						<td>
							<div class="chkBox st1">
								<input type="checkbox" id="Y54" class="ipt" name="CHECK54" value="Y" onclick="onchangeCheck(this);">
							</div>
						</td>
						<td>
							<div class="chkBox st2">
								<input type="checkbox" id="N54" class="ipt" name="CHECK54" value="N" onclick="onchangeCheck(this);">
							</div>
						</td>
					</tr> --%>
				</table>
			</div>
		</div>
		<div class="popBtnWrap popBtn"><!-- 버튼이 2개일때 클래스 추가 class="popBtn" -->
			<button id="btn_pdf" onclick="openPdf()">PDF변환</button>
			<button id="btn_save" onclick="doSave()">저장</button>
		</div>
	</div>
</div>
</body>

<div id="divDownload2">
	<iframe id="hiddenFrame2" style="display:none;"></iframe>
</div>