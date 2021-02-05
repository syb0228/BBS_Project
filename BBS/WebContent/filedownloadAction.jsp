<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.nio.charset.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quotation Mark</title>
</head>
<body>
	<%
	String fileRealName = request.getParameter("myrealfile"); // 서버에 저장된 실제 파일의 이름
	
	String directory = this.getServletContext().getRealPath("/upload/"); // 사용자가 업로드한 파일이 있는 경로
	String fileName = request.getParameter("myfile"); // 사용자가 저장한 파일의 이름
	
	int error = 1;
	
	if(fileName == null || "".equals(fileName)) // 전달된 파라미터가 null이라면 
	{
		error = -1; // 유효하지 않은 파일 - 에러
	}

	fileName = URLDecoder.decode(fileName, Charset.defaultCharset().name()); // 인코딩 우회 방지를 위한 디코딩
	
	String blockchar[] = {"..", "../", "..//"}; // 필터링 할 path traversal 문자열 리스트
	
	for(int i = 0; i < blockchar.length; i++)
	{
		if(fileName.indexOf(blockchar[i]) != -1)
		{
			error = -1; // 경로 조작 방지를 위해 다운로드 차단
		}
	}
	
	InputStream in = null;
	OutputStream os = null;
	File file = null;
	
	String client = "";
	
	try{
		try {
			file = new File(directory, fileName); // 파일 읽기
			in = new FileInputStream(file); // 스트림에 담기
		} catch (FileNotFoundException fe){
			error = -1;
		}
		
		// 파일 다운로드 헤더 지정
		response.reset();
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Description", "JSP Generated Data");
		
		client = request.getHeader("User-Agent");
		
		if(error != -1)
		{
            if(client.indexOf("MSIE") != -1) // 인터넷 익스플로러로 접속한 사용자라면
            { 
                response.setHeader ("Content-Disposition", "attachment; filename="
            		+ new String(fileName.getBytes("KSC5601"),"ISO8859_1"));
            }
            else // 인터넷 익스플로러로 접속한 사용자가 아니라면
            { 
            	// 한글 파일명 처리를 위해 파일 이름을 utf-8 방식으로 얻어서 8859 형식으로 인코딩
    			// 데이터가 깨지는 것을 방지할 수 있음
                fileName = new String(fileName.getBytes("utf-8"),"iso-8859-1");
 
                response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
            } 
             
            response.setHeader("Content-Length", "" + file.length());

            os = response.getOutputStream();
            byte b[] = new byte[(int)file.length()]; // 데이터를 바이트 단위로 나눠서 전송
            int data = 0;
             
            while((data = in.read(b)) > 0){
                os.write(b, 0, data); // 반복적으로 데이터를 전송
            }
        } 
		else // 유효하지 않는 파일인 경우
		{ 
            response.setContentType("text/html;charset=UTF-8");
            out.println("<script language='javascript'> alert('유효하지 않은 파일입니다'); history.back(); </script>");
        }
        
        in.close(); // 파일 close
        os.close(); 
 
    } catch(Exception e){
      e.printStackTrace();
    }
	
	%>
</body>
</html>