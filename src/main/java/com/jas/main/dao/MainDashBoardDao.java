package com.jas.main.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;
import org.springframework.ui.Model;

import com.ibatis.sqlmap.client.SqlMapClient;

@Repository
public class MainDashBoardDao extends SqlMapClientDaoSupport{
	@Autowired
	protected void initDAO(SqlMapClient sqlMapClient){
		this.setSqlMapClient(sqlMapClient);
	}
	public List<HashMap<String, Object>> getDashBoardList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getDashBoardList", reqMap);
	}
	public List<HashMap<String, Object>> getDashBoardListTab(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getDashBoardListTab", reqMap);
	}
	public List<HashMap<String, Object>> getGHOprList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getGHOprList", reqMap);
	}
	public List<HashMap<String, Object>> getGHUnitList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getGHUnitList", reqMap);
	}
	/**
	 *  비정상 팝업
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectEmr(HashMap<String, Object> params) throws DataAccessException {
		return (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("mainDashBoard.selectEmr", params);
	}
	
	/**
	 * 비정상 팝업 저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public void dashEMRSave(HashMap<String, Object> reqMap) {
		getSqlMapClientTemplate().insert("mainDashBoard.dashEMRSave", reqMap);
	}
	/**
	 *  전달사항 팝업
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectRmk(HashMap<String, Object> params) throws DataAccessException {
		return (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("mainDashBoard.selectRmk", params);
	}
	/**
	 * 전달사항 저장
	 * @param request
	 * @param model
	 * @return 
	 * @throws Exception
	 */
	public HashMap<String, Object> dashRMKSave(HashMap<String, Object> reqMap) {
		return (HashMap<String, Object>) getSqlMapClientTemplate().insert("mainDashBoard.dashRMKSave", reqMap);
	}	
	
	public List<HashMap<String, Object>> getDashTeamList(HashMap<String, Object> param) throws Exception {
		
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getDashTeamList", param);
	}
	
	
	public List<HashMap<String, Object>> getDashGhTeamUserList(HashMap<String, Object> param) throws Exception {
		
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getDashGhTeamUserList", param);
	}
	
	
	public int saveDashTeamUser(HashMap<String, Object> param) throws Exception {
		
		return getSqlMapClientTemplate().update("mainDashBoard.insertDashTeamUser", param);
	}
	public int deleteDashTeamUser(HashMap<String, Object> param) throws Exception {
		
		return getSqlMapClientTemplate().delete("mainDashBoard.deleteDashTeamUser", param);
	}
	
	public int addDashTeam(HashMap<String, Object> param) throws Exception {
		
		return getSqlMapClientTemplate().delete("mainDashBoard.addDashTeam", param);
	}
	public int deleteDashTeam(HashMap<String, Object> param) throws Exception {
		
		return getSqlMapClientTemplate().delete("mainDashBoard.deleteDashTeam", param);
	}
	public void createDailyTeamSkd(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		getSqlMapClientTemplate().insert("mainDashBoard.createDailyTeamSkd",param);
	}
	public List<HashMap<String, Object>> getDefaultUserList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getDefaultUserList",reqMap);
	}
	public void createDailyTeamUserSkd(HashMap<String, Object> paramMap) {
		// TODO Auto-generated method stub
		getSqlMapClientTemplate().insert("mainDashBoard.createDailyTeamUserSkd",paramMap);
	}
	public void saveGHTeam(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		getSqlMapClientTemplate().insert("mainDashBoard.saveGHTeam",reqMap);
		
	}
	public List<HashMap<String, Object>> getEQList(HashMap<String,Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getEQList",reqMap);
	}
	public void insertGHUnitLoad(Map<String, Object> map) {
		getSqlMapClientTemplate().insert("mainDashBoard.insertGHUnitLoad",map);
		
	}
	public void deleteGHUnitLoad(Map<String, Object> map) {
		getSqlMapClientTemplate().insert("mainDashBoard.deleteGHUnitLoad",map);
		
	}
	public List<HashMap<String,Object>> getEQUseList(HashMap<String,Object>map) {
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getEQUseList",map);
	}
	public List<HashMap<String, Object>> getDashGhNoTeamUserList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getDashGhNoTeamUserList", param);
		}
	public Object getGHTeamDayList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getGHTeamDayList",param);
	}
	public Map<String, Object> getPriceInfo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return (Map<String, Object>) getSqlMapClientTemplate().queryForObject("mainDashBoard.getPriceInfo",param);
	}
	public List<HashMap<String,Object>> getRMKEMRList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getRMKEMRList",reqMap);
	}
	public String selectEQ_FLAG(Map<String, Object> param) {
		return (String) getSqlMapClientTemplate().queryForObject("mainDashBoard.selectEQ_FLAG",param);
		
	}
	public void saveGHEQList(Map<String, Object> param) {
		getSqlMapClientTemplate().insert("mainDashBoard.saveGHEQList",param);
		
	}
	public List<HashMap<String,Object>> getGHEQOprList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getGHEQOprList",reqMap);
	}
	public List<HashMap<String, Object>> getDashUserInfo(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return  getSqlMapClientTemplate().queryForList("mainDashBoard.getDashUserInfo",param);
	}
	public List<HashMap<String, Object>> getAssignTeamList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return  getSqlMapClientTemplate().queryForList("mainDashBoard.getAssignTeamList",reqMap);
	}
	public void updateEQSignInfo(HashMap<String, Object> reqMap) {
		getSqlMapClientTemplate().update("mainDashBoard.updateEQSignInfo",reqMap);
		
	}
	public Map<String, Object> getRcLirPathInfo(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return (Map<String, Object>) getSqlMapClientTemplate().queryForObject("mainDashBoard.getRcLirPathInfo", reqMap);
	}
	public void deleteEQList(Map<String, Object> map) {
		getSqlMapClientTemplate().delete("mainDashBoard.deleteEQList",map);
		
	}
	public void deleteSignInfo(HashMap<String, Object> reqMap) {
		getSqlMapClientTemplate().update("mainDashBoard.deleteSignInfo",reqMap);
	}
	
	/**
	 * PDF
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> ghSlipList(HashMap<String, Object> reqMap) throws DataAccessException {
		return (List<HashMap<String, Object>>)getSqlMapClientTemplate().queryForList("mainDashBoard.ghSlipList", reqMap);
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectArpList(HashMap<String, Object> params) throws DataAccessException {
		return (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("mainDashBoard.selectArpList", params);
	}
	public HashMap<String, Object> getFlightInfo(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("mainDashBoard.getFlightInfo", reqMap);
	}
	
	/**
	 * RC CheckList 저장
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public int RCCheckSave(HashMap<String, Object> reqMap) {		
		return getSqlMapClientTemplate().update("mainDashBoard.RCCheckSave", reqMap);
	}
	
	/**
	 * RC Data 
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public HashMap<String, Object> getRCData(HashMap<String, Object> reqMap) {		
		return (HashMap<String, Object>) getSqlMapClientTemplate().queryForObject("mainDashBoard.getRCData", reqMap);
	}
	public Object getArpTeamList(HashMap<String, Object> reqMap) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("mainDashBoard.getArpTeamList",reqMap);
	}
}
