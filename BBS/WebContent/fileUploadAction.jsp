<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="myfile.MyfileDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<% request.setCharacterEncoding("UTF-8"); %>
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
		if(userID == null){ // 로그인이 되어 있지 않으면 파일을 업로드할 수 없음
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다')");
			script.println("location.href = 'login.jsp'"); // 로그인 할 수 있도록 로그인 페이지로 이동
			script.println("</script>");
		}
		else {
			String directory = application.getRealPath("/upload/"); // 파일 업로드될 서버의 경로	
			int maxSize = 1024 * 1024 * 100; // 파일의 최대 크기를 10MB로 제한	
			String encoding = "UTF-8";
			
			MultipartRequest multipartRequest 
			= new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());
			
			String fileName = multipartRequest.getOriginalFileName("myfile"); // 실제로 사용자가 업로드한 파일 이름
			String fileRealName = multipartRequest.getFilesystemName("myfile"); // 실제로 서버에 업로드된 파일 이름
			
			// Web Shell 업로드 취약점 보안을 위해 파일 업로드가 가능한 확장자를 지정해줌 
			if(!fileName.endsWith(".docx") && !fileName.endsWith(".hwp") && !fileName.endsWith(".pdf") 
					&& !fileName.endsWith(".xlsx") && !fileName.endsWith(".pptx")) {
				File file = new File(directory + fileRealName);
				file.delete();
				PrintWriter script = response.getWriter();  
				script.println("<script>");
				script.println("alert('파일 업로드가 불가능한 확장자입니다')");
				script.println("history.back()");
				script.println("</script>");
			}
			else {
				MyfileDAO myfileDAO = new MyfileDAO();
				int result = myfileDAO.upload(userID, fileName, fileRealName);
				if(result == -1) { // 데이터베이스 오류 발생
					PrintWriter script = response.getWriter();  
					script.println("<script>");
					script.println("alert('파일 업로드에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				}
				else{
					PrintWriter script = response.getWriter();  
					script.println("<script>");
					script.println("alert('파일 업로드에 성공했습니다')");
					script.println("location.href = 'myfile.jsp'");
					script.println("</script>");
				}
			}
		}		
	%>
</body>
</html>