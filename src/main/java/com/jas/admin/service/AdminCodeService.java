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
import com.jas.admin.dao.AdminCodeDao;
import com.jas.admin.dao.AdminCommonCodeDao;

@Service
public class AdminCodeService extends CommonAbstractService{

	@Autowired
	AdminCodeDao admDao;
	private Logger log = Logger.getLogger(this.getClass());
	
	/**
	 * 코드관리 메인
	 * @param model
	 * @throws Exception
	 */
	public void JasCodeListForm(HttpServletRequest req, Model model) throws Exception {			
		setMainPage(model, "COD_CODE_LIST");
	}
	/**
	 * 코드관리 리스트
	 * @param model
	 * @throws Exception
	 */
	public void JasCodeGridData(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:" + reqMap.toString());
		}
		// 그리드 컬럼 정보
		try {	
			HashMap<String, Object> resultMap = setGridListParamaters(reqMap); // 그리드 데이터
			List<HashMap<String, Object>> list = admDao.getCodeGridData(reqMap);
			resultMap.put("DATA_LIST", list);
			model.addAttribute("totalCnt", list.size());
			model.addAttribute("gridData", getGridDataJson(resultMap, false));
		} catch (Exception e) {}
	}
	/**
	 * 코드관리 수정/생성 팝업
	 * @param model
	 * @throws Exception
	 */
	public void JasCodeModify(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		String target = (String)reqMap.get("target");
		List<HashMap<String,Object>> list = admDao.getCMCCodeType(reqMap);
		
		if(("detail").equals(target)) {
			HashMap<String, Object> data= admDao.JasCodeDetailData(reqMap);	
			model.addAttribute("SELECTDATA", data);
			model.addAttribute("target", "detail");
		}else if(("new").equals(target)){
	
			model.addAttribute("target","new");
		}
		model.addAttribute("codeType",list);
	}
	/**
	 * 코드관리 수정/생성
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor= {Exception.class})
	public void codeModifySave(HttpServletRequest req, Model model) {

		try {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			String type = (String)reqMap.get("saveType");
			HttpSession session = req.getSession();
						
			HashMap<String,Object> map = getIdIp(req,reqMap);
				
			int result =0;
			
			if(session == null) return;
			else {
				if(("edit").equals(type)) {
					result = admDao.editCodeSave(map);
					model.addAttribute("result",result == 1?"success":"fail");
				}else if(("donew").equals(type)) {
					result = admDao.newCodeSave(map);
					model.addAttribute("result",result == 1?"success":"fail");
				}else
					model.addAttribute("result", "fail");
			}	
		} catch (Exception e) {

			e.printStackTrace();
		}
	}
	
	/**
	 * 코드 관리 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor= {Exception.class})
	public void codeDelete(HttpServletRequest req, Model model) {
		try {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			List<HashMap<String,Object>> list =StringUtil.jsonStringToList((String) reqMap.get("saveData"));
			int result = 0;
			for(HashMap<String,Object> map : list) {
				result = admDao.codeDelete(map);
			}			
				model.addAttribute("result", result ==1?"success":"fail" );
			} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void CodeIdCheck(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		int count = admDao.checkCodeId(reqMap);
		model.addAttribute("result", count);
		
	}	
}
