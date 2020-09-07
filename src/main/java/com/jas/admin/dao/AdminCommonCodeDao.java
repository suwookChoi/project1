package com.jas.admin.dao;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.jfree.util.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.framework.dataHandler.dhtmlx.service.CommonAbstractService;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.jas.admin.dao.AdminUserManagementDao;

@SuppressWarnings("deprecation")
@Repository
public class AdminCommonCodeDao extends SqlMapClientDaoSupport{

	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	/**
	 * 공통코드관리 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getCommonCodeList(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admCmc.getCommonCodeList",reqMap);
	}
	/**
	 * 공통코드관리 수정 팝업 데이터
	 * @param model
	 * @throws Exception
	 */
	public Object JasCommonCodeModify(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForObject("admCmc.JasCommonCodeModify",reqMap);
	}
	/**
	 * 공통코드관리 수정
	 * @param model
	 * @throws Exception
	 */
	public int commonCodeModifySave(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("admCmc.commonCodeModifySave",reqMap);		
	}
	/**
	 * 공통코드관리 등록
	 * @param model
	 * @throws Exception
	 */
	public int commonCodeNewSave(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("admCmc.commonCodeNewSave",reqMap);	
	}
	/**
	 * 공통코드 관리 삭제
	 * @param model
	 * @throws Exception
	 */
	public int commonCodeDelete(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().delete("admCmc.commonCodeDelete",reqMap);	
	}
	public int CommoneCodeIdCheck(HashMap<String, Object> reqMap) {
		return (int) this.getSqlMapClientTemplate().queryForObject("admCmc.CommoneCodeIdCheck",reqMap);
	}
//	public int codeUseynChange(HashMap<String, Object> reqMap) {
//		return this.getSqlMapClientTemplate().update("admCmc.codeUseynChange",reqMap);
//	}
	/**
	 * 코드 관리 USE_YN 'N'으로 변경
	 * @param model
	 * @throws Exception
	 */
	public int changCodeUseYn(HashMap<String, Object> map) {
		return this.getSqlMapClientTemplate().update("admCmc.changCodeUseYn",map);
	}
	
 
	
}
