package com.jas.main.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.Model;

import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.security.SmartSessionHelper;
import com.jas.main.dao.MainRcDao;

@Service
public class MainRcService extends CommonAbstractService{

	@Autowired
	MainRcDao mrDao;
	
	private Logger log = Logger.getLogger(this.getClass());
	
	/** Transaction 처리를 위한 Resource 설정 시작 **/
	@Resource(name = "transactionManager")
	protected DataSourceTransactionManager txManager;	
	protected TransactionStatus getTransaction() {
		DefaultTransactionDefinition definition = new DefaultTransactionDefinition();
		definition.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		return txManager.getTransaction(definition);
	}
	public void getRcData(HttpServletRequest request, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:" + reqMap.toString());
		}
//		String sdt = (String)reqMap.get("SDT");
//		String sta = (String)reqMap.get("STA");
//		String arp = (String)reqMap.get("ARP");
//		String flt = (String)reqMap.get("FLT");
//			
		HashMap<String,Object> data = mrDao.getRCData(reqMap);
//		data.put("SDT", sdt);
//		data.put("STA", sta);
//		data.put("ARP", arp);
//		data.put("FLT", flt);
		model.addAttribute("DATA",data);
	}
	public void rcSave(HttpServletRequest request, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		int result =0;
		
		
		HttpSession session = request.getSession(false);
		SmartSessionHelper sHelper = new SmartSessionHelper(session);
		reqMap.put("LAST_MOD_ID", sHelper.getUserId());
		reqMap.put("LAST_MOD_IP", sHelper.getLoginIp());
		
		Calendar calendar = Calendar.getInstance();
        java.util.Date date = calendar.getTime();
        String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
        reqMap.put("LAST_MOD_DT", today);
        
        result = mrDao.saveRc(reqMap);
        
		model.addAttribute("result",result == 1? "success":"fail");
	}	
	
}
