<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dhtmlxgrid.big.css"/>" />
<script type="text/javascript">
checkPageRole("${USER_SESSION.ROLE_ID}",["ADMIN"]);//ADMIN ROLE_ID권한 허용
//그리드 변수
var mygrid<c:out value='_${pageMap.GRID_ID}'/>;
var filter;

// Ajax CallBack 
function ajax_callback(sid,json) {
	if(sid == "getGridData"){
		try {
			//JSON 처리 시 세션이 정상일 경우 처리 [파라미터:json리턴변수]
			if(!sessionCheckJSON(json)) return;

			var data = json.gridData;
			
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.setImagePath('<c:url value="/resources/dhtmlx/imgs/"/>');
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.clearAll();
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.parse(data,"json");
			
			var count = mygrid<c:out value='_${pageMap.GRID_ID}'/>.getRowsNum();

			if(count != 0){
				jQuery("#totalCnt").text(toNumberFormat(count));
			} else if(count == 0){
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.enableColSpan(true);
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.addRow(0, [_TEXT_NOROW]);
				mygrid<c:out value='_${pageMap.GRID_ID}'/>.setColspan(0, 0, mygrid<c:url value='_${pageMap.GRID_ID}'/>.getColumnsNum());
			}
			
			mygrid<c:out value='_${pageMap.GRID_ID}'/>.initMultiSort();	
		} catch (e) {Logger.debug(e);}
	}else if(sid == "doDelete"){
		try {
			//JSON 처리 시 세션이 정상일 경우 처리  [파라미터:json리턴변수]
			var result = json.result;
			
			if(!sessionCheckJSON(json)) return;
			
			if(result == "1") {
				alert("삭제되었습니다");
				jQuery("#searchUserName").val("");
				getGridData<c:out value='_${pageMap.GRID_ID}'/>();
				}else{
					alert("삭제가 실패하였습니다.");
				}
			} catch (e) {Logger.debug(e);}
		}
	}

//그리드 data
function getGridData<c:out value='_${pageMap.GRID_ID}'/>(){

	var data =  jQuery("#searchForm").serialize();
	var sid = "getGridData";
	var url = "<c:url value="/userManagement/UserManagementListFormJSON.json"/>";
	ajax_sendData(sid,url,data);	
}

//더블 클릭 이벤트
function doOnRowDblClickSelected<c:out value='_${pageMap.GRID_ID}'/>(row, cell){
	var grid = mygrid<c:out value='_${pageMap.GRID_ID}'/>;
	var userid = grid.cells(row,grid.getColIndexById("USER_ID")).getValue();
	goDetailPage(userid);
}

// 상세보기 팝업 
function goDetailPage(id) {
	window.location.href="<c:url value='/userManagement/JasUsrInfoEdit.detail?USER_ID="+id+"'/>";
}

// 추가 팝업
function doNew(){
	try {
		var url = '<c:url value="/userManagement/JasUsrUserInfoRegisterPopup.popup"/>';
		$("#popupForm").attr("target" , 'Popup_UserRegistPopup');
		window.open(url , 'Popup_UserRegistPopup' , "width=550px,height=640px, scrollbars=yes").focus();
		$("#popupForm").submit();
	} catch(e) {
		alert(e);
	}
};

//초기화
function doRefresh(){
	
	//데이터 리로드	
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	if( $("#searchUserUSEYN").val() == "N"){
		$("#btn_delete").hide();
	}else{
		$("#btn_delete").show();
	}
		
}

//on click event 
function doOnRowSelected<c:url value='_${pageMap.GRID_ID}'/>(row,ind){
	if($("#totalCnt").text() == '0' || $("#totalCnt").text() == '')	return ;
	$("#selectUserID").val(mygrid<c:out value='_${pageMap.GRID_ID}'/>.cells(row, mygrid<c:out value='_${pageMap.GRID_ID}'/>.getColIndexById('USER_ID')).getValue());
	
};

 // 사용자 삭제
function doDelete(){  
	var userid = $("#selectUserID").val();	
	var data;
	var sid = "doDelete";
	var url =  "<c:url value="/userManagement/JasUserAccountUseN.json"/>";
	var type = $("#searchUserUSEYN").val();
	
	if(!userid){
		alert("삭제할 계정을 선택하세요.");
		return;
	}
	
	if(type = "Y") {		
		if(confirm("사용중인 계정을 비활성계정을 변경하시겠습니까?")){
			data =  {"USER_ID" : userid,"USEYN" : "Y"};
			ajax_sendData(sid,url,data);
		}
	}
	/* else if(type ="N") {
		if(confirm("비활성계정을 삭제하시겠습니까?")) {
			data =  {"USER_ID" : userid,"USE_YN" : "N"};
			ajax_sendData(sid,url,data);
		}
	} */
};

//Enter key 막기
function captureReturnKey(e) {
	if(e.keyCode==13&& e.srcElement.type !='textarea')
		return false;
}

jQuery("document").ready(function(){
	viewGrid<c:out value='_${pageMap.GRID_ID}'/>();
	getGridData<c:out value='_${pageMap.GRID_ID}'/>();
	jQuery(".enter").keydown(function(event){
		if(event.keyCode == 13){
			event.preventDefault();
		}
	});
	jQuery("#btn_filter").click(function(event){
		commGridFilter('${pageMap.GRID_ID}');
	}).css("cursor", "pointer");

	//필터에 이벤트 발생시 체크박스 초기화
	jQuery(".hdr > tbody tr:eq(2) input").on("keydown",function(){Logger.debug("change-input");doAllCheckNot();});
	jQuery(".hdr > tbody tr:eq(2) select").change(function(){Logger.debug("change-select");doAllCheckNot();});
	
	//$(window).resize();
});
	$(window).resize(function(){
		var p = $("#${pageMap.GRID_ID}").offset();
		var h = $("body").height() - p.top - 30;
		var w = $("body").width() - p.left - 30;
		
	 	$(".chart").height(h);
	 	$(".chart").width(w);
	 	
		$("#${pageMap.GRID_ID}").width(w);
	 	$("#${pageMap.GRID_ID}").height(h);
	});
</script>
<div id="contents" class="contWrap">
	<form id="popUpForm" method="post">
		<input type="hidden" id="popCol" name="col">
		<input type="hidden" id="popColId" name="colId">
		<input type="hidden" id="popArp" name="arp">
		<input type="hidden" id="popCompanynm" name="companynm">
		<input type="hidden" id="popDeptnm" name="deptnm">
		<input type="hidden" id="popJoblevel" name="joblevel">
		<input type="hidden" id="popUserid" name="userid" >
		<input type="hidden" id="popUsernm" name="usernm">
		<input type="hidden" id="popRolenm" name="rolenm">
		<input type="hidden" id="popAccst" name="accst">
		<input type="hidden" id="popUseyn" name="useyn">
		<input type="hidden" id="popStat" name="stat">
		<input type="hidden" id="popSubType" name="subType" value="">
		<input type="hidden" name="width" id="popupWidth" value=""/>
		<input type="hidden" name="height" id="popupHeight" value=""/>
		<input type="hidden" name="ACCESS_CHECK" value="${ACCESS_CHECK}"/>
	</form>
	<form id="deleteFrom" method="post">
		<input type="hidden" id="selectUserID" name="col">
	</form>
	<!-- contents title start-->
	<div class="titWrap">
		<h3>사용자 관리</h3>
		<input id="totalCnt" type="hidden" />
	</div>
	
	<!-- contents title end-->
	<!-- contents search start-->
	<div class="schCon clear seachWrap">
		<form name="searchForm" id="searchForm" method="post" onkeydown="return captureReturnKey(event)">
			<input type="hidden" name="GRID_ID" value="${pageMap.GRID_ID}">
			<ul class="schCon">
				<li>
					<label for="searchUserUSEYN">계정 사용</label>
					<select id="searchUserUSEYN" name="searchUserUSEYN">
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
				</li>
				<li>
					<label for="searchUserKeyType">타입 </label>
					<select id="searchUserKeyType" name="searchUserKeyType">
						<option value="">전체</option>
						<option value="USER_ID">아이디</option>
						<option value="USER_NM">이름</option>
						<option value="DEPT_NM">부서명</option>
					</select>
				</li>
				<li>
					<input type="text" id="searchUserName" name="searchUserName">
				</li>
			</ul>
			<div class="schBtnWrap">
 				<c:if test="${USER_SESSION.ROLE_ID eq 'ADMIN'}">
					<button type="button" id="btn_refresh" class="btn" onclick="doRefresh();">조회</button>
					<button type="button" id="btn_new" class="btn" onclick="doNew();">신규</button>
					<button type="button" id="btn_delete" class="btn btnOrange" onclick="doDelete();">삭제</button>		
				</c:if>			
			</div> 
		</form>
	</div>
	<!-- contents search end-->
	<!-- contents start -->
	<div class="chart listWrap">
		<form name="updateForm" id="updateForm" method="post">			
				<div id="${pageMap.GRID_ID}" class="tbWrap">${USER_LIST_TAG}</div>
		</form>
	</div>
	<!-- contents end -->
	<form id="goDetailFrom">
		<input type="hidden" id="goDetailID" name="goDetailID" />
	</form>
</div>
