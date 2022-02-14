<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="company.companyDAO" %>
<%@ page import="company.companyDTO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<jsp:useBean id="companyDTO" class="company.companyDTO" scope="page"/> 
<jsp:setProperty name="companyDTO" property="com_id"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" content="text/html; charset=UTF-8">
<% 
	companyDAO dao=new companyDAO();
	companyDTO dto=null;
	String comid=request.getParameter("com_id");
%>
</head>
<body>
<script>
		<%
		if(comid != null){
			int result = dao.delete(comid);
			
			if(result != 0){%> 
			alert('삭제하였습니다!'); location.href="company.jsp";
			<%}else { %>
	        alert('실패하였습니다!'); history.back();
	        <%}
	    }%>
</script>
</body>
</html>