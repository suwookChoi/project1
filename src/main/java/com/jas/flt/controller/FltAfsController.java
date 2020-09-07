package com.jas.flt.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.dataHandler.dhtmlx.service.CommonGridDAO;
import com.framework.exception.ResponseExceptionHandler;
import com.framework.util.ReqUtil;
import com.jas.flt.service.FltAfsService;

@Controller
public class FltAfsController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private FltAfsService fltAfsService;
	
	
	@Autowired
	protected CommonGridDAO commonGridDAO;
	
	/**
	 * @param HttpServletRequest
	 *            request
	 * @param Model
	 *            model
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
	 * 일일 스케줄 현황 화면 
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/afsListForm.do")
	public String afsListForm(HttpServletRequest request, Model model) throws Exception{
		fltAfsService.afsListForm(model,request);
		return "flt/afsList.tiles";
	}
	
	/**
	 * 일일 스케줄 현황 리스트 조회 
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/getAfsList.json")
	public String getAfsList(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		try {
			fltAfsService.getAfsList(model,request);
		} catch (DataAccessException de) {
			ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
		} catch (Exception e) {
			ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
		}
		return "/flt/getAfsList.json";
	}

}
