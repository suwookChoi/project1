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
public class FltAfsDao extends SqlMapClientDaoSupport {
	
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	
	/**
	 * 공항 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getArpInfo(HashMap<String, Object> params) throws DataAccessException {
		return getSqlMapClientTemplate().queryForList("fltAfs.getArpInfo", params);
	}
	
	/**
	 * 일일 스케줄 현황 리스트 조회
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getAfsList(HashMap<String, Object> reqMap) throws DataAccessException {
		return (List<HashMap<String, Object>>)getSqlMapClientTemplate().queryForList("fltAfs.getAfsList", reqMap);
	}
}
