<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO" %>
<%@ page import="member.Member" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
<title>Quotation Mark</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){ // 세션을 확인함
			userID = (String) session.getAttribute("userID"); // 자신에게 할당된 세션 아이디 저장
		}
		if(userID == null){ // 로그인이 되어 있지 않으면 회원 정보를 수정할 수 없음
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다')");
			script.println("location.href = 'login.jsp'"); // 로그인 할 수 있도록 로그인 페이지로 이동
			script.println("</script>");
		}
		
		String userPassword = ""; // 현재 회원의 old password를 알려주는 변수
		if (request.getParameter("old_userPassword") != null) {
			userPassword = request.getParameter("old_userPassword"); // 파라미터로 넘어온 old password 값을 변수에 넣어줌
		}
		
		if (userPassword == ""){ // 확인이 필요한 old password를 사용자가 입력하지 않았다면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호를 입력하세요')");
			script.println("location.href = 'user_update.jsp'"); // 다시 회원 정보 수정 페이지로 이동
			script.println("</script>");
		}
		
		Member member = new MemberDAO().getInfo(userID); // 회원 정보를 가져옴
		if(!userID.equals(member.getUserID())){ // 로그인한 사용자의 회원 정보가 맞는지 확인 - 만약 아니라면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('회원 정보 수정 권한이 없습니다')");
			script.println("location.href = 'main.jsp'"); // 메인 페이지로 이동
			script.println("</script>");
		}
		else if(!userPassword.equals(member.getUserPassword())){ // 입력한 old password가 일치하지 않으면 정보를 수정할 수 없음
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀렸습니다')");
			script.println("history.back()");
			script.println("</script>");
		}
		else { // 회원 정보 수정 권한이 있는 사용자라면
			// update 페이지에서 매개변수로서 넘어오는 값이 null 값이거나 빈칸이 있는 경우 체크
			if (request.getParameter("userID") == null || request.getParameter("userPassword") == null
				|| request.getParameter("userName") == null || request.getParameter("userEmail") == null
				|| request.getParameter("userID").equals("") || request.getParameter("userPassword").equals("") 
				|| request.getParameter("userName").equals("") || request.getParameter("userEmail").equals("")) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력되지 않은 사항이 있습니다')");
				script.println("history.back()");
				script.println("</script>");
			}
			else {
				MemberDAO memberDAO = new MemberDAO();
				int result = memberDAO.update(userID, request.getParameter("userPassword"), 
					request.getParameter("userName"), request.getParameter("userEmail"));
				if(result == -1) { // 데이터베이스 오류 발생
					PrintWriter script = response.getWriter();  
					script.println("<script>");
					script.println("alert('회원 정보 수정에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				}
				else { // 회원 정보 수정에 성공한 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('회원 정보가 수정됐습니다')");
					script.println("location.href = 'main.jsp'"); // 메인 페이지로 이동
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>