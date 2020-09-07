package com.jas.cod.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.jas.cod.dao.CodeGHUnitDao;

@Service
public class CodeGHUnitService extends CommonAbstractService {
	
	Logger log = Logger.getLogger(this.getClass());
	
	@Autowired
	CodeGHUnitDao workUnitDao;

	public void getGHUnitList(Model model) throws Exception {
		// TODO Auto-generated method stub
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		HashMap<String, Object> resultMap = setGridListParamaters(reqMap);
		List<HashMap<String, Object>> list = workUnitDao.getGHUnitList(reqMap); 
		resultMap.put("DATA_LIST", list);
		System.out.println("!!!!!!!!!!!!!!"+list);
		model.addAttribute("DATA_LIST", list);
		model.addAttribute("totalCnt", list.size());
		model.addAttribute("gridData",  getGridDataJson(resultMap, false));
	}
	
	@Transactional(rollbackFor=Exception.class)
	public void saveGHUnit(HttpServletRequest request, Model model) {
		HashMap<String,Object> reqMap = (HashMap<String,Object>) model.asMap().get("pageMap");
		JSONObject job = (JSONObject) JSONValue.parse(reqMap.get("list").toString());
		Iterator it = job.keySet().iterator();
		try {
			while(it.hasNext()) {
				String KEY = it.next().toString();

			//	HashMap<String,Object> map = (HashMap<String,Object>) job.get(it.next());
				Map<String,Object> map = new ObjectMapper().readValue(job.get(KEY).toString(), Map.class) ;
				
			//	map.put("USER_ID",user_id);
			//	map.put("USER_IP",user_ip);
				workUnitDao.insertGHUnit(map);
			}
			model.addAttribute("result","success");
		}catch(Exception e) {
			model.addAttribute("result","fail");
		}
		
	}
}
