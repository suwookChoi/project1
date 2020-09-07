package com.jas.flt.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.dataHandler.dhtmlx.service.CommonGridDAO;
import com.framework.util.ReqUtil;
import com.jas.flt.service.FltLIRService;

@Controller
public class FltLIRController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	FltLIRService lirService;
	
	@Autowired
	protected CommonGridDAO commonGridDAO;
		
	/**
	 * @param HttpServletRequest request
	 * @param Model model
	 * @return void
	 * @exception Exception
	 * @category CommonData Set (InitializeAspectPM)
	 */
	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		HashMap<String, Object> reqParam = ReqUtil.reqToHashMap(request);
		
		model.addAttribute("pageMap", reqParam);
		
		if(logger.isDebugEnabled()) {
			logger.debug(reqParam);
		}
	}
	/**
	 * LIR 메인화면
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/flt/LIRList.do")
	public String LIRList2 (HttpServletRequest req, HttpServletResponse res, Model model) {
		lirService.LIRList(req,model);
		 return "flt/lir/FltLIR.tiles"; 
	}	
	/**
	 * LIR 그리드 리스트
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/LIRList.json")
	public String getLIRListData (HttpServletRequest req, HttpServletResponse res, Model model) {
		lirService.getLIRListData(req,model);
		return "LIRList.json";
	}
	/**
	 * LIR PDF 파일 업로드
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/uploadPDFFile.json")
	public void uploadPDFFile(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		JSONObject jobj = lirService.uploadPDFFile(request, model);
		response.setContentType("text/plain");
		response.getWriter().write(jobj.toJSONString());
	}
	/**
	 * LIR PDF 파일 경로 저장
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/savePDFPath.json")
	public String savePDFPath(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		lirService.savePDFPath(request, model);
		return "savePDFPath.json";
	}
//	@RequestMapping("/flt/saveRCPDFPath.json")
//	public String saveRCPDFPath(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
//		lirService.saveRCPDFPath(request, model);
//		return "saveRCPDFPath.json";
//	}
	/**
	 * LIR PDF 파일삭제
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/pdfDelete.json")
	public String pdfDelete(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		lirService.pdfDelete(request, model);
		return "pdfDelete.json";
	}
	
}
