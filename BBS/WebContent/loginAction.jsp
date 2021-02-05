<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="member" class="member.Member" scope="page" />
<jsp:setProperty name="member" property="userID" />
<jsp:setProperty name="member" property="userPassword" />
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
		if(userID != null){ // 이미 로그인이 되어 있는 상태이므로 재로그인이 되지 않도록 함
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인 되어 있는 상태 입니다')");
			script.println("location.href = 'main.jsp");
			script.println("</script>");
		}
		
		MemberDAO memberDAO = new MemberDAO();
		int result = memberDAO.login(member.getUserID(), member.getUserPassword());
		if(result == 1) { // 로그인에 성공한 경우
			session.setAttribute("userID", member.getUserID()); // 로그인에 성공한 사용자의 id를 userID라는 이름으로 세션에 저장
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'main.jsp'"); // 메인 페이지로 이동
			script.println("</script>");
		}
		else if(result == 0) { // 비밀번호가 틀린 경우
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀렸습니다')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result == -1) { // 존재하지 않는 아이디인 경우
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디 입니다')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result == -2) { // 데이터베이스에 오류가 발생한 경우
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>