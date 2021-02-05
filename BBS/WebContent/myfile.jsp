<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.File" %>
<%@ page import="myfile.MyfileDAO" %>
<%@ page import="myfile.Myfile" %>
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
				<li><a href="board.jsp">board</a></li>
				<li class="active"><a href="myfile.jsp">file</a></li>
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
						<th style="background-color: #eeeeee; text-align: center;">ID</th>
						<th style="background-color: #eeeeee; text-align: center;">File Name</th>
						<th style="background-color: #eeeeee; text-align: center;">Date</th>
						<th style="background-color: #eeeeee; text-align: center;">Click!</th>
					</tr>
				</thead>
				<tbody>
				<%
				
					String directory = application.getRealPath("/upload/");
					String files[] = new File(directory).list();

					
					MyfileDAO myfileDAO = new MyfileDAO();
					ArrayList<Myfile> list = myfileDAO.getList();

					for(int i = 0; i < list.size(); i++) { // 업로드된 모든 파일에 대해
				%>

					<tr>
						<td><%= list.get(i).getUserID() %>
						<td><%= list.get(i).getFileName() %>
						<td><%= list.get(i).getUploadDate() %>
						<td>
						<%
							out.write("<a href=filedownloadAction.jsp?myrealfile=" 
								+ java.net.URLEncoder.encode(list.get(i).getFileRealName(), "UTF-8") + "&myfile="
								+ java.net.URLEncoder.encode(list.get(i).getFileName(), "UTF-8") + " \">" + "download" + "</a><br>");
							// 특정 파일을 클릭하면 해당 파일 다운로드 페이지로 이동함
						%>
						</td>
					</tr>
					<%

						}
					%>
				</tbody>
			</table>
			<a href="fileUpload.jsp" class="btn btn-primary pull-right">File Upload</a>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>