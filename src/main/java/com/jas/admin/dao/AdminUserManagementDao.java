package com.jas.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@SuppressWarnings("deprecation")
@Repository
public class AdminUserManagementDao extends SqlMapClientDaoSupport{
	
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient) {
		this.setSqlMapClient(sqlMapClient);
	}
	/**
	 * 사용자 리스트 가져오기
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> userManagementListForm(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admUsrMgt.userManagementListForm",reqMap);
	}
	/**
	 * 사용자 상세보기 정보 가져오기
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> usrUserInfoModifyPopup(HashMap<String, Object> reqMap) {
		return (HashMap<String, Object>)this.getSqlMapClientTemplate().queryForObject("admUsrMgt.usrUserInfoModify",reqMap);
	}
	/**
	 * 관리자 사용자 비밀번호 초기화
	 * @param model
	 * @throws Exception
	 */
	public int JASChangePWD(HashMap<String, Object> reqMap) { 
		return this.getSqlMapClientTemplate().update("admUsrMgt.JASChangePWD",reqMap); 
	}
	/**
	 * 사용자 이전 비밀번호 가져오기
	 * @param model
	 * @throws Exception
	 */
	public String getOldPWD(HashMap<String, Object> reqMap) {
		return (String) this.getSqlMapClientTemplate().queryForObject("admUsrMgt.getOldPWD",reqMap);
	}
	/**
	 * 사용자 신규등록
	 * @param model
	 * @throws Exception
	 */
	public int userRegisterUSRINFONT(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("admUsrMgt.userRegisterUSRINFONT",reqMap);
	}

	public int findUserManagementId(HashMap<String, Object> reqMap) {
		return (int)this.getSqlMapClientTemplate().queryForObject("admUsrMgt.findUserManagementId", reqMap);
	}
	/**
	 * 회사 리스트 가져오기
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getCompanyName(HashMap<String, Object> reqMap) {		
		return this.getSqlMapClientTemplate().queryForList("admUsrMgt.getCompanynm",reqMap);
	}
	/**
	 * 회사별 지점 리스트 가져오기
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> findARP(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admUsrMgt.findARP",reqMap);
	}
	/**
	 * 회사 지점별 부서 리스트 가져오기
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> usrFindDepartmentJSON(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admUsrMgt.usrFindDepartmentJSON",reqMap);
	}

	/**
	 * 계정 권한 리스트 가져오기
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getRoleList(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().queryForList("admUsrMgt.getRoleList",reqMap);
	}
	
	public int UserIdCompare(String userid) {
		return (int)this.getSqlMapClientTemplate().queryForObject("admUsrMgt.UserIdCompare",userid);
	}
	
	public int usrModifyUserManagement(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("admUsrMgt.updateUserManagement", reqMap);
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> findUserInfoNt(HashMap<String, Object> reqMap) {
		return (HashMap<String, Object>) this.getSqlMapClientTemplate().queryForObject("login.findUserInfoNt", reqMap);
	}

	/**
	 * 사용자 비밀번호 수정 
	 * @param model
	 * @throws Exception
	 */
	public int UserPasswordReset(HashMap<String, Object> reqMap) {
		return this.getSqlMapClientTemplate().update("admUsrMgt.UserPasswordReset",reqMap);
	}
	/**
	 * 사용자 정보 수정 
	 * @param model
	 * @throws Exception
	 */
	public int updateUserInfo(HashMap<String, Object> reqMap) {		
		return this.getSqlMapClientTemplate().update("admUsrMgt.updateUserInfo",reqMap);
	}
	/**
	 * 사용자 정보 삭제(사용 N으로 변경) 
	 * @param model
	 * @throws Exception
	 */
	public Object userInfoDelete(HashMap<String, Object> reqMap) {		
		return this.getSqlMapClientTemplate().update("admUsrMgt.userInfoDelete",reqMap);
	}
	/**
	 * 사용자 장비 리스트 가져오기 
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getEqmList(HashMap<String, Object> reqMap) {
		 return (HashMap<String, Object>) this.getSqlMapClientTemplate().queryForObject("admUsrMgt.getEqmList",reqMap);
	}
	/**
	 * 부서 및 지점 리스트 가져오기 
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getDeptName(HashMap<String, Object> reqMap) {
		 return (List<HashMap<String, Object>>) this.getSqlMapClientTemplate().queryForList("admUsrMgt.getDeptName",reqMap);
	}
	/**
	 * 전체 지점 리스트 가져오기 
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getARPList(HashMap<String, Object> reqMap) {
		return (List<HashMap<String, Object>>) this.getSqlMapClientTemplate().queryForList("admUsrMgt.getARPList",reqMap);
		
	}


}
