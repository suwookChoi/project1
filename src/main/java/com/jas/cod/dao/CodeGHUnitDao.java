package com.jas.cod.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@Repository
public class CodeGHUnitDao extends SqlMapClientDaoSupport{
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	
	public List<HashMap<String, Object>> getGHUnitList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("cod_ghUnit.getGHUnitList",reqMap);
	}

	public void insertGHUnit(Map<String, Object> map) {
		getSqlMapClientTemplate().insert("cod_ghUnit.insertGHUnit",map);
	}

}
