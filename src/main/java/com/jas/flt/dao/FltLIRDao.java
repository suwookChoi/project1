package com.jas.flt.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@SuppressWarnings("deprecation")
@Repository
public class FltLIRDao extends SqlMapClientDaoSupport{
	
	@SuppressWarnings("deprecation")
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	/**
	 * 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getLIRList(HashMap<String, Object> reqMap) {
		return getSqlMapClientTemplate().queryForList("fltLir.getLIRList", reqMap);
	}
	/**
	 *  항공사 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getFlcList() {
		return getSqlMapClientTemplate().queryForList("fltLir.getFlcList");
	}
	/**
	 *  PDF 파일 저장경로/파일명 저장
	 * @param model
	 * @throws Exception
	 */
	public int savePDFPath(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("fltLir.savePDFPath",reqMap);
	}
	/**
	 *  PDF 파일 저장경로/파일명 저장
	 * @param model
	 * @throws Exception
	 */
	public int deletePDFPath(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("fltLir.deletePDFPath",reqMap);
		
	}
	public int saveRCPDFPath(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("fltLir.saveRCPDFPath",reqMap);
	}
	

	public List<HashMap<String, Object>> getAfsList() {
		return getSqlMapClientTemplate().queryForList("fltLir.getAfsList");
		
	}
	public List<HashMap<String, Object>> getPakOprList() {
		return getSqlMapClientTemplate().queryForList("fltLir.getPakOprList");
	}


}
