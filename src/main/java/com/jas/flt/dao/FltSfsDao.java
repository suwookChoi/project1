package com.jas.flt.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * @author Administrator
 *
 */
@SuppressWarnings("deprecation")
@Repository
public class FltSfsDao extends SqlMapClientDaoSupport {
	
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	
	/**
	 * 시즌 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSSCInfo(HashMap<String, Object> params) throws DataAccessException {
		return getSqlMapClientTemplate().queryForList("fltSfs.getSSCInfo", params);
	}
	
	/**
	 * 버전 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getRevisionInfo(HashMap<String, Object> params) throws DataAccessException {
		return getSqlMapClientTemplate().queryForList("fltSfs.getRevisionInfo", params);
	}
	
	/**
	 * 항공사 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getFlcInfo(HashMap<String, Object> params) throws DataAccessException {
		return getSqlMapClientTemplate().queryForList("fltSfs.getFlcInfo", params);
	}
	
	/**
	 * 공항 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getArpInfo(HashMap<String, Object> params) throws DataAccessException {
		return getSqlMapClientTemplate().queryForList("fltSfs.getArpInfo", params);
	}
	
	/**
	 * 시즌 스케줄 현황 리스트 조회 
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSfsList(HashMap<String, Object> reqMap) throws DataAccessException {
		return (List<HashMap<String, Object>>)getSqlMapClientTemplate().queryForList("fltSfs.getSfsList", reqMap);
	}
	
	/**
	 * 시즌 스케줄 신규/상세
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectSfsInfo(HashMap<String, Object> params) throws DataAccessException {
		return (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("fltSfs.selectSfsInfo", params);
	}
	
	/**
	 * 시즌 스케줄 신규/상세 중복체크
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> findSfsSchedule(HashMap<String, Object> reqMap) {
		return getSqlMapClientTemplate().queryForList("fltSfs.findSfsSchedule", reqMap);
	}
	
	/**
	 * 시즌 스케줄 신규
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> createSfsSchedule(HashMap<String, Object> reqMap) throws DataAccessException {
		return (HashMap<String, Object>)getSqlMapClientTemplate().insert("fltSfs.createSfsSchedule", reqMap);
	}
	
	/**
	 * Local을 UTC로 변환
	 * yyyyMMddHHmm -> yyyyMMdd
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> LocalToUtcSSC(HashMap<String, Object> reqMap) throws DataAccessException {
		return (HashMap<String, Object>)getSqlMapClientTemplate().queryForObject("fltSfs.LocalToUtcSSC", reqMap);
	}
	
	/**
	 * Local을 UTC로 변환
	 * HHmm -> HHmm
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> LocalToUtcST(HashMap<String, Object> reqMap) throws DataAccessException {
		return (HashMap<String, Object>)getSqlMapClientTemplate().queryForObject("fltSfs.LocalToUtcST", reqMap);
	}
	
	/**
	 * UTC를 Local로 변환
	 * yyyyMMddHHmm -> yyyyMMdd
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> UtcToLocalSSC(HashMap<String, Object> reqMap) throws DataAccessException {
		return (HashMap<String, Object>)getSqlMapClientTemplate().queryForObject("fltSfs.UtcToLocalSSC", reqMap);
	}
	
	/**
	 * 시즌 스케줄 삭제
	 * @param model
	 * @throws Exception
	 */
	public void deleteSfsList(HashMap<String, Object> param){
		getSqlMapClientTemplate().update("fltSfs.deleteSfsList", param);
	}
}
