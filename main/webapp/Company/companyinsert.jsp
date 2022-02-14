<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="company.companyDAO" %>
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
<jsp:useBean id="companyDTO" class="company.companyDTO" scope="page"/> 
<jsp:useBean id="companyDAO" class="company.companyDAO" scope="page"/>
<jsp:setProperty name="companyDTO" property="com_id" param="com_id"/>
<jsp:setProperty name="companyDTO" property="com_name" param="com_name"/>
<jsp:setProperty name="companyDTO" property="abbreviation" param="abbreviation"/>
<jsp:setProperty name="companyDTO" property="customers_sortation" param="customers_sortation"/>
<jsp:setProperty name="companyDTO" property="clientstatus" param="client_status"/>
<jsp:setProperty name="companyDTO" property="customers_group" param="customers_group"/>
<jsp:setProperty name="companyDTO" property="representative" param="representative"/>
<jsp:setProperty name="companyDTO" property="postal_code" param="postal_code"/>
<jsp:setProperty name="companyDTO" property="address" param="address"/>
<jsp:setProperty name="companyDTO" property="detailed_address" param="detailed_address"/>
<jsp:setProperty name="companyDTO" property="com_registration_num" param="com_registration_num"/>
<jsp:setProperty name="companyDTO" property="phone" param="phone"/>
<jsp:setProperty name="companyDTO" property="fax" param="fax"/>
<jsp:setProperty name="companyDTO" property="manager_name" param="manager_name"/>
<jsp:setProperty name="companyDTO" property="manager_phone" param="manager_phone"/>
<jsp:setProperty name="companyDTO" property="email" param="email"/>
<jsp:setProperty name="companyDTO" property="companyusing" param="usingYN"/>
<jsp:setProperty name="companyDTO" property="main_task" param="main_task"/>
<jsp:setProperty name="companyDTO" property="note" param="note"/>
<%
	String com_id=request.getParameter("com_id");

	if(companyDTO.getCom_id()==0){
		companyDTO.setCom_id(companyDAO.getNext());
	}
	if(companyDAO.write(companyDTO)>0){
%>
<script>alert('완료'); location.href="company.jsp"</script>
<%
	}else{
%>
<script>alert('실패'); history.back();</script>
<%	} %>
</body>
</html>