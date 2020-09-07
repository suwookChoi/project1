<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript">

var stat = '${pageMap.stat}';
var type = '${type}';

$(document).ready(function(){
	$("#ARP").val('${DATA.ARP}');
	
	if(type == 'detail'){
		$("#USE_YN").val('${DATA.USE_YN}');
	}else{
		$('#USE_YN').val('Y');
	}
	
	$("#btnSave").click(function(){
	if(type == "new"){
		doSave();
	}else{
		orgDelete();
	}
	}).css("cursor", "pointer");
});

function orgDelete() {
	var ARP = $("#orgARP").val();
	var PAK = $("#orgPak").val();
	var ODR = $("#orgODR").val();
	
	var data = {"ARP" : ARP,"PAK":PAK, "ODR":ODR,"type":type};
	var url = "<c:url value="/admin/JasDelete.json"/>";
	var sid = "delete";
	
	ajax_sendData(sid, url, data);
}

function doSave(){
	var ARP = $("#ARP").val();
	var PAK = $("#PAK").val();
	var ODR = $("#ODR").val();
	var USE_YN = $("#USE_YN").val();
	var RMK = $("#RMK").val();
	
	if(ARP == ''){
		alert("공항를 선택하세요.");
		$('#ARP').focus();
		return false;
	}else if(PAK == ''){
		alert("주기장을 입력하세요.");
		$('#PAK').focus();
		return false;
	}else if(ODR == ''){
		alert("화면순서를 입력하세요.");
		$('#ODR').focus();
		return false;
	}else if(USE_YN== ''){
		alert("사용여부를 선택하세요.");
		$('#USE_YN').focus();
		return false;
	}else{
		var data = {"ARP" : ARP,"PAK":PAK,"ODR":ODR,"USE_YN":USE_YN,"RMK" : RMK, "type":type};
		var url = "<c:url value="/admin/JasSpotSave.json"/>";
		var sid = "save";
		
		ajax_sendData(sid, url, data);
	}
}

function ajax_callback(sid, json){
	if(sid == "save"){
		var result =json.result;
		
		if(result == 1){
			alert("저장에 성공하였습니다.");
	 		opener.doRefresh(); 
			window.close();
		}else{
			alert("저장에 실패하였습니다.");
			return;
		}
	}else if(sid == "delete"){
		var result =json.result;
		
		if(result == "1"){
			doSave();
		}else{
			alert("삭제가 실패하였습니다.");
			return;
		}
	}
}

</script>
<div class="popupWrap">
	<div class="contWrap">
		<div class="titWrap">
			<c:choose>
				<c:when test="${type eq 'new'}">
					<h3>주기장 신규등록</h3>
				</c:when>
				<c:otherwise>
					<h3>주기장 상세보기</h3>
				</c:otherwise>
			</c:choose>
		</div>
		<form action="orgForm">
			<input type="hidden" id="orgARP"name="ARP" value="${DATA.ARP}">
			<input type="hidden" id="orgPak"name="PAK" value="${DATA.PAK}">
			<input type="hidden" id="orgODR"name="ODR" value="${DATA.ODR}">
		</form>
		<div class="popConWrap scrPop">
			<ul class="pIptWrap">
				<li>
					<label class="rq">공항</label>
					<select id="ARP" name="ARP">
						<option value=''>선택</option>
						<c:forEach var="list" items="${arpList}">
							<option value="<c:out value="${list.ARP}"/>" ><c:out value="${list.ARP}"/></option>
						</c:forEach>
					</select>
				</li>
				<li>
					<label class="rq">주기장</label>
					<input type="text" id="PAK" name="PAK" maxlength="4" fname="" onkeyup="javascript:engNumCheck(this);" value="${DATA.PAK}">
				</li>
				<li>
					<label class="rq">화면순서</label>
					<input type="text" name="ODR" id="ODR" maxlength="4" fname="" onkeyup="javascript:engNumCheck(this);" value="${DATA.ODR}"/>
				</li>
				<li>
					<label class="rq">사용 여부</label>
					<select id="USE_YN" name="USE_YN">
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
				</li>
				<li>
					<label class="rq">비고</label>
					<textarea name="RMK" id="RMK" maxlength="190">${DATA.RMK}</textarea>
				</li>
			</ul>
		</div>
		<div class="popBtnWrap" title="save"><!-- 버튼이 2개일때 클래스 추가 class="popBtn" -->
			<button  type="button" id="btnSave" >저장</button>
		</div>
	</div>
</div>
