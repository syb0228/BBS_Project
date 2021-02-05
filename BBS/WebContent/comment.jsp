<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
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
		
		int writerID = 0; // 현재 댓글을 달려고 하는 게시글의 아이디를 알려주는 변수
		if (request.getParameter("writerID") != null) {
			writerID = Integer.parseInt(request.getParameter("writerID")); // 파라미터로 넘어온 아이디 값을 int 형으로 바꿔서 변수에 넣어줌
		}
		if (writerID == 0){ // 유효하지 않아서 접근이 불가능한 상태
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 상태 입니다')");
			script.println("location.href = 'board.jsp'"); // 다시 게시판 페이지로 이동
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
				<li><a href="main.jsp">main</a></li>
				<li class="active"><a href="board.jsp">board</a></li>
				<li><a href="myfile.jsp">file</a></li>
			</ul>
			<% 
				if(userID == null){ // 로그인 되어 있지 않는 경우에만 로그인과 회원가입을 진행할 수 있도록
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">connect<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">login</a></li>
						<li><a href="join.jsp">sign</a></li>
					</ul>
				</li>
			</ul>
			<% 
				}
				else { // 로그인이 되어 있는 경우에만 사용자 관리와 로그아웃을 진행할 수 있도록
			%>
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
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<div class="row">
		<form method="post" action="commentAction.jsp?writerID=<%= writerID %>">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2" style="background-color: #eeeeee; text-align: center;">Comment</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="1"><%= userID %></td>
						<td><textarea class="form-control" placeholder="Enter your Comment" name="commentContent" maxlength="2048" style="height: 200px;"></textarea></td>
					</tr>
				</tbody>
			</table>	
			<input type="submit" class="btn btn-primary pull-right" value="Save">		
		</form>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>