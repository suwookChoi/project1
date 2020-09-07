package com.jas.admin.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.util.ReqUtil;
import com.jas.admin.service.AdminCodeService;
import com.jas.admin.service.AdminCommonCodeService;

@Controller
public class AdminCodeController {
	@Autowired
	AdminCodeService admCdservice; 
	
	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
		model.addAttribute("pageMap", reqMap);
	}
	/**
	 * 코드관리 메인
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/code/JasCodeListForm.do")
	public String JasCodeListForm(HttpServletRequest req, Model model) throws Exception {
		admCdservice.JasCodeListForm(req,model);
		return "/admin/code/JasCodeListForm.tiles";
	}
	/**
	 * 코드관리 리스트 조회
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/code/JasCodeGridData.json")
	public String JasCodeGridData(HttpServletRequest req, Model model) {
		admCdservice.JasCodeGridData(req,model);
		return "JasCodeGridData.json";
	}
	/**
	 * 코드관리 생성/수정 팝업
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/code/JasCodeModifyPopup.popup")
	public String JasCodeModifyPopup(HttpServletRequest req, Model model) {
		admCdservice.JasCodeModify(req,model);
		return "/admin/code/JasCodeModifyPopup.popup";
	}
	/**
	 * 코드관리 생성/수정
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/code/codeModifySave.json")
	public String codeModifySave(HttpServletRequest req, Model model) {
		admCdservice.codeModifySave(req,model);
		return "codeModifySave.json";
	}
	@RequestMapping("/code/CodeIdCheck.json")
	public String CodeIdCheck(HttpServletRequest req, Model model) {
		admCdservice.CodeIdCheck(req,model);
		return "CodeIdCheck.json";
	}

	/**
	 * 코드관리 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/code/codeDelete.json")
	public String codeDelete(HttpServletRequest req, Model model) {
		admCdservice.codeDelete(req,model);
		return "codeDelete.json";
	}

}
