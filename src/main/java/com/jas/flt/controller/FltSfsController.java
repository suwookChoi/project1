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

import com.jas.flt.service.FltSfsService;
import com.framework.dataHandler.dhtmlx.service.CommonGridDAO;
import com.framework.exception.ResponseExceptionHandler;
import com.framework.util.ReqUtil;

@Controller
public class FltSfsController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private FltSfsService fltSfsService;
	
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
	 * 시즌 스케줄 현황 화면 
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/sfsListForm.do")
	public String sfsListForm(HttpServletRequest request, Model model) throws Exception{
		fltSfsService.sfsListForm(model,request);
		return "flt/sfsList.tiles";
	}
	
	/**
	 * 시즌 스케줄 현황 리스트 조회 
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/getSfsList.json")
	public String getSfsList(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		try {
			fltSfsService.getSfsList(model,request);
		} catch (DataAccessException de) {
			ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
		} catch (Exception e) {
			ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
		}
		return "/flt/getSfsList.json";
	}
	
	/**
	 * 시즌 스케줄 신규/상세 화면
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/sfsSchedulePopup.popup")
	public String sfsSchedulePopup(HttpServletRequest request, Model model) throws Exception{
		fltSfsService.sfsSchedulePopup(model, request);
		return "/flt/sfsSchedulePopup.popup";
	}
	
	/**
	 * 시즌 스케줄 조회
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/detailSfsSchedule.json")
	public String detailSfsSchedule(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		try {
			fltSfsService.detailSfsSchedule(model, request);
		} catch (DataAccessException de) {
			ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
		} catch (Exception e) {
			ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
		}
		return "/flt/detailSfsSchedule.json";
	}
	
	/**
	 * 시즌 스케줄 신규/상세
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/upsertSfsSchedule.json")
	public String upsertSfsSchedule(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		try {
			fltSfsService.upsertSfsSchedule(model, request);
		} catch (DataAccessException de) {
			ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
		} catch (Exception e) {
			ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
		}
		return "/flt/upsertSfsSchedule.json";
	}
	
	/**
	 * 시즌 스케줄 삭제
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("/flt/deleteSfsList.json")
	public String deleteSfsList(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		try {
			fltSfsService.deleteSfsList(model, request);
		} catch (DataAccessException de) {
			ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
		} catch (Exception e) {
			ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
		}
		return "/flt/deleteSfsList.json";
	}
	
}
