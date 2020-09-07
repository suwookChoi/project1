package com.jas.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.jfree.util.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@Repository
public class AdminUnitCostcDao extends SqlMapClientDaoSupport{

	@SuppressWarnings("deprecation")
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	
	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<HashMap<String, Object>> getUnitCostList(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admUnitCost.getUnitCostList",reqMap);
	}
	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<HashMap<String, Object>>  getSearchAirCraftData(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admUnitCost.getSearchAirCraftData",reqMap);
	}

	@SuppressWarnings("deprecation")
	public List<HashMap<String, Object>> getSearchDateData(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admUnitCost.getSearchDateData",reqMap);
	}
	@SuppressWarnings("deprecation")
	public Object getSearchARPData(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admUnitCost.getSearchARPData",reqMap);
	}
	/**
	 * 기본 조업요율 팝업 데이터
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public Object geUnitCosttDetailData(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForObject("admUnitCost.geUnitCosttDetailData",reqMap);
	}
	/**
	 * 기본 조업요율 수정
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public int EditUnitCostSave(HashMap<String, Object> reqMap) {
		Log.debug("DAO reaMap ::: "+reqMap);
		return this.getSqlMapClientTemplate().update("admUnitCost.EditUnitCostSave",reqMap);
	}
	/**
	 * 기본 조업요율 생성
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public int NewUnitCostSave(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("admUnitCost.NewUnitCostSave",reqMap);
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<HashMap<String,Object>> getArpList() {
		return this.getSqlMapClientTemplate().queryForList("admUnitCost.getArpList");

	}

	/**
	 * 기본 조업요율 생성 시 중복데이터 검사
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public int checkData(HashMap<String, Object> reqMap) {
		return (int) this.getSqlMapClientTemplate().queryForObject("admUnitCost.checkData",reqMap);
	}

	/**
	 * 코드 관리 삭제
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public int orgDeleteUnitCost(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().delete("admUnitCost.orgDeleteUnitCost",reqMap);
	}
	
	@SuppressWarnings("deprecation")
	public int deleteunitCost(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().delete("admUnitCost.deleteunitCost",reqMap);
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<HashMap<String, Object>> UnitCostFindAIR(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admUnitCost.UnitCostFindAIR",reqMap);
	}

	
}
