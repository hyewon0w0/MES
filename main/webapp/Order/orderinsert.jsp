<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="order.orderDAO" %>
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
<jsp:useBean id="orderDTO" class="order.orderDTO" scope="page"/> 
<jsp:setProperty name="orderDTO" property="item_no" param="itemno"/>
<jsp:setProperty name="orderDTO" property="o_com_id" param="company"/>
<jsp:setProperty name="orderDTO" property="o_date" param="orderday"/>
<jsp:setProperty name="orderDTO" property="o_status" param="classification"/>
<jsp:setProperty name="orderDTO" property="p_status" param="parts"/>
<jsp:setProperty name="orderDTO" property="c_name" param="car"/>
<jsp:setProperty name="orderDTO" property="p_name" param="productname"/>
<jsp:setProperty name="orderDTO" property="o_price" param="amount"/>
<jsp:setProperty name="orderDTO" property="n_price" param="negotiate"/>
<jsp:setProperty name="orderDTO" property="del_date" param="expectedday"/>
<jsp:setProperty name="orderDTO" property="p_e_date" param="processcompletionday"/>
<jsp:setProperty name="orderDTO" property="due_date" param="dueday"/>
<jsp:setProperty name="orderDTO" property="o_note" param="remarks"/>
<jsp:setProperty name="orderDTO" property="img" param="img"/>
<jsp:setProperty name="orderDTO" property="o_et_id" param="quotation"/>
<jsp:setProperty name="orderDTO" property="o_num" param="num"/>

<jsp:useBean id="orderDAO" class="order.orderDAO" scope="page"/>
<% 
	if(orderDAO.write(orderDTO)>0){%>
	<script>alert('완료'); location.href="Order.jsp"</script>
<%}else{%>
	<script>alert('실패'); history.back();</script>
<%} %>
</body>
</html>