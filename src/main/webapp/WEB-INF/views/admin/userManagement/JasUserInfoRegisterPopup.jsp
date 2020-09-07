<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript" charset="utf-8"  src="<c:url value="/resources/js/ajaxfileupload.js"/>"></script>
<script type="text/javascript">
// 아이디 중복검사 변수
var idcheck = false;

//Ajax CallBack
function ajax_callback(sid,json) {
	if(sid =="doIdCheck"){
		try {
			if(!sessionCheckJSON(json)) return;
			
			var result = json.result;
			
			if(result == "Y") {
				$("#USER_ID_CK").html('<span class=" idExTex " >등록 가능한 사원번호 입니다</span>');
				idcheck = true;
			}else{
				$("#USER_ID_CK").html('<span class=" idExTex ">등록된 사원번호 입니다.</span>');
				idcheck = false;
			}
		} catch (e) {Logger.debug(e);}
	}else if(sid == 'findARP'){
		try {
			var html = "";
			var arp = json.arp;
			
			$.each(arp,function(enytyIndex,entry){
				html +="<option value="+entry.ARP+">"+entry.ARP+"</option>";
			});
			$('#ARP').empty();
			$("#ARP").append(html);
		} catch (e) {Logger.debug(e);}
	}else if(sid == "doSave"){
		try {
			//JSON 처리 시 세션이 정상일 경우 처리  [파라미터:json리턴변수]
			if(!sessionCheckJSON(json)) return;
			
			var result = json.result;
			
			if(result == "1") {
				alert("저장에 성공하였습니다.");
				opener.doRefresh(); 
				window.close();
			}else{
				alert("저장에 실패하였습니다.");
			}
		} catch (e) {Logger.debug(e);}
	}
}

// 아이디 중복검사
function doIdCheck() {
	var userid = $("#USER_ID").val();
	userid = $.trim(userid);
	
	if( userid.length <4 ){
		$("#USER_ID_CK").html('<span class="idExTex">사용할 수 없는 사원번호 입니다. 4자리 이상 입력하세요.</span>');
		return;
	}else{
		if(userid == ''){
			alert("사원번호를 입력하세요");
			return;
		}else{
			var data = {"USER_ID" : $("#USER_ID").val()};
			var sid = "doIdCheck";
			var url = "<c:url value="/userManagement/usrFindUserManagementId.json" />";
			ajax_sendData(sid,url,data);
		}
	}
	return;
}

//저장하기
function doSave(){
	var roleid = $("#ROLE_ID").val();
	roleid = $.trim(roleid);
	
	if(idcheck == false){
		alert("사원번호을 다시 확인하세요.");
		return;
	}else if (roleid == ''){
		alert("계정권한을 다시 확인하세요.");
		return;
	}else{
		var dept_code =  $("#DEPT_NM").val();
		var updateForm = jQuery("#updateForm").serialize();
		var data = {
					 "USER_ID":$("#USER_ID").val()
					,"USER_NM": $("#USER_NM").val()
					,"ROLE_ID": $("#ROLE_ID").val()
					,"ARP": $("#ARP").val()
					};
		var sid = "doSave";
		var url = "<c:url value="/userManagement/usrUserInfoRegister.json"/>";
		ajax_sendData(sid,url,data);
	}
};

// 부모창의 새로고침/닫기/앞으로/뒤로 시 팝업 닫기
$(this).one('load', function() {
	// 부모창의 새로고침/닫기/앞으로/뒤로
	$(opener).one('beforeunload', function() {
		window.close();
	});
});

$("document").ready(function() {
	var user = '${USER_SESSION.ROLE_ID}';
	
	$("#btn_save").click(function(){
		if($("#USER_ID").val() == '' || $("#USER_ID").val() == null || $("#USER_NM").val() =='' || $("#USER_NM").val() == null || $("#ROLE_ID").val == '' || $("#ROLE_ID").val() == null ){
			alert("모든항목을 기입하세요.");
			return;
		}else{
			var formUtil = new FormUtil(document.updateForm);
			if(formUtil.success()) doSave();
		}
	}).css("cursor", "pointer");
	
	$("#USER_ID").blur(function () {
		idcheck=false;
		doIdCheck();
	});
	
	$("#COMPANY_NM").click(function () {
		findARP();
	}).css("cursor", "pointer");
	
	$("#btn_close").click(function(){
		opener.parent.location.reload();
		window.close();
	}).css("cursor", "pointer");
});

</script>
<div class="popupWrap">
	<div id="pop_contents" class="contWrap">
		<div class="titWrap">
			<h3>사용자 신규등록</h3>
		</div>
		<form name="updateForm" id="updateForm" method="post">
			<div class="popConWrap">
				<ul class="pIptWrap">
					<li>
						<label class="rq">사원번호</label>
						<input type="text" id="USER_ID" maxlength="20" name="USER_ID" fname="사원번호는" onkeyup="javascript:numCheck4(this);" />
					</li>
					<li><span  id="USER_ID_CK"></span> <!--  CSS 수정필요   -->
					</li>
					<li>
						<label class="rq">이름</label>
						<input type="text" id="USER_NM" maxlength="20" name="USER_NM" fname="이름은" onkeyup="javascript:korCheck(this);"/>
					</li>
					<li>
						<label class="rq">계정 권한</label>
						<select id="ROLE_ID" name="ROLE_ID">
							<option value="">선택</option>
							<c:forEach var="role" items="${ROLE_NM}">
								<option value="${role.ROLE_ID}">${role.ROLE_NM}</option>
							</c:forEach>
						</select>
					</li>
					<li>
						<label class="rq">지점</label>
						<select id="ARP" name="ARP">
							<option value="HO">본사</option>
							<c:forEach var="aprList" items="${ARP}">
								<option value="${aprList.CD}">${aprList.CD}</option>
							</c:forEach>
						</select>
					</li>
				</ul>
			</div>
		</form>
		<div class="popBtnWrap">
			<button type="button" id="btn_save">저장</button>
		</div>
	</div>
</div>
