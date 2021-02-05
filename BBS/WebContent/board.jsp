<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.Board" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/myfont.css">
<title>Quotation Mark</title>
<style type="text/css">
	a, a:hover{
		color:#000000;
		text-decoration:none;
	}
</style>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){ // 세션이 존재하는 사용자라면 (로그인한 사용자라면)
			userID = (String) session.getAttribute("userID"); // 세션에 있는 값을 가져옴
		}
		
		int pageNo = 1; // 현재 게시판의 페이지 번호를 알려주는 변수
		if (request.getParameter("pageNo") != null) {
			pageNo = Integer.parseInt(request.getParameter("pageNo")); // 파라미터로 넘어온 페이지 넘버 값을 int 형으로 바꿔서 변수에 넣어줌
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
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">No.</th>
						<th style="background-color: #eeeeee; text-align: center;">Title</th>
						<th style="background-color: #eeeeee; text-align: center;">Writer</th>
						<th style="background-color: #eeeeee; text-align: center;">Date</th>
					</tr>
				</thead>
				<tbody>
					<%
						BoardDAO boardDAO = new BoardDAO();
						ArrayList<Board> list = boardDAO.getList(pageNo); // 현재 페이지에서 게시글 리스트를 가져옴
						for(int i = 0; i < list.size(); i++) { // 가져온 게시글 리스트를 하나씩 출력
					%>
					<tr>
						<td><%= list.get(i).getWriterID() %></td>
						<td><a href="view.jsp?writerID=<%= list.get(i).getWriterID()%>">
						<%=list.get(i).getPostTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></a></td>
						<% // 스크립트를 이용한 공격을 막기 위해 특수문자를 치환해줌  %>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getPostDate().substring(0, 11) 
								+ list.get(i).getPostDate().substring(11, 13) + ":"
								+ list.get(i).getPostDate().substring(14, 16) + ":"
								+ list.get(i).getPostDate().substring(17, 19)
								%></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
				if(pageNo != 1) { // 2페이지 이상인 경우 - 이전 페이지로 돌아갈 수 있도록 해야 함
			%>
				<a href="board.jsp?pageNo=<%=pageNo - 1%>" class="btn btn-success btn-arraw-left">Prev</a>
			<%
				}
				if(boardDAO.nextPage(pageNo + 1)){ // 다음 페이지가 존재하는 경우 - 다음 페이지로 넘어갈 수 있도록 해야 함
			%>
				<a href="board.jsp?pageNo=<%=pageNo + 1%>" class="btn btn-success btn-arraw-left">Next</a>
			<%
				}
			%>
				
			<a href="post.jsp" class="btn btn-primary pull-right">Post</a>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>