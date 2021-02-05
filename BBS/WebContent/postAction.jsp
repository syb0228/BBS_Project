<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="board" class="board.Board" scope="page" />
<jsp:setProperty name="board" property="postTitle" />
<jsp:setProperty name="board" property="postContent" />
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
		if(userID == null){ // 로그인이 되어 있지 않으면 게시글을 작성할 수 없음
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다')");
			script.println("location.href = 'login.jsp'"); // 로그인 할 수 있도록 로그인 페이지로 이동
			script.println("</script>");
		}
		else {
			// 2개 항목 중에서 하나라도 입력하지 않은 항목이 있는 경우
			if (board.getPostTitle() == null || board.getPostContent() == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력되지 않은 항목이 있습니다')");
				script.println("history.back()");
				script.println("</script>");
			}
			else {
				BoardDAO boardDAO = new BoardDAO();
				int result = boardDAO.post(board.getPostTitle(), userID, board.getPostContent());
				if(result == -1) { // 데이터베이스 오류 발생
					PrintWriter script = response.getWriter();  
					script.println("<script>");
					script.println("alert('게시글 작성에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				}
				else { // 성공적으로 게시글을 작성한 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'board.jsp'"); // 게시판 메인 페이지로 이동
					script.println("</script>");
				}
			}
		}

	%>
</body>
</html>