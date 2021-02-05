<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quotation Mark</title>
</head>
<body>
	<%
		session.invalidate(); // 해당 페이지에 접속하면 세션을 빼앗기도록 함
	%>
	<script>
		location.href = 'main.jsp';
	</script>
</body>
</html>