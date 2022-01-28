<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="order.orderDAO" %>
<%@ page import="order.orderDTO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<jsp:useBean id="orderDTO" class="order.orderDTO" scope="page"/> 
<jsp:setProperty name="orderDTO" property="item_no"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" content="text/html; charset=UTF-8">
<% 
	orderDAO dao=new orderDAO();
	orderDTO dto=null;
	request.setCharacterEncoding("UTF-8");
	String itemno=request.getParameter("item_no");
%>
</head>
<body>
<script>
		<%
		if(itemno != null){
			int result = dao.delete(itemno);
			
			if(result != 0){%> 
			alert('삭제하였습니다!'); location.href="Order.jsp";
			<%}else { %>
	        alert('실패하였습니다!'); history.back();
	        <%}
	    }%>
</script>
</body>
</html>