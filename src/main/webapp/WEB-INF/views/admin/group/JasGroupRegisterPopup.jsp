<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript" charset="utf-8"  src="<c:url value="/resources/js/ajaxfileupload.js"/>"></script>
<script type="text/javascript">
/* var arpType ;
	function findHighDept() {
		var arp; 
		if(arpType == "new"){
			arp = '${GROUPDATA.ARP}';	
		}else{
			arp = $("#ARP_NEW").val();
		}
		var data = {"ARP" : arp};
		var sid = "findHighDept";
		var url = "<c:url value='/group/findHighDept.json'/>";		
		ajax_sendData(sid,url,data);
	}
	 */
	//부모창의 새로고침/닫기/앞으로/뒤로 시 팝업 닫기
	 $(this).one('load', function() {
	    // 부모창의 새로고침/닫기/앞으로/뒤로
	    $(opener).one('beforeunload', function() {
	        window.close();
	    });
	});
	 
	function idCheck() {
		var type="${type}";
		if(type =='new'){
			var sid ="idCheck";
			var url = "<c:url value="/group/idCheckJson.json"/>";
			
			var company = $("#COMPANY_NM_NEW").val();
			var arp = $("#ARP_NEW").val();
			var deptnm = $("#DEPT_NM").val();
			var pardetpnm =$("#PAR_DEPT_NM").val();			
			var data={
					"COMPANY_NM": company
					,"ARP":arp					
					//,"ARP_NM":$("#ARP_NM").val()
					,"PAR_DEPT_NM": pardetpnm
					,"DEPT_NM": deptnm
					};
			ajax_sendData(sid,url,data);
		}else{
			doSave();
		}
	}
	function doSave(){
		var sid;
		var url = "<c:url value="/group/doGroupSave.json"/>";
		var type="${type}";
		var data;
		
		if(type == 'new'){
			data = {
					"COMPANY_NM": $("#COMPANY_NM_NEW").val()
					,"ARP":$("#ARP_NEW").val()
					//,"ARP_NM":$("#ARP_NM_NEW").val()
					,"PAR_DEPT_NM":$("#PAR_DEPT_NM_NEW option:checked").text()
					,"PAR_DEPT_CD":$("#PAR_DEPT_NM_NEW").val()	
					,"DEPT_LEVEL": $("#DEPT_LEVEL").val()
					,"DEPT_NM": $("#DEPT_NM").val()
					,"USERGROUP_DESC": $("#USERGROUP_DESC").val()
					,"USE_YN": $("#USE_YN").val()
					,"TYPE" : type 
					};
			
			sid="doSave";
		}else{
			
			data = {
					"COMPANY_NM": $("#COMPANY_NM").val()
					,"ARP":$("#ARP").val()
					//,"ARP_NM":$("#ARP_NM").val()
					,"PAR_DEPT_NM":$("#PAR_DEPT_NM option:checked").text()
					,"PAR_DEPT_CD":$("#PAR_DEPT_NM").val()
					,"DEPT_CD": $("#DEPT_CD").val()
					,"DEPT_LEVEL": $("#DEPT_LEVEL").val()
					,"DEPT_NM": $("#DEPT_NM").val()
					,"USERGROUP_DESC": $("#USERGROUP_DESC").val()
					,"USE_YN": $("#USE_YN").val()
					,"TYPE" : type 
					};
			sid="doSave";
		}
		ajax_sendData(sid,url,data);
		
	};
	
	function ajax_callback(sid,json) {
		if(sid=="doSave"){
			
			try {
// 				var result = json.result;
// 				var msg = json.msg;
// 				alert(msg);
// 				if(result == "success") {
// 					opener.parent.location.reload();
// 					window.close();
// 				}
				
				var result = json.result;
				
				if(result == "success") {
					alert("저장에 성공하였습니다.");
			 		opener.doRefresh(); 
					window.close();
				
				}else if(result =="noParID" ){
					alert("상위부서를 확인하세요.");
					return;
				
				}else alert("저장에 실패하였습니다.");
			} catch (e) {Logger.debug(e);}
		
		}else if(sid =="idCheck"){
			
			var result = json.result;
			if(result == 0){
				doSave();
			}else{
				alert("이미 사용중인 부서입니다.");
				return;
			}
		}else if(sid == "findHighDept"){
			try {
				var html = "";
				var dept = json.DEPT_CD;
				
				$.each(dept,function(enytyIndex,entry){
					html +="<option value="+entry.DEPT_CD+">"+entry.DEPT_NM+"</option>";
				});
				
				
				var type = '${GROUPDATA.PAR_DEPT_CD}';
				
				if(type != null){
					$('#PAR_DEPT_NM').empty();
					$("#PAR_DEPT_NM").append(html);
					$("#PAR_DEPT_NM").val('${GROUPDATA.PAR_DEPT_CD}');	
				}else{
					$('#PAR_DEPT_NM_NEW').empty();
					$("#PAR_DEPT_NM_NEW").append(html);					 	
				}
				
			} catch (e) {Logger.debug(e);}
		}
	};

$("document").ready(function() {
	var type = "${type}";
	
	if(type == 'detail'){
		$("#ARP").val("${GROUPDATA.ARP}");
		$("#USE_YN").val('${GROUPDATA.USE_YN}');
		$("#DEPT_LEVEL").val('${GROUPDATA.DEPT_LEVEL}');
		$("#PAR_DEPT_NM").val('${GROUPDATA.PAR_DEPT_CD}');
	}
	
/* 	arpType = "";
	$("#ARP").change(function () {		
		findHighDept();
		arpType = "detail";
	}).css("cursor", "pointer");
	$("#ARP_NEW").change(function () {
		findHighDept();
		arpType = "new";
	}).css("cursor", "pointer");
	 */
	$("#btn_save").click(function(){
		var ARP;
		//var ARP_NM;
		var COMPANY_NM;
	
		if(type == 'new'){
			COMPANY_NM =$("#COMPANY_NM_NEW").val();
			ARP =$("#ARP_NEW").val();
			//ARP_NM =$("#ARP_NM_NEW").val();
		}else{
			COMPANY_NM =$("#COMPANY_NM").val();
			ARP =$("#ARP").val();
			//ARP_NM =$("#ARP_NM").val();
		}
		var PAR_DEPT_NM=$("#PAR_DEPT_NM").val();
		var DEPT_NM=$("#DEPT_NM").val();
		var DEPT_LEVEL=$("#DEPT_LEVEL").val();
		var USE_YN=$("#USE_YN").val();
		
		COMPANY_NM = $.trim(COMPANY_NM);
		ARP = $.trim(ARP);
		//ARP_NM = $.trim(ARP_NM);
		PAR_DEPT_NM = $.trim(PAR_DEPT_NM);
		DEPT_NM = $.trim(DEPT_NM);
		
		if(COMPANY_NM == null || ARP == null || DEPT_NM==null || USE_YN==null ||COMPANY_NM == ''|| ARP ==''|| DEPT_NM==''|| USE_YN==''){
			alert("필수 항목을 확인하세요.");
			return;
		}else{
			idCheck();
		}
	}).css("cursor", "pointer");
	$("#btn_close").click(function(){
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
			<c:if test="${GROUPDATA.COMPANY_NM ne null}">
				<h3>조직 상세보기</h3>
			</c:if>
			<c:if test="${GROUPDATA.COMPANY_NM eq null}">
				<h3>조직 등록</h3>
			</c:if>

		</div>
		<div class="pop_area">
			<form name="updateForm" id="updateForm" method="post">
				<div class="popConWrap">
					<ul class="pIptWrap">
						<li>
							<label class="rq">회사명</label>
							<c:if test="${type eq 'detail'}" >
	                          <input type="text" id="COMPANY_NM" name="COMPANY_NM" value="${GROUPDATA.COMPANY_NM}" readonly="readonly" disabled="disabled"/>
	                    	</c:if>
	                    	<c:if test='${type eq "new"}' >
	                        	<input type="text" id="COMPANY_NM_NEW" name="COMPANY_NM"/>
	                    	</c:if>
						</li>
						<li>
							<label class="rq">지점</label>
		                    <c:if test="${type eq 'detail'}" >
	    	                      <input type="hidden" id="ARP" name="ARP" value="${GROUPDATA.ARP}" readonly="readonly" disabled="disabled"/>
	    	                      <input type="text" id="ARP" name="ARP" value="${GROUPDATA.ARP}" readonly="readonly" disabled="disabled"/>
	        	            </c:if>
	            	        <c:if test="${type eq 'new'}" >
	                		       <select id="ARP_NEW" name ="ARP">
										<option value="HO">본사</option>
										<c:forEach var="airport" items="${ARP}">
											<option value="${airport.CD}">${airport.CD}</option>
										</c:forEach>
									</select>
	                    	</c:if>
						</li>	
						<li>
							<label class="rq">상위부서명</label>
							<c:if test="${type eq 'detail'}" >
	    	                  	<%-- <input type="text" id="PAR_DEPT_NM" name="PAR_DEPT_NM"  value="${GROUPDATA.PAR_DEPT_NM}"/>--%>
								<%-- <input type="text" id="PAR_DEPT_CD" name = "PAR_DEPT_CD" value ="${GROUPDATA.PAR_DEPT_CD}"/> --%> 
								<select id="PAR_DEPT_NM" name ="PAR_DEPT_NM">
									
									<option value="HO">본사</option>
									
									<c:forEach var="deptList" items="${highDeptList}">
										<c:if test="${deptList.DEPT_CD ne GROUPDATA.DEPT_CD}">
											<option value="${deptList.DEPT_CD}">${deptList.DEPT_NM}</option>
										</c:if>										
									</c:forEach>
								</select>
	        	            </c:if>
	            	        <c:if test="${type eq 'new'}" >
	                		       <select id="PAR_DEPT_NM_NEW" name ="PAR_DEPT_NM_NEW">
										<c:forEach var="deptList" items="${highDeptList}">
											<option value="${deptList.DEPT_CD}">${deptList.DEPT_NM}</option>
										</c:forEach>
									</select>
	                    	</c:if>
						</li>		
						<li>
							<label class="rq">부서명</label>
		                 		<input type="text" id="DEPT_NM" name = "DEPT_NM"  value="${GROUPDATA.DEPT_NM}" maxlength="10" >
									<input type="hidden" id="DEPT_CD" name = "DEPT_CD" value ="${GROUPDATA.DEPT_CD}">
						</li>	
						<li>
							<label class="rq">부서레벨</label>
		                 	<select id="DEPT_LEVEL" name = "DEPT_LEVEL">
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
							</select>
						</li>		
						<li>
							<label>설명</label>
		                 	<textarea id="USERGROUP_DESC" name="USERGROUP_DESC" maxlength="250"><c:out value="${GROUPDATA.USERGROUP_DESC}"/></textarea>
						</li>
						<li>
							<label class="rq">사용여부</label>
		                 	<select id="USE_YN" name ="USE_YN">
		                 		<option	value="Y">Y</option>
		                 		<option	value="N">N</option>
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