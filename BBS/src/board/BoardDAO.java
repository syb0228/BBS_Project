// 데이터 접근 객체

package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BoardDAO {
	private Connection conn;
	private ResultSet rs;
	
	public BoardDAO() { // 데이터베이스 연결
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
	
	public int getNext() { // 새로 작성할 게시글의 번호를 가져오는 함수
		String SQL = "SELECT writerID FROM BOARD ORDER BY writerID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // 데이터베이스에 접근할 때 충돌이 생기지 않도록 하기 위해 내부에 정의
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1; // 마지막 번호의 다음 번호를 리턴
			}
			return 1; // 새로 작성할 게시글이 첫 번째 게시글인 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 발생 시 -1 반환
	}
	
	public int post(String postTitle, String userID, String postContent) { // 새로 작성한 게시글을 데이터베이스에 삽입
		String SQL = "INSERT INTO BOARD VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext());
			pstmt.setString(2,  postTitle);
			pstmt.setString(3,  userID);
			pstmt.setString(4,  getDate());
			pstmt.setString(5,  postContent);
			pstmt.setInt(6,  1); // 처음엔 삭제가 안된 상태이므로
			return pstmt.executeUpdate(); // 성공적으로 실행한 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 발생 시 -1 반환
	}
	
	
	public ArrayList<Board> getList(int pageNo){ // 특정 페이지에서 최대 10개의 게시글 리스트를 보여줌
		// 게시판에 작성된 전체 게시글을 특정 페이지 넘버에 맞게 나눠서 리스트로 출력
		// 이때 삭제되지 않은 게시글의 수만 고려해야 함
		String SQL = "SELECT * FROM BOARD WHERE WriterID < ? AND postAvailable = 1 ORDER BY writerID DESC LIMIT 10";
		ArrayList<Board> list = new ArrayList<Board>(); // 하나의 페이지에서 보여줄 게시글 리스트
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNo - 1) * 10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Board board = new Board();
				board.setWriterID(rs.getInt(1));
				board.setPostTitle(rs.getString(2));
				board.setUserID(rs.getString(3));
				board.setPostDate(rs.getString(4));
				board.setPostContent(rs.getString(5));
				board.setPostAvailable(rs.getInt(6));
				
				list.add(board); // 리스트에 데이터가 저장된 인스턴스를 넣음
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list; // 10개로 뽑힌 리스트를 반환해줌
	}
	
	public boolean nextPage(int pageNo) { // Paging - 10개씩 하나의 페이지를 이루고 그 외에 나머지는 다음 페이지로 나누기 위함
		String SQL = "SELECT * FROM BOARD WHERE WriterID < ? AND postAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNo - 1) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) { // 게시글이 하나라도 있으면
				return true; // 다음 페이지로 넘어갈 수 있음
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false; // 다음 페이지로 넘어갈 수 없음
	}
	
	public Board getPost(int writerID) { // 하나의 게시글을 불러오는 함수
		String SQL = "SELECT * FROM BOARD WHERE writerID = ?"; // 특정 작성자 아이디에 해당하는 게시글을 가져옴
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, writerID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Board board = new Board();
				board.setWriterID(rs.getInt(1));
				board.setPostTitle(rs.getString(2));
				board.setUserID(rs.getString(3));
				board.setPostDate(rs.getString(4));
				board.setPostContent(rs.getString(5));
				board.setPostAvailable(rs.getInt(6));
				
				return board; // 해당 게시글의 정보를 반환
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null; // 게시글이 존재하지 않는 경우
	}
	
	public int update(int writerID, String postTitle, String postContent) { // 게시글의 제목과 내용을 수정
		String SQL = "UPDATE BOARD SET postTitle = ?, postContent = ? WHERE writerID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  postTitle);
			pstmt.setString(2,  postContent);
			pstmt.setInt(3, writerID);

			return pstmt.executeUpdate(); // 성공적으로 실행한 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 발생 시 -1 반환
	}
	
	public int delete(int writerID) { // 게시글 삭제
		String SQL = "UPDATE BOARD SET postAvailable = 0 WHERE writerID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, writerID);

			return pstmt.executeUpdate(); // 성공적으로 실행한 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 발생 시 -1 반환
	}
	
	public Board delete_check(int writerID) { // 삭제된 게시글 열람을 차단하기 위한 함수
		String SQL = "SELECT writerID FROM BOARD WHERE writerID = ? AND postAvailable = 1"; // 특정 writeID의 삭제 여부를 확인
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, writerID);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				Board board = new Board();
				board.setWriterID(rs.getInt(1));
				
				return board; // 유효한 게시글인 경우 게시글 정보 반환
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null; // 삭제된 게시글인 경우
	}
	
}
