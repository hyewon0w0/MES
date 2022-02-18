<%@ page import="javax.security.auth.callback.ConfirmationCallback" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="outsourcing.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:useBean id="dao" class="outsourcing.outsourcingDAO"/>

<%
	request.setCharacterEncoding("UTF-8");

	int LastListNum=-1;

	// ajax로 부터 받은 값 저장 
	String pagenum = request.getParameter("page");
	int p = 1;
	if(pagenum != null){
		p = Integer.parseInt(pagenum);	
	}
	
	String duration = request.getParameter("date");
	String startdate = null, enddate = null;
	
	if(duration != "" && duration != null){
		int index = duration.indexOf(" ");
		startdate = duration.substring(0,index);
		enddate = duration.substring(index+3);
	}
	
	if(duration == ""){
		duration = null;
	}
	
	String input=request.getParameter("input");
	
	if(input==""){
		input=null;
	}
%>

<table class="table table-bordered table-hover">
	<thead class="table_head">
		<tr>
			<th style="width: 5%;"></th>
			<th style="width: 15%;">수주명</th>
			<th style="width: 15%;">제품명</th>
			<th style="width: 10%;">공정</th>
			<th style="width: 10%;">유형</th>
			<th style="width: 10%;">업체</th>
			<th style="width: 10%;">금액</th>
			<th style="width: 15%;">입고예정일</th>
			<th style="width: 10%;">불량</th>

		</tr>
	</thead>
	<tbody>
		<%
		// 검색
		ArrayList<outsourcingDTO> list = null;
		if(duration==null && input==null){
			list = dao.getOutList(p);
			LastListNum=dao.getNext()-1;
		}else{
			String txt_where="";
			
			if(startdate!=null && enddate!=null){
				txt_where=txt_where+" WHERE warehousing_exp_date >= \'"+startdate+"\' and warehousing_exp_date <= \'" +enddate +"\'";
				
				if(input!=null){
					txt_where=txt_where+" and (orders_name like \'%"+input+"%\' or prod_name like \'%"+input+"%\' or process like \'%"
								+input+"%\' or company like \'%"+input+"%\')";
				}
			}
			
			else if(input!=null){
				txt_where=txt_where+" WHERE (orders_name like \'%"+input+"%\' or prod_name like \'%"+input+"%\' or process like \'%"
							+input+"%\' or company like \'%"+input+"%\')";
			}
			LastListNum=dao.getSearchAmount(txt_where);
			list=dao.getOutList2(p, txt_where);
		}
		%>
		<%
		if(list.isEmpty() == false){
			// 검색 테이블 세팅
			for(int i=0; i<list.size(); i++){
		%>
		<tr class="tablecontent" id="<%=list.get(i).getOutsourcing_no()%>">
			<td><input type="checkbox" name="chkbox" value="<%=list.get(i).getOutsourcing_no()%>"></td>
			<td id="orders_name"><%=list.get(i).getOrder_name()%></td>
			<td id="prod_name"><%=list.get(i).getProd_name()%></td>
			<td id="process"><%=list.get(i).getProcess()%></td>
			<td id="type"><%=list.get(i).getType()%></td>
			<td id="company"><%=list.get(i).getCompany()%></td>	
			<td id="price"><%=list.get(i).getPrice()%></td>
			<td id="warehousing_exp_date"><%=list.get(i).getWarehousing_exp_date().substring(0,10)%></td>
			<td id="faulty"><%=list.get(i).getFaulty()%></td>
			
			<td id="outstart_date" style='display:none'><%=list.get(i).getOutstart_date()%></td>
			<td id="endstart_date" style='display:none'><%=list.get(i).getOutend_date()%></td>
		</tr>
		<%
		}} else{ %>
		<tr>
			<td colspan="8" align="center"><div>외주정보가 없습니다.</div></td>
		</tr>
		<% } %>
	</tbody>
</table>
<script>
// 완료 및 비상 처리
<% if(list.isEmpty() == false){ %>
	$(document).ready(function(){
		for(var i=1; i<=<%=list.get(0).getOutsourcing_no() %>; i++){
			var warehousing_date = $("#"+i).children('#warehousing_exp_date').text();
			var today_date = new Date();
			
			if(warehousing_date!=null){
				var warehousing_date_yyyy=warehousing_date.substr(0,4);
				var warehousing_date_mm=warehousing_date.substr(5,2);
				var warehousing_date_dd=warehousing_date.substr(8,2);

				var warehousing_date_val=new Date(warehousing_date_yyyy, warehousing_date_mm-1, warehousing_date_dd); 
				
				if(((warehousing_date_val.getTime()-today_date.getTime())/1000/60/60/24)<=0){
					$("#"+i).css("color","red");
				}else{
					$("#"+i).css("color","black");
				}
			}
		}
	});
<%}%>
</script>
<ul class="pagination">
	<li><a class="preanpage">Previous</a></li>
	<%
		// 페이지네이션
		int block = p / 5 + 1;
		if(p % 5 == 0){
			block = block -1;
		}
		
		int startpage = (block-1) * 5 + 1;
		int endpage = ((LastListNum-1)/10);
		
		if(LastListNum%10 != 0 || endpage == 0){
			endpage += 1;
		}
		
		int endexpage = endpage;
		
		if(endexpage > 4 + startpage){
			endexpage = startpage + 4;
		}
		
		for(; startpage<=endexpage; startpage++){
	%>
		<li id="p<%=startpage%>"><a class="anpage"><%=startpage %></a></li>
		<%} %>
		<li><a class="nextanpage">Next</a></li>
</ul>
<script>
// 페이지네이션
	var pdate=null;
	var pinput=null;

	$(".anpage").removeClass("active");
	$("#p" + <%=p%>).addClass("active");
	
	$(".anpage").click(function(){
		$("li").removeClass("active");
		$(this).parent().addClass("active");
		
		var pnum = $(this).text();
		pdate=$('input[name="dates"]').val();
		pinput=$("#searchbox").val();
		
		if(pdate == "null"){
			pdate = null;
		}
		if(pinput == "null"){
			pinput = null;
		}
		
		$.ajax({
			type:"GET",
			url:"./outsourcingsearch.jsp",
			data:{page:pnum, date:pdate, input:pinput},
			dataType:"html",
			success:function(data){
	            $("#outsourcingt").html(data);
	        }
		});
	});
	
	$(".preanpage").click(function(){
		$("li").removeClass("active");
		
		var k = Number($(this).parent().next().text());
		if(k != 1){
			k = k - 5;
		}
		
		$("#p" + k).addClass("active");
		
		var pnum = k;
		pdate=$('input[name="dates"]').val();
		pinput=$("#searchbox").val();
		
		
		if(pdate == "null"){
			pdate = null;
		}
		if(pinput == "null"){
			pinput = null;
		}
		
		$.ajax({
			type:"GET",
			url:"./outsourcingsearch.jsp",
			data:{page:pnum, date:pdate, input:pinput},
			dataType:"html",
			success:function(data){
	            $("#outsourcingt").html(data);
	        }
		});
		
	});
	
	$(document).ready(function(){
		var kp = Number($(".preanpage").parent().next().text());
		var kn = Number($(".nextanpage").parent().prev().text());
		
		if(kp == 1){
			$(".preanpage").parent().addClass("disabled");
			$(".preanpage").css({"cursor":"Default"});
		}
		
		else{
			$(".preanpage").css({"color":"#337ab7"});
		}
		
		if(kn == <%= endpage %>){
			$(".nextanpage").parent().addClass("disabled");
			$(".nextanpage").css({"cursor":"Default"});
		}
		
		else{
			$(".nextanpage").css({"color":"#337ab7"});
		}
	});
	
	$(".nextanpage").click(function(){
		$("li").removeClass("active");
		
		var k = Number($(this).parent().prev().text());
		if(k != <%=endpage %>){
			k = k + 1; 
		}
		
		$("#p" + k).addClass("active");
		
		var pnum = k;
		pdate=$('input[name="dates"]').val();
		pinput=$("#searchbox").val();
		
		if(pdate == "null"){
			pdate = null;
		}
		if(pinput == "null"){
			pinput = null;
		}
		
		$.ajax({
			type:"GET",
			url:"./outsourchingsearch.jsp",
			data:{page:pnum, date:pdate, input:pinput},
			dataType:"html",
			success:function(data){
	            $("#outsourcingt").html(data);
	        }
		});
		
	});
		
</script>