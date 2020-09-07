package com.jas.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@Repository
public class AdminSpotDao extends SqlMapClientDaoSupport{
	
	@SuppressWarnings("deprecation")
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}

	@SuppressWarnings("deprecation")
	public List<HashMap<String, Object>> getSpotList(HashMap<String, Object> reqMap) {
		return getSqlMapClientTemplate().queryForList("usrSpot.getSpotList", reqMap);
	}

	public int saveSpotData(HashMap<String, Object> reqMap) {
		return getSqlMapClientTemplate().update("usrSpot.saveSpotData", reqMap);
	}

	public int deleteSpotData(HashMap<String, Object> reqMap) {
		return getSqlMapClientTemplate().delete("usrSpot.deleteSpotData", reqMap);
	}

	public List<HashMap<String, Object>> getAprList() {
		return getSqlMapClientTemplate().queryForList("usrSpot.getAprList");
	}

	public HashMap<String, Object> getSpotData(HashMap<String, Object> reqMap) {
		return (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("usrSpot.getSpotData", reqMap);
	}

}
