<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="outregistration.outregistrationDAO" %>
<%@ page import="outregistration.outregistrationDTO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:useBean id="outregistrationDAO" class="outregistration.outregistrationDAO" scope="page"/>
		
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
	
	String [] arr_id=request.getParameterValues("outsourcing_no");
	String [] arr_order=request.getParameterValues("orders_name");
	String [] arr_prod=request.getParameterValues("prod_name");
	String [] arr_process=request.getParameterValues("process");
	String [] arr_com=request.getParameterValues("company");
	String [] arr_price=request.getParameterValues("price");
	String [] arr_exp_date=request.getParameterValues("warehousing_exp_date");
	String [] arr_start_date=request.getParameterValues("outstart_date");
	String [] arr_end_date=request.getParameterValues("outend_date");
	String [] arr_faulty=request.getParameterValues("faulty");

	if(arr_id!=null){
	for(int i=0; i<arr_order.length; i++){
		
		System.out.println(arr_id[i]);
%>
 		<jsp:useBean id="dto" class="outregistration.outregistrationDTO"/>
		<jsp:setProperty name="dto" property="outsourcing_no" value='<%=Integer.parseInt(arr_id[i])%>'/>
		
<%
		if(dto.getOutsourcing_no() == 0){
			dto.setOutsourcing_no(outregistrationDAO.getNext());
		}

		String currentuser = (String)session.getAttribute("id");
%>
		<jsp:setProperty name="dto" property="order_name" value="<%=arr_order[i]%>"/>
		<jsp:setProperty name="dto" property="prod_name" value="<%=arr_prod[i]%>"/>
		<jsp:setProperty name="dto" property="process" value="<%=arr_process[i]%>"/>
		<jsp:setProperty name="dto" property="company" value="<%=arr_com[i]%>"/>
		<jsp:setProperty name="dto" property="warehousing_exp_date" value="<%=arr_exp_date[i]%>"/>
		<jsp:setProperty name="dto" property="outstart_date" value="<%=arr_start_date[i]%>"/>
		<jsp:setProperty name="dto" property="outend_date" value="<%=arr_end_date[i]%>"/>
		<jsp:setProperty name="dto" property="status" value='0'/>
		<jsp:setProperty name="dto" property="worker" value="<%=currentuser %>"/>
<%
		if(arr_price[i].length() != 0){
			dto.setPrice(Integer.parseInt(arr_price[i]));
		}else{
			dto.setPrice(0);
		}

		Date today = new Date();
		SimpleDateFormat df = new SimpleDateFormat("YYYY-MM-dd");
		String rd = df.format(today);
		dto.setReg_date(rd);
		
		if(dto.getOutstart_date().length() != 0){
			if(dto.getOutend_date().length() != 0){
				dto.setType("완료");
			}else{
				dto.setType("진행중");
			}
		}else{
			dto.setType("시작대기");
		}
		
		outregistrationDAO.write(dto);
	
		 }
	}
		
		outregistrationDAO.clearFaulty();
		
	// 불량 입력 및 업데이트
	if(arr_faulty!=null){
		for(int i=0; i<arr_faulty.length; i++){
			outregistrationDAO.settingFaulty(Integer.parseInt(arr_faulty[i]));
		}
	}
		 
		 if(true){	
%>
			<script>alert('완료'); location.href="outregistration.jsp"</script>
<%
		}else{
%>
			<script>alert('실패'); history.back();</script>
<%		}%>