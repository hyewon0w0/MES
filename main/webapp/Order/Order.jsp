<!-- 수주관리 메인 jsp -->
<%@ page import="javax.security.auth.callback.ConfirmationCallback" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="order.*" %>
<%@ page import="java.util.ArrayList" %>

<jsp:useBean id="orderDAO" class="order.orderDAO" scope="page"/> 

<!DOCTYPE html>
<html>
	<head>

	<%
		request.setCharacterEncoding("UTF-8");
	
		String duration = request.getParameter("dates");
		
		String startdate = null, enddate = null;
		if(duration != null){
			int index = duration.indexOf(" ");
			startdate = duration.substring(0,index);
			enddate = duration.substring(index+3);
		}
	%>
	
	<meta charset="UTF-8">
		<!--jquery-->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" 
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

        <!--bootstrap-->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="ordercontent.css">
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    
    	<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
        
	</head>
	
<body id="orderp">
<!-- 수주관리 최상단 타이틀 -->
	<div class="title">수주 관리</div>
	
	<!-- 수주관리 검색 패널 -->
	<div class="panel panel-default border searchbox">
		<div class="panel-body">
			검색&nbsp;&nbsp;<input type="text" class="form-control searchtitle" id="searchbox">
			
			<script>
			var pnum = "1";
			var dates = "";
			var input = "";

			<!-- 기본 베이스 테이블 -->
		
			$(document).ready(function(){
				$.ajax({
					type:"GET",
			        url:"./ordersearch.jsp",
			        data:{page:pnum},
			        dataType:"html",
			        success:function(data){
			            $("#ordert").html(data);
					}	
				});
			});
			</script>
			
			<!-- &nbsp;&nbsp;
			차종&nbsp;&nbsp;<select name="car" class="form-control searchtitle">
				<option value="none">전체</option>
				<option value="car1">소나타</option>
				<option value="car2">그랜저</option>
			</select>
			&nbsp;&nbsp;
			업체명&nbsp;&nbsp;<select name="company" class="form-control searchtitle">
				<option value="none">전체</option>
				<option value="company1">814</option>
				<option value="company2">815</option>
			</select>
			&nbsp;&nbsp;
			품명&nbsp;&nbsp;<input type="text" class="form-control searchtitle">-->
			
			수주일&nbsp;&nbsp;<input type="text" name="dates" class="form-control searchtitle">
			
			<script>
			<!-- 검색 -->
			$('input[name="dates"]').daterangepicker({
				timePicker: false,
				locale:{
					format: 'YY/MM/DD'
				},
				"startDate": "<%=orderDAO.getstartdate()%>",
				"endDate": new Date()
			});
			
			$('input[name="dates"]').on("change",function(){
				dates=$('input[name="dates"]').val();
				input=$("#searchbox").val();
				
				$.ajax({
					type:"GET",
			        url:"./ordersearch.jsp",
			        data:{page:"1", date:dates, input:input},
			        dataType:"html",
			        success:function(data){
			            $("#ordert").html(data);
					}	
				});
			});
			
			$("#searchbox").on("keydown",function(e){
				if(e.keyCode==13){
					input=$("#searchbox").val();
					
					$.ajax({
						type:"GET",
				        url:"./ordersearch.jsp",
				        data:{page:"1", input:input},
				        dataType:"html",
				        success:function(data){
				            $("#ordert").html(data);
						}	
					});
				}
			});
			</script>
		</div>
	</div>
	
	<!-- 수주관리 리스트 -->
	<div class="row">
		<div class="panel panel-default border orderlistbox col-md-6">
			<div class="panel-heading">
				<h5 class="panel-title">수주관리</h5>
			</div>
			
			<div class="panel-body">
			<div id="ordert"></div>
				
			</div>
		</div>
		
		<!-- 수주 등록/수정 패널 -->
		<div class="panel panel-default border orderinputbox col-md-6">
			<div class="panel-heading">
				<h5 class="panel-title">수주 등록/수정</h5>
			</div>
			
			<!-- 수주 등록/수정 입력 패널 -->
			<div class="panel-body">
				<form action="orderinsert.jsp" method="post">
					<table style="border: 0; width: 98%">
						<tr>
							<td>
								<div class="form-group quotation">
									<label for="order_quotation">견적서</label>
									<select id="order_et_id" name="quotation" class="form-control">
										<%
											ArrayList<String> et_list=orderDAO.getEtid();
											for(int i=0; i<et_list.size(); i++){
										%>
										<option value="<%= et_list.get(i) %>"><%= et_list.get(i) %></option>
										<%
											}
										%>
									</select>
								</div>
								<div class="form-group itemno">
									<label for="order_itemno">금형번호(ITEM NO)<span style="color: red;">*</span></label>
									<input type="text" id="item_no" class="form-control" name="itemno">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-group company">
									<label for="order_company">업체명<span style="color: red;">*</span></label>
									<select id="order_com_id" name="company" class="form-control">
									<%
										ArrayList<String> com_list=orderDAO.getComid();
										for(int i=0; i<com_list.size(); i++){
									%>
										<option value= "<%= com_list.get(i) %>"><%= com_list.get(i) %></option>
									<%
											}
									%>
									</select>
								</div>
								<div class="form-group orderday">
									<label for="order_orderday">수주일<span style="color: red;">*</span></label>
									<input type="text" id="order_date" class="form-control" name="orderday" value="">
								</div>
							</td>
						</tr>
						<tr>
							<td id="cover">
								<div class="form-group classification">
									<label for="order_classification">수주구분<span style="color: red;">*</span></label>
									<select id="order_status" name="classification" class="form-control">
										<option value="현물수정">현물수정</option>
										<option value="신작">신작</option>
										<option value="기타">기타</option>
									</select>
								</div>
								<div class="form-group parts">
									<label for="order_parts">부품구분<span style="color: red;">*</span></label>
									<select id="part_status" name="parts" class="form-control">
										<option value="test1">TEST</option>
									</select>
								</div>
								<div class="form-group car">
									<label for="order_car">차종<span style="color: red;">*</span></label>
									<select id="car_name" name="car" class="form-control">
										<option value="test1">TEST</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td id="cover">
								<div class="form-group productname">
									<label for="order_productname">품명<span style="color: red;">*</span></label>
									<input type="text" id="prod_name" class="form-control" name="productname">
								</div>
								<div class="form-group amount">
									<label for="order_amount">수주금액(원)</label>
									<input type="number" id="order_price" class="form-control" name="amount">
								</div>
								<div class="form-group negotiate">
									<label for="order_negotiate">네고금액(원)</label>
									<input type="number" id="nego_price" class="form-control" name="negotiate">
								</div>
							</td>
						</tr>
						<tr>
							<td id="cover">
								<div class="form-group expectedday">
									<label for="order_expectedday">출하(납기예정일)</label>
									<input type="text" id="del_date" class="form-control" name="expectedday" value="">
								</div>
								<div class="form-group processcompletionday">
									<label for="order_processcompletionday">공정완료일</label>
									<input type="text" id="proc_end_date" class="form-control" name="processcompletionday" value="" readonly>
								</div>
								<div class="form-group dueday">
									<label for="order_dueday">납기완료일</label>
									<input type="text" id="due_date" class="form-control" name="dueday" value="" readonly>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-group remarks">
									<label for="order_remarks">비고</label>
									<input type="text" id="order_note" class="form-control" name="remarks">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-group image">
									<label for="order_image">도면이미지</label>
									<input type="file" id="item_img" name="img" value="파일 선택">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="buttongruops">
									<input class="btn btn-primary" type="reset" value="초기화" id="orderreset">
									<input class="btn btn-primary" type="button" value="견적서연결" id="connestimates">
									<input class="btn btn-primary" type="button" value="수주복사" id="copyorder">
									<input class="btn btn-primary" type="button" value="납기" id="period">
									<input class="btn btn-primary" type="submit" value="등록" id="orderinsert">
									<input class="btn btn-danger" type="button" value="삭제" id="orderdelete" onclick="delete_order()" > 
								</div>
							</td>
							
							<!-- 수주관리 삭제버튼에 따른 이벤트 함수 -->
							<script>
							function delete_order(){
								var itemno=document.getElementById('item_no').value;
								location.href='orderdelete.jsp?item_no='+itemno;
							}
							</script>
							
						</tr>
					</table>
					
				</form>
			</div>
		</div>
	</div>
</body>
</html>
<script>
<!-- 기타 세팅(날짜 입력 세팅) -->
$(document).on("keyup", "input[name='orderday']", function(e) {
	$(this).val( $(this).val().replace(/[^0-9-]/gi,"") );
	
	$(this).val(date_mask($(this).val()));
});
$(document).on("keyup", "input[name='expectedday']", function(e) {
	$(this).val( $(this).val().replace(/[^0-9-]/gi,"") );
	
	$(this).val(date_mask($(this).val()));
});
function date_mask(objValue) {
	 var v = objValue.replace("--", "-");
	    if (v.match(/^\d{4}$/) !== null) {
	        v = v + '-';
	    } else if (v.match(/^\d{4}\-\d{2}$/) !== null) {
	        v = v + '-';
	    }
	 
	    return v;
	}
</script>
</script>
