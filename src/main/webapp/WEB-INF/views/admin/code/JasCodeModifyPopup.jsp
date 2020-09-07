<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<script type="text/javascript" charset="utf-8" src="<c:url value="/resources/js/pak/smart.date.js"/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />
<script type="text/javascript" charset="utf-8" src="<c:url value="/resources/dhtmlx/dhtmlxcombo.js"/>"></script>

<script type="text/javascript">
var accessCheck = '${ACCESS_CHECK}';
var RMSROLE = '${USER_SESSION.rmsRole}';
var ROLEID = '${USER_SESSION.rolegroup_id}';

function ajax_callback(sid,json) {
	var type="${target}";
	
	if(sid == "doSave"){
		if(!sessionCheckJSON(json)) return;
		
		var result = json.result;
		
		if(result == "success"){
			alert("저장에 성공하였습니다.");
	 		opener.doRefresh(); 
			window.close();
		}else{
			alert("저장에 실패하였습니다.");
			return;
		}
	}else if(sid=="idCheck"){
		var result = json.result;
		
		if(result == 0){
			doSave();
		}else{
			alert("이미 사용중인 코드 ID 입니다.");
			return;
		}
	}
}

// 코드 ID 중복검사
function idCheck() {
	var data;
	var url;
	var sid = "idCheck";
	var type = "${target}";
	
	if(type=="new"){
		data = {"COD_ID" : $("#COD_ID_NEW").val()};
		url = "<c:url value="/code/CodeIdCheck.json"/>";
		ajax_sendData(sid, url, data);
	}else{
		doSave();
	}
}

// 저장하기
function doSave() {
	var type = "${target}";
	var codid;
	var saveType;
	
	if(type == 'detail'){
		saveType = "edit"
		codid = $("#COD_ID").val();
	}else if(type == 'new'){
		saveType = "donew";
		codid=$("#COD_ID_NEW").val();
	}else return;
	
	var data;
	var url;
	var sid = "doSave";
	data = {	"saveType" : saveType,
				"CDCLASS_ID" :$("#CDCLASS_TYPE").val(),
				"COD_ID" : codid,
				"COD_NM" : $("#COD_NM").val(),
				"COD_NM2" : $("#COD_NM2").val(),
				"COD_NM3" : $("#COD_NM3").val(),
				"DSC" : $("#DSC").val(),
				"ETC2" : $("#ETC2").val(),
				"ETC" : $("#ETC").val(),
				"DISPLAY_ORDER" : $("#DISPLAY_ORDER").val(),
				"USE_YN" : $("#USE_YN").val()
			};
	url = "<c:url value="/code/codeModifySave.json"/>";
	ajax_sendData(sid, url, data);
}

$("document").ready(function() {
	var type =  '${target}';
	if(type == 'detail'){
		$('#USE_YN').val('${SELECTDATA.USE_YN}');
		
		var class_id = '${SELECTDATA.CDCLASS_ID}';
		
		if(class_id != null || class_id !=''){
			$("#CDCLASS_TYPE").val('${SELECTDATA.CDCLASS_ID}');
		}else{ // 코드분류가 삭제된 경우
			$("#CDCLASS_TYPE").val('ETC');
		}
	}else{
		$('#USE_YN').val('Y');
	}
	
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
		var cdclasstype=$("#CDCLASS_TYPE").val();
		var cdclasscode=$("#CDCLASS_ID").val();
		var codid;
		
		if(type == 'new'){ codid =$("#COD_ID_NEW").val(); }
		else{ codid =$("#COD_ID").val(); }
		
		var codname=$("#COD_NM").val();
		var displayorder=$("#DISPLAY_ORDER").val();
		var regex = /^[0-9]+$/;
		displayorder = $.trim(displayorder);
		
		if(!regex.test(displayorder)){
			alert("화면 순서 형식을 확인하세요 ");
			return;
		}
		
		var useyn=$("#USE_YN").val(); 
		
		cdclasstype = $.trim(cdclasstype);
		cdclasscode = $.trim(cdclasscode);
		codid = $.trim(codid);
		codname = $.trim(codname);
		
		if(cdclasstype == null || cdclasscode == null || codid == null || codname==null || displayorder==null || useyn==null ||cdclasstype == ''|| cdclasscode ==''|| codid == ''|| codname=='' || displayorder==''|| useyn==''){
			alert("필수 항목을 확인하세요");
			return;
		}else{
			idCheck();
		}
	}).css("cursor", "pointer");
	
	$(window).resize();
});

$(window).resize(function(){
	var h = $(".popConWrap").height() - 60;
	
	$(".chart").height(h);
	$("#${pageMap.GRID_ID}").height(h);
});

</script>
<div class="popupWrap">
	<div class="contWrap">
		<!-- contents title start--> 
		<!-- contents title end-->
		<div class="titWrap">
			<c:if test="${SELECTDATA.CDCLASS_ID eq null}">
				<h3>코드 신규등록</h3>
			</c:if>
			<c:if test="${SELECTDATA.CDCLASS_ID ne null}">
				<h3>코드 상세보기</h3>
			</c:if>
		</div>
		<!-- contents start -->
		<div class="popConWrap scrPop">
			<ul class="pIptWrap">
				<li>
					<label class="rq">코드분류</label>
					<select id="CDCLASS_TYPE" name="CDCLASS_TYPE">
						<option value="">선택</option>
						<c:forEach items="${codeType}" var="list">
							<option value="${list.CDCLASS_ID}">${list.CDCLASS_TYPE}</option>
						</c:forEach>
					</select>
				</li>
				<li>
					<label class="rq">공통 코드 ID</label>
					<input type="text" id="CDCLASS_ID" maxlength="25" onkeyup="javascript:engCheck2(this)" fname="공통코드 ID는  " name="CDCLASS_ID" value="${SELECTDATA.CDCLASS_ID}"/>
				</li>
				<li>
					<label class="rq">코드 ID</label>
					<c:if test="${target == 'new'}">
						<input type="text" id="COD_ID_NEW" maxlength="50" name="COD_ID_NEW"/>
					</c:if> <c:if test="${target == 'detail'}">
						<input type="text" id="COD_ID" maxlength="50" name="COD_ID" value="${SELECTDATA.COD_ID}" readonly="readonly" disabled="disabled" />
					</c:if>
				</li>
				<li>
					<label class="rq">코드명</label>
					<input type="text" maxlength="25" id="COD_NM" name="COD_NM" value="${SELECTDATA.COD_NM}" />
				</li>
				<li>
					<label>코드명2</label>
					<input type="text" maxlength="25" id="COD_NM2" name="COD_NM2" value="${SELECTDATA.COD_NM2}" />
				</li>
				<li>
					<label>코드명3</label>
					<input type="text" maxlength="25" id="COD_NM3" name="COD_NM3" value="${SELECTDATA.COD_NM3}"/>
				</li>
				<li>
					<label class="rq">화면순서</label>
					<input type="text" id="DISPLAY_ORDER" maxlength="2" name="DISPLAY_ORDER" value="${SELECTDATA.DISPLAY_ORDER}" onkeyup="javascript:numCheck4(this);" fname="화면순서는" placeholder="ex:3"/>
				</li>
				<li>
					<label class="rq">사용여부</label>
					<select id="USE_YN" name="USE_YN">
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
				</li>
				<li>
					<label>기타</label>
					<textarea id="ETC" maxlength="190" name="ETC"><c:out value="${SELECTDATA.ETC}" /></textarea>
				</li>
				<li>
					<label>기타2</label>
					<textarea id="ETC2"  maxlength="190" name="ETC2"><c:out value="${SELECTDATA.ETC2}" /></textarea>
				</li>
				<li>
					<label>설명</label>
					<textarea id="DSC"  maxlength="350" name="DSC"><c:out value="${SELECTDATA.DSC}" /></textarea>
				</li>
			</ul>
		</div>
		<div class="popBtnWrap" title="save" id="btnSave"><!-- 버튼이 2개일때 클래스 추가 class="popBtn" -->
			<button>저장</button>
		</div>
	</div>
</div>