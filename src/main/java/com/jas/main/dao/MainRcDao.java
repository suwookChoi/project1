package com.jas.main.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@Repository
public class MainRcDao  extends SqlMapClientDaoSupport{

	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}

	public HashMap<String, Object> getRCData(HashMap<String, Object> reqMap) {		
		return (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("mainRc.getRCData", reqMap);
	}

	public int saveRc(HashMap<String, Object> reqMap) {
		return getSqlMapClientTemplate().update("mainRc.saveRc", reqMap);
	}
}
