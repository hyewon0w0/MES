<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="outsourcing.outsourcingDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" content="text/html; charset=UTF-8">
</head>
<body>

<jsp:useBean id="outsourcingDAO" class="outsourcing.outsourcingDAO" scope="page"/>
<%
	String outsourcingNo=request.getParameter("chk_arr");
	String wday=request.getParameter("Wday");
	
	outsourcingDAO.update(outsourcingNo,wday);
%>
</body>
</html>