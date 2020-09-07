package com.jas.cod.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.framework.initialize.CodeHandler;

@Controller
public class CodeCacheController {

	private Logger log = Logger.getLogger(this.getClass());
	
	@RequestMapping("/cod/cache/codeCacheReload.ajax")
	public void codeCacheReload(HttpServletRequest request
			, HttpServletResponse response, Model model, @ModelAttribute("tbNm") String tbNm)throws Exception{
		
		log.debug("######################################################");
		log.debug("################## codeCacheReload ###################");
		log.debug("######################################################");
		
		if(tbNm != null && !"".equals(tbNm)){
			log.debug("### table name : " + tbNm);
			CodeHandler.cdhdlReloadCd(tbNm);
		}
		response.setContentType("application/javascript");
		response.getWriter().write("reloadCallback();");
	}
	
	@RequestMapping("/cod/cache/codeCacheDozenReload.ajax")
	public void codeCacheDozenReload(HttpServletRequest request
			, HttpServletResponse response, Model model, @ModelAttribute("tbNm") String tbNm)throws Exception{
		
		log.debug("######################################################");
		log.debug("############### codeCacheDozenReload #################");
		log.debug("######################################################");
		
		if(tbNm != null && !"".equals(tbNm)){
			log.debug("### table name : " + tbNm);
			String[] arrTableName = tbNm.split(",");
			CodeHandler.cdhdlReloadCd(arrTableName);
		}
		response.setContentType("application/javascript");
		response.getWriter().write("reloadCallback();");
	}
	
	@RequestMapping("/cod/cache/commonCodeReload.ajax")
	public void commonCodeReload(HttpServletRequest request, HttpServletResponse response, Model model)throws Exception{
		log.debug("######################################################");
		log.debug("################# commonCodeReload ###################");
		log.debug("######################################################");
		
		CodeHandler.commCdReload();
		response.setContentType("application/javascript");
		response.getWriter().write("reloadCallback();");
	}
	
	@RequestMapping("/cod/cache/menuRoleReload.ajax")
	public void menuRoleReload(HttpServletRequest request, HttpServletResponse response, Model model)throws Exception{
		log.debug("######################################################");
		log.debug("################# menuRoleReload ###################");
		log.debug("######################################################");
		
		CodeHandler.menuRoleReload();
		response.setContentType("application/javascript");
		response.getWriter().write("reloadCallback();");
	}
	
	@RequestMapping("/cod/cache/codeCacheAllReload.ajax")
	public void codeCacheAllReload(HttpServletRequest request, HttpServletResponse response, Model model)throws Exception{
		log.debug("######################################################");
		log.debug("################# codeCacheAllReload #################");
		log.debug("######################################################");

		CodeHandler.cdhdlLoadCd();
		response.setContentType("application/javascript");
		response.getWriter().write("reloadCallback();");
	}
}
