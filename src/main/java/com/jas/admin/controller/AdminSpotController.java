package com.jas.admin.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.util.ReqUtil;
import com.jas.admin.service.AdminSpotService;
@Controller
public class AdminSpotController {
	
	private Logger log = Logger.getLogger(this.getClass());

	@Autowired
	AdminSpotService spotSvc;
	
	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		
		HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
		model.addAttribute("pageMap", reqMap);

	}
	@RequestMapping("/admin/spot/SpotListForm.do")
	public String SpotListForm(HttpServletRequest req, HttpServletResponse res, Model model) {
		spotSvc.SpotListForm(req,res,model);
		return"/admin/spot/JasSpotListForm.tiles";
	}
	@RequestMapping("/admin/spot/getGirdData.json")
	public String getGirdData(HttpServletRequest req, HttpServletResponse res, Model model) {
		spotSvc.getGirdData(req,res,model);
		return"/getGirdData.json";
	}
	@RequestMapping("/admin/JasSpotPopup.popup")
	public String JasSpotPopup(HttpServletRequest req, HttpServletResponse res, Model model) {
		spotSvc.JasSpotPopup(req,res,model);
		return"/admin/spot/JasSpotPopup.popup";
	}
	@RequestMapping("/admin/JasSpotSave.json")
	public String JasSpotSave(HttpServletRequest req, HttpServletResponse res, Model model) {
		spotSvc.JasSpotSave(req,res,model);
		return"/admin/JasSpotSave.json";
	}
	@RequestMapping("/admin/JasSpotDelete.json")
	public String JasSpotDelete(HttpServletRequest req, HttpServletResponse res, Model model) {
		spotSvc.JasSpotDelete(req,res,model);
		return"/admin/JasSpotDelete.json";
	}
	@RequestMapping("/admin/JasDelete.json")
	public String JasDelete(HttpServletRequest req, HttpServletResponse res, Model model) {
		spotSvc.JasDelete(req,res,model);
		return"/admin/JasDelete.json";
	}
	
	
}
