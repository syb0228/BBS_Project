// database access
// 데이터 접근 객체

package member;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import board.Board;
import member.Member;

public class MemberDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public MemberDAO() { // 데이터베이스 연결
		try {
			String dbURL = "jdbc:mysql://localhost:3306";
			String dbID = "DB 아이디";
			String dbPassword = "DB 비밀번호";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public int login(String userID, String userPassword) { // 로그인 함수
			String SQL = "SELECT userPassword FROM MEMBER WHERE userID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1,  userID);
				rs = pstmt.executeQuery();
				if(rs.next()) { // 아이디가 존재하는 경우
					if(rs.getString(1).equals(userPassword))
						return 1; // 비밀번호가 일치하는 경우 - 로그인 성공
					else
						return 0; // 비밀번호가 일치하지 않는 경우
				}
				return -1; // 아이디가 존재하지 않는 경우
			} catch(Exception e) {
				e.printStackTrace();
			}
			return -2; // 데이터베이스 오류 발생시
	}
	
	public int join(Member user) { // 회원 가입 함수
		String SQL = "INSERT INTO MEMBER VALUES(?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			
			return pstmt.executeUpdate(); // 해당 statement를 실행한 결과를 삽입 - 회원가입 성공
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 발생시
	}
	
	public Member getInfo(String userID) { // 특정 회원 정보를 불러오는 함수
		String SQL = "SELECT * FROM MEMBER WHERE userID = ?"; // 특정 아이디에 해당하는 회원 정보를 가져옴
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Member member = new Member();
				member.setUserID(rs.getString(1));
				member.setUserPassword(rs.getString(2));
				member.setUserName(rs.getString(3));
				member.setUserGender(rs.getString(4));
				member.setUserEmail(rs.getString(5));
				
				return member; // 특정 회원 정보를 반환
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null; // 회원 정보가 존재하지 않는 경우
	}
	
	public int update(String userID, String userPassword, String userName, String userEmail) { // 회원 정보 수정 - 아이디 성별은 변경 불가능
		String SQL = "UPDATE MEMBER SET userPassword = ?, userName = ?, userEmail = ? WHERE userID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  userPassword);
			pstmt.setString(2,  userName);
			pstmt.setString(3, userEmail);
			pstmt.setString(4, userID);

			return pstmt.executeUpdate(); // 성공적으로 실행한 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 발생 시 -1 반환
	}

}
