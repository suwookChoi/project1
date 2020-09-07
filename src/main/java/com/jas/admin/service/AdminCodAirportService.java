package com.jas.admin.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.framework.common.view.ExcelView;
import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.dataHandler.dhtmlx.service.CommonGridDAO;
import com.framework.initialize.CodeHandler;
import com.framework.initialize.InitializeProperties;
import com.framework.security.SmartSessionHelper;
import com.framework.util.CommCodeListUtil;
import com.framework.util.FileUploadUtil;
import com.jas.admin.dao.AdminCodAirportDao;

@Service
public class AdminCodAirportService extends CommonAbstractService {

	@Autowired
	private AdminCodAirportDao adminCodAirportDao;
	
	private Logger log = Logger.getLogger(this.getClass());
	
	/**
	 *  공항 관리 메인
	 * @param model
	 * @throws Exception
	 */
	public void airportListForm(Model model, HttpServletRequest request)throws Exception {	
		
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		setMainPage(model, "COD_AIRPORT");
	}


	/**
	 *  공항 관리 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void getAirportList(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		//그리드 컬럼 정보 
		HashMap<String, Object> resultMap = setGridListParamaters(reqMap);
		//그리드 데이터
		List<HashMap<String, Object>> list = adminCodAirportDao.getAirportList(reqMap);
		
		resultMap.put("DATA_LIST", list);
		
		model.addAttribute("totalCnt", list.size());
		model.addAttribute("gridData", getGridDataJson(resultMap, false));
	}

	/**
	 * 공항 관리 생성 팝업
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void codAirportListDetailPopup(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		if(null == reqMap.get("stat") || "".equals(reqMap.get("stat"))){
			reqMap.put("stat", "create");
		}
		
		HttpSession session = request.getSession(false);
		SmartSessionHelper sHelper = new SmartSessionHelper(session);

		if("detail".equals(reqMap.get("stat"))){
			HashMap<String, Object> map = adminCodAirportDao.selectAirport(reqMap);
			model.addAttribute("airportInfo", map);
		}else{
			model.addAttribute("airportInfo", "N");
		}
		model.addAttribute("pageMap", reqMap);
	}
	/**
	 * 공항 관리 생성
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class)
	public void createAirtport(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		try {
			HashMap<String, Object> map = getIdIp(request,reqMap);
						
			int result = -1;
			List<HashMap<String, Object>> chkList = adminCodAirportDao.findAirport(map);
			
			if("create".equals(reqMap.get("stat").toString())) {
				if(0 == Integer.parseInt(String.valueOf(chkList.get(0).get("CNT")))) {
					reqMap.put("CHK", "i");
					adminCodAirportDao.createAirport(map);
					result = 1;
				}
			}else {
				reqMap.put("CHK", "u");
				adminCodAirportDao.createAirport(map);
					result = 1;
			}
			model.addAttribute("result", result == -1 ? "dup" : "success");
		} catch (Exception e) {
			model.addAttribute("result", "error");
			throw e;
		}
	}
	
	/**
	 * 공항 관리 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class)
	public void deleteAirport(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
		}
		
		int result = 0;
		
		try {
			if(null != reqMap.get("extractList") && !"".equals(reqMap.get("extractList").toString())){
				JSONObject job = (JSONObject) JSONValue.parse(reqMap.get("extractList").toString());
				Set<String> set = job.keySet();
				Iterator<String> itr = set.iterator();
				while (itr.hasNext()) {
					HashMap<String, Object> map = (HashMap<String, Object>) job.get(itr.next());
					adminCodAirportDao.deleteAirport(map);
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
