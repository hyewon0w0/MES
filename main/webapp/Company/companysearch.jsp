<%@ page import="javax.security.auth.callback.ConfirmationCallback" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="company.*" %>
<%@ page import="java.util.ArrayList" %>
<% 
	request.setCharacterEncoding("UTF-8");

	int LastListNum=-1;
	
	// ajax로 부터 받은 값 저장 
	String pagenum = request.getParameter("page");
	int p = 1;
	if(pagenum != null){
		p = Integer.parseInt(pagenum);	
	}
	
	String input=request.getParameter("input");
	
	if(input==""){
		input=null;
	}
%>
<jsp:useBean id="dao" class="company.companyDAO"/>

<table class="table table-bordered table-hover">
	<thead class="table_head">
		<tr>
			<th style="width: 25%;">유형</th>
			<th style="width: 25%;">상호(이름)</th>
			<th style="width: 25%;">담당자</th>
			<th style="width: 25%;">전화번호</th>
		</tr>
	</thead>
	<tbody>
	<%
		ArrayList<companyDTO> list = null;
		String txt_where="";
		if(input==null){
			list = dao.getCompanyList1(p);
			LastListNum=dao.getNext()-1;
		}else{
			txt_where=txt_where+" WHERE (client_outsourcing like \'%"+input+"%\' OR com_name like \'%"+input+"%\' OR manager_name like \'%"+input+"%\' OR phone like \'%"+input+"%\')";
			LastListNum=dao.getSearchAmount(txt_where);
			list=dao.getCompanyList2(p, txt_where);
		}
		
		for(int i=0; i<list.size(); i++){
	%>
	<tr class="tablecontent" id="<%=list.get(i).getCom_id()%>">
		<td id="Clientstatus"><%=list.get(i).getClientstatus()%></td>
		<td id="Comname"><%=list.get(i).getCom_name()%></td>
		<td id="Managername"><%=list.get(i).getManager_name()%></td>
		<td id="Phone"><%=list.get(i).getPhone()%></td>
		
		<td id="Abbreviation" style='display:none'><%=list.get(i).getAbbreviation()%></td>
		<td id="Customerssortation" style='display:none'><%=list.get(i).getCustomers_sortation()%></td>
		<td id="Customersgroup" style='display:none'><%=list.get(i).getCustomers_group()%></td>
		<td id="Representative" style='display:none'><%=list.get(i).getRepresentative()%></td>
		<td id="Postalcode" style='display:none'><%=list.get(i).getPostal_code()%></td>
		<td id="Address" style='display:none'><%=list.get(i).getAddress()%></td>
		<td id="Detailedaddress" style='display:none'><%=list.get(i).getDetailed_address()%></td>
		<td id="Comregistrationnum" style='display:none'><%=list.get(i).getCom_registration_num()%></td>
		<td id="Fax" style='display:none'><%=list.get(i).getFax()%></td>
		<td id="Managerphone" style='display:none'><%=list.get(i).getManager_phone()%></td>
		<td id="Email" style='display:none'><%=list.get(i).getEmail()%></td>
		<td id="Using" style='display:none'><%=list.get(i).getCompanyusing()%></td>
		<td id="Maintask" style='display:none'><%=list.get(i).getMain_task()%></td>
		<td id="Note" style='display:none'><%=list.get(i).getNote()%></td>
		<td id="Comid" style='display:none'><%=list.get(i).getCom_id()%></td>
	<%
		}
	%>
	<%
		if(list.isEmpty()){ 
	%>
		<tr>
			<td colspan="5" align="center">
				<div>업체정보가 없습니다.</div>
			</td>
		</tr>
	<%
		}
	%>
	</tbody>
</table>
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
//클릭 시 업체 등록/수정 로딩
	$(".tablecontent").on("click",function(){
		$(".tablecontent").css("background","white");
		$(this).css("background","lightgray");
		$("#com_name").val($(this).children('#Comname').text());		
		if($(this).children('#Abbreviation').text()!="null"){
			$("#abbreviation").val($(this).children('#Abbreviation').text());
		}else{
			$("#abbreviation").val(null);
		}
		if($(this).children('#Customerssortation').text()!="null"){
			$("#customers_sortation").val($(this).children('#Customerssortation').text());
		}else{
			$("#customers_sortation").val(null);
		}
		$("#client_status").val($(this).children('#Clientstatus').text());
		if($(this).children('#Customersgroup').text()!="null"){
			$("#customers_group").val($(this).children('#Customersgroup').text());
		}else{
			$("#customers_group").val(null);
		}
		if($(this).children('#Representative').text()!="null"){
			$("#representative").val($(this).children('#Representative').text());
		}else{
			$("#representative").val(null);
		}
		if($(this).children('#Postal_code').text()!="null"){
			$("#postal_code").val($(this).children('#Postal_code').text());
		}else{
			$("#postal_code").val(null);
		}
		if($(this).children('#Address').text()!="null"){
			$("#address").val($(this).children('#Address').text());
		}else{
			$("#address").val(null);
		}
		if($(this).children('#Detailedaddress').text()!="null"){
			$("#detailed_address").val($(this).children('#Detailedaddress').text());
		}else{
			$("#detailed_address").val(null);
		}
		if($(this).children('#Comregistrationnum').text()!="null"){
			$("#com_registration_num").val($(this).children('#Comregistrationnum').text());
		}else{
			$("#com_registration_num").val(null);
		}
		if($(this).children('#Phone').text()!="null"){
			$("#phone").val($(this).children('#Phone').text());
		}else{
			$("#phone").val(null);
		}
		if($(this).children('#Fax').text()!="null"){
			$("#fax").val($(this).children('#Fax').text());
		}else{
			$("#fax").val(null);
		}
		if($(this).children('#Managername').text()!="null"){
			$("#manager_name").val($(this).children('#Managername').text());
		}else{
			$("#manager_name").val(null);
		}
		if($(this).children('#Managerphone').text()!="null"){
			$("#manager_phone").val($(this).children('#Managerphone').text());
		}else{
			$("#manager_phone").val(null);
		}
		if($(this).children('#Email').text()!="null"){
			$("#email").val($(this).children('#Email').text());
		}else{
			$("#email").val(null);
		}
		if($(this).children('#Using').text()!="null"){
			$("#using_YN").val($(this).children('#Using').text());
		}else{
			$("#using_YN").val(null);
		}
		if($(this).children('#Maintask').text()!="null"){
			$("#main_task").val($(this).children('#Maintask').text());
		}else{
			$("#main_task").val(null);
		}
		if($(this).children('#Note').text()!="null"){
			$("#note").val($(this).children('#Note').text());
		}else{
			$("#note").val(null);
		}
		if($(this).children('#Comid').text()!="null"){
			$("#com_id").val($(this).children('#Comid').text());
		}else{
			$("#com_id").val(null);
		}
	});
// 페이지네이션
	var pdate=null;
	var pinput=null;

	$(".anpage").removeClass("active");
	$("#p" + <%=p%>).addClass("active");
	
	$(".anpage").click(function(){
		$("li").removeClass("active");
		$(this).parent().addClass("active");
		
		var pnum = $(this).text();
		pinput=$("#searchbox").val();
		
		if(pinput == "null"){
			pinput = null;
		}
		
		$.ajax({
			type:"GET",
			url:"./companysearch.jsp",
			data:{page:pnum, input:pinput},
			dataType:"html",
			success:function(data){
	            $("#companyt").html(data);
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
		pinput=$("#searchbox").val();
		
		if(pinput == "null"){
			pinput = null;
		}
		
		$.ajax({
			type:"GET",
			url:"./companysearch.jsp",
			data:{page:pnum, input:pinput},
			dataType:"html",
			success:function(data){
	            $("#companyt").html(data);
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
		pinput=$("#searchbox").val();
		
		if(pinput == "null"){
			pinput = null;
		}
		
		$.ajax({
			type:"GET",
			url:"./companysearch.jsp",
			data:{page:pnum, input:pinput},
			dataType:"html",
			success:function(data){
	            $("#companyt").html(data);
	        }
		});
		
	});
	
</script>