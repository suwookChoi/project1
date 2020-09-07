package com.jas.admin.controller;

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

import com.framework.exception.ResponseExceptionHandler;
import com.framework.util.ReqUtil;
import com.jas.admin.service.AdminCodAirportService;

@Controller
public class AdminCodAirportController {

	@Autowired
	private AdminCodAirportService adminCodAirportService;
	
	/**
	 * @param HttpServletRequest
	 *            request
	 * @param Model
	 *            model
	 * @return void
	 * @exception Exception
	 * @category CommonData Set
	 */
	
	private Logger log = Logger.getLogger(this.getClass());
	
	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		
		HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
		model.addAttribute("pageMap", reqMap);

	}
	

	/**
	 * 공항관리 메인
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/admin/airport/airportListForm.do")
	public String airportListForm(HttpServletRequest request, Model model) throws Exception{
		adminCodAirportService.airportListForm(model, request);
		return "admin/airport/codAirportListForm.tiles";
	}
	
	/**
	 * 공항 관리 리스트 조회
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/admin/airport/getAirportList.json")
	public String getAirportList(HttpServletRequest request, HttpServletResponse response ,Model model) throws Exception{
		try {
			adminCodAirportService.getAirportList(model, request);
		} catch (DataAccessException de) {
			ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
		} catch (Exception e) {
			ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
		}
		return "/admin/airport/getAirportList.json";
	}
	
	/**
	 * 공항 관리 생성 팝업
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/admin/airport/codAirportCreatePopup.popup")
	public String codAirportCreatePopup(HttpServletRequest request, Model model) throws Exception{
		adminCodAirportService.codAirportListDetailPopup(model, request);
		return "/admin/airport/codAirportCreatePopup.popup";
	}

	/**
	 * 공항 관리 생성
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/admin/airport/createAirport.json")
	public String createAirtport(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		try {
			adminCodAirportService.createAirtport(model, request);
		} catch (DataAccessException de) {
			ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
		} catch (Exception e) {
			ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
		}
		return "/admin/airport/createAirport.json";
	}
	
	/**
	 * 공항 관리 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/admin/airport/deleteAirport.json")
	public String deleteAirport(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		try {
			adminCodAirportService.deleteAirport(model, request);
		} catch (DataAccessException de) {
			ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
		} catch (Exception e) {
			ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
		}
		return "/admin/airport/deleteAirport.json";
	}
	
}
