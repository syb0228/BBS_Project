<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="comment.CommentDAO" %>
<%@ page import="comment.Comment" %>
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
		if(userID == null){ // 로그인이 되어 있지 않으면 게시글을 수정할 수 없음
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다')");
			script.println("location.href = 'login.jsp'"); // 로그인 할 수 있도록 로그인 페이지로 이동
			script.println("</script>");
		}
		
		int commentID = 0;
		if (request.getParameter("commentID") != null) {
			commentID = Integer.parseInt(request.getParameter("commentID"));
		}
		if (commentID == 0){ // 유효하지 않아서 접근이 불가능한 상태
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 댓글 입니다')");
			script.println("location.href = 'board.jsp'"); // 다시 게시판 페이지로 이동
			script.println("</script>");
		}
		
		Comment comment = new CommentDAO().getComment(commentID); // 해당 댓글을 가져옴
		if(!userID.equals(comment.getUserID())){ // 로그인한 사용자가 작성한 댓글이 맞는지 확인 - 만약 아니라면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('댓글 수정 권한이 없습니다')");
			script.println("location.href = 'board.jsp'"); // 다시 게시판 페이지로 이동
			script.println("</script>");
		} 
		else { // 댓글 수정 권한이 있는 사용자라면
			// update_comment 페이지에서 매개변수로서 넘어오는 댓글의 내용이 null 값이거나 빈칸인 경우 체크
			if (request.getParameter("commentContent") == null || request.getParameter("commentContent").equals("")) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('댓글을 입력하세요')");
				script.println("history.back()");
				script.println("</script>");
			}
			else {
				CommentDAO commentDAO = new CommentDAO();
				int result = commentDAO.update(commentID, request.getParameter("commentContent"));
				if(result == -1) { // 데이터베이스 오류 발생
					PrintWriter script = response.getWriter();  
					script.println("<script>");
					script.println("alert('댓글 수정에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				}
				else { // 댓글 수정에 성공한 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글 수정에 성공했습니다')");
					script.println("location.href = 'board.jsp'");
					script.println("</script>");
				}
			}
		}

	%>
</body>
</html>