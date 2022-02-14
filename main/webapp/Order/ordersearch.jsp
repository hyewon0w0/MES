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
		// 검색
		ArrayList<orderDTO> list = null;
		if(duration==null && input==null){
			list = dao.getOrderList(p);
			LastListNum=dao.getNext()-1;
		}else{
			String txt_where="";
			
			if(startdate!=null && enddate!=null){
				txt_where=txt_where+" WHERE order_date >= \'"+startdate+"\' and order_date <= \'" +enddate +"\'";
				
				if(input!=null){
					txt_where=txt_where+" and (item_no like \'%"+input+"%\' or car_name like \'%"+input+"%\' or order_com_id like \'%"
								+input+"%\' or prod_name like \'%"+input+"%\')";
				}
			}
			
			else if(input!=null){
				txt_where=txt_where+" WHERE (item_no like \'%"+input+"%\' or car_name like \'%"+input+"%\' or order_com_id like \'%"
							+input+"%\' or prod_name like \'%"+input+"%\')";
			}
			LastListNum=dao.getSearchAmount(txt_where);
			list=dao.getOrderList2(p, txt_where);
		}
		%>
		<%
		if(list.isEmpty() == false){
			// 검색 테이블 세팅
			for(int i=0; i<list.size(); i++){
		%>
		<tr class="tablecontent" id="<%=list.get(i).getO_num()%>">
			<td id="itemno"><%=list.get(i).getItem_no()%></td>
			<td id="carname"><%=list.get(i).getC_name() %></td>
			<td id="ordercomid"><%=list.get(i).getO_com_id()%></td>
			<td id="orderdate"><%=list.get(i).getO_date().substring(0,10)%></td>
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
		}} else{ %>
		<tr>
			<td colspan="5" align="center"><div>수주정보가 없습니다.</div></td>
		</tr>
		<% }; %>
	</tbody>
</table>
<script>
// 완료 및 비상 처리
<% 
if(list.isEmpty() == false){ %>
$(document).ready(function(){
	for(var i=1; i<=<%=list.get(0).getO_num() %>; i++){
		var due_date = $("#"+i).children('#duedate').text();
		var del_date = $("#"+i).children('#deldate').text();
		var ord_date = $("#"+i).children('#orderdate').text();

		if(due_date!=null && due_date != "null"){
			$("#"+i).css("color","green"); 
		}else{
			
			var del_date_yyyy=del_date.substr(0,4);
			var del_date_mm=del_date.substr(5,2);
			var del_date_dd=del_date.substr(8,2);
			
			var ord_date_yyyy=ord_date.substr(0,4);
			var ord_date_mm=ord_date.substr(5,2);
			var ord_date_dd=ord_date.substr(8,2);
			
			var del_date_val=new Date(del_date_yyyy, del_date_mm-1, del_date_dd);
			var ord_date_val=new Date(ord_date_yyyy, ord_date_mm-1, ord_date_dd);
			
			if(((del_date_val.getTime()-ord_date_val.getTime())/1000/60/60/24<3)){
				$("#"+i).css("color","red");
			}else{
				$("#"+i).css("color","black");
			}
		}
	}
});
<% }%>
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
// 클릭 시 수주 등록/수정 로딩
			$(".tablecontent").on("click",function(){
				$(".tablecontent").css("background","white");
				$(this).css("background","lightgray");
				$("#item_no").val($(this).children('#itemno').text());		//클릭한 열의 금형번호를 가져옴
				$("#order_com_id").val($(this).children('#ordercomid').text());
				$("#order_date").val($(this).children('#orderdate').text());
				$("#order_status").val($(this).children('#orderstatus').text());
				$("#part_status").val($(this).children('#partstatus').text());
				$("#car_name").val($(this).children('#carname').text());
				$("#prod_name").val($(this).children('#prodname').text());
				$("#order_price").val($(this).children('#orderprice').text());
				$("#nego_price").val($(this).children('#negoprice').text());
				
				if($(this).children('#deldate').text()!="null"){
					$("#del_date").val($(this).children('#deldate').text().substr(0,10));
				}else{
					$("#del_date").val(null);
				}
				
				if($(this).children('#procenddate').text()!="null"){
					$("#proc_end_date").val($(this).children('#procenddate').text().substr(0,10));
				}else{
					$("#proc_end_date").val(null);
				}
				
				// 납기 버튼 처리
				if($(this).children('#duedate').text()!="null"){
					$("#due_date").val($(this).children('#duedate').text().substr(0,10));
					$("#period").attr("value","납기취소");
					$("#period").attr("id","noperiod");
					$("#orderinsert").hide();
				}else{
					$("#due_date").val(null);
					$("#noperiod").attr("value","납기");
					$("#noperiod").attr("id","period");
					$("#orderinsert").show();
				}
				
				if($(this).children('#ordernote').text()!="null"){
					$("#order_note").val($(this).children('#ordernote').text());
				}else{
					$("#order_note").val(null);
				}
				
				$("#order_et_id").val($(this).children('#orderetid').text());
				
			});
			
</script>
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
				url:"./ordersearch.jsp",
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
				url:"./ordersearch.jsp",
				data:{page:pnum, date:pdate, input:pinput},
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
				url:"./ordersearch.jsp",
				data:{page:pnum, date:pdate, input:pinput},
				dataType:"html",
				success:function(data){
		            $("#ordert").html(data);
		        }
			});
			
		});
		
	</script>