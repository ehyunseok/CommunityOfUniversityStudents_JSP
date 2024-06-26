package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import util.DatabaseUtil;

public class UserDao {
	
//로그인
	public int login(String userID, String userPassword) {
		
		String SQL = "SELECT userPassword FROM user WHERE userID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword)) {
					return 1;	// 로그인 성공
				} else {
					return 0;	// 비번 틀림
				}
			}
			return -1;	// 아이디 없음
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return -2; // db 오류

	}
	
	
//회원가입
	public int join(UserDto user) {
		String SQL = "INSERT INTO user VALUES(?, ?, ?, ?, ?);";
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserEmail());
			pstmt.setString(4, user.getUserEmailHash());
			pstmt.setBoolean(5, Boolean.parseBoolean(user.getUserEmailChecked()));
			return pstmt.executeUpdate();	// 회원가입 성공
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return -1; // 회원가입 실패
	}
	
//회원 아이디 중복 확인
	public boolean checkDuplication(String userID) {
		
		String SQL = "SELECT userID FROM user WHERE userID = ?;";
		
		try(Connection conn = DatabaseUtil.getConnection()){
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			try(ResultSet rs = pstmt.executeQuery()){
				return rs.next();	//중복된 아이디일 경우 next()가 true를 반환함
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
//이메일 인증 상태 확인
	public boolean getUserEmailChecked(String userID) {
		
		String SQL = "SELECT userEmailChecked FROM user WHERE userID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getBoolean(1);	// 이메일 인증이 완료된 사용자일 경우 true 반환 
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return false;
	}

	
//이메일 인증 완료 처리
	public boolean setUserEmailChecked(String userID) {
		
		String SQL = "UPDATE user SET userEmailChecked = true WHERE userID = ?;";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
			return true;
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return false;
	}
	
	
//회원 이메일 조회
	public String getUserEmail(String userID) {
		
		String SQL = "SELECT userEmail FROM user WHERE userID = ?;";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch(Exception e ) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch(Exception e ) {e.printStackTrace();}
		}
		return null;
	}
	
// userID를 검증하는 메소드
	public boolean isValidUser(String userID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT COUNT(*) FROM user WHERE userID = ?";
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			System.out.println("userDao-userID : " + userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) > 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return false; 
	}	
	
}
