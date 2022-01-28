<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.boardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<jsp:useBean id="boardDTO" class="board.boardDTO" scope="page"/> 
<jsp:setProperty name="boardDTO" property="title"/>
<jsp:setProperty name="boardDTO" property="content"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR" content="text/html; charset=UTF-8">
<title>jsp 웹사이트</title>
</head>
<body>
<% 

	int bid=0;
	if(request.getParameter("Id")!=null) bid=Integer.parseInt(request.getParameter("Id"));
	if(bid==0){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href='board.jsp'");
		script.println("</script>");
	}
	
	boardDAO boarddao=new boardDAO();
	
	int result=boarddao.bdelete(bid);
	
	if(result==-1){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('글 삭제에 실패했습니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else{
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("location.href='board.jsp'");
		script.println("</script>");
	}
	
%>
</body>
</html>