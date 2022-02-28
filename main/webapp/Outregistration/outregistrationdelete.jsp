<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="outregistration.outregistrationDAO" %>
<%@ page import="outregistration.outregistrationDTO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>

<jsp:useBean id="outregistrationDAO" class="outregistration.outregistrationDAO" scope="page"/>
<meta charset="UTF-8" content="text/html; charset=UTF-8">
<script>
<%
	String out_no=request.getParameter("outsourcing_no");
	if(out_no!=null){
		int result = outregistrationDAO.delete(Integer.parseInt(out_no));
		
		if(result != 0){%> 
		alert('삭제하였습니다!'); location.href="outregistration.jsp";
		<%}else { %>
        alert('실패하였습니다!'); history.back();
        <%}
	}
%>
</script>