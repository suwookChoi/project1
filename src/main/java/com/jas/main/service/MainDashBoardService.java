package com.jas.main.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.framework.dataHandler.dhtmlx.GridHandler;
import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.util.StringUtil;
import com.jas.cod.dao.CodeGHUnitDao;
import com.jas.gh.dao.GhTeamDAO;
import com.jas.main.dao.MainDashBoardDao;

@Service
public class MainDashBoardService extends CommonAbstractService {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	MainDashBoardDao dashBoardDao;

	@Autowired
	CodeGHUnitDao codGHUnitDao;
	
	@Autowired
	GhTeamDAO ghTeamDao;
	
	/**
	 * 대시보드 메인화면 접근
	 * @param model,request
	 * @throws Exception
	 */
	public void getDashBoardFormInfo(Model model,HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		/*
		 * HttpSession session = request.getSession(false); String ARP = "";
		 * if(session!= null) { ARP = session.getAttribute("SELECTED_ARP")==
		 * null ? "" : session.getAttribute("SELECTED_ARP").toString(); }else
		 * ARP = "GMP";
		 */
		reqMap.put("dashBoard","Y");
		reqMap.put("FLC","ALL");
		//reqMap.put("ARP",ARP);
		SimpleDateFormat dateFormatGmt = new SimpleDateFormat("yyyy.MM.dd");
		dateFormatGmt.setTimeZone(TimeZone.getTimeZone("GMT+9"));
		reqMap.put("searchDate", dateFormatGmt.format(new Date()).toString());
		//model.addAttribute("ARP",ARP);
		model.addAttribute("flcCodeList",getFlcCodeList());
		model.addAttribute("arpList",getCodeVal("BRA"));
	}
	
	/**
	 * 대시보드 데이터
	 * @param model
	 * @throws Exception
	 */
	public void getDashBoardList(Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		reqMap.put("dashBoard","Y");
		
		Iterator it = reqMap.keySet().iterator();
		while(it.hasNext()) {
			String key = it.next().toString();
		}
		
		
		model.addAttribute("RMKEMRLIST", getRMKEMRList(reqMap)); //RMK, EMR 리스트
		model.addAttribute("WORKUNITLIST",this.codGHUnitDao.getGHUnitList(reqMap)); //작업정보 헤더 리스트
		model.addAttribute("GHOPRLIST",  dashBoardDao.getGHOprList(reqMap)); //작업 오퍼레이션 리스트
		model.addAttribute("ARRDEPLIST", dashBoardDao.getDashBoardList(reqMap)); //그리드 데이터 ,항공편 등등
		model.addAttribute("pageMap",reqMap);
	}
	public void getDashBoardListTab(Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		reqMap.put("dashBoard","Y");
		
		Iterator it = reqMap.keySet().iterator();
		while(it.hasNext()) {
			String key = it.next().toString();
		}
		
		model.addAttribute("GHOPRLIST",  dashBoardDao.getGHOprList(reqMap)); //작업 오퍼레이션 리스트
		model.addAttribute("ARRDEPLIST", dashBoardDao.getDashBoardListTab(reqMap)); //그리드 데이터 ,항공편 등등
		model.addAttribute("pageMap",reqMap);
	}
	
	/**
	 * 작업 팝업
	 * @param model
	 * @throws Exception
	 */
	public void getGHUnitList(Model model){
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		try {
			HashMap<String, Object> resultMap = setGridListParamaters(reqMap);
			List<HashMap<String, Object>> list = dashBoardDao.getGHUnitList(reqMap); 
			resultMap.put("DATA_LIST", list);
			model.addAttribute("totalCnt", list.size());
			model.addAttribute("gridData",  getGridDataJson(resultMap, false));
			model.addAttribute("list",list);
			model.addAttribute("pageMap",reqMap);
		}catch(Exception e) {
			logger.error(e);
		}
		
	}

	/**
	 * 비정상 팝업
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void dashEMRPopup(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
		model.addAttribute("codeList", getCodeVal("UNF_COD"));
		
		if (logger.isDebugEnabled()) {
			logger.debug("reqMap:"+reqMap.toString());
		}
		model.addAttribute("pageMap", reqMap);
		
		reqMap.put("TOI", "IN");
		HashMap<String, Object> map = dashBoardDao.selectEmr(reqMap);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("FLT", reqMap.get("LKT"));
		param.put("SDT", reqMap.get("SDT"));
		param.put("ARP", reqMap.get("ARP"));
		param.put("TOI", "OUT");
		HashMap<String, Object> map2 = dashBoardDao.selectEmr(param);
		model.addAttribute("emrinInfo", map);
		model.addAttribute("emroutInfo", map2);
		}

	/**
	 * 비정상 팝업 저장
	 * @param model
	 * @throws Exception
	 */
	public void dashEMRSave(Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		String EMR_IN = reqMap.get("EMR_IN") == null ? "" : reqMap.get("EMR_IN").toString();
		String EMR_OUT = reqMap.get("EMR_OUT") == null ? "" : reqMap.get("EMR_OUT").toString();
		
		if (!"".equals(EMR_IN)) {
			String EMR = EMR_IN;
			reqMap.put("EMR", EMR);
			reqMap.put("TOI", "IN");
			reqMap.put("REG", reqMap.get("IN_ACNO").toString());
			dashBoardDao.dashEMRSave(reqMap); 
		}
		if (!"".equals(EMR_OUT)) {
			String EMR = EMR_OUT;
			String FLT = reqMap.get("LKT").toString();
			reqMap.put("EMR", EMR);
			reqMap.put("TOI", "OUT");
			reqMap.put("FLT", FLT);
			reqMap.put("REG", reqMap.get("OUT_ACNO").toString());
			dashBoardDao.dashEMRSave(reqMap);
		}
		model.addAttribute("result", "success");
	}
	
	/**
	 * 전달사항 팝업
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void dashRMKPopup(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (logger.isDebugEnabled()) {
			logger.debug("reqMap:"+reqMap.toString());
		}
		model.addAttribute("pageMap", reqMap);

	}
	
	@SuppressWarnings("unchecked")
	public void dashRMKSearch(Model model, HttpServletRequest request)throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
		HashMap<String, Object> map = dashBoardDao.selectRmk(reqMap);
		if(map != null) {
			String inRMK = map.get("RMK") == null ? "" : map.get("RMK").toString().replaceAll("\r\n","<br>"); 
			map.put("RMK",inRMK);
		}
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("FLT", reqMap.get("LKT"));
		param.put("SDT", reqMap.get("SDT"));
		param.put("ARP", reqMap.get("ARP"));

		HashMap<String, Object> map2 = dashBoardDao.selectRmk(param);
		if(map2 != null) {
			String outRMK = map2.get("RMK") == null ? "" : map2.get("RMK").toString().replaceAll("\r\n","<br>"); 
			map2.put("RMK",outRMK);
		}
		
		model.addAttribute("emrinInfo", map);
		model.addAttribute("emroutInfo", map2);
		
	}
	/**
	 * 전달사항 팝업 저장
	 * @param model
	 * @throws Exception
	 */
	public void dashRMKSave(Model model) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		if("OUT".equals(reqMap.get("FLAG"))) {
			param.put("FLT", reqMap.get("LKT"));
			param.put("SDT", reqMap.get("SDT"));
			param.put("ARP", reqMap.get("ARP"));
			param.put("RMK", reqMap.get("RMK"));
			param.put("TOI", "OUT");
		} else {
			param.put("FLT", reqMap.get("FLT"));
			param.put("SDT", reqMap.get("SDT"));
			param.put("ARP", reqMap.get("ARP"));
			param.put("RMK", reqMap.get("RMK"));
			param.put("TOI", "IN");
		}
		
		dashBoardDao.dashRMKSave(param);
		model.addAttribute("result", "success");
	}
	/**
	 * 팀유저리스트 조회
	 * @param model
	 * @throws Exception
	 */
	public void getDashGhTeamUserList(Model model) throws Exception {

		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		List<HashMap<String, Object>> DEFAULT_TEAM_LIST = dashBoardDao.getDashGhTeamUserList(reqMap);
		
		List<HashMap<String, Object>> TEAM_LIST = new ArrayList<>();
		List<HashMap<String, Object>> NOTEAM_LIST = new ArrayList<>();
		List<HashMap<String, Object>> NOTEAM_LIST2 = new ArrayList<>();
		
		for(HashMap<String,Object> map : DEFAULT_TEAM_LIST) {
			String FLAG = map.get("TEAM_FLAG") == null ? "": map.get("TEAM_FLAG").toString();
			if("Y".equals(FLAG)) TEAM_LIST.add(map);
			else NOTEAM_LIST.add(map);
		}
		String team_nm = "";
		
		for(int i=0;i<NOTEAM_LIST.size();i++) {
			String user1 = "";
			String user2 = "";
			String team1 = NOTEAM_LIST.get(i).get("TEAM_NM") == null ?"":NOTEAM_LIST.get(i).get("TEAM_NM").toString();
			String team2 = "";
			
			user1 = NOTEAM_LIST.get(i).get("USER_ID").toString();
			if(i+1 != NOTEAM_LIST.size()) {
				user2 = NOTEAM_LIST.get(i+1).get("USER_ID").toString();
				team2 = NOTEAM_LIST.get(i+1).get("TEAM_NM") == null ? "":NOTEAM_LIST.get(i+1).get("TEAM_NM").toString();
			}
			if(i == 0) {
				team_nm = team1;
			}else if(i-1 == NOTEAM_LIST.size()) {
				team_nm += ","+team2;
			}
			if(user1.equals(user2)) {
				team_nm += ","+team2;
			}else {
				if(team_nm != "") {
					if(team_nm.substring(0,1).equals(",")) {
						team_nm = team_nm.substring(1);
					}
					NOTEAM_LIST.get(i).put("TEAM_NM",team_nm);
				}
				NOTEAM_LIST2.add(NOTEAM_LIST.get(i));
				team_nm = team2;
			}
		}
		result.put("GH_TEAM_USER_LIST", TEAM_LIST);
		result.put("GH_NOTEAM_USER_LIST", NOTEAM_LIST2);
		
		model.addAttribute("TEAM_ID", reqMap.get("TEAM_ID").toString());
		model.addAttribute("DATA",  result);
	}
	
	/**
	 * 팀유저 저장
	 * @param model
	 * @throws Exception
	 */
	public void saveDashGhTeamUser(Model model) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		List<HashMap<String, Object>> paramList = new ArrayList<>();
		Iterator<String> keys = reqMap.keySet().iterator();
		while(keys.hasNext()){
			String key = keys.next();
			JSONParser parser = new JSONParser();
			HashMap<String,Object> map = (HashMap<String,Object>)parser.parse(key);
			paramList = (List) map.get("saveData");
		}
		int successCnt = 0;
		for(HashMap<String, Object> param : paramList){
			
			if("I".equals(param.get("STAT"))){
				successCnt += dashBoardDao.saveDashTeamUser(param);
			}else if("D".equals(param.get("STAT"))){
				successCnt += dashBoardDao.deleteDashTeamUser(param);
			}
		}
		model.addAttribute("DATA",  successCnt);
	}
	
	/**
	 * 대시보드 팀 조회
	 * @param model
	 * @throws Exception
	 */
	public void getDashTeamList(Model model) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		String SDT = reqMap.get("SDT").toString();
		String year = SDT.substring(0,4);
		String month = SDT.substring(4,6);
		String day = SDT.substring(6,8);
		
		reqMap.put("YEAR",year);
		reqMap.put("MONTH",month);
		reqMap.put("DAY",day);
		List<HashMap<String, Object>> TEAM_LIST = dashBoardDao.getDashTeamList(reqMap);
		model.addAttribute("DATA",TEAM_LIST);
		}
	
	/**
	 * 일일 팀 저장,삭제
	 * @param model
	 * @throws Exception
	 */
	public void saveDashTeam(Model model) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		List<HashMap<String, Object>> paramList = StringUtil.jsonStringToList((String) reqMap.get("saveData"));
		String team_day = reqMap.get("TEAM_DAY").toString();
		for(HashMap<String, Object> map : paramList){
			map.put("TEAM_DAY",team_day);
			if("NEW".equals((String)map.get("STAT"))){
				if(!"".equals(map.get("TEAM_NM").toString()))
				dashBoardDao.addDashTeam(map);
			} else if("DELETE".equals((String)map.get("STAT"))){
				dashBoardDao.deleteDashTeam(map);
			}	
		}
		model.addAttribute("DATA",  0);
	}

	/**
	 * 대시보드 그리드 정보 조회
	 * @param model
	 * @throws Exception
	 */
	public void ghDashTeamGrid(Model model) throws Exception{
		setGhTeamGrid(model, "GH_NOTEAM_LIST_DASH");
		setGhTeamGrid(model, "GH_TEAM_LIST");
		setGhTeamGrid(model, "GH_TEAM_GRID");
	}
	
	/**
	 * 팀그리드
	 * @param model
	 * @throws Exception
	 */
	public void setGhTeamGrid(Model model, String gridId) throws Exception {
		StringBuilder gridTag = new StringBuilder();
		HashMap<String, Object> reqMap = new HashMap<>(); 
		if(null == reqMap.get("LANG_TYPE")){
			reqMap.put("LANG_TYPE", "KOR");
		}
		reqMap.put("GRID_ID", gridId);
		List<HashMap<String, Object>> gridColumnList = commonGridDAO.getGridColumnList(reqMap);
		//그리드 테그
		gridTag = GridHandler.getGridTags(gridColumnList, "loadXMLString", gridId);
		model.addAttribute(gridId + "_TAG", gridTag.toString());
		reqMap.put("GRID_TAG", gridTag.toString());
		model.addAttribute("pageMap_" + gridId, reqMap);
	}	
	

	/**
	 * 일일 팀유저 저장
	 * @param model
	 * @throws Exception
	 */
	public void saveDashTeamUser(Model model) throws Exception {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		List<HashMap<String, Object>> paramList = new ArrayList<>();
		Iterator<String> keys = reqMap.keySet().iterator();
		while(keys.hasNext()){
			String key = keys.next();
			JSONParser parser = new JSONParser();
			HashMap<String,Object> map = (HashMap<String,Object>)parser.parse(key);
			paramList = (List) map.get("saveData");
		}
		int successCnt = 0;
		for(HashMap<String, Object> param : paramList){
			if("I".equals(param.get("STAT"))){
				successCnt += dashBoardDao.saveDashTeamUser(param);
			}else if("D".equals(param.get("STAT"))){
				successCnt += dashBoardDao.deleteDashTeamUser(param);
			}
		}
		model.addAttribute("DATA",  successCnt);
	}
	/**
	 * 일일 대시보드 팀 저장
	 * @param model
	 * @throws Exception
	 */
	public void saveGHTeam(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		JSONObject job = (JSONObject) JSONValue.parse(reqMap.get("list").toString());
		Iterator<String> it = job.keySet().iterator();
		try {
			String USER_NMList = "";
			String USER_IDList = "";
			String TEAM_NM = "";
			String TEAM_ID = "";
			List<Map<String, String>> tempList = new ArrayList<>();
			while(it.hasNext()) {
				Map<String,String> tempMap = new HashMap<>();	
				HashMap<String,Object> map = (HashMap<String,Object>) job.get(it.next());
				TEAM_NM = map.get("TEAM_NM").toString();
				TEAM_ID = map.get("TEAM_ID").toString();
				tempMap.put("USER_NM",map.get("USER_NM").toString());
				tempMap.put("USER_ID",map.get("USER_ID").toString());
				tempList.add(tempMap);
			}
			Collections.sort(tempList, new Comparator<Map<String,String>>(){ 
				 public int compare(Map<String,String> map1, Map<String,String> map2) { 
					 return map1.get("USER_NM").compareTo(map2.get("USER_NM")); }
				 });
			for(int i =0; i<tempList.size();i++) {
				Map<String,String> temp = tempList.get(i);
				USER_NMList += temp.get("USER_NM");
				USER_IDList += temp.get("USER_ID");
				if(tempList.size() != i+1) {
					USER_NMList += ",";
					USER_IDList += ",";
				}
			}
			reqMap.put("TEAM_ID", TEAM_ID);
			reqMap.put("TEAM_NM", TEAM_NM);
			reqMap.put("USER_LIST", USER_NMList);
			reqMap.put("USER_ID_LIST",USER_IDList);
			dashBoardDao.saveGHTeam(reqMap);
			
			model.addAttribute("result","success");
		}catch(Exception e) {
			model.addAttribute("result","fail");
		}
	}

	/**
	 * 대시보드 장비 리스트 조회
	 * @param model
	 * @throws Exception
	 */	
	public void getEQList(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		List<HashMap<String,Object>> EQList = dashBoardDao.getEQList(reqMap);
		model.addAttribute("EQList",EQList);
	}

	/**
	 * 대시보드 작업정보 저장
	 * @param model
	 * @throws Exception
	 */
	public void saveGHUnitLoad(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		JSONObject job = (JSONObject) JSONValue.parse(reqMap.get("list").toString());
		Iterator it = job.keySet().iterator();
		try {
			while(it.hasNext()) {
				String KEY = it.next().toString();	
				//HashMap<String,Object> map = (HashMap<String, Object>) job.get(KEY);
				Map<String,Object> map = new ObjectMapper().readValue(job.get(KEY).toString(), Map.class) ;
				if("DELETE".equals(map.get("STATUS").toString())) {
					dashBoardDao.deleteGHUnitLoad(map);	
				}else{
					dashBoardDao.insertGHUnitLoad(map);	
				}
				
			}	
		}catch(Exception e) {
			model.addAttribute("result","fail");
		}

	}

	/**
	 * 대시보드 장비 단가 조회
	 * @param model
	 * @throws Exception
	 */
	public void getEQUseList(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		model.addAttribute("EQLIST",dashBoardDao.getEQUseList(reqMap));
	}
	
	/**
	 * 대시보드 배정된 조원 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	public void getGHTeamDayList(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		model.addAttribute("DAYTEAMLIST",dashBoardDao.getGHTeamDayList(reqMap));
	}

	/**
	 * 대시보드 장비 사용내역 저장
	 * @param model
	 * @throws Exception
	 */
	public void saveGHEQList(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		JSONObject job = (JSONObject) JSONValue.parse(reqMap.get("list").toString());
		Iterator it = job.keySet().iterator();
		try {
			while(it.hasNext()) {
				String KEY = it.next().toString();
	
				Map<String,Object> map = new ObjectMapper().readValue(job.get(KEY).toString(), Map.class) ;
				String endTime = map.get("EQ_ENDTIME") == null ? "" : map.get("EQ_ENDTIME").toString(); 
				String status = map.get("STATUS").toString();
				System.out.println(">>>>>>>>>>>>>>>>>>>>>>>test:"+map.get("EQ_TY2"));
				System.out.println(">>>>>>>>>>>>>>>>>>>>>>>test2:"+map.get("EQ_TY"));
				if(status.equals("DELETE")) {
					dashBoardDao.deleteEQList(map);
				}else {
					if(!"".equals(endTime)) { //작업 종료시간이 입력됐을 경우만
						String EQ_FLAG = dashBoardDao.selectEQ_FLAG(map);
						if("N".equals(EQ_FLAG)) {
							map.put("EQ_TY2","Ramp Agent");
							map.put("EQ_FLAG","N");
						}else {
							map.put("EQ_FLAG","Y");
							map.put("EQ_TY2",map.get("EQ_TY"));
						}
						Map<String,Object> returnMap = costCalculator(map);
						map.put("COSTRATES",returnMap.get("COSTRATES").toString());
						map.put("ADDRATES",returnMap.get("ADDRATES").toString());
						map.put("COST", returnMap.get("COST").toString());
						map.put("USE_TIME", returnMap.get("USE_TIME").toString());
						map.put("NIGHT", returnMap.get("NIGHT").toString());
					}
					map.put("EQ_TY",map.get("EQ_TY"));
					dashBoardDao.saveGHEQList(map);
				}	
			}
		}catch(Exception e) {
			logger.error(e);
			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>");
			e.printStackTrace();
			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>");
			model.addAttribute("result","fail");
		}
	}
	
	/**
	 * 대시보드 장비 단가 계산
	 * @param map
	 * @throws Exception
	 */
	public Map<String,Object> costCalculator(Map<String,Object> map) {
		Map<String,Object> priceInfo = dashBoardDao.getPriceInfo(map);
		//RampAgenet 요율 * (지원인력 * 시간 ) *할증
		String per = priceInfo.get("PER").toString(); //요율 타입
		String s = map.get("EQ_STTIME").toString(); //시작 시간
		String e = map.get("EQ_ENDTIME").toString(); //종료 시간
		int addRate = priceInfo.get("ADDRATES") == null ? 0 : Integer.parseInt(priceInfo.get("ADDRATES").toString()); 
		int costRate = priceInfo.get("COSTRATES") == null ? 0 : Integer.parseInt(priceInfo.get("COSTRATES").toString());
		String night = "N";
		int wPerson = map.get("EQ_PERSON").toString() == "" ? 0 : Integer.parseInt(map.get("EQ_PERSON").toString()); 
		int wTime = 0, fullTime = 0, cost = 0 , h =0 , m =0 , ah = 0 , am =0;
		int sYear, eYear, sMonth, eMonth, sTime, eTime;
		sYear = Integer.parseInt(s.substring(0,4));
		eYear = Integer.parseInt(e.substring(0,4));
		sMonth = Integer.parseInt(s.substring(4,8));
		eMonth = Integer.parseInt(e.substring(4,8));
		sTime = Integer.parseInt(s.substring(8,10))*60+Integer.parseInt(s.substring(10));
		eTime = Integer.parseInt(e.substring(8,10))*60+Integer.parseInt(e.substring(10));
		
		if(sTime <= 360 || 1320<=sTime || eTime <= 360 || 1320 <=eTime) night = "Y";
		//다음날로 넘어갈 경우 , 연말계산 12월31일 -> 1월 1일
		if(sYear<eYear) eTime += 1440;
		else if(sMonth<eMonth)eTime += 1440;
		
		wTime = eTime - sTime;  //사용 시간
		fullTime = wTime * wPerson; //전체 사용시간
		
		//TIME 횟수
		if("TIME".equals(per)) {
			cost = costRate;
		//TRIP 여정
		}else if("TRIP".equals(per)) {
			cost = costRate;
		//Hour 시간 
		}else if("HOUR".equals(per)) {
			if(0 == addRate) { //10분당 요금 없을경우
			   h = fullTime / 60;
			   m = fullTime % 60;
			   if(m >0) h += 1;
			   if(fullTime == 0)  //0분
				   h = 1;
			   cost = costRate * h;
			}else { // 10분당 요금 존재
			   if(fullTime <= 60) { //1시간 이하
				   h = 1;
				   cost = costRate * h;
			   }else { //1시간 이상
				   h = 1; //기본 1시간 요율  
				   int remainTime = fullTime - 60; 
				   ah = remainTime / 10;  //남은시간 10분당 계산
				   am = remainTime % 10; 
				   if(am > 0) ah += 1;
				   cost = (costRate * h) + (addRate * ah);  
				   
			   }
			}
		}
		if("Y".equals(night)) cost *= 1.3;
		Map<String,Object> returnMap = new HashMap<>();
		returnMap.put("COST", cost + "");
		returnMap.put("USE_TIME", fullTime +"");
		returnMap.put("NIGHT", night);
		returnMap.put("COSTRATES", costRate +"");
		returnMap.put("ADDRATES", addRate +"");
		
		return returnMap;
	}
	
	/**
	 * 대시보드 비정상,전달사항 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	public List<HashMap<String,Object>> getRMKEMRList(HashMap<String,Object> reqMap){
	List<HashMap<String,Object>> list =	dashBoardDao.getRMKEMRList(reqMap);
	List<HashMap<String,Object>> RMKEMRList =	new ArrayList<>();
	for(HashMap<String,Object> map : list) {
		String TOI = map.get("TOI").toString();
		if("OUT".equals(TOI)) {
			String LKT = map.get("FLT").toString();
			map.put("LKT",LKT);
			map.put("FLT","");
		}
		RMKEMRList.add(map);
	}
	return RMKEMRList;	
	
	}

	/**
	 * 대시보드 장비 횟수 조회
	 * @param model
	 * @throws Exception
	 */
	public void getGHEQList(Model model) throws Exception {
		HashMap<String,Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
		HashMap<String, Object> resultMap = setGridListParamaters(reqMap);
		List<HashMap<String, Object>> list = dashBoardDao.getGHEQOprList(reqMap); 
		resultMap.put("DATA_LIST", list);
		model.addAttribute("list", list);
		model.addAttribute("totalCnt", list.size());
		model.addAttribute("gridData",  getGridDataJson(resultMap, false));
		model.addAttribute("pageMap",reqMap);
		
	}
	
	/**
	 * 대시보드 유저정보 조회 
	 * @param model
	 * @throws Exception
	 */
	public void getDashUserInfo(Model model) throws Exception{
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		List<HashMap<String, Object>> paramList = new ArrayList<>();
		Iterator<String> keys = reqMap.keySet().iterator();
		
		while (keys.hasNext()) {
			String key = keys.next();

			JSONParser parser = new JSONParser();
			HashMap<String, Object> map = (HashMap<String, Object>) parser.parse(key);
			paramList = (List) map.get("saveData");
		}
		 
		String type = paramList.get(0).get("STAT").toString();
		List<HashMap<String,Object>> returnList = new ArrayList<>();
		String teamList = "";
		for(HashMap<String, Object> param : paramList){
			HashMap<String,Object> returnMap = new HashMap<>();
			List<HashMap<String,Object>> list = dashBoardDao.getDashUserInfo(param);
			for(HashMap<String,Object> map : list) {
				String team_nm = map.get("TEAM_NM")== null ? "" : map.get("TEAM_NM").toString();
				teamList += ","+team_nm;
				returnMap = map;
				returnMap.put("TEAM_NM",teamList);
				returnMap.put("TYPE", type);
			}
			returnList.add(returnMap);
			teamList = "";
			
		}
		model.addAttribute("DATA",returnList);
	}
	
	/**
	 * 대시보드 배정된 조원 조회
	 * @param model
	 * @throws Exception
	 */
	public void getAssignTeamList(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		HashMap<String, Object> result = new HashMap<>();
		String strUserList = reqMap.get("USER_LIST").toString();
		String [] userList = strUserList.split(",");
		reqMap.put("USER_LIST", userList);
		List<HashMap<String, Object>> DEFAULT_TEAM_LIST = dashBoardDao.getAssignTeamList(reqMap);
		List<HashMap<String, Object>> ASSIGN_TEAM_LIST = new ArrayList<>();
		List<HashMap<String, Object>> ASSIGN_NOTEAM_LIST = new ArrayList<>();

		for(HashMap<String,Object> map : DEFAULT_TEAM_LIST) {
			String flag = map.get("TEAM_FLAG").toString();
			if("Y".equals(flag)) ASSIGN_TEAM_LIST.add(map);
			else ASSIGN_NOTEAM_LIST.add(map);
		}
		result.put("ASSIGN_TEAM_LIST", ASSIGN_TEAM_LIST);
		result.put("ASSIGN_NOTEAM_LIST", ASSIGN_NOTEAM_LIST);
		
		model.addAttribute("TEAM_ID", reqMap.get("TEAM_ID").toString());
		model.addAttribute("DATA",  result);
		
	}
	/**
	 * 대시보드 사인 입력
	 * @param model
	 * @throws Exception
	 */
	public void updateEQSignInfo(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		String FILE_PATH = reqMap.get("FILE_PATH").toString();
		FILE_PATH = FILE_PATH.replaceAll("/", "\\\\");
		reqMap.put("FILE_PATH",FILE_PATH);
		reqMap.put("FILE_NAME",reqMap.get("FILE_NAME")+".png");
		dashBoardDao.updateEQSignInfo(reqMap);
	}
	
	/**
	 * 대시보드 RC,LIR 저장 경로 조회
	 * @param model
	 * @throws IOException 
	 * @throws Exception
	 */
	public void getRcLirPathInfo(Model model) throws IOException {
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		Map<String,Object> returnMap = dashBoardDao.getRcLirPathInfo(reqMap);
		if(returnMap != null) {
			String lirImgInfo = returnMap.get("LIRPATH") == null ? "" : returnMap.get("LIRPATH").toString().replace(".pdf", ".png");
			if(!"".equals(lirImgInfo)) {
				File f = new File(lirImgInfo);
				
				if(!f.isFile()){//이미지 없을때 변환
					
					File pdfFile = new File(lirImgInfo.replace(".png", ".pdf"));
					
					if(pdfFile.isFile()){
						PDDocument doc = PDDocument.load(pdfFile);
						
						//파일변환
						PDFRenderer renderer = new PDFRenderer(doc);
						BufferedImage image = renderer.renderImageWithDPI(0, 200);  // 해상도 조절 150~200이 적당한듯
						File outputfile = new File(lirImgInfo);
						ImageIO.write(image, "png", outputfile);
						
						doc.close();	
					}
				}
				
				returnMap.put("LIRPATH",lirImgInfo.replace(".png", ".pdf"));
			}
			
			
			String rcImgInfo = returnMap.get("RCPATH") == null ? "" : returnMap.get("RCPATH").toString().replace(".pdf", ".png");
			if(!"".equals(rcImgInfo)) {
				File f = new File(rcImgInfo);
				
				if(!f.isFile()){//이미지 없을때 변환
					
					File pdfFile = new File(rcImgInfo.replace(".png", ".pdf"));
					
					if(pdfFile.isFile()){
						PDDocument doc = PDDocument.load(pdfFile);
						
						//파일변환
						PDFRenderer renderer = new PDFRenderer(doc);
						BufferedImage image = renderer.renderImageWithDPI(0, 200);  // 해상도 조절 150~200이 적당한듯
						File outputfile = new File(rcImgInfo);
						ImageIO.write(image, "png", outputfile);
						
						doc.close();	
					}
				}
				
				returnMap.put("RCPATH",rcImgInfo);
				
			}
		}
		reqMap.put("dashBoard","Y");
		model.addAttribute("WORKUNITLIST",codGHUnitDao.getGHUnitList(reqMap));
		model.addAttribute("IMG_INFO",returnMap);
	}

	public void deleteSignInfo(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		
		try {				
			String path = (String) reqMap.get("FILE_PATH");
			reqMap.put("pdf_path", path);
			File file = new File(path);
			if(!file.isFile()) {
				logger.debug("######################################");
				logger.debug("파일 없음!!!!!!!!!"+path);
				model.addAttribute("result","noData");
				return;
			}			
			boolean result = file.delete();
			if(result == true) {
				dashBoardDao.deleteSignInfo(reqMap);
			}
			model.addAttribute("result","success");
		} catch (Exception e) {
			e.printStackTrace();
		}	
		
		
		
		
	}

	public void getFlightInfo(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		HashMap<String,Object> resultMap = dashBoardDao.getFlightInfo(reqMap);
		model.addAttribute("FLIGHT",resultMap);
	}
	
	/**
	 * 대시보드 RC 체크리스트 저장 Json
	 * @param model,request
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class)
	public void RCCheckSave(HttpServletRequest request,Model model) {
		try {			
			HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
			logger.debug(":::::: RC CheckList 저장 ::::::"+reqMap);
			//HashMap<String, Object> map = getIdIp(request,reqMap);
			int result = dashBoardDao.RCCheckSave(reqMap);		
			logger.debug(":::::: RC CheckList 저장 ::::::"+result+reqMap);
			model.addAttribute("result",result==1?"success":"fail");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 대시보드 RC 체크리스트 데이터
	 * @param model,request
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void getRCData(HttpServletRequest request, Model model) {
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		
		String std = (String)reqMap.get("STD");
		std = std.replaceAll("[.:]","");
		std = std.replaceAll("[ ]","");

		reqMap.put("STD_RO",std);

		HashMap<String,Object> data = dashBoardDao.getRCData(reqMap);
		System.out.println("############");
		System.out.println("data :::"+data );
		model.addAttribute("DATA",data);		
		
	}

	public void getArpTeamList(Model model) {
		// TODO Auto-generated method stub
		HashMap<String,Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		model.addAttribute("DAYTEAMLIST",dashBoardDao.getArpTeamList(reqMap));
		
	}
}