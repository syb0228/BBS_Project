package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import comment.Comment;

public class CommentDAO {
	private Connection conn;
	private ResultSet rs;
	
	public CommentDAO() { // 데이터베이스 연결
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
	
	public int getNext() { // 새로 작성할 댓글의 번호를 가져오는 함수
		String SQL = "SELECT commentID FROM COMMENT ORDER BY commentID DESC";
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
	
	public int comment(int writerID, String userID, String commentContent) { // 새로 작성한 게시글을 데이터베이스에 삽입
		String SQL = "INSERT INTO COMMENT VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext());
			pstmt.setInt(2,  writerID);
			pstmt.setString(3,  userID);
			pstmt.setString(4,  getDate());
			pstmt.setString(5,  commentContent);
			pstmt.setInt(6,  1); // 처음엔 삭제가 안된 상태이므로
			
			return pstmt.executeUpdate(); // 성공적으로 실행한 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 발생 시 -1 반환
	}
	
	public ArrayList<Comment> getList(int writerID){ // 특정 게시글에 달린 댓글 리스트를 보여줌
		String SQL = "SELECT * FROM COMMENT WHERE writerID = ? AND commentAvailable = 1 ORDER BY commentID DESC";
		ArrayList<Comment> list = new ArrayList<Comment>(); // 댓글 리스트
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, writerID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Comment comment = new Comment();
				comment.setCommentID(rs.getInt(1));
				comment.setWriterID(rs.getInt(2));
				comment.setUserID(rs.getString(3));
				comment.setCommentDate(rs.getString(4));
				comment.setCommentContent(rs.getString(5));
				comment.setCommentAvailable(rs.getInt(6));
				
				list.add(comment); // 리스트에 데이터가 저장된 인스턴스를 넣음
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list; // 댓글 리스트를 반환해줌
	}
	
	public Comment getComment(int commentID) { // 하나의 댓글을 불러오는 함수
		String SQL = "SELECT * FROM COMMENT WHERE commentID = ?"; // 특정 댓글을 가져옴
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Comment comment = new Comment();
				comment.setCommentID(rs.getInt(1));
				comment.setWriterID(rs.getInt(2));
				comment.setUserID(rs.getString(3));
				comment.setCommentDate(rs.getString(4));
				comment.setCommentContent(rs.getString(5));
				comment.setCommentAvailable(rs.getInt(6));
				
				return comment; // 해당 댓글의 정보를 반환
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null; // 댓글이 존재하지 않는 경우
	}
	
	public int update(int commentID, String commentContent) { // 댓글 수정
		String SQL = "UPDATE COMMENT SET commentContent = ? WHERE commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  commentContent);
			pstmt.setInt(2, commentID);

			return pstmt.executeUpdate(); // 성공적으로 실행한 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 발생 시 -1 반환
	}
	
	public int delete(int commentID) { // 댓글 삭제
		String SQL = "UPDATE COMMENT SET commentAvailable = 0 WHERE commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);

			return pstmt.executeUpdate(); // 성공적으로 실행한 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 발생 시 -1 반환
	}
}