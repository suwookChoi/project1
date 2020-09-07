package com.jas.admin.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.util.ReqUtil;
import com.jas.admin.service.AdminCommonCodeService;
import com.jas.admin.service.AdminGroupService;;

@Controller
public class AdminCommonCodeController {
	@Autowired
	AdminCommonCodeService admCmcdservice;

	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
		model.addAttribute("pageMap", reqMap);
	}
	/**
	 * 공통코드관리 메인
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commonCode/JasCommonCodeListForm.do")
	public String JasCommonCodeListForm(HttpServletRequest req, Model model) {
		admCmcdservice.JasCommonCodeListForm(req,model);
		return "/admin/commonCode/JasCommonCodeListForm.tiles";
	}
	/**
	 * 공통코드관리 리스트 조회
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commonCode/JasCommonCodeListJson.json")
	public String JasCommonCodeListJson(HttpServletRequest req, Model model) throws Exception {
		admCmcdservice.JasCommonCodeListJson(req,model);
		return "JasCommonCodeListJson.Json";
	}
	/**
	 * 공통코드관리 생성/수정 팝업
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commonCode/JasCommonCodeModifyPopup.popup")
	public String JasCommonCodeModifyPopup(HttpServletRequest req, Model model) {
		admCmcdservice.JasCommonCodeModify(req,model);
		return "/admin/commonCode/JasCommonCodeModifyPopup.popup";
	}
	/**
	 * 공통코드관리 생성/수정
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commonCode/JascommonCodeModifySave.json")
	public String JascommonCodeModifySave(HttpServletRequest req, Model model){
		admCmcdservice.JascommonCodeModifySave(req,model);
		return "JascommonCodeModifySave.json";
	}	
	
	@RequestMapping("/commonCode/CommoneCodeIdCheck.json")
	public String CommoneCodeIdCheck(HttpServletRequest req, Model model){
		admCmcdservice.CommoneCodeIdCheck(req,model);
		return "CommoneCodeIdCheck.json";
	}	
	/**
	 * 공통코드관리 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commonCode/JasCommonCodeDeleteJson.json")
	public String JasCommonCodeDelete(HttpServletRequest req, Model model){
		admCmcdservice.JasCommonCodeDelete(req,model);
		return "JasCommonCodeDeleteJson.json";
	}
}
