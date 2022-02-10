<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String Et_id=request.getParameter("et_id");	
%>
<jsp:useBean id="dao" class="order.orderDAO"/>
<%
	String company=null;
	int price=0;
	
	company=dao.getcompany(Et_id);
	price=dao.getorderprice(Et_id);
%>
{"company" : "<%=company %>", "price" : <%=price %>}