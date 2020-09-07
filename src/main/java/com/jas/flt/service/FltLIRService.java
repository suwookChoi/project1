package com.jas.flt.service;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.ws.rs.Produces;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.Model;

import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.security.SmartSessionHelper;
import com.framework.util.DateUtil;
import com.framework.util.FileUploadUtil;
import com.jas.admin.dao.AdminUnitCostcDao;
import com.jas.flt.dao.FltLIRDao;

@Service
public class FltLIRService extends CommonAbstractService{

	@Autowired
	FltLIRDao lirdao;
	@Autowired
	AdminUnitCostcDao admCost;
	
	private Logger log = Logger.getLogger(this.getClass());
	
	/** Transaction 처리를 위한 Resource 설정 시작 **/
	@Resource(name = "transactionManager")
	protected DataSourceTransactionManager txManager;	
	protected TransactionStatus getTransaction() {
		DefaultTransactionDefinition definition = new DefaultTransactionDefinition();
		definition.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		return txManager.getTransaction(definition);
	}	
	
	/**
	 *  LIR 관리 메인
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void LIRList(HttpServletRequest req, Model model) {
		try {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			SimpleDateFormat dateFormatGmt = new SimpleDateFormat("yyyy.MM.dd");
			dateFormatGmt.setTimeZone(TimeZone.getTimeZone("GMT+9"));
			reqMap.put("searchDate", dateFormatGmt.format(new Date()).toString());
			//reqMap.put("searchDate", new SimpleDateFormat("yyyy.MM.dd").format(new Date()).toString());
			List<HashMap<String,Object>> flcList = lirdao.getFlcList();
			model.addAttribute("flcList", flcList);			
			model.addAttribute("arpList", getCodeVal("BRA"));
			setMainPage(model, "LIR_LIST");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 *  LIR 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void getLIRListData(HttpServletRequest req, Model model) {
		
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:" + reqMap.toString());
		}
		// 그리드 컬럼 정보
		try {
			HashMap<String, Object> resultMap = setGridListParamaters("LIR_LIST"); // 그리드 데이터
			List<HashMap<String,Object>> lirList = lirdao.getLIRList(reqMap);
			resultMap.put("DATA_LIST", lirList);
			model.addAttribute("totalCnt", lirList.size());
			model.addAttribute("gridData", getGridDataJson(resultMap, false));
		} catch (Exception e) {
			e.printStackTrace();
		}
		

	}

	/**
	 *  LIR PDF 파일 업로드
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Produces("text/html")
	@Transactional(rollbackFor=Exception.class)
	public JSONObject uploadPDFFile(HttpServletRequest request, Model model) {
		JSONObject jobj = new JSONObject();
		
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		HashMap<String, Object> fileInfo = new HashMap<String, Object>();
		
		try {
			
			//임시 저장시 파일경로 지정 X
			fileInfo.put(FileUploadUtil.KEY_INPUTFILE_NAME,   reqMap.get("INPUTFILE_NAME").toString());
			fileInfo.put(FileUploadUtil.KEY_TARGET_PATH, "/upload/temp/" +reqMap.get("FILE_NAME_PREFIX").toString()+"/"+(String)DateUtil.getFormatString("yyyyMMdd"));
			fileInfo.put(FileUploadUtil.KEY_FILE_NAME_PREFIX, reqMap.get("FILE_NAME_PREFIX").toString());
			
			HashMap<String, Object> resultMap = FileUploadUtil.fileUpload(request, fileInfo, false, false);
			
			jobj.put("RESULT", resultMap.get(FileUploadUtil.KEY_REULST).toString());
			
			if("SUCCESS".equals(resultMap.get(FileUploadUtil.KEY_REULST).toString())){
				jobj.put("TARGET_PATH", resultMap.get(FileUploadUtil.KEY_TARGET_PATH).toString());
				jobj.put("ORIFILE_NAME", resultMap.get(FileUploadUtil.KEY_ORIFILE_NAME).toString());
				jobj.put("KEY_TARGET_REAL_PATH", resultMap.get(FileUploadUtil.KEY_TARGET_REAL_PATH).toString());
				jobj.put("KEY_FILE_NAME", resultMap.get(FileUploadUtil.KEY_FILE_NAME).toString());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return jobj;
	}
	/**
	 *  LIR PDF 파일 경로 삭제 및 파일 삭제
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Produces("text/html")
	@Transactional(rollbackFor=Exception.class)
	public void pdfDelete(HttpServletRequest request, Model model) {
				
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		
		try {	
			
			String path = (String) reqMap.get("pdf_path");
			path = path.replace("//","\\");
			reqMap.put("pdf_path", path);
			 
			File file = new File(path);
			
			if(!file.isFile()) {
				model.addAttribute("result","noFile");
				return;
			}									
			/*
			 * boolean result = FileUploadUtil.fileRemvoe(path.substring(15));
			 */
			
			boolean result = FileUploadUtil.fileRemvoe(path);
//			boolean result = FileUploadUtil.fileRemvoe(path.substring(12));
									
			if(result == true) {
				int i = lirdao.deletePDFPath(reqMap);
				path = path.replace(".pdf", ".png");
				/* FileUploadUtil.fileRemvoe(path.substring(43)); */				
				 FileUploadUtil.fileRemvoe(path); 
//				 FileUploadUtil.fileRemvoe(path.substring(12)); 
				/* FileUploadUtil.fileRemvoe(path.substring(15)); */
				 
			}
			model.addAttribute("result",result);
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}	
	/**
	 *  LIR PDF 파일 경로 저장
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void savePDFPath(HttpServletRequest request, Model model) {
		
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
    	HttpSession session = request.getSession(false);
		SmartSessionHelper sHelper = new SmartSessionHelper(session);
		Calendar calendar = Calendar.getInstance();
		
		String userid = sHelper.getUserId();
		String ip = sHelper.getLoginIp();
		java.util.Date date = calendar.getTime();
		
		String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
				
		reqMap.put("FRST_REG_ID", userid);			
		reqMap.put("FRST_REG_DT", today);
		reqMap.put("FRST_REG_IT", ip);
		int result = lirdao.savePDFPath(reqMap);
		
		model.addAttribute("result",result);
	}
	
	/**
	 *  RC PDF 파일 경로 저장
	 * @param model
	 * @throws Exception
	 */
//	@SuppressWarnings("unchecked")
//	public void saveRCPDFPath(HttpServletRequest request, Model model) {
//		
//		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
//		HttpSession session = request.getSession(false);
//		SmartSessionHelper sHelper = new SmartSessionHelper(session);
//		Calendar calendar = Calendar.getInstance();
//		
//		String userid = sHelper.getUserId();
//		java.util.Date date = calendar.getTime();
//		String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
//			
//		reqMap.put("FRST_REG_ID", userid);
//		reqMap.put("FRST_REG_DT", today);
//		
//		int result = lirdao.saveRCPDFPath(reqMap);
//		
//		model.addAttribute("result",result);
//		
//	}	
}

