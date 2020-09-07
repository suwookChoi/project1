package com.jas.admin.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.framework.common.vo.CodeVO;
import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.framework.security.SmartSessionHelper;
import com.jas.admin.dao.AdminGroupDao;

@Service
public class AdminGroupService extends CommonAbstractService{

	@Autowired
	AdminGroupDao agdao;
	
	private Logger log = Logger.getLogger(this.getClass());
	/**
	 * 조직관리 메인
	 * @param model
	 * @throws Exception
	 */
	public void JasGroupListForm(HttpServletRequest req, Model model) throws Exception {
		setMainPage(model, "GRP_LIST");		
	}
	/**
	 * 조직관리 리스트
	 * @param model
	 * @throws Exception
	 */
	public void JasGroupListGridData(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		if (log.isDebugEnabled()) {
			log.debug("reqMap:" + reqMap.toString());
		}
		// 그리드 컬럼 정보
		try {
			HashMap<String, Object> resultMap = setGridListParamaters(reqMap); // 그리드 데이터
			List<HashMap<String, Object>> list = agdao.JasGroupListGridData(reqMap);
			resultMap.put("DATA_LIST", list);
			model.addAttribute("totalCnt", list.size());
			model.addAttribute("gridData", getGridDataJson(resultMap, false));
		} catch (Exception e) {
		}
		
	}
	//부서코드 중복확인
	@SuppressWarnings("unchecked")
	public void checkDeptCode(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		int result = agdao.checkDeptCode(reqMap);
		model.addAttribute("result", result == 0?"success":"fail");
	}
	
	/**
	 * 조직 등록/수정 팝업 
	 * 
	 * @param request
	 * @param model
	 */	
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor= {Exception.class})
	public void JasGroupRegister(HttpServletRequest req, Model model) {
		try {
			HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
			String deptcd = (String)reqMap.get("DEPT_CD_EDIT");
			reqMap.put("DEPT_CD", deptcd);
			
			HashMap<String,Object> groupData = agdao.getGroupData(reqMap);			
			List<CodeVO> braList = getCodeVal("BRA");			
			List<HashMap<String,Object>> list = agdao.HighDeptList(reqMap);
			
			if(deptcd != null) {
				model.addAttribute("highDeptList", list);
				model.addAttribute("GROUPDATA",groupData);		
				model.addAttribute("ARP", getCodeVal("BRA"));
				model.addAttribute("type", "detail");			
			}else {
				model.addAttribute("highDeptList", list);
				model.addAttribute("ARP", getCodeVal("BRA"));	
				model.addAttribute("type", "new");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 조직관리 수정
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor= {Exception.class})
	public void doGroupSave(HttpServletRequest req, Model model) throws Exception {
		
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");

		HttpSession session = req.getSession(false);
				
		HashMap<String, Object> map = getIdIp(req,reqMap);
		

		String type = (String) map.get("TYPE");
		int result =0;
		
		if("new".equals(type)) {
			
//			int idcheck = (0);
//			if(idcheck == 0) {
//				try {
//					//저장 sql = 저장
//					if(sql ==0) {
//						model.addAttribute("result","fail");
//						model.addAttribute("msg","저장 실패1");
//					}else {
//						model.addAttribute("result","success");
//						model.addAttribute("msg","저장에 성공하였습니");
//					}
//					
//				} catch (Exception e) {
//					model.addAttribute("result","fail");
//					model.addAttribute("msg",e.getMessage());
//				}
//				//저장진행
//			}else {
//				model.addAttribute("result","fail");
//				model.addAttribute("msg","이미 등록된 부서입니다");
//			}
			
			if(session.getAttribute("USER_SESSION") == null) return; 
			else{			

				//부서코드 등록
				String parDetenm = (String) map.get("PAR_DEPT_NM");
				String arp = (String) map.get("ARP");
				String companynm = (String) map.get("COMPANY_NM");
				String dept_nm= (String) map.get("DEPT_NM");

				arp  = arp.trim();
				companynm  = companynm.trim();
				dept_nm  = dept_nm.trim();
				
				String cod = parDetenm+arp+companynm+dept_nm;

				map.put("DEPT_CD", cod);				
				map.put("PAR_DEPT_NM", parDetenm);
				map.put("ARP",arp);
				map.put("COMPANY_NM",companynm);	
				try {
					result = agdao.doGroupSave(map);
					
					model.addAttribute("result", "success");
				}catch (Exception e) {
					model.addAttribute("result", "fail");
				}
				
			}
			model.addAttribute("result", result == 1?"success":"fail");
		}else if("detail".equals(type)) {
			if(session.getAttribute("USER_SESSION") == null) return; 
			else{
				String parDept = (String)reqMap.get("PAR_DEPT_CD");
				HashMap<String, Object> getParDept = agdao.getPARDept(reqMap);
				String detpLevel = (String)reqMap.get("DEPT_LEVEL");
				if(detpLevel.equals("1")) {
					result = agdao.doGroupEditSave(map);	
				}else {
					map.put("PAR_DEPT_NM", getParDept.get("DEPT_NM"));
					result = agdao.doGroupEditSave(map);	
				}
				
			}
		}
		model.addAttribute("result", result == 1?"success":"fail");
	}
	/**
	 * 조직관리 삭제
	 * @param model
	 * @throws Exception
	 */	
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor= {Exception.class})
	public void deleteGroup(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");		
		int result = agdao.deleteData(reqMap);
		if(result == 1) {
			agdao.changeUseLowDept(reqMap);
		}
		model.addAttribute("result", result ==1?"success":"fail" );
	}
	public void idCheckJson(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");		
		int result = agdao.idCheckJson(reqMap);
		model.addAttribute("result", result);		
	}
/*	public void findHighDept(HttpServletRequest req, Model model) {
		HashMap<String, Object> reqMap = (HashMap<String, Object>) model.asMap().get("pageMap");
		List<HashMap<String,Object>> deptList = agdao.findHighDept(reqMap);
		model.addAttribute("highDept",deptList);		
	}
*/
	
}
