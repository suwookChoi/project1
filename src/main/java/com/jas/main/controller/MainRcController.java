package com.jas.main.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.util.ReqUtil;
import com.jas.main.service.MainRcService;

@Controller
public class MainRcController {

private Logger log = Logger.getLogger(this.getClass());

	@Autowired
	MainRcService mrservice;

	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		
		HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
		model.addAttribute("pageMap", reqMap);

	}
	

	/**
	 * RC 팝업 메인
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/RC/JasRCPopup.popup")
	public String noticeListForm(HttpServletRequest request, Model model) throws Exception{
		mrservice.getRcData(request,model);
		return "main/RC/JasRCPopup.popup";
	}
	
	/**
	 * RC 팝업 저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/RC/JasRCSave.json")
	public String JasRCSave(HttpServletRequest request, Model model) throws Exception{
		mrservice.rcSave(request,model);
		return "JasRCSave.json";
	}

}
