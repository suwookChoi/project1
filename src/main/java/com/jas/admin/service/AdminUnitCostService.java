package com.jas.admin.service;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.security.SmartSessionHelper;
import com.framework.util.StringUtil;
import com.jas.admin.dao.AdminGroupDao;
import com.jas.admin.dao.AdminUnitCostcDao;


@Service
public class AdminUnitCostService extends CommonAbstractService{

		@Autowired
		AdminUnitCostcDao admCost;
		AdminGroupDao agdao;
		private Logger log = Logger.getLogger(this.getClass());		
		/**
		 * 기본 조업요율 메인
		 * @param model
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		public void JasCodeListForm(HttpServletRequest req, Model model) throws Exception {	
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			setMainPage(model, "UCR_LIST");
			List<HashMap<String,Object>> list = admCost.getSearchDateData(reqMap);
			model.addAttribute("getSearchAirCraftData",admCost.getSearchAirCraftData(reqMap));
			model.addAttribute("getSearchDateData_MIN",list.get(0).get("MIN_YEAR"));
			model.addAttribute("getSearchDateData_MAX",list.get(0).get("MAX_YEAR"));
			
			SimpleDateFormat dateFormatGmt1 = new SimpleDateFormat("yyyy");
			dateFormatGmt1.setTimeZone(TimeZone.getTimeZone("GMT+9"));
			SimpleDateFormat dateFormatGmt2 = new SimpleDateFormat("MM");
			dateFormatGmt2.setTimeZone(TimeZone.getTimeZone("GMT+9"));
			reqMap.put("searchYear", dateFormatGmt1.format(new Date()).toString());
			reqMap.put("searchMonth",dateFormatGmt2.format(new Date()).toString());
			//reqMap.put("searchYear", new SimpleDateFormat("yyyy").format(new Date()).toString());
			//reqMap.put("searchMonth", new SimpleDateFormat("MM").format(new Date()).toString());
			
			
			model.addAttribute("getSearchARPData", admCost.getSearchARPData(reqMap));
			model.addAttribute("arpList", getCodeVal("BRA"));
		}

		/**
		 * 기본 조업요율 리스트
		 * @param model
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		public void getUnitCostGridData(HttpServletRequest req, Model model) throws Exception {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			// 그리드 컬럼 정보
			DecimalFormat df = new DecimalFormat("#,###");
			HashMap<String, Object> resultMap = setGridListParamaters(reqMap);
			List<HashMap<String, Object>> result1 = admCost.getUnitCostList(reqMap);
			List<HashMap<String, Object>> result2 = new ArrayList<HashMap<String, Object>>();
			int i=0;
			for(HashMap<String,Object> cellCount : result1) {				
				
				String startDate = result1.get(i).get("START_DT").toString();
				String endDate = result1.get(i).get("END_DT").toString();
				cellCount.put("START_DT", startDate);
				int yyyy = Integer.parseInt(startDate.substring(0, 4));
				int mm = Integer.parseInt(startDate.substring(5,7));
				cellCount.put("START_DT_YY", yyyy);
				cellCount.put("START_DT_MM",mm);				
				cellCount.put("END_DT", endDate);
				int endYy = Integer.parseInt(endDate.substring(0, 4));
				int endMm = Integer.parseInt(endDate.substring(5,7));
				cellCount.put("END_DT_YY", endYy);
				cellCount.put("END_DT_MM",endMm);
				
				String money = df.format( Integer.parseInt((String) result1.get(i).get("COSTRATES") )  ).toString();
				money = ("￦").concat(money);
				cellCount.put("COSTRATES",money);			
				cellCount.put("ARP_NM", result1.get(i).get("ARP_NM"));
				cellCount.put("ARP", result1.get(i).get("ARP"));
				cellCount.put("AIRCRAFT", result1.get(i).get("AIRCRAFT"));
				cellCount.put("BLANK", i + 1);
				result2.add(cellCount);
				i++;			
			}
			resultMap.put("DATA_LIST", result2);
			model.addAttribute("count", result1.size());
			model.addAttribute("rows", result2);
			model.addAttribute("gridData", getGridDataJson(resultMap, false));			
		}

		/**
		 * 기본 조업요율 수정/생성 팝업
		 * @param model
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		public void UnitCostDetailPopup(HttpServletRequest req, Model model) throws Exception {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			String type = (String)reqMap.get("subType");
			
			List<HashMap<String,Object>>list = admCost.UnitCostFindAIR(reqMap);
			
			
			model.addAttribute("list",list );	
			model.addAttribute("ghlist", getCodeVal("UCR"));	
			model.addAttribute("arpList", getCodeVal("BRA"));
			model.addAttribute("subType",type);
			model.addAttribute("arpnm",admCost.getSearchARPData(reqMap));
			model.addAttribute("getDetailData",admCost.geUnitCosttDetailData(reqMap));		
		}
		/**
		 * 기본 조업요율 수정/생성
		 * @param model
		 * @throws Exception
		 */
		@SuppressWarnings({ "unchecked"})
		@Transactional(rollbackFor=Exception.class)
		public void UnitCostSave(HttpServletRequest req, Model model) {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			int result = 0;
			HttpSession session = req.getSession();
			SmartSessionHelper sessionHelper = new SmartSessionHelper(session);
			
			String userid = (String)sessionHelper.getUserId();
			String ip =(String)sessionHelper.getLoginIp();
			
			//저장 전 확인
			int n = admCost.checkData(reqMap);
			String type = (String) reqMap.get("subType");
						
			if(ip == null) {
				return;
			}else {
				if(n == 0) {
					if(("detail").equals(type)) {
						admCost.orgDeleteUnitCost(reqMap);
					
						reqMap.put("LAST_MOD_ID", userid);
						reqMap.put("LAST_MOD_IP",ip);
						result = admCost.NewUnitCostSave(reqMap);
						
						}else if(("new").equals(type)){
						reqMap.put("FRST_REG_ID", userid);
						reqMap.put("FRST_REG_IP",ip);
						result =admCost.NewUnitCostSave(reqMap);
					}else {
						return;
					}								
				}else {
					if(("detail").equals(type)) {
						admCost.orgDeleteUnitCost(reqMap);
						reqMap.put("LAST_MOD_ID", userid);
						reqMap.put("LAST_MOD_IP",ip);
						result = admCost.NewUnitCostSave(reqMap);						
						}else if(("new").equals(type)){
							model.addAttribute("result","duplication");
							return;		
						}
					}						
				model.addAttribute("result",result == 1?"success":"fail");
				return;
			}
		}
		
		/**
		 * 기본 조업요율 삭제
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		@Transactional(rollbackFor=Exception.class)
		public void deleteunitCost(HttpServletRequest req, Model model) {
			try {
				HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
				List<HashMap<String, Object>> paramList = StringUtil.jsonStringToList((String) reqMap.get("saveData"));			
				int result = 0;  
				for(HashMap<String,Object> map : paramList) {
					result = admCost.deleteunitCost(map);
				}
				model.addAttribute("result",result == 1?"success":"fail");			
			}catch (Exception e) {
				e.printStackTrace();
			}
		}

		/**
		 * 기본 조업요율 팝업 ARP 리스트
		 * @param model
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		public void UnitCostFindARP(HttpServletRequest req, Model model) {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");			
			String arp = (String)reqMap.get("ARP");
			List<HashMap<String,Object>>list = admCost.getArpList();
			
			String getArp ="";
			String arp_nm=""; 
			for(HashMap<String,Object> map : list) {
				getArp = (String) map.get("ARP");
				if((arp).equals(getArp)) {
					arp_nm = (String)map.get("ARP_NM");
				}				
			}
		model.addAttribute("ARP_NM", arp_nm);
	}
}
