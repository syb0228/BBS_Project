package myfile;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import board.Board;

public class MyfileDAO {
	private Connection conn;
	private ResultSet rs;
	
	public MyfileDAO() {
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
	
	public String getDate() { // 현재 날짜를 가져오는 함수
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // 데이터베이스에 접근할 때 충돌이 생기지 않도록 하기 위해 내부에 정의
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1); // 현재 날짜를 그대로 리턴
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류 발생 시 빈 문자열 반환
	}
	
	public int upload(String userID, String fileName, String fileRealName) { // 파일 업로드
		String SQL = "INSERT INTO MYFILE VALUES (?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, fileName);
			pstmt.setString(3, fileRealName);
			pstmt.setString(4, getDate());
			
			return pstmt.executeUpdate();			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public ArrayList<Myfile> getList(){
		String SQL = "SELECT * FROM MYFILE";
		ArrayList<Myfile> list = new ArrayList<Myfile>(); // 하나의 페이지에서 보여줄 게시글 리스트
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Myfile myfile = new Myfile();
				myfile.setUserID(rs.getString(1));
				myfile.setFileName(rs.getString(2));
				myfile.setFileRealName(rs.getString(3));
				myfile.setUploadDate(rs.getString(4));
				
				list.add(myfile); // 리스트에 데이터가 저장된 인스턴스를 넣음
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list; // 10개로 뽑힌 리스트를 반환해줌
	}
}
