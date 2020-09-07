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
import com.jas.admin.service.AdminGroupService;

@Controller
public class AdminGroupController {

	@Autowired
	AdminGroupService agService;
	
	Logger log = Logger.getLogger(this.getClass());
	
	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
		model.addAttribute("pageMap", reqMap);
	}
	
	/**
	 * 조직관리 메인
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/group/JasGroupList.do")
	public String JasGroupListForm(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
		agService.JasGroupListForm(req,model);
		return "/admin/group/JasGroupListForm.tiles";
	}	
	/**
	 * 조직관리 리스트
 	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/group/JasGroupListGridData.json")
	public String JasGroupListGridData(HttpServletRequest req,HttpServletResponse res, Model model) {
		agService.JasGroupListGridData(req,model);
		return "JasGroupListGridData.json";
	}

	/**
	 * 조직 등록/수정  팝업
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/group/JasGroupRegisterPopup.popup")
	public String JasGroupRegister(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
		agService.JasGroupRegister(req,model);
		return "/admin/group/JasGroupRegisterPopup.popup";
	}
	@RequestMapping("/group/checkDeptCode.json")
	public String checkDeptCode(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
		agService.checkDeptCode(req,model);
		return "checkDeptCode.json";
	}
	/**
	 * 조직관리 수정
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/group/doGroupSave.json")
	public String doGroupSave(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
		agService.doGroupSave(req,model);
		return "doGroupSave.json";
	}
	
	/**
	 * 조직 아이디 중복 확인
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/group/idCheckJson.json")
	public String idCheckJson(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
		agService.idCheckJson(req,model);
		return "idCheckJson.json";
	}
	/**
	 * 조직관리 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping("/group/deleteGroup.json")
	public String deleteGroup(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
		agService.deleteGroup(req,model);
		return "deleteGroup.json";
	}
	/*
	 * @RequestMapping("/group/findHighDept.json") public String
	 * findHighDept(HttpServletRequest req,HttpServletResponse res, Model model)
	 * throws Exception { agService.findHighDept(req,model); return
	 * "findHighDept.json"; }
	 */
}
