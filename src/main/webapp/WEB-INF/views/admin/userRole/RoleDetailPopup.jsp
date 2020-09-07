<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript" charset="utf-8"  src="<c:url value="/resources/js/ajaxfileupload.js"/>"></script>
<script type="text/javascript">
<%@ page import="java.util.*, java.text.*"  %>
var idCheck = false;

//Ajax CallBack 함수
function ajax_callback(sid,json) {
	// 저장하기
	if(sid =="doSave"){
		try {
			if(!sessionCheckJSON(json)) return;
			
			var result = json.result;
			
			if(result == "success") {
				alert("저장에 성공하였습니다.");
				opener.doRefresh(); 
				window.close();
			}else alert("저장에 실패하였습니다");
		} catch (e) {Logger.debug(e);}
	}else if(sid == "idCheck"){
		try {
			var cnt = json.count;
			var type = "${subType}";
			
			if(type == "detail"){
				doIdCheck();
			}else{
				if(cnt == 0) doIdCheck();
				else alert("이미 사용중인 권한 ID 입니다.");
			}
		}catch (e) {
			Logger.debug(e);
		}
	}
};

// 저장하기 후 중복 ID 검사
function doSave() {
	var data;
	var url;
	var sid = "idCheck";
	data = {"ROLE_ID" : $("#ROLE_ID").val()};
	url = "<c:url value="/role/RoleIdCheck.json"/>";
	ajax_sendData(sid, url, data);
}

//저장하기
function doIdCheck() {
	var type = "${subType}";
	var data;
	var regex = /^[0-9]+$/;
	var fail = $("#FAILED_LOGIN_TIME").val();
	
	fail = $.trim(fail);
	
	if (!regex.test(fail)) {
		alert("로그인 실패 횟수 형식을 다시 확인하세요.");
		return;
	}
	
	var sid = "doSave";
	var data;
	var desc = $("#ROLE_DESC").val();
	desc = desc.replace("<script","<&ltscript");
	
	if(type == "new"){
		data = {
				"subType" : type,
				"ROLE_ID" : $("#ROLE_ID").val(),
				"ROLE_NM" : $("#ROLE_NM").val(),
				"FAILED_LOGIN_TIME" : $("#FAILED_LOGIN_TIME").val(),
				"ROLE_DESC" : desc,
				"USE_YN" : $("#USE_YN").val()
				}
	}else{
		data = {
				"subType" : type,
				"ROLE_ID" : $("#ROLE_ID_Detail").val(),
				"ROLE_NM" : $("#ROLE_NM").val(),
				"FAILED_LOGIN_TIME" : $("#FAILED_LOGIN_TIME").val(),
				"ROLE_DESC" : desc,
				"USE_YN" : $("#USE_YN").val()
				}
	}
	
	var url = "<c:url value="/role/RoleSave.json"/>";
	ajax_sendData(sid, url, data);
};

//부모창의 새로고침/닫기/앞으로/뒤로 시 팝업 닫기
$(this).one('load', function() {
	// 부모창의 새로고침/닫기/앞으로/뒤로
	$(opener).one('beforeunload', function() {
		window.close();
	});
});

$("document").ready(function() {
	var data = "${DetailData.ROLE_ID}";
	var type = "${subType}";
	
	if (data != null) {
		$("#USE_YN").val("${DetailData.USE_YN}");
	}
	
	$("#btn_save").click(function() {
		var roleid; 
		if(type == "new") roleid = $("#ROLE_ID").val();
		else if(type=="detail") roleid = $("#ROLE_ID_Detail").val();
		
		var rolenm = $("#ROLE_NM").val();
		var fail = $("#FAILED_LOGIN_TIME").val();
		var useyn = $("#USE_YN").val();
		roleid = $.trim(roleid);
		rolenm = $.trim(rolenm);
		fail = $.trim(fail);
		
		// 필수 항목 확인
		if (roleid == null || rolenm == null || fail == null || useyn==null || useyn == ''|| roleid == '' || rolenm == '' || fail == '') {
			alert("항목을 입력하세요.");
			return;
		} else {
			doSave();
		}
	}).css("cursor", "pointer");
	
	$("#btn_close").click(function() {
		opener.parent.location.reload();
		window.close();
	}).css("cursor", "pointer");
});
</script>
<div class="popupWrap">
	<div id="pop_contents" class="contWrap">
		<form id="popUpForm" name="popUpForm" method="post">
			<input type="hidden" id="imgUrl" name="imgUrl"/>
		</form>
		<div class="titWrap">
			<c:if test="${DetailData.ROLE_NM ne null}">
				<h3 class="tit fl">권한 상세보기</h3>
			</c:if>
			<c:if test="${DetailData.ROLE_NM eq null}">
				<h3 class="tit fl">권한 신규등록</h3>
			</c:if>
		</div>
		<div class="pop_area">
			<form name="updateForm" id="updateForm" method="post">
				<div class="popConWrap">
					<ul class="pIptWrap w150">
						<li>
							<label class="rq">권한명</label>
							<input type="text" id="ROLE_NM" maxlength="25" name="ROLE_NM" value="${DetailData.ROLE_NM}"/>
						</li>
						<li>
							<label class="rq">권한 ID</label>
							<c:if test="${DetailData ne null and DetailData ne ''}">
								<input type="text" id="ROLE_ID_Detail" maxlength="7" name="ROLE_ID_Detail" value="${DetailData.ROLE_ID}" readonly="readonly" disabled="disabled"/>
							</c:if>
							<c:if test="${DetailData eq null or DetailData eq ''}">
								<input type="text" id="ROLE_ID" maxlength="7" name="ROLE_ID" value="${DetailData.ROLE_ID}"/>
							</c:if>
						</li>
						<li>
							<label class="rq">로그인 실패 횟수</label>
							<input type="text" id="FAILED_LOGIN_TIME" maxlength="2" name="FAILED_LOGIN_TIME" value="${DetailData.FAILED_LOGIN_TIME}" onkeyup="javascript:numCheck4(this);" fname="LOGIN FAIL NUMBER" placeholder="ex:4"/>
						</li>
						<li>
							<label>설명</label>
							<textarea id="ROLE_DESC" name = "ROLE_DESC" maxlength="200" ><c:out value="${DetailData.ROLE_DESC}" /></textarea>
						</li>
						<li>
							<label class="rq">사용여부</label>
							<select id="USE_YN" name="USE_YN" >
								<option value="">선택</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</li>
					</ul>
				</div>
			</form>
		</div>
		<div class="popBtnWrap">
			<button type="button" id="btn_save">저장</button>
		</div>
	</div>
</div>