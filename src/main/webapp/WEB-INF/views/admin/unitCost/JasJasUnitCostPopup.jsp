<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<script type="text/javascript" charset="utf-8"  src="<c:url value="/resources/js/ajaxfileupload.js"/>"></script>
<script type="text/javascript">
<%@ page import="java.util.*, java.text.*"  %>
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
			}else if(result == "duplication"){
				alert("이미 사용중인 정보 입니다.");
				return;
			}else{
				alert("저장에 실패하였습니다");
			}
		} catch (e) {Logger.debug(e);}
	}
};

//저장하기
function doSave(){
	var type="${subType}";
	var data;
	var regex= /^[0-9]+$/;
	var rates = $("#COSTRATES").val();
	var startdt = $("#START_DT_YY").val()+$("#START_DT_MM").val();
	var startdt_ro = $("#START_DT_YY_RO").val()+$("#START_DT_MM_RO").val();
	var startdyy= $("#START_DT_YY").val();
	var startdmm= $("#START_DT_MM").val();
	var startdyy_ro= $("#START_DT_YY_RO").val();
	var startdmm_ro= $("#START_DT_MM_RO").val();
	var enddt = $("#END_DT_YY").val()+$("#END_DT_MM").val();
	var enddtyy = $("#END_DT_YY").val();
	var enddtmm = $("#END_DT_MM").val();
	startdt=$.trim(startdt);
	startdt_ro=$.trim(startdt_ro);
	startdyy=$.trim(startdyy);
	enddt=$.trim(enddt);
	rates = $.trim(rates);
	
	if(!regex.test(rates)){
		alert("Rates 을 다시 확인하세요.");
		return;
	}
	if(type != "detail" && !regex.test(startdt) && !regex.test(enddt)){
		alert("날짜 형식을 다시 확인하세요.");
		return;
	}
	if(type == "detail" && !regex.test(enddt)){
		alert("날짜 형식을 다시 확인하세요.");
		return;
	}
	if(type != "detail" && startdt >= enddt){
		alert("날짜 형식을 다시 확인하세요. ");
		return;
	}
	if(type == "detail" && startdt_ro >= enddt){
		alert("날짜 형식을 다시 확인하세요.");
		return;
	}
	var data;
	if(type == "detail"){
		data={"subType":type
			 , "AIRCRAFT":$("#AIRCRAFT_RO").val()
			 , "ARP":$("#ARP_RO").val()
			 , "GHTYPE":$("#GHTYPE_hidden").val()
			 , "COD_ID":$("#GHTYPE_hidden").val()
			 , "START_DT":startdt_ro
			 , "END_DT":enddt
			 , "COSTRATES":rates
			 , "START_DT_YY":startdyy_ro
			 , "START_DT_MM":startdmm_ro
			 , "END_DT_YY":enddtyy
			 , "END_DT_MM":enddtmm
		 	 , "orgSTARTDT":$("#orgSTARTDT").val()
		 	 , "orgARP":$("#orgARP").val(),"orgAIRCRAFT":$("#orgAIRCRAFT").val()
		 	 , "orgGHTYPE":$("#orgGHTYPE").val()
		 	 , "orgENDDT":$("#orgENDDT").val()
		 	 , "orgENDDT":$("#orgCOSTRATES").val()
		 	};
	}else{
		data={"subType":type
			 , "AIRCRAFT":$("#AIRCRAFT").val()
			 , "ARP":$("#ARP").val()
			 , "GHTYPE":$("#GHTYPE").val()
			 , "COD_ID":$("#GHTYPE").val()
			 , "START_DT":startdt
			 , "END_DT":enddt
			 , "COSTRATES":rates
		 	 , "START_DT_YY":startdyy
		 	 ,"START_DT_MM":startdmm
		 	 ,"END_DT_YY":enddtyy
		 	 ,"END_DT_MM":enddtmm
		 	};
	}
	var sid;
	var url;
	
	sid = "doSave";
	url ="<c:url value="/unitCost/UnitCostSave.json"/>";
	
	ajax_sendData(sid,url,data);
};

$("document").ready(function() {
	var data = "${getDetailData}";
	var type="${subType}";
	
	// 수정팝업 일때 정보 
	if(data != null){
		$("#END_DT_MM").val("${getDetailData.END_DT_MM}");
	}
	
	$("#btn_save").click(function(){
		var AIRCRAFT = $("#AIRCRAFT").val();
		var AIRCRAFT_RO = $("#AIRCRAFT_RO").val();
		var ARP = $("#ARP").val();
		var ARP_RO = $("#ARP_RO").val();
		var GHTYPE = $("#GHTYPE").val();
		var GHTYPE_RO = $("#GHTYPE_RO").val();
		var END_DT_YY = $("#END_DT_YY").val();
		var END_DT_MM = $("#END_DT_MM").val();
		var COSTRATES = $("#COSTRATES").val();
		
		AIRCRAFT = $.trim(AIRCRAFT);
		ARP = $.trim(ARP);
		GHTYPE = $.trim(GHTYPE);
		
		// 필수 항목 확인
		if(type=="new"){
			if(	AIRCRAFT == null || ARP == null || GHTYPE == null || GHTYPE == null || END_DT_YY == null || END_DT_MM == null || COSTRATES== null
				|| AIRCRAFT == "" || ARP == "" || GHTYPE == "" || GHTYPE == "" || END_DT_YY == "" || END_DT_MM == "" || COSTRATES== ""){
				alert("항목을 확인하세요");
				return;
			}else{
				var cost = $("#COSTRATES").val();
				var startyy = $("#START_DT_YY").val();
				var endyy = $("#END_DT_YY").val();
				startyy = $.trim(startyy);
				endyy = $.trim(endyy);
				
				if(cost.length>9){
					alert("금액을 다시 확인하세요.");
					return;
				}else if(startyy.length <4 || startyy.length >5){
					alert("시작 년도를 확인하세요.");
					return;
				}else if(endyy.length <4 || endyy.length >5){
					alert("종료 년도를 확인하세요.");
					return;
				}
				doSave();
			}
		}else{
			if(	COSTRATES == null || END_DT_MM == null || END_DT_YY == null ){
				alert("항목을 다시 확인하세요.");
				return;
			}else{
				var cost = $("#COSTRATES").val();
				if(cost.length>9){
					alert("금액을 다시 확인해 주세요.");
					return;
				}
				doSave();
			}
		}
	}).css("cursor", "pointer");
	
	$("#btn_close").click(function(){
		opener.parent.location.reload();
		window.close();
	}).css("cursor", "pointer");
});
</script>
<div class="popupWrap">
	<div class="contWrap">
		<form id="popUpForm" name="popUpForm" method="post">
			<input type="hidden" id="imgUrl" name="imgUrl"/>
			<input type="hidden" id="orgARP" name="orgARP" value="${getDetailData.ARP}"/>
			<input type="hidden" id="orgAIRCRAFT" name="orgAIRCRAFT" value="${getDetailData.AIRCRAFT}"/>
			<input type="hidden" id="orgGHTYPE" name="orgGHTYPE" value="${getDetailData.COD_ID}"/>		
			<input type="hidden" id="orgSTARTDT" name="orgSTARTDT" value="${getDetailData.START_DT}"/>
			<input type="hidden" id="orgENDDT" name="orgENDDT" value="${getDetailData.END_DT}"/>
			<input type="hidden" id="orgCOSTRATES" name="orgCOSTRATES" value="${getDetailData.COSTRATES}"/>
		</form>
		<div class="titWrap">
			<h3>기본조업요율</h3>
		</div>
		<div class="popConWrap scrPop">
			<form name="updateForm" id="updateForm" method="post">
				<ul class="pIptWrap">
					<li>
						<label class="rq">항공사</label>
						<c:if test="${getDetailData.AIRCRAFT eq null}">
							<select id="AIRCRAFT" name="AIRCRAFT">
								<option value="">선택</optgroup>
								<c:forEach items="${list}" var="air">
									<option value="${air.FLC}">${air.FLC}</option>
								</c:forEach>
							</select>
						</c:if>
						<c:if test="${getDetailData.AIRCRAFT ne null}">
							<input type="text" id="AIRCRAFT_RO" name="AIRCRAFT_RO" value="${getDetailData.AIRCRAFT}" readonly="readonly" disabled="disabled">
						</c:if>
					</li>
					<li>
						<label class="rq">지점</label>
						<c:if test="${getDetailData.ARP eq null}">
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
										<option value="">선택</option>
										<c:forEach items="${arpList}" var="arp">
											<option value="${arp.CD }" >${arp.CD}</option>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</select>
						</c:if>
						<c:if test="${getDetailData.ARP ne null}">
							<input type="text" id="ARP_RO" name="ARP_RO" value="${getDetailData.ARP}" readonly="readonly" disabled="disabled">
						</c:if>
					</li>
					<li>
						<label class="rq">구분</label>
						<c:if test="${getDetailData.COD_NM eq null}">
							<select id="GHTYPE" name="GHTYPE">
								<option value="">선택</option>
								<c:forEach items="${ghlist}" var="list">
									<option value="${list.CD}">${list.VAL}</option>
								</c:forEach>
							</select>
						</c:if>
						<c:if test="${getDetailData.COD_NM ne null}">
							<input type="text" id="GHTYPE_RO" name="GHTYPE_RO" value="${getDetailData.COD_NM}" readonly="readonly" disabled="disabled">
							<input type="hidden" id="GHTYPE_hidden" name="GHTYPE_hidden" value="${getDetailData.COD_ID}">
						</c:if>
					</li>
					<li class="clear">
						<label class="rq">사용 시작</label>
							<div class="mtIptWrap clear">
								<div class="mtIptBox">
									<c:if test="${getDetailData.START_DT_YY eq null}">
										<input type="text" id="START_DT_YY" name="START_DT_YY" max="4" onkeyup="javascript:numCheck4(this);" fname="" placeholder="ex:2019"/>
										<span>년</span>
									</c:if>
									<c:if test="${getDetailData.START_DT_YY ne null}">
										<input type="text" id="START_DT_YY_RO" name="START_DT_YY_RO" min="4"max="4" value="${getDetailData.START_DT_YY}" fname="" readonly="readonly" disabled="disabled" />
										<span>년</span>
									</c:if>
								</div>
								<div class="mtIptBox">
									<c:if test="${getDetailData.START_DT_YY eq null}">
										<select id="START_DT_MM" name="START_DT_MM">
											<option value="">선택</option>
											<c:forEach begin="1" end="9" var="i" step="1">
												<option value="0<c:out value='${i}'/>">0<c:out value='${i}' /></option>
											</c:forEach>
											<c:forEach begin="10" end="12" var="i" step="1">
												<option value="<c:out value='${i}'/>"><c:out value='${i}' /></option>
											</c:forEach>
										</select>
										<span>월</span>
									</c:if>
									<c:if test="${getDetailData.START_DT_YY ne null}">
										<input type="text" id="START_DT_MM_RO" name="START_DT_MM_RO" value="${getDetailData.START_DT_MM}" fname=""  readonly="readonly" disabled="disabled">
										<span>월</span>
									</c:if>
								</div>
							</div>
					</li>
					<li class="clear">
						<label class="rq">사용 종료</label>
						<div class="mtIptWrap clear">
							<div class="mtIptBox">
								<input type="text" id="END_DT_YY" name="END_DT_YY" maxlength="4" value="${getDetailData.END_DT_YY}" fname="" onkeyup="javascript:numCheck4(this);" placeholder="ex:2019"/>
								<span>년</span>
							</div>
							<div class="mtIptBox">
								<select id="END_DT_MM" name="END_DT_MM">
									<option value="">선택</option>
									<c:forEach begin="1" end="9" var="i" step="1">
										<option value="0<c:out value='${i}'/>">0<c:out value='${i}' /></option>
									</c:forEach>
									<c:forEach begin="10" end="12" var="i" step="1">
										<option value="<c:out value='${i}'/>"><c:out value='${i}' /></option>
									</c:forEach>
								</select>
								<span>월</span>
							</div>
						</div>
					</li>
					<li>
						<label class="rq">Rates</label>
						<input type="text" id="COSTRATES" name="COSTRATES" value="${getDetailData.COSTRATES}" fname="" onkeyup="javascript:numCheck4(this);" placeholder="ex:400000 "/>
					</li>
				</ul>
			</form>
		</div>
		<div class="popBtnWrap" title="save"><!-- 버튼이 2개일때 클래스 추가 class="popBtn" -->
			<button id="btn_save">저장</button>
		</div>
	</div>
</div>
