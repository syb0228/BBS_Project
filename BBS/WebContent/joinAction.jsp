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
<jsp:setProperty name="member" property="userName" />
<jsp:setProperty name="member" property="userGender" />
<jsp:setProperty name="member" property="userEmail" />
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
		if(userID != null){ // 로그인이 되어 있는 상태이므로 회원가입을 진행할 수 없도록 함
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인 되어 있는 상태 입니다')");
			script.println("location.href = 'main.jsp");
			script.println("</script>");
		}
		// 5개 항목 중에서 하나라도 입력하지 않은 항목이 있는 경우
		if (member.getUserID() == null || member.getUserPassword() == null || member.getUserName() == null
			|| member.getUserGender() == null || member.getUserEmail() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력되지 않은 항목이 있습니다')");
			script.println("history.back()");
			script.println("</script>");
		}
		else {
			MemberDAO memberDAO = new MemberDAO();
			int result = memberDAO.join(member);
			if(result == -1) { // 입력한 아이디가 중복 아이디인 경우
				PrintWriter script = response.getWriter();  
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디 입니다')");
				script.println("history.back()");
				script.println("</script>");
			}
			else { // 입력한 모든 항목에 대해 회원가입이 성공적으로 이루어진 경우
				session.setAttribute("userID", member.getUserID()); // 회원 가입에 성공한 사용자의 id를 userID라는 이름으로 세션에 저장
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'main.jsp'"); // 메인 페이지로 이동
				script.println("</script>");
			}
				}
	%>
</body>
</html>