package com.jas.cod.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.security.SmartSessionHelper;
import com.jas.cod.dao.CodeCommonGHUnitDao;

@Service
public class CodeCommonGHUnitService extends CommonAbstractService {
	
	Logger log = Logger.getLogger(this.getClass());
	
	@Autowired
	CodeCommonGHUnitDao workUnitComDao;
	
	public void commonForm(Model model,HttpServletRequest request) throws Exception{
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		HttpSession session = request.getSession(false);
		SmartSessionHelper sessionHelper = new SmartSessionHelper(session);
		if(session != null) {
			model.addAttribute("USER_ID", sessionHelper.getUserId());
			model.addAttribute("ROLE_ID", sessionHelper.getRoleId());
			model.addAttribute("FRST_REG_ID", sessionHelper.getUserId());
			model.addAttribute("FRST_REG_IP", sessionHelper.getLoginIp());
			model.addAttribute("ARP", sessionHelper.getSelectedArp());
			}
		
	}
	
	public void getCommonGHUnitList(Model model) throws Exception {
		// TODO Auto-generated method stub
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		HashMap<String, Object> resultMap = setGridListParamaters(reqMap);
		Iterator it = reqMap.keySet().iterator();
		while(it.hasNext()) {
			String KEY = it.next().toString();
		}
		
		
		List<HashMap<String, Object>> list = workUnitComDao.getCommonGHUnitList(reqMap); 
		resultMap.put("DATA_LIST", list);
		model.addAttribute("totalCnt", list.size());
		model.addAttribute("gridData",  getGridDataJson(resultMap, false));
	}

	public void getCommonGHUnitCheckID(HttpServletRequest request, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		String unit_id = workUnitComDao.getCommonGHUnitCheckID(reqMap);
		String result = "";
		if(!"".equals(unit_id) && unit_id != null) {
			result = "duplicated";
		}else result = "OK";
		model.addAttribute("result", result);
		
	}

	public void saveCommonGHUnit(HttpServletRequest request, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		int res = workUnitComDao.saveCommonGHUnit(reqMap);
		String result = "";
		if(res>0) {
			result ="success";
		}else result ="fail";
		
		model.addAttribute("result", result);
	}
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class)
	public void deleteCommonGHUnit(HttpServletRequest request, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		/*
		 * String result = ""; if("".equals(reqMap.get("UNIT_ID")) ||
		 * reqMap.get("UNIT_ID")==null){ result = "fail"; }else {
		 * workUnitComDao.deleteCommonGHUnit(reqMap); } result ="success";
		 * model.addAttribute("result",result);
		 */
		int result = 0;
		try {
			if(null != reqMap.get("extractList") && !"".equals(reqMap.get("extractList").toString())){
				JSONObject job = (JSONObject) JSONValue.parse(reqMap.get("extractList").toString());
				Set<String> set = job.keySet();
				Iterator<String> itr = set.iterator();
				while (itr.hasNext()) {
					HashMap<String, Object> map = (HashMap<String, Object>) job.get(itr.next());
					workUnitComDao.deleteCommonGHUnit(map);
					workUnitComDao.deleteGHUnit(map);
				}
				result = 1;
			}
			
			model.addAttribute("result", (result > 0)?"success":"fail");
		} catch (Exception e) {
			model.addAttribute("result", "error");
			throw e;
		}
		

	}
}
