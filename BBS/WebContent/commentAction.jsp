<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="comment.CommentDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="comment" class="comment.Comment" scope="page" />
<jsp:setProperty name="comment" property="commentContent" />
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
		
		if(userID == null){ // 로그인이 되어 있지 않으면 댓글을 작성할 수 없음
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다')");
			script.println("location.href = 'login.jsp'"); // 로그인 할 수 있도록 로그인 페이지로 이동
			script.println("</script>");
		}
		else {
			// 내용을 입력하지 않은 경우
			if (comment.getCommentContent() == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('내용을 입력하세요')");
				script.println("history.back()");
				script.println("</script>");
			}
			else {
				CommentDAO commentDAO = new CommentDAO();
				int result = commentDAO.comment(writerID, userID, comment.getCommentContent());
				
				if(result == -1) { // 데이터베이스 오류 발생
					PrintWriter script = response.getWriter();  
					script.println("<script>");
					script.println("alert('댓글 작성에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				}
				else { // 성공적으로 댓글을 작성한 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글 작성에 성공했습니다')");
					script.println("location.href = 'board.jsp'");
					script.println("</script>");
				}
			}
		}

	%>
</body>
</html>