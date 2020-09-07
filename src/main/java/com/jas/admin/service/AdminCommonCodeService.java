package com.jas.admin.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.security.SmartSessionHelper;
import com.framework.util.StringUtil;
import com.jas.admin.dao.AdminCommonCodeDao;

@Service
public class AdminCommonCodeService extends CommonAbstractService{

	@Autowired
	AdminCommonCodeDao admCmcDao;
	private Logger log = Logger.getLogger(this.getClass());
	
	/**
	 * 공통코드관리 메인
	 * @param model
	 * @throws Exception
	 */
	public void JasCommonCodeListForm(HttpServletRequest req, Model model) {
		HttpSession session = req.getSession();
		SmartSessionHelper sHelper = new SmartSessionHelper(session);
		String role = (String) sHelper.getUserInfo("ROLE_ID");
		
		try {
			model.addAttribute("ROLEID", role);
			setMainPage(model, "COD_COMMON_CODE_LIST");
		} catch (Exception e) {			
			e.printStackTrace();
		}		
	}
	/**
	 * 공통코드관리 리스트
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void JasCommonCodeListJson(HttpServletRequest req, Model model) throws Exception {
			
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			if (log.isDebugEnabled()) {
				log.debug("reqMap:" + reqMap.toString());
			}
			// 그리드 컬럼 정보
			HashMap<String, Object> resultMap = setGridListParamaters(reqMap); // 그리드 데이터
			List<HashMap<String, Object>> list = admCmcDao.getCommonCodeList(reqMap);
			
			resultMap.put("DATA_LIST", list);
			model.addAttribute("totalCnt", list.size());
			model.addAttribute("gridData", getGridDataJson(resultMap, false));
	}
	/**
	 * 공통코드관리 수정/생성 팝업
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void JasCommonCodeModify(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		String donew = (String) reqMap.get("target");
		if(donew.equals("detail")) {
			HashMap<String, Object> SELECTDATA = (HashMap<String, Object>) admCmcDao.JasCommonCodeModify(reqMap);
			model.addAttribute("SELECTDATA",SELECTDATA);
			model.addAttribute("type", "detail");
		}else if(donew.equals("new")){
			model.addAttribute("type", "new");
		}
	}
	/**
	 * 공통코드관리 수정/생성
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void JascommonCodeModifySave(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}				
		HttpSession session = req.getSession(false);
		SmartSessionHelper sHelper = new SmartSessionHelper(session);	
		int result =0;
		String saveType = (String)reqMap.get("saveType");	
		reqMap.put("LAST_MOD_ID", sHelper.getUserId());
		reqMap.put("LAST_MOD_IP", sHelper.getLoginIp());
		reqMap.put("FRST_REG_ID", sHelper.getUserId());
		reqMap.put("FRST_REG_IP", sHelper.getLoginIp());
		
		if(saveType.equals("detail")) {		
			result = admCmcDao.commonCodeModifySave(reqMap);
			model.addAttribute("result", (result > 0)?"success":"fail");	
			String useyn = (String) reqMap.get("USE_YN");
		}else if(saveType.equals("new")) {
			result = admCmcDao.commonCodeNewSave(reqMap);
			model.addAttribute("result", (result > 0)?"success":"fail");	
		}else {
			model.addAttribute("result","0");
		}
		
	}
	/**
	 * 공통코드 ID 중복검사
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void CommoneCodeIdCheck(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		int result = admCmcDao.CommoneCodeIdCheck(reqMap);
		model.addAttribute("result", result);		
	}	
	/**
	 * 공통코드 관리 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void JasCommonCodeDelete(HttpServletRequest req, Model model) {
		try {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			if (log.isDebugEnabled()) {
				log.debug("reqMap:"+reqMap.toString());
			}					
			int result =0;
			int result2 =0;
			List<HashMap<String,Object>> list = StringUtil.jsonStringToList((String)reqMap.get("saveData"));
			for(HashMap<String,Object> map : list) {
				result = admCmcDao.commonCodeDelete(map);
				// 공통코드 삭제 시 코드 USE_YN 'N'으로 변경
				result2=admCmcDao.changCodeUseYn(map);
			}			
			model.addAttribute("result",result == 1?"success":"fail");
		} catch (Exception e) {		
			log.debug("AdminCommonController : 코드 삭제 실패!!");			
			e.printStackTrace();
		}
	}

}
