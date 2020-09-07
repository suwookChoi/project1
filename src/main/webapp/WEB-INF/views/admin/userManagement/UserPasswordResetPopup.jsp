<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript" charset="utf-8"  src="<c:url value="/resources/js/ajaxfileupload.js"/>"></script>
<script type="text/javascript">

var idcheck = false;

function ajax_callback(sid,json) {
	if(sid =="doSave"){
		try {
			//JSON 처리 시 세션이 정상일 경우 처리  [파라미터:json리턴변수]
			if(!sessionCheckJSON(json)) return;
			
			var result = json.result;
			
			if(result == "1") {
				alert("저장에 성공하였습니다.");
				self.close();
			}else{
				alert("저장에 실패하였습니다.");
			}
		}catch (e) {Logger.debug(e);}
	}
}

//부모창의 새로고침/닫기/앞으로/뒤로 시 팝업 닫기
$(this).one('load', function() {
	// 부모창의 새로고침/닫기/앞으로/뒤로
	$(opener).one('beforeunload', function() {
		window.close();
	});
});

// 저장
function doSave(){
	var getpwd = "${OLD_PWD}";
	var newPwd = $("#NEW_PASSWORD").val();
	
	if($("#OLD_PWD").val() != getpwd){
		alert("기존비밀번호를 다시 확인하세요.");
		$("#OLD_PWD").focus();
		return ;
	}else if($("#NEW_PASSWORD").val() == '' || $("#NEW_PASSWORD").val() != $("#CONFIRM_PASSWORD").val()){
		alert("변경할 비밀번호를 확인하세요.");
		$("#NEW_PASSWORD").focus();
		return;
	}else if(newPwd.length <4) {
		alert("비밀번호 4자리이하로 등록하실 수 없습니다.");
		$("#NEW_PASSWORD").val("");
		$("#CONFIRM_PASSWORD").val("");
		return;
	}else{
		var sid;
		var data;
		var url;
		sid = "doSave";
		data={
				"OLD_PWD":$("#OLD_PWD").val()
				,"NEW_PASSWORD" :$("#NEW_PASSWORD").val()
		};
		url = "<c:url value="/userManagement/UserPasswordResetJson.json"/>";
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
	$("#btn_close").click(function(){
		opener.parent.location.reload();
		window.close();
	}).css("cursor", "pointer");
});

</script>
<div id="pop_contents" class="popupWrap">
	<div class="contWrap">
		<div class="titWrap">
			<h3>비밀번호 변경화면</h3>
		</div>
		<div class="popConWrap">
			<form name="updateForm" id="updateForm" method="post">
				<ul class="pIptWrap w200">
					<li>
						<label class="rq">기존 비밀번호</label>
						<input type="password" id="OLD_PWD" name="OLD_PWD"  maxlength="10" maxbyte="10"/>
					</li>
					<li>
						<label class="rq">새로운 비밀번호</label>
						<input type="password" id="NEW_PASSWORD" name="NEW_PASSWORD" max="20" maxbyte="20" maxlength="20" fname="New Password"/>
					</li>
					<li>
						<label class="rq">새로운 비밀번호확인</label>
						<input type="password" id="CONFIRM_PASSWORD"  max="20" maxbyte="20" maxlength="20" fname="Confirm Password" />
					</li>
				</ul>
			</form>
		</div>
		<div class="popBtnWrap" title="save"><!-- 버튼이 2개일때 클래스 추가 class="popBtn" -->
			<button id="btn_save" onclick="doSave()">저장</button>
		</div>
	</div>
</div>