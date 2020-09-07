package com.jas.flt.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.Model;

import com.jas.flt.dao.FltSfsDao;
import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.security.SmartSessionHelper;

@Service
public class FltSfsService extends CommonAbstractService {
	
	@Autowired
	private FltSfsDao fltSfsDao;
	
	private Logger log = Logger.getLogger(this.getClass());
	
	HashMap<String, Object> sfsCommMap = new HashMap<String, Object>();
	
	/** Transaction 처리를 위한 Resource 설정 시작 **/
	@Resource(name = "transactionManager")
	protected DataSourceTransactionManager txManager;
	
	protected TransactionStatus getTransaction() {
		DefaultTransactionDefinition definition = new DefaultTransactionDefinition();
		definition.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		return txManager.getTransaction(definition);
	}
	
	/** Transaction 처리를 위한 Resource 설정 끝 **/
	
	/**
	 * 시즌 스케줄 현황 화면
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void sfsListForm(Model model, HttpServletRequest request)throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		List<HashMap<String, Object>> sfsntList = fltSfsDao.getSSCInfo(reqMap);
		model.addAttribute("sfsntList", sfsntList);
		
		List<HashMap<String, Object>> revList = fltSfsDao.getRevisionInfo(reqMap);
		
		model.addAttribute("revision", revList);
		
		setMainPage(model, "SFS_SKD_LIST");
	}
	
	/**
	 * 시즌 스케줄 현황 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void getSfsList(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		HashMap<String, Object> resultMap = setGridListParamaters(reqMap);
		List<HashMap<String, Object>> list = fltSfsDao.getSfsList(reqMap);
		HashMap<String, Object> sfsMap = new HashMap<String, Object>();
		List<HashMap<String, Object>> lastList = new ArrayList<HashMap<String, Object>>();
		
		for(int i=0; i<list.size(); i++){
			sfsMap = list.get(i);
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			
			HashMap<String, Object> stutc = new HashMap<String, Object>();
			stutc.put("SYMD", sfsMap.get("SSD"));
			stutc.put("SHM", sfsMap.get("STDUTC"));
			stutc.put("ARP", sfsMap.get("ORG"));
			
			HashMap<String, Object> ssdMap = fltSfsDao.UtcToLocalSSC(stutc);
			String SSDLOC = "";
			if(ssdMap != null) {
				SSDLOC = ssdMap.get("UTCTOLOC").toString();
			}else {
				SSDLOC = sfsMap.get("SSD").toString();
			}
			
			stutc.put("SYMD", sfsMap.get("SED"));
			stutc.put("SHM", sfsMap.get("STAUTC"));
			stutc.put("ARP", sfsMap.get("ORG"));
			
			HashMap<String, Object> sedMap = fltSfsDao.UtcToLocalSSC(stutc);
			String SEDLOC = "";
			if(sedMap != null) {
				SEDLOC = sedMap.get("UTCTOLOC").toString();
			}else {
				SEDLOC = sfsMap.get("SED").toString();
			}
			
			Date startDate = sdf.parse(SSDLOC);
			Date endDate = sdf.parse(sfsMap.get("SSD").toString());
			
			long diffDay = (startDate.getTime() - endDate.getTime()) / (24*60*60*1000);
			
			sfsMap.put("SSDLOC", SSDLOC);
			sfsMap.put("SEDLOC", SEDLOC);
			
			HashMap<String, Object> weekMap = new HashMap<String, Object>();
			weekMap = diffWEEK(diffDay, sfsMap);
			sfsMap.put("WMON", weekMap.get("MON"));
			sfsMap.put("WTUE", weekMap.get("TUE"));
			sfsMap.put("WWED", weekMap.get("WED"));
			sfsMap.put("WTHU", weekMap.get("THU"));
			sfsMap.put("WFRI", weekMap.get("FRI"));
			sfsMap.put("WSAT", weekMap.get("SAT"));
			sfsMap.put("WSUN", weekMap.get("SUN"));
			
			lastList.add(sfsMap);
		}
		
		resultMap.put("DATA_LIST", lastList);
		
		model.addAttribute("totalCnt", list.size());
		model.addAttribute("gridData", getGridDataJson(resultMap, false));
	}
	
	/**
	 * 시즌 스케줄 신규/상세
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void sfsSchedulePopup(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		if(null == reqMap.get("stat") || "".equals(reqMap.get("stat"))){
			reqMap.put("stat", "create");
		}
		
		List<HashMap<String, Object>> sfsntList = fltSfsDao.getSSCInfo(reqMap);
		model.addAttribute("sfsntList", sfsntList);
		
		List<HashMap<String, Object>> revList = fltSfsDao.getRevisionInfo(reqMap);
		model.addAttribute("revision", revList);
		
		List<HashMap<String, Object>> flcList = fltSfsDao.getFlcInfo(reqMap);
		model.addAttribute("flcList", flcList);
		
		List<HashMap<String, Object>> arpList = fltSfsDao.getArpInfo(reqMap);
		model.addAttribute("arpList", arpList);
		
		model.addAttribute("fstList", getCodeVal("FST"));
		model.addAttribute("airsubList", getCodeVal("ASP"));
		
		if("detail".equals(reqMap.get("stat"))){
			HashMap<String, Object> map = fltSfsDao.selectSfsInfo(reqMap);
			model.addAttribute("sfsinfo", map);
		}else{
			model.addAttribute("sfsinfo", "N");
		}
		
		model.addAttribute("pageMap", reqMap);
	}
	
	/**
	 * 시즌 스케줄 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void detailSfsSchedule(Model model, HttpServletRequest request)throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> SFS_DATA = fltSfsDao.selectSfsInfo(reqMap);
		
		result.put("SFS_DATA",SFS_DATA);
		
		model.addAttribute("DATA",  result);  
		
	}
	
	/**
	 * 시즌 스케줄 신규/상세
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class)
	public void upsertSfsSchedule(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		HttpSession session = request.getSession(false);
		SmartSessionHelper sHelper = new SmartSessionHelper(session);
		reqMap.put("USER_ID", sHelper.getUserId());
		reqMap.put("USER_IP", sHelper.getLoginIp());
		
		try {
			int result = -1;
			for (int i = 0; i < 1; i++) {
				List<HashMap<String, Object>> chkList = fltSfsDao.findSfsSchedule(reqMap);
				
				if("create".equals(reqMap.get("stat").toString()) && 0 != Integer.parseInt(String.valueOf(chkList.get(0).get("CNT")))) {
					continue;
				}
				
				HashMap<String, Object> stutc = new HashMap<String, Object>();
				HashMap<String, Object> ssedutc = new HashMap<String, Object>();
				HashMap<String, Object> stdutc = new HashMap<String, Object>();
				HashMap<String, Object> sfsMap = reqMap;
				HashMap<String, Object> weekMap = new HashMap<String, Object>();
				
				if("create".equals(reqMap.get("stat").toString())) {
					sfsMap.put("CHK", "i");
				}else {
					sfsMap.put("CHK", "u");
				}
				
				//ssd local->utc
				stutc.put("SYMD", reqMap.get("SSD"));
				stutc.put("SHM", reqMap.get("STD"));
				stutc.put("ARP", reqMap.get("ORG"));
				ssedutc = fltSfsDao.LocalToUtcSSC(stutc);
				sfsMap.put("SSDUTC", ssedutc.get("LOCTOUTC").toString().substring(0, 8));
				
				//sed local->utc
				stutc.put("SYMD", reqMap.get("SED"));
				stutc.put("SHM", reqMap.get("STA"));
				stutc.put("ARP", reqMap.get("ORG"));
				ssedutc = fltSfsDao.LocalToUtcSSC(stutc);
				sfsMap.put("SEDUTC", ssedutc.get("LOCTOUTC").toString().substring(0, 8));
				
				//std local->utc
				stutc.put("STDA", reqMap.get("STD"));
				stutc.put("ARP", reqMap.get("ORG"));
				stdutc = fltSfsDao.LocalToUtcST(stutc);
				sfsMap.put("STDUTC", stdutc.get("LOCTOUTC").toString());
				
				//sta local->utc
				stutc.put("STDA", reqMap.get("STA"));
				stutc.put("ARP", reqMap.get("DES"));
				stdutc = fltSfsDao.LocalToUtcST(stutc);
				sfsMap.put("STAUTC", stdutc.get("LOCTOUTC").toString());
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
				
				Date startDate = sdf.parse(sfsMap.get("SSDUTC").toString());
				Date endDate = sdf.parse(sfsMap.get("SSD").toString());
				
				long diffDay = (startDate.getTime() - endDate.getTime()) / (24*60*60*1000);
				
				weekMap = diffWEEK(diffDay, reqMap);
				sfsMap.put("MON", weekMap.get("MON"));
				sfsMap.put("TUE", weekMap.get("TUE"));
				sfsMap.put("WED", weekMap.get("WED"));
				sfsMap.put("THU", weekMap.get("THU"));
				sfsMap.put("FRI", weekMap.get("FRI"));
				sfsMap.put("SAT", weekMap.get("SAT"));
				sfsMap.put("SUN", weekMap.get("SUN"));
				
				fltSfsDao.createSfsSchedule(sfsMap);
				result = 1;
			}
			model.addAttribute("result", result == -1 ? "dup" : "success");
			
		} catch (Exception e) {
			model.addAttribute("result", "error");
			throw e;
		}
	}
	
	/**
	 * UTC to Local
	 * @param model
	 * @throws Exception
	 */
	public HashMap<String, Object> diffWEEK(long diffDay, HashMap<String, Object> reqMap) throws Exception {
		HashMap<String, Object> sfsMap = new HashMap<String, Object>();
		
		sfsMap.put("MON", "N");
		sfsMap.put("TUE", "N");
		sfsMap.put("WED", "N");
		sfsMap.put("THU", "N");
		sfsMap.put("FRI", "N");
		sfsMap.put("SAT", "N");
		sfsMap.put("SUN", "N");
		
		if(diffDay == -1) {
			if("Y".equals(reqMap.get("MON").toString())) {
				sfsMap.put("SUN", "Y");
			}
			if("Y".equals(reqMap.get("TUE").toString())) {
				sfsMap.put("MON", "Y");
			}
			if("Y".equals(reqMap.get("WED").toString())) {
				sfsMap.put("TUE", "Y");
			}
			if("Y".equals(reqMap.get("THU").toString())) {
				sfsMap.put("WED", "Y");
			}
			if("Y".equals(reqMap.get("FRI").toString())) {
				sfsMap.put("THU", "Y");
			}
			if("Y".equals(reqMap.get("SAT").toString())) {
				sfsMap.put("FRI", "Y");
			}
			if("Y".equals(reqMap.get("SUN").toString())) {
				sfsMap.put("SAT", "Y");
			}
		}else if(diffDay == 1) {
			if("Y".equals(reqMap.get("MON").toString())) {
				sfsMap.put("TUE", "Y");
			}
			if("Y".equals(reqMap.get("TUE").toString())) {
				sfsMap.put("WED", "Y");
			}
			if("Y".equals(reqMap.get("WED").toString())) {
				sfsMap.put("THU", "Y");
			}
			if("Y".equals(reqMap.get("THU").toString())) {
				sfsMap.put("FRI", "Y");
			}
			if("Y".equals(reqMap.get("FRI").toString())) {
				sfsMap.put("SAT", "Y");
			}
			if("Y".equals(reqMap.get("SAT").toString())) {
				sfsMap.put("SUN", "Y");
			}
			if("Y".equals(reqMap.get("SUN").toString())) {
				sfsMap.put("MON", "Y");
			}
		}else {
			if("Y".equals(reqMap.get("MON").toString())) {
				sfsMap.put("MON", "Y");
			}
			if("Y".equals(reqMap.get("TUE").toString())) {
				sfsMap.put("TUE", "Y");
			}
			if("Y".equals(reqMap.get("WED").toString())) {
				sfsMap.put("WED", "Y");
			}
			if("Y".equals(reqMap.get("THU").toString())) {
				sfsMap.put("THU", "Y");
			}
			if("Y".equals(reqMap.get("FRI").toString())) {
				sfsMap.put("FRI", "Y");
			}
			if("Y".equals(reqMap.get("SAT").toString())) {
				sfsMap.put("SAT", "Y");
			}
			if("Y".equals(reqMap.get("SUN").toString())) {
				sfsMap.put("SUN", "Y");
			}
		}
		
		return sfsMap;
	}
	
	/**
	 * 시즌 스케줄 삭제
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class)
	public void deleteSfsList(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		int result = 0;
		
		try {
			HttpSession session = request.getSession(false);
			SmartSessionHelper sHelper = new SmartSessionHelper(session);
			reqMap.put("FRST_REG_ID", sHelper.getUserId());
			reqMap.put("FRST_REG_IP", sHelper.getLoginIp());
			
			if(null != reqMap.get("extractList") && !"".equals(reqMap.get("extractList").toString())){
				JSONObject job = (JSONObject) JSONValue.parse(reqMap.get("extractList").toString());
				Set<String> set = job.keySet();
				Iterator<String> itr = set.iterator();
				while (itr.hasNext()) {
					HashMap<String, Object> map = (HashMap<String, Object>) job.get(itr.next());
					map.put("FRST_REG_ID", sHelper.getUserId());
					map.put("FRST_REG_IP", sHelper.getUserId());
					map.put("ARP", sHelper.getSelectedArp());
					
					fltSfsDao.deleteSfsList(map);
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

