package com.jas.cod.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.util.ReqUtil;
import com.jas.cod.service.CodeGHUnitService;
@Controller
public class CodeGHUnitController extends CommonAbstractService{

	Logger log = Logger.getLogger(this.getClass());

	@Autowired
	CodeGHUnitService ghUnitService;
	
	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
		model.addAttribute("pageMap", reqMap);
	}
	
	
	@RequestMapping("/cod/ghUnitListForm.do")
	public String ghUnitListForm(HttpServletRequest request, Model model) throws Exception {
		ghUnitService.setMainPage(model, "COD_GH_UNIT");
		model.addAttribute("arpList",getCodeVal("BRA"));
		model.addAttribute("flcCodeList",ghUnitService.getFlcCodeList());
		return "/cod/ghcode/codGHUnitListForm.tiles";
	}
	
	@RequestMapping("/cod/getGHUnitList.json")
	public String getGHUnitList(Model model) throws Exception {
		ghUnitService.getGHUnitList(model);
		return "/cod/getGHUnitList.json";
	}
	
	@RequestMapping("/cod/saveGHUnit.json")
	public String saveGHUnit(HttpServletRequest request,Model model) throws Exception{
		ghUnitService.saveGHUnit(request,model);
		return "/cod/saveGHUnit.json";
	}
	
	
}
