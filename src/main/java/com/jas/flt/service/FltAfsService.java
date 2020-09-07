package com.jas.flt.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.Model;

import com.jas.flt.dao.FltAfsDao;
import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;

@Service
public class FltAfsService extends CommonAbstractService {
	
	@Autowired
	private FltAfsDao fltAfsDao;
	
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
	 * 일일 스케줄 현황 화면 
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void afsListForm(Model model, HttpServletRequest request)throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		
		model.addAttribute("ArpList", getCodeVal("BRA"));
		SimpleDateFormat dateFormatGmt = new SimpleDateFormat("yyyy.MM.dd");
		dateFormatGmt.setTimeZone(TimeZone.getTimeZone("GMT+9"));
		reqMap.put("searchDate", dateFormatGmt.format(new Date()).toString());
		//reqMap.put("searchDate", new SimpleDateFormat("yyyy.MM.dd").format(new Date()).toString());
		
		setMainPage(model, "AFS_SKD_LIST");
	}
	
	/**
	 * 일일 스케줄 현황 리스트 조회 
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void getAfsList(Model model, HttpServletRequest request) throws Exception {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:"+reqMap.toString());
		}
		
		HashMap<String, Object> resultMap = setGridListParamaters(reqMap);
		List<HashMap<String, Object>> list = fltAfsDao.getAfsList(reqMap);
		HashMap<String, Object> afsMap = new HashMap<String, Object>();
		
		int pax = 0;
		int cgo = 0;
		int jja = 0;
		int oal = 0;
		
		for(int i=0; i<list.size(); i++){
			afsMap = list.get(i);
			
			if("PAX".equals(afsMap.get("FLX"))) {
				pax++;
			}
			if("CGO".equals(afsMap.get("FLX"))) {
				cgo++;
			}
			if("7C".equals(afsMap.get("FLC"))) {
				jja++;
			}
			if(!"7C".equals(afsMap.get("FLC"))) {
				oal++;
			}
		}
		
		resultMap.put("DATA_LIST", list);
		
		model.addAttribute("paxCnt", pax);
		model.addAttribute("cgoCnt", cgo);
		model.addAttribute("jjaCnt", jja);
		model.addAttribute("oalCnt", oal);
		model.addAttribute("totalCnt", list.size());
		model.addAttribute("gridData", getGridDataJsonASC(resultMap, false));
	}
	
}

