<!-- 외주작업일보 메인 jsp -->
<%@ page import="javax.security.auth.callback.ConfirmationCallback" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="outregistration.*" %>

<jsp:useBean id="outregistrationDAO" class="outregistration.outregistrationDAO" scope="page"/> 

<!DOCTYPE html>
<html>
<head>
<% 
	request.setCharacterEncoding("UTF-8");
%>
<meta charset="UTF-8">
<!--jquery-->
<script src="https://code.jquery.com/jquery-3.6.0.min.js" 
integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

<!--bootstrap-->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<link rel="stylesheet" href="outregistrationcontent.css?ver02">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
   
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>
<script>
	var index=0;
	var chk_num=0;
</script>
<%
	ArrayList<String> order_list=outregistrationDAO.getordercombo();
	ArrayList<String> prod_list=outregistrationDAO.getprod();
	ArrayList<String> process_list=outregistrationDAO.getprocess();
	ArrayList<String> com_list=outregistrationDAO.getcompany();
%>
</head>
<body>
<div class="row">
<div class=title>외주 작업일보</div>
	<div class="panel panel-default border outregistraionlistbox col-md-6">
		<div class="panel-heading">
			<h5 class="panel-title" style="display:inline-block;">외주 작업일보 등록/수정</h5>
		</div>
		<div class="panel-body">
				<!-- 데이터 리스트 -->
				<div id="outsourcingt" class="coutsourcingtable">
					<form id="out_form" action="outregistrationinsert.jsp" method="post">
					<table class="table table-bordered table-hover">
						<thead class="table_head">
							<tr>
								<th style="width: 20%;">수주명<span style="color: red;">*</span></th>
								<th style="width: 10%;">부품명</th>
								<th style="width: 10%;">공정<span style="color: red;">*</span></th>
								<th style="width: 10%;">외주사<span style="color: red;">*</span></th>
								<th style="width: 10%;">금액(원)</th>
								<th style="width: 10%;">입고예정일</th>
								<th style="width: 10%;">외주시작일</th>
								<th style="width: 10%;">외주종료일</th>
								<th style="width: 5%;">불량</th>
								<th style="width: 5%;"></th>
							</tr>
						</thead>
						<tbody>
						<% ArrayList<outregistrationDTO> list=outregistrationDAO.getOutList(); %>
							<tr id="addData">
								<td colspan="10" align="right">
									<div class="buttongruops">
										<input class="btn btn-primary" type="button" value="작업추가" id="addInsertKey" onclick="addInsert()">
										<input class="btn btn-primary" type="submit" value="작업일보등록" id="workinsert">
									</div>
								</td>
							</tr>
						</tbody>
					</table>
					</form>
				</div>
			</div>
	</div>
</div>
</body>
</html>
<script>
	$(document).ready(function(){
		let f = <%=list.size() %>;
		for(var i = 0; i<f; i++){
			addInsert();	
		}
		
		<%
		if(list!=null){
			for(int i=0; i<list.size(); i++){
		%>
		document.getElementById("row"+<%=i%>).children[0].children[0].value="<%= list.get(i).getOrder_name()%>";
		document.getElementById("row"+<%=i%>).children[1].children[0].value="<%= list.get(i).getProd_name()%>";
		document.getElementById("row"+<%=i%>).children[2].children[0].value="<%= list.get(i).getProcess()%>";
		document.getElementById("row"+<%=i%>).children[3].children[0].value="<%= list.get(i).getCompany()%>";
		document.getElementById("row"+<%=i%>).children[4].children[0].value="<%= list.get(i).getPrice()%>";		
		document.getElementById("row"+<%=i%>).children[5].children[0].value="<%= list.get(i).getWarehousing_exp_date()%>";
		document.getElementById("row"+<%=i%>).children[6].children[0].value="<%= list.get(i).getOutstart_date()%>";
		document.getElementById("row"+<%=i%>).children[7].children[0].value="<%= list.get(i).getOutend_date()%>";
		document.getElementById("row"+<%=i%>).children[10].children[0].value="<%= list.get(i).getOutsourcing_no()%>";
		document.getElementById("row"+<%=i%>).children[8].children[0].value="<%= list.get(i).getOutsourcing_no()%>";

		if("<%=list.get(i).getFaulty()%>" == "Y"){
			document.getElementById("row"+<%=i%>).children[8].children[0].checked=true;
		}else{
			document.getElementById("row"+<%=i%>).children[8].children[0].checked=false;
		}
		<%
				}
			}
		%>
		
		chk_num = <%= outregistrationDAO.getNext() %>;
	});
	
	function addInsert(){
		
		var rowItem="<tr class=filter_row id='row"+ index +"'>";
			rowItem+="<td id='insertdata' style='width:20%;'>";
			rowItem+="<select id='orders_name' name='orders_name' class='form-control'>";
			<%
				if(order_list!=null){
					for(int i=0; i<order_list.size(); i++){
			%>
			rowItem+="<option value='<%= order_list.get(i) %>'><%=order_list.get(i) %></option>";
			<%
					}
				}
			%>
			rowItem+="</select>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='width: 10%;'>";
			rowItem+="<select id='prod_name' name='prod_name' class='form-control'>";
			<%
				if(prod_list!=null){
					for(int i=0; i<prod_list.size(); i++){
			%>
			rowItem+="<option value='<%= prod_list.get(i) %>'><%=prod_list.get(i) %></option>";
			<%
					}
				}
			%>
			rowItem+="</select>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='width: 10%;'>";
			rowItem+="<select id='process' name='process' class='form-control'>";
			<%
				if(process_list!=null){
				for(int i=0; i<process_list.size(); i++){
			%>
			rowItem+="<option value='<%= process_list.get(i) %>'><%= process_list.get(i) %></option>";
			<%
					}
				}
			%>
			rowItem+="</select>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='width: 10%;'>";
			rowItem+="<select id='company' name='company' class='form-control'>";
			<%
			if(com_list!=null){
				for(int i=0; i<com_list.size(); i++){
			%>
			rowItem+="<option value='<%= com_list.get(i) %>'><%= com_list.get(i) %></option>";
			<%
					}
				}
			%>
			rowItem+="</select>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='width: 10%;'>";
			rowItem+="<input type='number' id='pric' class='form-control' value=0 name='price'>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='width: 10%;'>";
			rowItem+="<input type='date' id='warehousing_exp_date' class='form-control' name='warehousing_exp_date'>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='width: 10%;'>";
			rowItem+="<input type='date' id='outstart_date' class='form-control' name='outstart_date'>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='width: 10%;'>";
			rowItem+="<input type='date' id='outend_date' class='form-control' name='outend_date'>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='width: 5%;'>";
			rowItem+="<input type='checkbox' id='faulty' name='faulty' value='"+ chk_num +"'>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='width: 5%;'>";
			rowItem+="<input id='delInsertKey' type='button' class='btn btn-danger' name='delbtn' value='삭제' onclick='delInsert(this)'>";
			rowItem+="</td>";
			rowItem+="<td id='insertdata' style='display:none;'>";
			rowItem+="<input type='number' id='outsourcing_no' class='form-control' name='outsourcing_no' value=0 >";
			rowItem+="</td>";
			rowItem+="</tr>";
			
			chk_num+=1;
			index+=1;
		$('#addData').before(rowItem);
	}
	function delInsert(obj){
		var number = obj.parentNode.parentNode.children[10].children[0].value;

		index-=1;
		var div=$(obj).parent().parent();
		div.remove();
		
		location.href='outregistrationdelete.jsp?outsourcing_no='+number;
	}
</script>