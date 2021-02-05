<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.File" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.Board" %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="comment.Comment" %>
<%@ page import="java.util.ArrayList" %>

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
		
		int writerID = 0; // 현재 게시글의 작성자 아이디를 알려주는 변수
		if (request.getParameter("writerID") != null) {
			writerID = Integer.parseInt(request.getParameter("writerID")); // 파라미터로 넘어온 작성자 아이디 값을 int 형으로 바꿔서 변수에 넣어줌
		}
		
		Board board_writerID = new BoardDAO().delete_check(writerID);
		if (board_writerID == null) // 만약 삭제된 게시물에 접근하려고 한다면
		{
			writerID = 0;
		}
		
		if (writerID == 0){ // 유효하지 않아서 접근이 불가능한 상태
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 게시글 입니다')");
			script.println("location.href = 'board.jsp'"); // 다시 게시판 페이지로 이동
			script.println("</script>");
		}
		Board board = new BoardDAO().getPost(writerID); // 해당 게시글이 유효하다면 구체적인 내용을 담아줌
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
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">View</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width:20%;">Title</td>
						<td colspan="2"><%= board.getPostTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
					<tr>
						<td>Writer</td>
						<td colspan="2"><%= board.getUserID() %></td>
					</tr>
					<tr>
						<td>Date</td>
						<td colspan="2"><%= board.getPostDate().substring(0, 11)
								+ board.getPostDate().substring(11, 13) + ":"
								+ board.getPostDate().substring(14, 16) + ":"
								+ board.getPostDate().substring(17, 19) %>
						</td>
					</tr>
					<tr>
						<td>Content</td>
						<td colspan="2" style="height:200px; text-align:left;"><%= board.getPostContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
				</tbody>
			</table>
			<a href="board.jsp" class="btn btn-primary">Back</a>
			<%
				if(userID != null && userID.equals(board.getUserID())){ // 해당 게시글의 작성자만 글을 수정하고 삭제할 수 있도록
			%>
					<a href="post_update.jsp?writerID=<%= writerID %>" class="btn btn-success">Modify</a>
					<a onclick="return confirm('게시글을 삭제하시겠습니까?')" href="post_deleteAction.jsp?writerID=<%= writerID %>" class="btn btn-success">Delete</a>
			<%
				}
			%>
			<a href="comment.jsp?writerID=<%= writerID %>" class="btn btn-primary pull-right">Comment</a>		
		</div>
	</div>
	
	<p>
	
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">id</th>
						<th style="background-color: #eeeeee; text-align: center;">Comment</th>
						<th style="background-color: #eeeeee; text-align: center;">Date</th>
						<th style="background-color: #eeeeee; text-align: center;"></th>
					</tr>
				</thead>
				<tbody>
					<%
						CommentDAO commentDAO = new CommentDAO();
						ArrayList<Comment> list = commentDAO.getList(writerID); // 현재 게시글의 댓글 리스트를 가져옴
						for(int i = 0; i < list.size(); i++) { // 가져온 댓글 리스트를 하나씩 출력
					%>
					<tr>
						<td><%= list.get(i).getUserID() %></td>
						<td style="height:50px; text-align:left;"><%= list.get(i).getCommentContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
						<td><%= list.get(i).getCommentDate().substring(0, 11) 
								+ list.get(i).getCommentDate().substring(11, 13) + ":"
								+ list.get(i).getCommentDate().substring(14, 16) + ":"
								+ list.get(i).getCommentDate().substring(17, 19)
								%></td>
						<td>
					<%
							if(userID != null && userID.equals(list.get(i).getUserID())){ // 작성자만 댓글을 수정하고 삭제할 수 있도록
					%>
								<a href="comment_update.jsp?commentID=<%= list.get(i).getCommentID() %>" class="btn btn-success">Modify</a>
								<a onclick="return confirm('댓글을 삭제하시겠습니까?')" href="comment_deleteAction.jsp?commentID=<%= list.get(i).getCommentID() %>" class="btn btn-success">Delete</a>
						</td>
					</tr>
					<%
							}
						}
					%>
				</tbody>
			</table>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>