<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.Board" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quotation Mark</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){ // 세션을 확인함
			userID = (String) session.getAttribute("userID"); // 자신에게 할당된 세션 아이디 저장
		}
		if(userID == null){ // 로그인이 되어 있지 않으면 게시글을 삭제할 수 없음
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다')");
			script.println("location.href = 'login.jsp'"); // 로그인 할 수 있도록 로그인 페이지로 이동
			script.println("</script>");
		}
		
		int writerID = 0; // 현재 게시글의 작성자 아이디를 알려주는 변수
		if (request.getParameter("writerID") != null) {
			writerID = Integer.parseInt(request.getParameter("writerID")); // 파라미터로 넘어온 작성자 아이디 값을 int 형으로 바꿔서 변수에 넣어줌
		}
		if (writerID == 0){ // 유효하지 않아서 접근이 불가능한 상태
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 게시글 입니다')");
			script.println("location.href = 'board.jsp'"); // 다시 게시판 페이지로 이동
			script.println("</script>");
		}
		
		Board board = new BoardDAO().getPost(writerID); // 해당 게시글을 가져옴
		if(!userID.equals(board.getUserID())){ // 로그인한 사용자가 작성한 게시글이 맞는지 확인 - 만약 아니라면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('게시글 삭제 권한이 없습니다')");
			script.println("location.href = 'board.jsp'"); // 다시 게시판 페이지로 이동
			script.println("</script>");
		} 
		else { // 게시글 삭제 권한이 있는 사용자라면
			BoardDAO boardDAO = new BoardDAO();
			int result = boardDAO.delete(writerID);
			if(result == -1) { // 데이터베이스 오류 발생
				PrintWriter script = response.getWriter();  
				script.println("<script>");
				script.println("alert('게시글 삭제에 실패했습니다')");
				script.println("history.back()");
				script.println("</script>");
			}
			else { // 게시글 삭제에 성공한 경우
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'board.jsp'"); // 게시판 메인 페이지로 이동
				script.println("</script>");
			}
		}

	%>
</body>
</html>