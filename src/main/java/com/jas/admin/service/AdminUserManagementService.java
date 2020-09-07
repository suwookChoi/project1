package com.jas.admin.service;

import java.io.IOException;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.framework.common.vo.CodeVO;
import com.framework.dataHandler.dhtmlx.GridHandler;
import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.encription.EncriptionManager;
import com.framework.initialize.CodeHandler;
import com.framework.initialize.InitializeProperties;
import com.framework.security.SmartSessionHelper;
import com.framework.util.CommCodeListUtil;
import com.framework.util.JsonUtil;
import com.jas.admin.dao.AdminUserManagementDao;

@Service
public class AdminUserManagementService extends CommonAbstractService{

	@Autowired
	AdminUserManagementDao admUsrMgtDao;
	private Logger log = Logger.getLogger(this.getClass());
	
	/**
	 * 사용자 관리 메인페이지
	 * 
	 * @param request
	 * @param model
	 */
	public void usrUserManagementListForm(Model model, HttpServletRequest request) throws Exception {
		setMainPage(model, "USER_LIST");
	}
	/**
	 * 사용자 관리 그리드 데이터 정보
	 * 
	 * @param request
	 * @param model
	 */
	@SuppressWarnings("unchecked")
	public void userManagementListFormJSON(Model model, HttpServletRequest request) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:" + reqMap.toString());
		}
		// 그리드 컬럼 정보
		try {
			HashMap<String, Object> resultMap = setGridListParamaters(reqMap); // 그리드 데이터
			List<HashMap<String, Object>> list = admUsrMgtDao.userManagementListForm(reqMap);
			resultMap.put("DATA_LIST", list);
			model.addAttribute("totalCnt", list.size());
			model.addAttribute("gridData", getGridDataJson(resultMap, false));
			
		} catch (Exception e) {

		}
	}
	// 관리자 사용자 비밀번호 초기화
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void JASChangePWD(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		String oldPWD = admUsrMgtDao.getOldPWD(reqMap);				
		String NEW_PWD = (String) reqMap.get("USER_ID");
		int result = 0;
		if (NEW_PWD.trim().equals(null) && NEW_PWD.trim().equals("")) {
			model.addAttribute("result", 0);
		} else {
			try {
				EncriptionManager enc = new EncriptionManager();
				String decOldPWD = enc.decryptPassword(oldPWD);
				String encPWD = enc.encryptPassword(NEW_PWD);
				reqMap.put("OLD_PWD", enc.encryptPassword(decOldPWD));
				reqMap.put("NEW_PWD", encPWD);
				result = admUsrMgtDao.JASChangePWD(reqMap);
				if (result == 1)
					model.addAttribute("result", result);
				else
					model.addAttribute("result", 0);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 사용자 회원가입 폼
	 * 
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public void JASUsrUserInfoRegisterPopup(HttpServletRequest request, Model model) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		HttpSession session = request.getSession(false);
		SmartSessionHelper sHelper = new SmartSessionHelper(session);
		// 권한리스트명 가져오기
		List<HashMap<String, Object>> rolenm =  admUsrMgtDao.getRoleList(reqMap);
		/*
		 * List<HashMap<String, Object>> arplist =
		 * admUsrMgtDao.getARPList(reqMap);
		 */
		List<CodeVO> list = getCodeVal("BRA");
		model.addAttribute("ARP", list);
		model.addAttribute("ROLE_NM", rolenm);
	}

	/**
	 * 중복 아이디 조회
	 * 
	 * @param request
	 * @param model
	 */
	@SuppressWarnings("unchecked")
	public void findUsrUserManagementId(HttpServletRequest request, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (admUsrMgtDao.findUserManagementId(reqMap) == 0 ) model.addAttribute("result", "Y");
		else model.addAttribute("result", "N");
	}

	/**
	 * 관리자 사용자회원가입 저장
	 * 
	 * @param request
	 * @param model
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor= {Exception.class})
	public void usrUserInfoRegister(HttpServletRequest req, Model model){
		try {
			
			HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
			HttpSession session = req.getSession();
			
			int usrinfont =0;
			if(session == null) return;
			else{
			
				String new_pwd = (String) reqMap.get("USER_ID");
				
				HashMap<String, Object> map = getIdIp(req,reqMap);

				EncriptionManager encriptionManager = new EncriptionManager();				
				if( new_pwd == null && ("").equals(new_pwd)) {
						model.addAttribute("result","0"); 
				}else{
				
					reqMap.put("USER_PASSWORD",encriptionManager.encryptPassword(new_pwd)); 
					usrinfont =admUsrMgtDao.userRegisterUSRINFONT(map);
					model.addAttribute("result",usrinfont);
					
				}
			
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	/**
	 * 사용자 계정 사용안함 변경
	 * 
	 * @param request
	 * @param model
	 */
	@SuppressWarnings("unchecked")
	public void JasUserAccountUseN(HttpServletRequest req, Model model) {
		try {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			
			HashMap<String, Object> map = getIdIp(req,reqMap);
						
			String type = (String)reqMap.get("USEYN");
			
			if(("Y").equals(type)) {
				model.addAttribute("result", admUsrMgtDao.userInfoDelete(map));	
			}else if( "N".equals(type)) {
				model.addAttribute("result", admUsrMgtDao.userInfoDelete(map));
			}else model.addAttribute("result", "0");
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	/**
	 * 사용자 비밀번호 변경팝업
	 * 
	 * @param request
	 * @param model
	 */
	@SuppressWarnings("unchecked")
	public void UserPasswordResetPopup(HttpServletRequest req, Model model) {
		try {
				HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
				HttpSession session = req.getSession();
				SmartSessionHelper sessionHelper = new SmartSessionHelper(session);				
				reqMap.put("userid",sessionHelper.getUserId());
				HashMap<String,Object> userInfo = admUsrMgtDao.usrUserInfoModifyPopup(reqMap);				
				EncriptionManager encriptionManager = new EncriptionManager();
				String pwd = (String)userInfo.get("USER_PASSWORD");
				String dec = encriptionManager.decryptPassword(pwd);				
				model.addAttribute("OLD_PWD", dec);				
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}

	// 사용자 비밀번호 변경Json
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public void UserPasswordResetJson(HttpServletRequest req, Model model) {
		try {
				HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
				HttpSession session = req.getSession();
				SmartSessionHelper sessionHelper = new SmartSessionHelper(session);	
				
				if(session == null) {
					model.addAttribute("result","0");			
				}else {					
					EncriptionManager encriptionManager = new EncriptionManager();
					String PASSWORD_OLD = (String) reqMap.get("OLD_PWD");
					String USER_PASSWORD = (String) reqMap.get("NEW_PASSWORD");
					String userid = sessionHelper.getUserId();
					String enc_PASSWORD_OLD = encriptionManager.encryptPassword(PASSWORD_OLD);
					String enc_USER_PASSWORD = encriptionManager.encryptPassword(USER_PASSWORD);					
					reqMap.put("userid",userid);
					reqMap.put("PASSWORD_OLD", enc_PASSWORD_OLD);
					reqMap.put("USER_PASSWORD", enc_USER_PASSWORD);
					int result = admUsrMgtDao.UserPasswordReset(reqMap);
					
					model.addAttribute("result", result);					
				}		
			} catch (Exception e) {
					e.printStackTrace();
			}	
	}
	
	/**
	 * 사용자 정보 수정 폼
	 * 
	 * @param request
	 * @param model
	 */
	@SuppressWarnings("unchecked")
	public void JasUsrInfoEditForm(Model model, HttpServletRequest request) throws Exception {
		
		model.addAttribute("arpList",getCodeVal("BRA"));//공항코드
		
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
		HttpSession session = request.getSession();
		
		String userid  = (String)request.getParameter("USER_ID");
		
		Iterator<String> it = reqMap.keySet().iterator();

		int i = admUsrMgtDao.UserIdCompare(userid);
		if(session.getAttribute("USER_SESSION") == null) return;
		else if( i==0) return;
		else {
			
			request.setCharacterEncoding("utf-8");
			String USER_ID = (String)reqMap.get("USER_ID");
			reqMap.put("userid",USER_ID);
			String mypage = (String)reqMap.get("MYPAGE");
			
			List<HashMap<String, Object>> companynm = admUsrMgtDao.getCompanyName(reqMap);
			List<HashMap<String, Object>> dept_nm = admUsrMgtDao.getDeptName(reqMap);
			List<CodeVO> job_level =  getCodeVal("JBL");
			//List<HashMap<String, Object>> job_level = admUsrMgtDao.getJobLevelList(reqMap);
			List<HashMap<String, Object>> rolenm =  admUsrMgtDao.getRoleList(reqMap);
			List<CodeVO> statusnm =  getCodeVal("USR_STATUS");
			//List<HashMap<String, Object>> statusnm =  admUsrMgtDao.getStatusList(reqMap);
			HashMap<String, Object> usrEqList=  admUsrMgtDao.getEqmList(reqMap);
			HashMap<String, Object> data = admUsrMgtDao.usrUserInfoModifyPopup(reqMap);
			
			model.addAttribute("COMPANYLIST", companynm);
			model.addAttribute("DEPTLIST", dept_nm);
			model.addAttribute("ROLE_NM", rolenm);
			model.addAttribute("USER_STATUS_NM", statusnm);
			model.addAttribute("usrEq", usrEqList);
			model.addAttribute("jobList", job_level);
			model.addAttribute("hiddenUserID", USER_ID);
			model.addAttribute("SELECTDATA",data);
			model.addAttribute("MYPAGE",mypage);
			model.addAttribute("JBP",getCodeVal("JBP"));
		}			
	}
	
	/**
	 * 지점찾기
	 * 
	 * @param request
	 * @param model
	 */
	@SuppressWarnings("unchecked")
	public void findARPJSON(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		List<HashMap<String,Object>> arpList = admUsrMgtDao.findARP(reqMap);
		
		model.addAttribute("arp",arpList);		
	}
	/**
	 * 부서찾기
	 * 
	 * @param request
	 * @param model
	 */
	@SuppressWarnings("unchecked")
	public void usrFindDepartmentJSON(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
		model.addAttribute("deptnm", admUsrMgtDao.usrFindDepartmentJSON(reqMap));
	}
	
	//사용자 정보수정 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public void UserInfoEdit(HttpServletRequest req, Model model) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		int result = 0;
		HashMap<String, Object> map = getIdIp(req,reqMap);
		
		HttpSession session = req.getSession();
				
		if(session.getAttribute("USER_SESSION") == null) model.addAttribute("result","0");
		else {

			result = admUsrMgtDao.updateUserInfo(map);
			
			model.addAttribute("result", (result > 0) ? "1" : "0");
			// 정보변경 후 세션 새로고침.
			req.getSession(true);
		}
	}
}
