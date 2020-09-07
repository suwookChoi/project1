package com.jas.main.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.jfree.util.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.exception.ResponseExceptionHandler;
import com.framework.initialize.InitializeProperties;
import com.framework.util.ReqUtil;
import com.jas.main.service.MainDashBoardService;

@Controller
public class MainDashBoardController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	MainDashBoardService dashBoardService;
	
	
	@ModelAttribute
	public void common(HttpServletRequest request, Model model) throws Exception {
		HashMap<String, Object> reqParam = ReqUtil.reqToHashMap(request);

		model.addAttribute("contextPath", request.getContextPath());
		model.addAttribute("pageMap", reqParam);
		
		
		if(logger.isDebugEnabled()) {
			logger.debug(reqParam);
		}
	}
	/**
	 * 대시보드 메인화면
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashBoard.do")
	public String mainDashBoardForm(Model model ,HttpServletRequest request) throws Exception {
		Device device = DeviceUtils.getCurrentDevice(request);        
        if (device == null) {
            return "device is null";
        }
        String url = "";
        if (device.isNormal()) {
            url = "/main/mainDashBoard.tiles";
        } else if (device.isMobile()) {
            url = "/main/mainDashBoardTab.tiles";
        } else if (device.isTablet()) {
            url = "/main/mainDashBoardTab.tiles";
        }
        
		dashBoardService.getDashBoardFormInfo(model,request);
		return url;
	}
	
	
	/**
	 * 대시보드 메인화면 데이터 리스트
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/getDashBoardList.json")
	public String getDashBoardList(Model model) throws Exception {
		dashBoardService.getDashBoardList(model);
		return "/main/getDashBoardList.json";
	}
	@RequestMapping("/main/getDashBoardListTab.json")
	public String getDashBoardListTab(Model model) throws Exception {
		dashBoardService.getDashBoardListTab(model);
		return "/main/getDashBoardListTab.json";
	}
	

	/**
	 * 비정상코드 팝업
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashEMRPopupForm.popup")
	public String dashEMRPopupForm(Model model, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = (HashMap<String, Object>) model.asMap().get("pageMap");
		Iterator<String> it = map.keySet().iterator();
		while(it.hasNext()){
			String key = it.next();
		}
		dashBoardService.dashEMRPopup(model, request);
		//dashBoardService.setMainPage(model, "GRID MANAGEMENT 입력한 아이디");
		return "/main/dashEMRPopup.popup";
	}
	
	/**
	 * 비정상코드 저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashEMRSave.json")
	public String dashEMRSave(Model model) throws Exception {
		HashMap<String,Object> map = (HashMap<String, Object>) model.asMap().get("pageMap");
		Iterator<String> it = map.keySet().iterator();
		while(it.hasNext()){
			String key = it.next();
		}
		dashBoardService.dashEMRSave(model);
		//dashBoardService.setMainPage(model, "GRID MANAGEMENT 입력한 아이디");
		return "/main/dashEMRPopup.json";
	}
	
	/**
	 * 전달사항 팝업
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashRMKPopupForm.popup")
	public String dashRMKPopupForm(Model model, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = (HashMap<String, Object>) model.asMap().get("pageMap");
		dashBoardService.dashRMKPopup(model, request);
		//dashBoardService.setMainPage(model, "GRID MANAGEMENT 입력한 아이디");
		return "/main/dashRMKPopup.popup";
	}
	/**
	 * 전달사항 조회
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashRMKSearch.json")
	public String detailSfsSchedule(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		try {
			dashBoardService.dashRMKSearch(model, request);
		} catch (DataAccessException de) {
			ResponseExceptionHandler.ajaxResponseException(de, response, this.getClass());
		} catch (Exception e) {
			ResponseExceptionHandler.ajaxResponseException(e, response, this.getClass());
		}
		return "/main/dashRMKSearch.json";
	}
	/**
	 * 전달사항 저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashRMKSave.json")
	public String dashRMKSave(Model model) throws Exception {
		HashMap<String,Object> map = (HashMap<String, Object>) model.asMap().get("pageMap");
		Iterator<String> it = map.keySet().iterator();
		while(it.hasNext()){
			String key = it.next();
		}
		dashBoardService.dashRMKSave(model);
		//dashBoardService.setMainPage(model, "GRID MANAGEMENT 입력한 아이디");
		return "/main/dashRMKPopup.json";
	}
	/**
	 * 대시보드 팀 팝업
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashTeamPopupForm.popup")
	public String openGhTeam(HttpServletRequest request, Model model) throws Exception{
		dashBoardService.ghDashTeamGrid(model);
		dashBoardService.getDashTeamList(model);
		return "/main/dashTeamPopup.popup";
	}
	/**
	 * 대시보드 팀 리스트 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/getDashTeamList.json")
	public String getGhTeamList(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		dashBoardService.getDashTeamList(model);
		return "/main/getDashTeamList.json";
	}
	/**
	 * 대시보드 팀 저장
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/saveDashTeam.json")
	public String saveTeam(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		dashBoardService.saveDashTeam(model);
		return "/main/saveDashTeam.json";
	}
	
	/**
	 * 대시보드 팀 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/getDashTeamUserList.json")
	public String getGhTeamUserList(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		dashBoardService.getDashGhTeamUserList(model);//조회 데이터 세팅
		return "/main/dashTeamUserList.json";
	}
	
	/**
	 * 대시보드 팀 유저 저장
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/saveDashTeamUser.json")
	public String saveGhTeamUser(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		dashBoardService.saveDashTeamUser(model);
		return "/main/saveDashTeamUser.json";
	}
	/**
	 * 대시보드 팀 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/saveGHTeam.json")
	public String saveGHTeam(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		dashBoardService.saveGHTeam(model);
		return "/main/saveGHTeam.json";
	}
	/**
	 * 대시보드 Loading,UnLoading 작업 팝업
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashLoadPopupForm.popup")
	public String unitPopupForm(Model model) throws Exception {
		dashBoardService.getEQList(model);
		dashBoardService.setMainPage(model, "MAIN_UNIT_LOAD_LIST");
		return "/main/unitLoadPopup.popup";
	}
	
	/**
	 * 대시보드 Loading,UnLoading 작업 작업
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/saveGHUnitLoad.json")
	public String saveGHUnitLoad(Model model){
		dashBoardService.saveGHUnitLoad(model);
		return "/main/saveGHUnitLoad.json";
	}
	
	/**
	 * 대시보드 RAMP_IN,DoorClose 작업 팝업
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashRampDoorPopupForm.popup")
	public String unitRampPushPopupForm(Model model) throws Exception {
		dashBoardService.setMainPage(model, "MAIN_UNIT_RAMPDOOR_LIST");
		return "/main/unitRampDoorPopup.popup";
	}
	
	/**
	 * 대시보드 FUEL 작업 팝업
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashFuelPopupForm.popup")
	public String unitFuelPopupForm(Model model) throws Exception {
		dashBoardService.getEQList(model);
		dashBoardService.setMainPage(model, "MAIN_UNIT_LOAD_LIST");
		return "/main/unitFuelPopup.popup";
	}

	/**
	 * 대시보드 RAMP_IN,PUSH_BACK 작업 팝업
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/dashPushBackPopupForm.popup")
	public String unitTowingPopupForm(Model model) throws Exception {
		dashBoardService.getEQList(model);
		dashBoardService.setMainPage(model, "MAIN_UNIT_PUSHBACK_LIST");
		return "/main/unitPushBackPopup.popup";
	}

	@RequestMapping("/main/dashDefaultPopupForm.popup")
	public String unitDefaultPopupForm(Model model) throws Exception {
		//dashBoardService.getEQList(model);
		dashBoardService.setMainPage(model, "MAIN_UNIT_DEF_LIST");
		return "/main/unitDefaultPopup.popup";
	}
	
	@RequestMapping("/main/getGHUnitList.json")
	public String getGHUnitPopupList(Model model) throws Exception {
		dashBoardService.getGHUnitList(model);
		return "/main/getGHUnitPopupList.json";
	}
	
	
	@RequestMapping("/main/dashEQRegisterPopupForm.popup")
	public String EQRegisterPopupForm(Model model) throws Exception {
		//사용 가능 장비 목록
		dashBoardService.getEQUseList(model);
		dashBoardService.setMainPage(model, "MAIN_EQ_LIST");
		return "/main/dashEQRegisterPopup.popup";
	}
	@RequestMapping("/main/getGHEQList.json")
	public String getGHEQList(Model model) throws Exception {
		dashBoardService.getGHEQList(model);
		dashBoardService.getGHTeamDayList(model); //일일배정된 조원 리스트 
		//dashBoardService.getArpTeamList(model);
		return "/main/getGHEQList.json";
	}
	
	@RequestMapping("/main/saveGHEQList.json")
	public String saveGHEQList(Model model) {
		dashBoardService.saveGHEQList(model);
		return "/main/saveGHEQList.json";
	}
	
	@RequestMapping("/main/getDashUserInfo.json")
	public String getDashUserInfo(Model model) throws Exception {
		dashBoardService.getDashUserInfo(model);
		return "/main/getDashUserInfo.json";
	}
	
	@RequestMapping("/main/getAssignTeamList.json")
	public String getAssignTeamList(Model model) throws Exception {
		dashBoardService.getAssignTeamList(model);
		return "/main/getAssignTeamList.json";
	}
	
	@RequestMapping("/main/dashRcLirButtonPopup.popup")
	public String dashRcLirButtonPopup(Model model) throws IOException {
		dashBoardService.getRcLirPathInfo(model);
		dashBoardService.getFlightInfo(model);
		return "/main/dashRcLirButtonPopup.popup";
	}
	
	@RequestMapping("/main/updateEQSignInfo.json")
	public String updateEQSignInfo(Model model) {
		dashBoardService.updateEQSignInfo(model);
		return "/main/updateEQSignInfo.json";
	}
	@RequestMapping("/main/rcLirDetailPopup.popup")
	public String rcLirDetailPopup(Model model,HttpServletResponse response) throws Exception {
		HashMap<String,Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		//String IMG_PATH = reqMap.get("IMG_PATH").toString().replaceAll("//", "\\\\");
		String IMG_PATH = reqMap.get("IMG_PATH").toString();
		reqMap.put("IMG_PATH",IMG_PATH);
		File imageFile = new File(IMG_PATH);
		if(!imageFile.isFile()) {
			model.addAttribute("err","Y");
			return "/main/rcLirDetailPopup.popup";
		}
		FileInputStream is = new FileInputStream(imageFile);
		byte b[] = IOUtils.toByteArray(is);
		byte[] encodeBase64 = Base64.encodeBase64(b);
		String base64DataString = new String(encodeBase64 , "UTF-8");			
		is.close();
		
		model.addAttribute("data",base64DataString);
		
		
		
		return "/main/rcLirDetailPopup.popup";
	}
	
	@RequestMapping("/main/dashSignPopup.popup")
	public String dashSignPopup(Model model) {
		HashMap<String,Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		String FILE_PATH =	InitializeProperties.getProperty("file.root.path");
			   FILE_PATH += InitializeProperties.getProperty("file.upload.sign.path");
			   FILE_PATH += "/"+reqMap.get("SDT").toString()+"/";
		reqMap.put("FILE_PATH",FILE_PATH);
		return "/main/dashSignPopup.popup";
	}
	@RequestMapping("/main/dashSignChkPopup.popup")
	public String signChkPopup(HttpServletRequest request, Model model) throws Exception{
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		//String FILE_PATH = reqMap.get("FILE_PATH").toString().replaceAll("//", "\\\\");
		String FILE_PATH = reqMap.get("FILE_PATH").toString();
		//reqMap.put("FILE_PATH",FILE_PATH);
		
		File imageFile = new File(FILE_PATH);
		if(imageFile.isFile()){
			FileInputStream is = new FileInputStream(imageFile);
			byte b[] = IOUtils.toByteArray(is);
			byte[] encodeBase64 = Base64.encodeBase64(b);
			String base64DataString = new String(encodeBase64 , "UTF-8");			
			is.close();
			
			model.addAttribute("data",base64DataString);
		}else{
			model.addAttribute("data","NOT FILE");
		}
		
		
		return "/main/dashSignChkPopup.popup";
	}
	
	@RequestMapping("/main/deleteSignInfo.json")
	public String deleteSignInfo(Model model) {
		dashBoardService.deleteSignInfo(model);
		return "/main/deleteSignInfo.json";
		
	}
	
	
	@RequestMapping("/main/arpStatus.do")
	public String mainArpStatusForm(Model model ,HttpServletRequest request) throws Exception {
		dashBoardService.getDashBoardFormInfo(model,request);
		return "/main/arpStatusForm.tiles";
	}
	
	@RequestMapping("/main/BriefingPDFDownLoad.pdf")
	public String BriefingPDFDownLoad(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		response.setHeader("Content-Disposition", "attachment; fileName=\"pdfData.pdf\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		return "pdfDownLoad";
	}

	/**
	 * 대시보드 RC CheckList 팝업
	 * @param model
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping("/main/dashRcLirButton.popup")
	public String dashRcLirButton(HttpServletRequest request,Model model) throws IOException {
		dashBoardService.getRcLirPathInfo(model);
		dashBoardService.getRCData(request,model);
		
		return "/main/dashRcCheckList.popup";
	}
//	@RequestMapping("/main/dashRcLirButton.popup")
//	public String dashRcLirButton(HttpServletRequest request,Model model) throws IOException {
//		dashBoardService.getRcLirPathInfo(model);
//		dashBoardService.getRCData(request,model);
//		
//		return "/main/dashRcLirButton.popup";
//	}
	/**
	 * 대시보드 RC CheckList 저장
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/main/RCCheckSave.json")
	public String RCCheckSave(HttpServletRequest request, HttpServletResponse response,Model model) throws IOException {
		dashBoardService.RCCheckSave(request,model);
		return "main/RCCheckSave.json";
	}
}
