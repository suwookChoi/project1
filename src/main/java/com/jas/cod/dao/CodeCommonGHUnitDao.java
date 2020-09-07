package com.jas.cod.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@Repository
public class CodeCommonGHUnitDao extends SqlMapClientDaoSupport{
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	
	public List<HashMap<String, Object>> getCommonGHUnitList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("cod_commonGHUnit.getCommonGHUnitList",reqMap);
	}

	public String getCommonGHUnitCheckID(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return (String) getSqlMapClientTemplate().queryForObject("cod_commonGHUnit.getCommonGHUnitCheckID",reqMap);
	}

	public int saveCommonGHUnit(HashMap<String, Object> reqMap) {
		return (int) getSqlMapClientTemplate().update("cod_commonGHUnit.saveCommonGHUnit", reqMap);
	}

	public void deleteCommonGHUnit(HashMap<String, Object> map) {
		getSqlMapClientTemplate().delete("cod_commonGHUnit.deleteCommonGHUnit",map);
		
	}

	public void deleteGHUnit(HashMap<String, Object> map) {
		getSqlMapClientTemplate().delete("cod_commonGHUnit.deleteGHUnit",map);
	}

}
