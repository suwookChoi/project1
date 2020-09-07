package com.jas.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@Repository
public class AdminCodAirportDao extends SqlMapClientDaoSupport {

	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}	


	/**
	 *  공항 관리 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getAirportList(HashMap<String, Object> reqMap) throws DataAccessException {
		return (List<HashMap<String, Object>>)getSqlMapClientTemplate().queryForList("adminCodAirport.getAirportList", reqMap);
	}
	/**
	 *  공항 관리 중복 검사
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> findAirport(HashMap<String, Object> reqMap) {
		return getSqlMapClientTemplate().queryForList("adminCodAirport.findAirport", reqMap);
	}
	/**
	 *  공항 관리 생성
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> createAirport(HashMap<String, Object> reqMap) throws DataAccessException {
		return (HashMap<String, Object>)getSqlMapClientTemplate().insert("adminCodAirport.createAirport", reqMap);
	}
	/**
	 *  공항 관리 상세
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectAirport(HashMap<String, Object> params) throws DataAccessException {
		return (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("adminCodAirport.selectAirport", params);
	}

	/**
	 * 공항 관리 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public void deleteAirport(HashMap<String, Object> param){
		getSqlMapClientTemplate().update("adminCodAirport.deleteAirport", param);
	}
}
