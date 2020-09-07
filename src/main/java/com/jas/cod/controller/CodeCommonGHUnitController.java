package com.jas.cod.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.util.ReqUtil;
import com.jas.cod.service.CodeCommonGHUnitService;

@Controller
public class CodeCommonGHUnitController {

	Logger log = Logger.getLogger(this.getClass());

	@Autowired
	CodeCommonGHUnitService ghUnitComService;
	
	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
		model.addAttribute("pageMap", reqMap);
	}
	
	
	@RequestMapping("/cod/commonGHUnitList.do")
	public String codeWorkUnitComListForm(HttpServletRequest request, Model model) throws Exception {
		ghUnitComService.commonForm(model, request);
		ghUnitComService.setMainPage(model, "COD_GH_CM_UNIT");
		return "cod/ghcode/commonGHUnitListForm.tiles";
	}
	
	@RequestMapping("/cod/getCommonGHUnitList.json")
	public String getCommonGHUnitList(Model model) throws Exception {
		ghUnitComService.getCommonGHUnitList(model);
		return "/cod/getCommonGHUnitList.json";
	}
	
	@RequestMapping("/cod/commonGHUnitDetailPopup.popup")
	public String codWorkUnitComDetailPopup(HttpServletRequest request, Model model) throws Exception {
		common(request,model);
		return "/cod/ghcode/commonGHUnitDetailPopup.popup";
	}
	
	@RequestMapping("/cod/getCommonGHUnitCheckID.json")
	public void getCommonGHUnitCheckID(HttpServletRequest request,Model model) throws Exception {
		ghUnitComService.getCommonGHUnitCheckID(request,model);
	}
	
	@RequestMapping("/cod/saveCommonGHUnit.json")
	public void saveCommonGHUnit(HttpServletRequest request, Model model) {
		ghUnitComService.saveCommonGHUnit(request,model);
	}
	
	@RequestMapping("/cod/deleteCommonGHUnit.json")
	public void deleteCommonGHUnit(HttpServletRequest request, Model model) {
		ghUnitComService.deleteCommonGHUnit(request,model);
	}
}
