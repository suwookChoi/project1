package com.jas.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@SuppressWarnings("deprecation")
@Repository
public class AdminGroupDao extends SqlMapClientDaoSupport{
	
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	/**
	 * 조직관리 리스트 데이터
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> JasGroupListGridData(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("adGroup.JasGroupListGridData",reqMap); 
	}
//	@SuppressWarnings("unchecked")
//	public List<HashMap<String, Object>> getARP() {
//		return this.getSqlMapClientTemplate().queryForList("adGroup.getARP");
//	}

	public int checkDeptCode(HashMap<String, Object> reqMap) {		
		return (int)this.getSqlMapClientTemplate().queryForObject("adGroup.checkDeptCode",reqMap);
	}
	/**
	 * 조직관리 데이터 등록 
	 * @param request
	 * @param model
	 */
	
	public int doGroupSave(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("adGroup.doGroupSave",reqMap);
	}
	/**
	 * 조직관리 데이터 수정 
	 * @param request
	 * @param model
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getGroupData(HashMap<String, Object> reqMap) {
		return (HashMap<String, Object>) this.getSqlMapClientTemplate().queryForObject("adGroup.getGroupData",reqMap);
	}
	public int doGroupEditSave(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("adGroup.doGroupEditSave",reqMap);
	}
	/**
	 * 조직관리 삭제 
	 * @param request
	 * @param model
	 */
	
	public int deleteData(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("adGroup.deleteData",reqMap);
	}
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getPARDept(HashMap<String, Object> reqMap) {
		return (HashMap<String, Object>) this.getSqlMapClientTemplate().queryForObject("adGroup.getPARDept",reqMap);
	}
	public int idCheckJson(HashMap<String, Object> reqMap) {
		return (int)this.getSqlMapClientTemplate().queryForObject("adGroup.idCheckJson", reqMap);
	}
	public int changeUseLowDept(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("adGroup.changeUseLowDept",reqMap);
	}
	public List<HashMap<String, Object>> HighDeptList(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("adGroup.HighDeptList",reqMap); 
	}
	/*
	 public List<HashMap<String, Object>> findHighDept(HashMap<String, Object> reqMap) {
	 
		return this.getSqlMapClientTemplate().queryForList("adGroup.findHighDept",reqMap);
	}*/
}
