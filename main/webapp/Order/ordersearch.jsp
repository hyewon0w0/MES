<%@ page import="javax.security.auth.callback.ConfirmationCallback" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="order.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
	request.setCharacterEncoding("UTF-8");

	int LastListNum=-1;

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
<jsp:useBean id="dao" class="order.orderDAO"/>

<table class="table table-bordered table-hover">
	<thead class="table_head">
		<tr>
			<th style="width: 20%;">금형번호</th>
			<th style="width: 20%;">차종</th>
			<th style="width: 20%;">업체명</th>
			<th style="width: 20%;">수주일</th>
			<th style="width: 20%;">품명</th>
		</tr>
	</thead>
	<tbody>
		<%
		ArrayList<orderDTO> list = null;
		if(duration==null && input==null){
			list = dao.getOrderList();
			LastListNum=dao.getNext()-1;
		}else{
			String txt_where="";
			
			if(startdate!=null && enddate!=null){
				txt_where=txt_where+" WHERE order_date >= \'"+startdate+"\' and order_date <= \'" +enddate +"\'";
				
				if(input!=null){
					txt_where=txt_where+" WHERE item_no like \'%"+input+"%\' or car_name like \'%"+input+"%\' or order_com_id like \'%"
								+input+"%\' or prod_name like \'%"+input+"%\'";
				}
			}
			
			else if(input!=null){
				txt_where=txt_where+" WHERE item_no like \'%"+input+"%\' or car_name like \'%"+input+"%\' or order_com_id like \'%"
							+input+"%\' or prod_name like \'%"+input+"%\'";
			}
			LastListNum=dao.getSearchAmount(txt_where);
			list=dao.getOrderList2(txt_where);
		}
		%>
		<%
			for(int i=0; i<list.size(); i++){
		%>
		<tr id="orderList" class="tablecontent">
			<td id="itemno"><%=list.get(i).getItem_no()%></td>
			<td id="carname"><%=list.get(i).getC_name() %></td>
			<td id="ordercomid"><%=list.get(i).getO_com_id()%></td>
			<td id="orderdate"><%=list.get(i).getO_date()%></td>
			<td id="prodname"><%=list.get(i).getP_name()%></td>
			
			<td id="orderstatus" style='display:none'><%=list.get(i).getO_status()%></td>
			<td id="partstatus" style='display:none'><%=list.get(i).getP_status()%></td>
			<td id="orderprice" style='display:none'><%=list.get(i).getO_price()%></td>
			<td id="negoprice" style='display:none'><%=list.get(i).getN_price()%></td>
			<td id="deldate" style='display:none'><%=list.get(i).getDel_date()%></td>
			<td id="procenddate" style='display:none'><%=list.get(i).getP_e_date()%></td>
			<td id="duedate" style='display:none'><%=list.get(i).getDue_date()%></td>
			<td id="ordernote" style='display:none'><%=list.get(i).getO_note()%></td>
			<td id="orderetid" style='display:none'><%=list.get(i).getO_et_id()%></td>
			<td id="ordernum" style='display:none'><%=list.get(i).getO_num()%></td>
		</tr>
		<%
		}
		%>
		<% if(list.isEmpty()){ %>
		<tr>
			<td colspan="4" align="center"><div>수주정보가 없습니다.</div></td>
		</tr>
		<% } %>
	</tbody>
</table>
<ul class="pagination">
	<li><a class="preanpage">Previous</a></li>
	<%
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
			$(".tablecontent").on("click",function(){
				$("#item_no").val($(this).children('#itemno').text());		//클릭한 열의 금형번호를 가져옴
				$("#order_com_id").val($(this).children('#ordercomid').text());
				$("#order_date").val($(this).children('#orderdate').text());
				$("#order_status").val($(this).children('#orderstatus').text());
				$("#part_status").val($(this).children('#partstatus').text());
				$("#car_name").val($(this).children('#carname').text());
				$("#prod_name").val($(this).children('#prodname').text());
				$("#order_price").val($(this).children('#orderprice').text());
				$("#nego_price").val($(this).children('#negoprice').text());
				$("#del_date").val($(this).children('#deldate').text());
				$("#proc_end_date").val($(this).children('#procenddate').text());
				$("#due_date").val($(this).children('#duedate').text());
				$("#order_note").val($(this).children('#ordernote').text());
				$("#order_et_id").val($(this).children('#orderetid').text());
			});
</script>
<script>
		$(".anpage").removeClass("active");
		$("#p" + <%=p%>).addClass("active");
		
		$(".anpage").click(function(){
			$("li").removeClass("active");
			$(this).parent().addClass("active");
			
			var pnum = $(this).text();
			var pdate = "<%=request.getParameter("date") %>";
			var pinput = "<%=request.getParameter("input") %>";
			
			if(pdate == "null"){
				pdate = null;
			}
			if(pinput == "null"){
				pinput = null;
			}
			
			$.ajax({
				type:"GET",
				url:"./orderdsearch.jsp",
				data:{page:pnum, date:pdate, input:pinput},
				dataType:"html",
				success:function(data){
		            $("#ordert").html(data);
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
			var datess = "<%=request.getParameter("date") %>";
			var sda = "<%=request.getParameter("input") %>";
			dates=$('input[name="dates"]').val();
			input=$("#searchbox").val();
			
			if(datess == "null"){
				datess = null;
			}
			if(sda == "null"){
				sda = null;
			}
			
			$.ajax({
				type:"GET",
				url:"./ordersearch.jsp",
				data:{page:pnum, date:datess, sdata:sda},
				dataType:"html",
				success:function(data){
		            $("#ordert").html(data);
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
		})
		
		$(".nextanpage").click(function(){
			$("li").removeClass("active");
			
			var k = Number($(this).parent().prev().text());
			if(k != <%=endpage %>){
				k = k + 1; 
			}
			
			$("#p" + k).addClass("active");
			
			var pnum = k;
			var datess = "<%=request.getParameter("date") %>";
			var sda = "<%=request.getParameter("sdata") %>";
			
			if(datess == "null"){
				datess = null;
			}
			if(sda == "null"){
				sda = null;
			}
			
			$.ajax({
				type:"GET",
				url:"./ordersearch.jsp",
				data:{page:pnum, date:datess, sdata:sda},
				dataType:"html",
				success:function(data){
		            $("#ordert").html(data);
		        }
			});
			
		})
		
	</script>