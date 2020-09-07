package com.jas.admin.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.framework.common.vo.CodeVO;
import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.util.StringUtil;
import com.jas.admin.dao.AdminSpotDao;

@Service
public class AdminSpotService extends CommonAbstractService {
	@Autowired
	AdminSpotDao spotDao;
	
	private Logger log = Logger.getLogger(this.getClass());	

	
	/**
	 *  주기장 그리드
	 * @param model
	 * @throws Exception
	 */

	public void SpotListForm(HttpServletRequest req, HttpServletResponse res, Model model) {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");					
			try {
				setMainPage(model, "SPOT_LIST");
			} catch (Exception e) { 
				e.printStackTrace();
			}
	}

	/**
	 *  주기장 리스트
	 * @param model
	 * @throws Exception
	 */
	public void getGirdData(HttpServletRequest req, HttpServletResponse res, Model model) {
		try {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			if (log.isDebugEnabled()) {
				log.debug("reqMap:"+reqMap.toString());
			}		
			
			//그리드 컬럼 정보 
			HashMap<String, Object> resultMap;
			resultMap = setGridListParamaters(reqMap);	
			//그리드 데이터
			List<HashMap<String, Object>> list = spotDao.getSpotList(reqMap);
			resultMap.put("DATA_LIST", list);
			model.addAttribute("totalCnt", list.size());
			model.addAttribute("gridData", getGridDataJson(resultMap, false));
			log.debug("list:::::::::" +list);
		} catch (Exception e) {			
			e.printStackTrace();
		}		
	}

	public void JasSpotPopup(HttpServletRequest req, HttpServletResponse res, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
		String type = (String)req.getParameter("type");
		
		HashMap<String,Object> data = spotDao.getSpotData(reqMap);
		List<HashMap<String,Object>> arpList =  spotDao.getAprList();
		
		log.debug("DATA :::"+data);
		log.debug("arpList :::"+arpList);
		
		model.addAttribute("DATA", data);
		model.addAttribute("arpList", arpList);
		model.addAttribute("type", type);
	}
	public void  JasDelete(HttpServletRequest req, HttpServletResponse res, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
		int delete = spotDao.deleteSpotData(reqMap);
		model.addAttribute("result",delete);
		
	}
	public void  JasSpotSave(HttpServletRequest req, HttpServletResponse res, Model model) {
		try {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
			HashMap<String, Object> map = getIdIp(req,reqMap);
			
			int result = spotDao.saveSpotData(reqMap);
			model.addAttribute("result",result);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}

	//그리트 체크 삭제
	public void JasSpotDelete(HttpServletRequest req, HttpServletResponse res, Model model) {
		try {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			List<HashMap<String,Object>> list =StringUtil.jsonStringToList((String) reqMap.get("saveData"));
			
			int result = 0;
			for(HashMap<String,Object> map : list) {
				result =  spotDao.deleteSpotData(map);
			}			
				model.addAttribute("result",result);
			} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
