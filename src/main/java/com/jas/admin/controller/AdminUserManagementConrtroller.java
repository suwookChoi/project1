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
import com.jas.admin.service.AdminUserManagementService;

@Controller
public class AdminUserManagementConrtroller {

	@Autowired
	AdminUserManagementService admUsrMgtservice; 
	
	private Logger log = Logger.getLogger(this.getClass()); 
	
	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
		model.addAttribute("pageMap", reqMap);
	}
	/**
	 * 관리자 사용자 관리 리스트 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/userManagement/UserManagementListForm.do")
	public String UserManagementListForm(HttpServletRequest request,HttpServletResponse response, Model model)throws Exception{
			try {
				admUsrMgtservice.usrUserManagementListForm(model,request);
			} catch (DataAccessException de) {
				ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
			} catch (Exception e) {
				ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
			}
		return "/admin/userManagement/JasUerManagementListForm.tiles";
	}	
	// 사용자관리 그리드
	@RequestMapping("/userManagement/UserManagementListFormJSON.json")
	public String userManagementListFormJSON(HttpServletRequest request,HttpServletResponse response, Model model)throws Exception{
			try {
				admUsrMgtservice.userManagementListFormJSON(model,request);
			} catch (DataAccessException de) {
				ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
			} catch (Exception e) {
				ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
			}
		return "UserManagementListFormJSON.json";
	}
	
	/**
	 * 관리자 회원가입
	 * @param request
	 * @param model
	 */
	@RequestMapping("/userManagement/JasUsrUserInfoRegisterPopup.popup")
	public String JASUsrUserInfoRegisterPopup(HttpServletRequest request, Model model)throws Exception{		
			admUsrMgtservice.JASUsrUserInfoRegisterPopup(request, model);
		return "/admin/userManagement/JasUserInfoRegisterPopup.popup";
	}
	//아이디 중복검사	
	 @RequestMapping("/userManagement/usrFindUserManagementId.json") 
	 public String findUsrUserManagementId(HttpServletRequest request, Model model)throws Exception{ 
		 	admUsrMgtservice.findUsrUserManagementId(request, model);
		return "usrFindUserManagementId.json"; 
	 }	 
	
	@RequestMapping("/userManagement/usrUserInfoRegister.json")
		public String usrUserInfoRegister(HttpServletRequest req, Model model) {
			admUsrMgtservice.usrUserInfoRegister(req,model);
		return "usrUserInfoRegister.json";
	}
	//사용자 비밀번호 변경 팝업
	@RequestMapping("/userManagement/UserPasswordResetPopup.popup")
	public String UserPasswordResetPopup(HttpServletRequest req,Model model) {
		admUsrMgtservice.UserPasswordResetPopup(req,model);
		return "/admin/userManagement/UserPasswordResetPopup.popup";
	}
	//사용자 비밀번호 변경
	@RequestMapping("/userManagement/UserPasswordResetJson.json")
	public String UserPasswordResetJson(HttpServletRequest req, Model model) {
		admUsrMgtservice.UserPasswordResetJson(req,model);
		return "UserPasswordResetJson.json";
	}

	/**
	 * 사용자 회원정보수정
	 * @param request
	 * @param model
	 */
	@RequestMapping("/userManagement/JasUsrInfoEdit.detail")
	public String JasUsrInfoEdit(HttpServletRequest request,HttpServletResponse response, Model model)throws Exception{
		admUsrMgtservice.JasUsrInfoEditForm(model,request);
		return "/admin/userManagement/JasUsrInfoEdit.tiles";
	}	
	//사용자 정보 저장
	@RequestMapping("/userManagement/UserInfoEdit.json")
	public String UserInfoEdit(HttpServletRequest req, Model model) throws Exception {
		admUsrMgtservice.UserInfoEdit(req,model);
		return "UserInfoEdit.json";
	}
	// 관리자 사용자 비밀번호 초기화 
	@RequestMapping("/userManagement/JASChangePWD.json")
	public String testChangePWD(HttpServletRequest req, Model model) {
		admUsrMgtservice.JASChangePWD(req,model);
		return "JASChangePWD.json";
	}
	// 사용자 계정  USE_YN 'N'으로 변경
	@RequestMapping("/userManagement/JasUserAccountUseN.json")
	public String JasUserAccountUseN(HttpServletRequest req, Model model) {
		admUsrMgtservice.JasUserAccountUseN(req,model);
		return "JasUserAccountUseN.json";
	}

	//ARP 찾기 
	@RequestMapping("/userManagement/findARPJSON.json")
	public String findARPJSON(HttpServletRequest req, Model model){
		admUsrMgtservice.findARPJSON(req,model);
		return "findARPJSON.json";
	}	
	//부서찾기
	@RequestMapping(value="/userManagement/usrFindDepartmentJSON.json")
	public String usrFindDepartmentJSON(HttpServletRequest req, Model model){
		admUsrMgtservice.usrFindDepartmentJSON(req,model);			
		return "usrFindDepartmentJSON.json";
	}	
}
