<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="comment.Comment" %>
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
		
		int commentID = 0;
		if (request.getParameter("commentID") != null) {
			commentID = Integer.parseInt(request.getParameter("commentID")); // 파라미터로 넘어온 댓글 아이디 값을 int 형으로 바꿔서 변수에 넣어줌
		}
		if (commentID == 0){ // 유효하지 않아서 접근이 불가능한 상태
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 댓글입니다')");
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
		<div class="row">
		<form method="post" action="comment_updateAction.jsp?commentID=<%= commentID %>">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2" style="background-color: #eeeeee; text-align: center;">Modify</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><textarea class="form-control" placeholder="Enter your Comment" name="commentContent" maxlength="2048" style="height: 200px;"><%= comment.getCommentContent() %></textarea></td>
					</tr>
				</tbody>
			</table>
			<input type="submit" class="btn btn-primary pull-right" value="Modify">		
		</form>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>