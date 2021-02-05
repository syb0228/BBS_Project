<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="member.MemberDAO" %>
<%@ page import="member.Member" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/myfont.css">
<title>Quotation Mark</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){ // 세션이 존재하는 사용자라면 (로그인한 사용자라면)
			userID = (String) session.getAttribute("userID"); // 세션에 있는 값을 가져옴
		}
		
		if(userID == null){ // 로그인이 되어있지 않다면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다')");
			script.println("location.href = 'login.jsp'"); // 로그인 페이지로 이동
			script.println("</script>");
		}
		
		Member member = new MemberDAO().getInfo(userID);
		if(!userID.equals(member.getUserID())){ // 로그인한 사용자의 회원 정보가 맞는지 확인 - 만약 아니라면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('회원 정보 수정 권한이 없습니다')");
			script.println("location.href = 'main.jsp'"); // 다시 메인 페이지로 이동
			script.println("</script>");
		}
	%>

	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">Quotation Mark</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">main</a></li>
				<li><a href="board.jsp">board</a></li>
				<li><a href="myfile.jsp">file</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">user management<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">logout</a></li>
						<li><a href="member_update.jsp">edit</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
		<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top:20px;">
				<form method="post" action="member_updateAction.jsp?userID=<%= userID %>">
					<h3 style="text-align:center;">Edit</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="id" name="userID" maxlength="20" value="<%= member.getUserID() %> (Cannot be modified)" disabled>
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="Please enter your Old Password." name="old_userPassword" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="Please enter your New Password." name="userPassword" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="name" name="userName" maxlength="20" value="<%= member.getUserName() %>">
					</div> 
					<div class="form-group">
						<input type="text" class="form-control" placeholder="User Gender" name="userGender" maxlength="20" value="<%= member.getUserGender() %> (Cannot be modified)" disabled>
					</div>
					<div class="form-group">
						<input type="email" class="form-control" placeholder="email" name="userEmail" maxlength="20" value="<%= member.getUserEmail() %>">
					</div>
					<a href="main.jsp" class="btn btn-primary">Cancel</a>
					<input a onclick="return confirm('회원 정보를 수정하시겠습니까?')" type="submit" class="btn btn-primary pull-right" value="Modify">
				</form>
			</div>
		</div>
		<div class="col-lg-4"></div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>