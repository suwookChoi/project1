package com.jas.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@SuppressWarnings("deprecation")
@Repository
public class AdminCodeDao extends SqlMapClientDaoSupport{

	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	/**
	 * 코드관리 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getCodeGridData(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admCode.getCodeGridData",reqMap); 
	}
	/**
	 * 코드관리 수정 팝업 데이터
	 * @param model
	 * @throws Exception
	 */
	public HashMap<String, Object> JasCodeDetailData(HashMap<String, Object> reqMap) {
		return (HashMap<String, Object>) this.getSqlMapClientTemplate().queryForObject("admCode.JasCodeDetailData",reqMap);
	}

	public List<HashMap<String, Object>> getCMCCodeType(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admCode.getCMCCodeType",reqMap);
	}

	/**
	 * 코드관리 수정
	 * @param model
	 * @throws Exception
	 */
	public int editCodeSave(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("admCode.editCodeSave",reqMap);
	}
	/**
	 * 코드관리 생성
	 * @param model
	 * @throws Exception
	 */
	public int newCodeSave(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("admCode.newCodeSave",reqMap);
	}
	/**
	 * 코드 관리 삭제
	 * @param model
	 * @throws Exception
	 */
	public int codeDelete(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().delete("admCode.codeDelete",reqMap);
	}
	public int checkCodeId(HashMap<String, Object> reqMap) {
		return (int) this.getSqlMapClientTemplate().queryForObject("admCode.checkCodeId",reqMap) ;
	}
	
}
