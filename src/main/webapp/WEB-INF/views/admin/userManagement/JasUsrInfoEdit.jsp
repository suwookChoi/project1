<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />
<script type="text/javascript">

//Ajax CallBack 함수
function ajax_callback(sid,json) {
	if(sid == 'findDepartment'){
		try {
			var html = "";
			var dept = json.deptnm;
			
			$.each(dept,function(enytyIndex,entry){
				html +="<option value="+entry.DEPT_CD+">"+entry.DEPT_NM+"</option>";
			});
			$('#DEPT_NM').empty();
			$("#DEPT_NM").append(html);
			$("#DEPT_NM").val('${SELECTDATA.DEPT_CD}');
		} catch (e) {Logger.debug(e);}
	}else if(sid == "doSave"){
		try {
			var result = json.result;
			if(!sessionCheckJSON(json)) return;
			else if(result == "1") alert("저장에 성공하였습니다.");
			else alert("저장이 실패하였습니다");
		}catch (e) {Logger.debug(e);}
	}else if(sid == "pwdInit"){
		if(!sessionCheckJSON(json)) return;
		else{
			if(json.result == 1) alert("저장에 성공하였습니다.");
			else alert("저장에 실패하였습니다.");
		}
	}
}

//지점 선택
function findARP() {
	var companynm = $("#COMPANY_NM").val();
	var data = {"COMPANY_NM" : companynm};
	var sid = "findARP";
	var url = "<c:url value='/userManagement/findARPJSON.json'/>";
	ajax_sendData(sid,url,data);
}

// 부서 선택
function findDepartment() {
	var companynm = $("#COMPANY_NM").val();
	var arp = $("#ARP").val();
	var data = { "COMPANY_NM" : companynm, "ARP" : arp};
	var sid = "findDepartment";
	var url = "<c:url value='/userManagement/usrFindDepartmentJSON.json'/>";
	ajax_sendData(sid,url,data);
}

// 저장하기
function doSave() {
	var pattern = new RegExp("\\w+([\\-\\+\\.]\\w+)*@\\w+([\\-\\.]\\w+)*\\.[a-zA-Z]{2,4}$", "");
	var email = $("#EMAIL").val();
	
	if(!fn_isEmpty(email) && !pattern.test(email)){
		alert("이메일 형식을다시  확인하세요.");
		return;
	}
	
	if($("#USER_NM").val() == null || $("#MOBILE_NO").val() == null || $("#COMPANY_NM option:selected").val() == null
			|| $("#ARP").val() == null || $("#DEPT_NM").val() == null
			|| $("#USER_NM").val() == "" || $("#MOBILE_NO").val() == "" || $("#COMPANY_NM option:selected").val() == ""
			|| $("#ARP").val() == "" || $("#DEPT_NM").val() == ""){
		alert("필수항목을 다시 확인하세요.\n(핸드폰/회사/지점/부서)");
		return;
	}
	
	var roleid;
	var USER_STATUS;
	var STATUS_REASON;
	var companynm = $("#COMPANY_NM option:selected").val();
	var sessionRoleid = "${USER_SESSION.ROLE_ID}";
	var mypage="${MYPAGE}";
	var TOWING ="";
	var CARGOLOADER="";
	var RAMPBUS = "";
	var De_ICING ="";
	var INTERPHONE ="";
	var type="${MYPAGE}";
	var data;
	var sid ="doSave";
	var url ="<c:url value='/userManagement/UserInfoEdit.json'/>";
	
	//사용자 장비 사용가능 여부 체크 
	if($('#TOWING').is(":checked") == false) TOWING ="N";
	else TOWING ="Y";
	if($('#CARGOLOADER').is(":checked") == false) CARGOLOADER = "N";
	else CARGOLOADER = "Y";
	if($('#RAMPBUS').is(":checked") == false) RAMPBUS = "N";
	else RAMPBUS = "Y";
	if($('#DE_ICING').is(":checked") == false) DE_ICING = "N";
	else DE_ICING = "Y";
	if($('#INTERPHONE').is(":checked") == false) INTERPHONE = "N";
	else INTERPHONE = "Y";
	
	//관리자 페이지에서 진입 시
	if(sessionRoleid == "ADMIN" && type != 'Y'){
		roleid =$("#ROLE_NM option:selected").val();
		USER_STATUS = $("#USER_STATUS option:selected").val();
		STATUS_REASON = $("#STATUS_REASON").val();
		data = {
				"USER_ID":$("#USER_ID").val()
				, "USER_NM": $("#USER_NM").val()
				, "COMPANY_NM": companynm
				, "DEPT_NM": $("#DEPT_NM").val()
				, "JOB_LEVEL": $("#JOB_LEVEL").val()
				, "DUTY": $("#DUTY").val()
				, "ARP": $("#ARP").val()
				, "MOBILE_NO": $("#MOBILE_NO").val()
				, "EMAIL": $("#EMAIL").val()
				, "OFFICE_NO": $("#OFFICE_NO").val()
				, "USERINFO_DESC" : $("#USERINFO_DESC").val()
				, "USER_STATUS": USER_STATUS
				, "STATUS_REASON":$("#STATUS_REASON").val()
				, "DEPT_CD" : $("#DEPT_NM").val()
				, "ROLE_ID" : roleid
				, "USE_YN" :$("#USE_YN").val()
				, "USER_STATUS_ID" : $("#USER_STATUS").val()
				, "STATUS_REASON" : STATUS_REASON
				, "TOWING" : TOWING
				, "CARGOLOADER" : CARGOLOADER
				, "RAMPBUS" : RAMPBUS
				, "DE_ICING" : DE_ICING
				, "INTERPHONE" : INTERPHONE
				, "JOB_POS" : $("#JOB_POS").val()
		}
	//마이페이지에서 진입 시
	}else{ 
		roleid =$("#ROLE_NM_RO").val();
		USER_STATUS = $("#USER_STATUS_RO").val();
		STATUS_REASON = $("#USER_REASON_RO").val();
		data = {
				"USER_ID":$("#USER_ID").val()
				, "USER_NM": $("#USER_NM").val()
				, "COMPANY_NM": companynm
				, "DEPT_NM": $("#DEPT_NM").val()
				, "JOB_LEVEL": $("#JOB_LEVEL").val()
				, "DUTY": $("#DUTY").val()
				, "ARP": $("#ARP").val()
				, "MOBILE_NO": $("#MOBILE_NO").val()
				, "EMAIL": $("#EMAIL").val()
				, "OFFICE_NO": $("#OFFICE_NO").val()
				, "USERINFO_DESC" : $("#USERINFO_DESC").val()
				, "USER_STATUS": USER_STATUS
				, "STATUS_REASON":$("#STATUS_REASON").val()
				, "DEPT_CD" : $("#DEPT_NM").val()
				, "ROLE_ID" : roleid
				, "USE_YN" : "Y"
				, "USER_STATUS_ID" : $("#USER_STATUS_ID_RO").val()
				, "STATUS_REASON" : STATUS_REASON
				, "TOWING" : TOWING
				, "CARGOLOADER" : CARGOLOADER
				, "RAMPBUS" : RAMPBUS
				, "DE_ICING" : DE_ICING
				, "INTERPHONE" : INTERPHONE
				, "JOB_POS" : $("#JOB_POS").val()
			}
	}
	ajax_sendData(sid,url,data); 
}

// 관리자 비밀번호 초기화
function pwdInit(){
	var sid="pwdInit";
	var url="<c:url value="/userManagement/JASChangePWD.json" />";
	var data ={'USER_ID':$("#USER_ID").val()};
	ajax_sendData(sid,url,data);
}

// 사용자 비밀번호 초기화
function newPassWord() {
	var url = '<c:url value="/userManagement/UserPasswordResetPopup.popup"/>';
	$("#popupForm").attr("target" , 'Popup_UserRegistPopup');
	window.open(url , 'Popup_UserPasswordReset' , "width=700,height=640, scrollbars=yes").focus();
	$("#popupForm").submit();
}

jQuery("document").ready(function(){
	$('#ROLE_NM').val('${SELECTDATA.ROLE_NM}');
	$('#USE_YN').val('${SELECTDATA.USE_YN}');
	$('#COMPANY_NM').val('${SELECTDATA.COMPANY_NM}');
	$('#DEPT_NM').html('<option value="${SELECTDATA.DEPT_CD}">${SELECTDATA.DEPT_NM}</option>');
	$('#ACC_ST').val('${SELECTDATA.ACC_ST}');
	$("#JOB_LEVEL").val('${SELECTDATA.JOB_LEVEL}');
	$("#USER_STATUS").val('${SELECTDATA.USER_STATUS_ID}');
	$("#JOB_POS").val('${SELECTDATA.JOB_POS}');
	$("#ARP").val('${SELECTDATA.ARP}');
	$("#STATUS_REASON").text('${SELECTDATA.STATUS_REASON}');
	findDepartment();
	$("#DEPT_NM").val('${SELECTDATA.DEPT_CD}');
	
	jQuery(".enter").keydown(function(event){
		if(event.keyCode == 13) {
			event.preventDefault();
		}
	});
	
	$("#COMPANY_NM").change(function () {
		findARP();
		findDepartment();
	}).css("cursor", "pointer");
	
	$("#ARP").change(function () {
		findDepartment();
	}).css("cursor", "pointer");
	
	$("#btnSetting").click(function(){
		if($("#USER_PASSWORD").val() != ''){
			if(confirm("비밀번호를 초기화 하시겠습니까?")){
				newPassWord();
			}else return;
		}else{
			alert("비밀번호를 다시 확인하세요");
		}
	}).css("cursor", "pointer");
	
	$("#btn_setting").click(function(){
		if($("#USER_PASSWORD").val() != ''){
			if(confirm("비밀번호를 초기화 하시겠습니까?")){
				pwdInit();
			}
		}else{
			alert("비밀번호를 다시 확인하세요");
		}
	}).css("cursor", "pointer");
	
	$("#btn_List").click(function(){
		window.location.href="<c:out value='/userManagement/UserManagementListForm.do' />";
	}).css("cursor", "pointer");
	
	$(window).resize();
});
</script>
<div id="contents" class="contWrap">
	<form id="deleteFrom" method="post">
		<input type="hidden" id="selectUserID" name="col">
	</form>
	<div class="listWrap uiConWrap">
		<!-- contents title end-->
		<!-- contents start -->
		<div class="chart" class="contWrap">
			<input type="hidden" id="hiddenUserID" name="hiddenUserID" value="${hiddenUserID}">
			<div id="div_INF" class="uiCont">
				<h4>사용자 개인 정보</h4>
				<div class="tbWrap nFtb">
					<table>
						<tr>
							<th>사원번호</th>
							<th>이름</th>
							<th>이메일</th>
							<th>핸드폰</th>
						</tr>
						<tr>
							<td>
								<span style="display:block; width:180px;" id="spanUSER_ID"></span>
								<input type="text" id="USER_ID" name="USER_ID" readonly="readonly" style="background-color: #ebebe4;" value="${SELECTDATA.USER_ID}" />
							</td>
							<td>
								<input type="text" id="USER_NM" name="USER_NM" readonly="readonly" style="background-color: #ebebe4;" value="${SELECTDATA.USER_NM}" fname="Name"/>
							</td>
							<td>
								<input type="text" id="EMAIL" name="EMAIL" value="${SELECTDATA.EMAIL}" maxlength="35" fname="EMAIL"/>
							</td>
							<td>
								<input type="text" id="MOBILE_NO" name="MOBILE_NO" maxlength="13" value="${SELECTDATA.MOBILE_NO}" fname="MOBILE"  onkeyup="javascript:numCheck4(this);" />
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div id="div_INF2" class="uiCont">
				<h4>사용자 직무 정보</h4>
				<div class="tbWrap nFtb">
					<table>
						<tr>
							<th>회사</th>
							<th>지점</th>
							<th>부서</th>
							<th>직책</th>
							<th>직급</th>
							<th>사내번호</th>
						</tr>
						<tr>
							<td>
								<select id="COMPANY_NM" name="COMPANY_NM" class="w180" >
									<c:forEach var="caompanynm" items="${COMPANYLIST}">
										<option value="${caompanynm.COMPANY_NM}">${caompanynm.COMPANY_NM}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<select id="ARP" name="ARP" class="w180">
									<option value="HO">본사</option>
									<c:forEach items="${arpList }" var="arp">
										<option value="${arp.CD}">${arp.CD}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<select id="DEPT_NM" name="DEPT_NM" class="w180" ></select>
							</td>
							<td>
								<select id="JOB_POS" name="JOB_POS" class="w180">
									<option value="">선택</option>
									<c:forEach var="job" items="${JBP}">
										<option value="${job.CD}">${job.VAL}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<select id="JOB_LEVEL" name="JOB_LEVEL" class="w180">
									<option value="">선택</option>
									<c:forEach var="job" items="${jobList}">
										<option value="${job.CD}">${job.VAL}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input type="text" id="OFFICE_NO" name="OFFICE_NO" maxlength="15" value="${SELECTDATA.OFFICE_NO}" fname="OFFICE" onkeyup="javascript:numCheck4(this);" />
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="uiCont">
				<h4>사용자 장비 사용가능 여부</h4>
				<div class="chkWrap clear">
					<ul>
						<li><label for="TOWING">토잉</label><input type="checkbox" id="TOWING" name="TOWING" value="Y" <c:out value="${usrEq.TOWING eq 'Y' ? 'checked' : '' }" />  /></li>
						<li><label for="CARGOLOADER">카고로더</label><input type="checkbox" id="CARGOLOADER" name="CARGOLOADER"  value="Y" <c:out value="${usrEq.CARGOLOADER eq 'Y' ? 'checked' : '' }" /> /></li>
						<li><label for="RAMPBUS">램프버스</label><input type="checkbox" id="RAMPBUS" name="RAMPBUS" value="Y" <c:out value="${usrEq.RAMPBUS eq 'Y' ? 'checked' : '' }" /> /></li>
						<li><label for="DE_ICING">De-icing</label><input type="checkbox" id="DE_ICING" name="DE_ICING" value="Y" <c:out value="${usrEq.DE_ICING eq 'Y' ? 'checked' : '' }" /> /></li>
						<li><label for="INTERPHONE">인터폰</label><input type="checkbox" id="INTERPHONE" name="INTERPHONE" value="Y" <c:out value="${usrEq.INTERPHONE eq 'Y' ? 'checked' : '' }" /> /></li>
					</ul>
				</div>
			</div>
			<c:if test="${USER_SESSION.ROLE_ID eq 'ADMIN'}">
				<c:if test="${MYPAGE ne 'Y'}">
					<div id="div_INF3" class="uiCont">
						<h4>사용자 계정 및 재직 상태</h4>
						<div class="tbWrap nFtb">
							<table>
								<tr>
									<th>계정 권한</th>
									<th>재직상태</th>
									<th>사유</th>
								</tr>
								<tr>
									<td>
										<select id="ROLE_NM" name="ROLE_NM">
											<c:forEach var="rolenm" items="${ROLE_NM}" >
												<option value="${rolenm.ROLE_ID}">${rolenm.ROLE_NM}</option>
											</c:forEach>
										</select>
									</td>
									<td>
										<select id="USER_STATUS" name="USER_STATUS">
											<c:forEach var="status" items="${USER_STATUS_NM}" >
												<option value="${status.CD}">${status.VAL}</option>
											</c:forEach>
										</select>
									</td>
									<td>
										<textarea id="STATUS_REASON" name="STATUS_REASON" maxlength="100" style="width: 100%; " >${SELECTDATA.STATUS_REASON}</textarea>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</c:if>
			</c:if>
			<c:if test="${USER_SESSION.ROLE_ID ne 'ADMIN'}">
				<div id="div_INF3_RO" class="uiCont">
					<h4>사용자 계정 및 재직 상태</h4>
					<div class="tbWrap nFtb">
						<table>
							<tr>
								<th>계정 권한</th>
								<th>재직상태</th>
								<th>사유</th>
							</tr><tr>
								<td>
									<input type="text" id="ROLE_NM_RO" name="ROLE_NM" value="${SELECTDATA.ROLE_NM}" readonly="readonly"/>				
								</td>
								<td>
									<input type="text" id="USER_STATUS_RO" name="USER_STATUS" value="${SELECTDATA.USER_STATUS}" readonly="readonly"/>
									<input type="hidden" id="USER_STATUS_ID_RO" name="USER_STATUS_ID" value="${SELECTDATA.USER_STATUS_ID}" readonly="readonly"/>
								</td>
								<td>
									<textarea id="USER_REASON_RO" name="USER_REASON" maxlength="100" readonly="readonly" style="width: 100%;" onkeydown="javascript:fn_TextAreaLineLimit();" >${SELECTDATA.STATUS_REASON}</textarea>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</c:if>
			<c:if test="${USER_SESSION.ROLE_ID eq 'ADMIN'}">
				<c:if test="${MYPAGE ne 'Y'}">
					<div id="div_INF4" class="uiCont">
					<h4>사용자 로그인 정보</h4>
						<div class="tbWrap nFtb">
							<table>
								<tr>
									<th>계정 사용여부</th>
									<th>마지막 로그인 날짜</th>
									<th>로그인 실패 횟수</th>
									<th>비밀번호 변경일</th>
									<th>비밀번호 초기화</th>
								</tr>
								<tr>
									<td>
										<select id="USE_YN" name="USE_YN">
											<option value="Y">Y</option>
											<option value="N">N</option>
										</select>
									</td>
									<td>${SELECTDATA.LAST_LOGIN_DT}</td>
									<td>${SELECTDATA.FAILED_LOGIN_NUM}</td>
									<td>${SELECTDATA.PASSWORD_CHG_DT}</td>
									<td>
										<button id="btn_setting" title="비밀번호 초기화" class="btn txtBtn setting">설정</button>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</c:if>
				<c:if test="${MYPAGE eq 'Y'}">
					<div id="div_INF4_RO" class="uiCont">
						<h4>사용자 계정 및 재직 상태</h4>
						<div class="tbWrap nFtb">
							<table>
								<tr>
									<th>계정 권한</th>
									<th>재직상태</th>
									<th>사유</th>
								</tr><tr>
									<td>
										<input type="text" id="ROLE_NM_RO" name="ROLE_NM" value="${SELECTDATA.ROLE_NM}" readonly="readonly"/>
									</td>
									<td>
										<input type="text" id="USER_STATUS_RO" name="USER_STATUS" value="${SELECTDATA.USER_STATUS}" readonly="readonly"/>
										<input type="hidden" id="USER_STATUS_ID_RO" name="USER_STATUS_ID" value="${SELECTDATA.USER_STATUS_ID}" readonly="readonly"/>
									</td>
									<td>
										<textarea type="text" id="USER_REASON_RO" name="USER_REASON" readonly="readonly" >${SELECTDATA.STATUS_REASON}</textarea>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</c:if>
			</c:if>
		</div>
		<div class="btnWrap">
			<c:if test="${MYPAGE eq 'Y'}">
				<button id="btnSave_edit" title="save" class="btn btnOrange" onclick="doSave();">저장</button>
				<button id="btnSetting" title="Setting" class="btn">비밀번호변경</button>
			</c:if>
			<c:if test="${MYPAGE ne 'Y' && USER_SESSION.ROLE_ID eq 'ADMIN'}">
				<button id="btnSave" title="save" class="btn btnOrange" onclick="doSave();">저장</button>
				<button id="btn_List" title="list" class="btn" >목록</button>
			</c:if>
		</div>
	</div>
	<!-- contents end -->
</div>