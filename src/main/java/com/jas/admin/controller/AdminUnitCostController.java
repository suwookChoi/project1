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
import com.jas.admin.service.AdminUnitCostService;

@Controller
public class AdminUnitCostController {

		@Autowired
		AdminUnitCostService admCostService;
		private Logger log = Logger.getLogger(this.getClass());
		
		@ModelAttribute
		public void common(HttpServletRequest request, Model model) throws Exception{
			HashMap<String, Object> reqMap = ReqUtil.reqToHashMap(request);
			model.addAttribute("pageMap", reqMap);
		}
		
		/**
		 * 기본 조업요율 메인
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/unitCost/JasUnitCostForm.do")
		public String JasUnitCostForm(HttpServletRequest req, HttpServletResponse res, Model model) {
			try {
				admCostService.JasCodeListForm(req, model);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return "/admin/unitCost/JasUnitCostForm.tiles";
		}
		/**
		 * 기본 조업요율 리스트 조회
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/unitCost/UnitCostGridData.json")
		public String UnitCostGridData(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
				admCostService.getUnitCostGridData(req,model);
			return "UnitCostGridData.json";
		}
		/**
		 * 기본 조업요율 생성/수정 팝업
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/unitCost/UnitCostDetailPopup.popup")
		public String UnitCostDetailPopup(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
				admCostService.UnitCostDetailPopup(req,model);
			return "/admin/unitCost/JasJasUnitCostPopup.popup";
		}
		/**
		 * 기본 조업요율 팝업 ARP 선택
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/unitCost/UnitCostFindARP.json")
		public String UnitCostFindARP(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
				admCostService.UnitCostFindARP(req,model);
			return "UnitCostFindARP.json";
		}
		/**
		 * 기본 조업요율 생성/수정
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/unitCost/UnitCostSave.json")
		public String UnitCostSave(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
				admCostService.UnitCostSave(req,model);
			return "UnitCostSave.json";
		}
		/**
		 * 기본 조업요율 삭제
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping("/unitCost/deleteunitCost.json")
		public String deleteunitCost(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
				admCostService.deleteunitCost(req,model);
			return "deleteunitCost.json";
		}
}
