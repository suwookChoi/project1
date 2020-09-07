<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript">
var stat = '${pageMap.stat}';

$(document).ready(function(){
	$("input[type=button]").button();
	
	$("#btnClose").click(function(event){
		event.preventDefault();
		doClose();
	});
	
	$("#btnSave").click(function(event){
		event.preventDefault();
		doSave();
	});
	
	//화면 컨트롤
	displayControll();
});

function doSave(){
	var ARP = $('#ARP').val();
	var ICAO = $('#ICAO').val();
	var NTC = $('#NTC').val();
	var NTNM = $('#NTNM').val();
	var CTN = $('#CTN').val();
	var APT = $('#APT').val();
	var UYN = $('#UYN').val();
	var TMZN = $('#TMZN').val();
	var RMK = $('#RMK').val();
	
	var data = {'ARP': ARP
			, 'ICAO': ICAO
			, 'NTC': NTC
			, 'NTNM': NTNM
			, 'CTN': CTN
			, 'APT': APT
			, 'UYN': UYN
			, 'TMZN': TMZN
			, 'RMK': RMK
			, 'stat' : stat
	};
	
	if(ARP == ''){
		alert("IATA Code를 입력하세요.");
		$('#ARP').focus();
		return false;
	}else if(ICAO == ''){
		alert("ICAO Code를 입력하세요.");
		$('#ICAO').focus();
		return false;
	}else if(NTC == ''){
		alert("국가 코드를 입력하세요.");
		$('#NTC').focus();
		return false;
	}else if(NTNM == ''){
		alert("국가를 입력하세요.");
		$('#NTNM').focus();
		return false;
	}else if(CTN == ''){
		alert("도시를 입력하세요.");
		$('#CTN').focus();
		return false;
	}else if(APT == ''){
		alert("공항명을 입력하세요.");
		$('#APT').focus();
		return false;
	}else if(UYN == ''){
		alert("사용여부를 입력하세요.");
		$('#UYN').focus();
		return false;
	}else if(TMZN == ''){
		alert("시차를 입력하세요.");
		$('#TMZN').focus();
		return false;
	}else{
		var data = data;
		var url = "<c:url value="/admin/airport/createAirport.json"/>";
		var sid = "save";
		
		ajax_sendData(sid, url, data);
	}
}

function ajax_callback(sid, json){
	if(sid == "save"){
		if(json.result == "success"){
			alert("저장에 성공하였습니다.");
			doClose();
			window.opener.doRefresh();
		}else if(json.result == "dup"){
			alert("이미 사용중인 코드 ID 입니다.");
		}else{
			alert("저장에 실패하였습니다.");
		}
	}
}

function doClose(){
	self.close();
}

//화면 설정
function displayControll(){
	<c:if test="${pageMap.stat eq 'detail'}">
		jQuery("#ARP").attr("disabled", true);
		jQuery("#ARP").val('${airportInfo.ARP}');
		jQuery("#ICAO").val('${airportInfo.ICAO}');
		jQuery("#NTC").val('${airportInfo.NTC}');
		jQuery("#NTNM").val('${airportInfo.NTNM}');
		jQuery("#CTN").val('${airportInfo.CTN}');
		jQuery("#APT").val('${airportInfo.APT}');
		jQuery("#UYN").val('${airportInfo.UYN}');
		jQuery("#TMZN").val('${airportInfo.TMZN}');
		jQuery("#RMK").val('${airportInfo.RMK}');
	</c:if>
}

function tmznCheck(value){
	if(!value){
		return;
	}
	
	if(value.length > 5){
		return;
	}else{
		var hMinus = value.substr(0, 1);
		if(hMinus == "-"){
			var hTime = value.substr(1, 4);
			
			if(hTime.length == 4){
				var pattern = /^[0-9]+$/;
				
				if(!pattern.test(hTime)){
					alert("마이너스와 숫자만 입력하세요.");
					return;
				} else if(!checkDateString(hTime)){
					alert("시간형식이 맞지 입력하세요.");
					return;
				}
			} else{
				alert("마이너스와 숫자만 입력하세요.");
				return;
			}
		}else{
			if(value.length == 4){
				var pattern = /^[0-9]+$/;
				
				if(!pattern.test(value)){
					alert("숫자만 입력하세요.");
					return;
				}else if(!checkDateString(value)){
					alert("시간형식이 맞지 않습니다.");
					return;
				}
			} else{
				alert("숫자 4자리를 입력해주세요.");
				return;
			}
		}
	}
}

</script>
<div class="popupWrap">
	<div class="contWrap">
		<div class="titWrap">
			<c:choose>
				<c:when test="${pageMap.stat eq 'create'}">
					<h3>공항코드 등록</h3>
				</c:when>
				<c:otherwise>
					<h3>공항코드 수정</h3>
				</c:otherwise>
			</c:choose>
		</div>
		<div class="popConWrap scrPop">
			<ul class="pIptWrap">
				<li>
					<label class="rq">IATA Code</label>
					<c:choose>
						<c:when test="${pageMap.stat eq 'create'}">
							<input type="text" id="ARP" name="ARP" onkeyup="javascript:engCheck2(this)" maxlength="3" />
						</c:when>
						<c:otherwise>
							<input type="text" id="ARP" name="ARP" onkeyup="javascript:engCheck2(this)" maxlength="3" readonly/>
						</c:otherwise>
					</c:choose>
				</li>
				<li>
					<label class="rq">ICAO Code</label>
					<input type="text" name="ICAO" id="ICAO" onkeyup="javascript:engCheck2(this)" maxlength="4"/>
				</li>
				<li>
					<label class="rq">국가 코드</label>
					<input type="text" name="NTC" id="NTC" onkeyup="javascript:engCheck2(this)"  maxlength="2"/>
				</li>
				<li>
					<label class="rq">국가</label>
					<input type="text" name="NTNM" id="NTNM" />
				</li>
				<li>
					<label class="rq">도시</label>
					<input type="text" name="CTN" id="CTN" class="w90"/>
				</li>
				<li>
					<label class="rq">공항명</label>
					<input type="text" name="APT" id="APT" class="w90"/>
				</li>
				<li>
					<label class="rq">사용유무</label>
					<select id="UYN" name="UYN" class="w90">
						<option value='Y'>Y</option>
						<option value='N'>N</option>
					</select>
				</li>
				<li>
					<label class="rq">시차</label>
					<input type="text" name="TMZN" id="TMZN" class="w90" onkeyup="javascript:numCheck4(this);" fname="시차는 " maxlength="5" placeholder="ex:-0100"/>
				</li>
				<li>
					<label>설명</label>
					<textarea id="RMK" style="width:100%;height:70px;" ></textarea>
				</li>
			</ul>
		</div>
		<div class="popBtnWrap" title="save" id="btnSave"><!-- 버튼이 2개일때 클래스 추가 class="popBtn" -->
			<button>저장</button>
		</div>
	</div>
</div>
