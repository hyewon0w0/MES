<!-- 수주관리 메인 jsp -->
<%@ page import="javax.security.auth.callback.ConfirmationCallback" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="order.*" %>
<%@ page import="java.util.ArrayList" %>

<jsp:useBean id="orderDAO" class="order.orderDAO" scope="page"/> 

<!DOCTYPE html>
<html>
	<head>

	<%
		request.setCharacterEncoding("UTF-8");
	
		String duration = request.getParameter("dates");//name이 dates인 값을 가져옴(검색패널의 수주일)
		
		String startdate = null, enddate = null;
		if(duration != null){
			//공백을 기준으로 시작일과 종료일 설정
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
        <link rel="stylesheet" href="./ordercontent.css?ver02">
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
			검색 &nbsp;&nbsp; 
			<input type="text" class="form-control searchtitle" id="searchbox">
			
			<!-- 기본 베이스 테이블 세팅 -->
			<script>
			var pnum = "1";// 페이지
			var dates = "";// 수주일
			var input = "";// 입력 데이터
			$(document).ready(function(){
				$.ajax({
					type:"GET",
			        url:"./ordersearch.jsp",
			        data:{page:pnum},	// 페이지 데이터 넘김
			        dataType:"html",
			        success:function(data){
			            $("#ordert").html(data);	// 요청 성공 시 ordert에 데이터를 세팅 
					}	
				});
			});
			</script>			
			&nbsp;&nbsp;&nbsp;&nbsp;수주일&nbsp;&nbsp;
			<input type="text" name="dates" class="form-control searchtitle">
			
			<!-- 검색 -->
			<script>	
			// 수주일 세팅
			$('input[name="dates"]').daterangepicker({ // .daterangepicker = 시작일시와 종료일시를 받는 컴포넌트
				timePicker: false,	// 시간 노출 여부 false
				locale:{	
					format: 'YY/MM/DD'	// 일시 노출 포맷
				},
				"startDate": "<%=orderDAO.getstartdate()%>",	
				"endDate": new Date() // 시작일자(데이터 중 가장 오래된 수주일)과 종료일자(오늘) 설정
			});
			
			// 검색과 수주일 처리
			$('input[name="dates"]').on("change",function(){	// 날짜 변경에 대한 이벤트 처리 
				dates=$('input[name="dates"]').val();	// 입력한 날짜 값 저장
				input=$("#searchbox").val();	// 검색 창에 입력한 값 저장
				
				$.ajax({
					type:"GET",
			        url:"./ordersearch.jsp",
			        data:{page:"1", date:dates, input:input},	// 페이지=1, 입력한 날짜 및 검색 조건 넘김
			        dataType:"html",
			        success:function(data){
			            $("#ordert").html(data);
					}	
				});
			});
			
			// 검색 처리
			$("#searchbox").on("keydown",function(e){	// 검색 창에 값이 입력됨에 따른 이벤트 처리
				if(e.keyCode==13){	// 엔터가 입력 됐을 때 
					input=$("#searchbox").val();
					dates=$('input[name="dates"]').val();	
				
					$.ajax({
						type:"GET",
				        url:"./ordersearch.jsp",
				        data:{page:"1", input:input, date:dates},
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
				<h5 class="panel-title" style="display:inline-block;">수주관리</h5>
				<!-- 완료/비상 -->
				<div class="warningbox" style="float: right;">
					<div class="completegreenbox" style="display:table-cell;"></div>
                    <div class="completegreenexp" style="display:table-cell; background: white;"><h4 style="font-weight: bold; margin: 10px;">완료</h4></div>
                    <div class="warningredbox" style="display:table-cell;"></div>
                    <div class="warningboxexp" style="display:table-cell; background: white;"><h4 style="font-weight: bold; margin: 10px;">비상</h4></div>                    
                </div>
			</div>
			
			<div class="panel-body">
			<!-- 데이터 리스트 -->
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
				<!-- 등록 버튼 클릭 시 orderinsert로 데이터 전송 -->
				<form action="orderinsert.jsp" method="post">	
					<table style="border: 0; width: 98%">
						<!-- 수주 등록/수정 테이블 세팅 -->
						<tr>
							<td>
								<div class="form-group quotation">
									<label for="order_quotation">견적서</label>
									<!-- 견적서 번호 콤보박스 세팅 -->
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
									<!-- 업체명 콤보박스 세팅 -->
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
									<!-- 수주구분 콤보박스 세팅 -->
									<select id="order_status" name="classification" class="form-control">
										<%
										ArrayList<String> orderS_list=orderDAO.getOrderstatus();
										for(int i=0; i<orderS_list.size(); i++){
										%>
											<option value= "<%= orderS_list.get(i) %>"><%= orderS_list.get(i) %></option>
										<%
												}
										%>
									</select>
								</div>
								<div class="form-group parts">
									<label for="order_parts">부품구분<span style="color: red;">*</span></label>
									<!-- 부품구분 콤보박스 세팅 -->
									<select id="part_status" name="parts" class="form-control">
										<%
										ArrayList<String> partS_list=orderDAO.getPartstatus();
										for(int i=0; i<partS_list.size(); i++){
										%>
											<option value= "<%= partS_list.get(i) %>"><%= partS_list.get(i) %></option>
										<%
												}
										%>
									</select>
								</div>
								<div class="form-group car">
									<label for="order_car">기타<span style="color: red;">*</span></label>
									<input type="text" id="car_name" name="car" class="form-control">
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
									<input type="text" id="proc_end_date" class="form-control" name="processcompletionday" readonly>
								</div>
								<div class="form-group dueday">
									<label for="order_dueday">납기완료일</label>
									<input type="text" id="due_date" class="form-control" name="dueday" readonly>
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
									<input class="btn btn-primary" type="button" value="수주복사" id="copyorder" onclick="order_copy(this.form)">
									<input class="btn btn-primary" type="button" value="납기" id="period">
									<input class="btn btn-primary" type="submit" value="등록" id="orderinsert">
									<input class="btn btn-danger" type="button" value="삭제" id="orderdelete" onclick="delete_order()" > 
								</div>
							</td>
							
							<script>
							<!-- 수주관리 삭제버튼에 따른 이벤트 함수 -->
							function delete_order(){
								var itemno=document.getElementById('item_no').value;	// id값이 item_no에 담긴 데이터를 orderdelete로 전송
								location.href='orderdelete.jsp?item_no='+itemno;
							}
							
							<!-- 수주복사 버튼에 따른 이벤트 함수 -->
							function order_copy(frm){
								frm.action = './ordercopy.jsp';
								frm.submit();	
							}
							
							<!-- 납기 버튼에 따른 이벤트 함수 -->
							$(document).on("click","#period",function(){
								$("#due_date").val(dateFormat(new Date()));
								$("form").submit();
							});
							
							<!-- 납기취소 버튼에 따른 이벤트 함수 -->
							$(document).on("click","#noperiod",function(){
								$("#due_date").val(null);
								$("form").submit();
							});
							
							function dateFormat(date) {
						        let month = date.getMonth() + 1;
						        let day = date.getDate();
						        month = month >= 10 ? month : '0' + month;
						        day = day >= 10 ? day : '0' + day;
						        return date.getFullYear() + '-' + month + '-' + day;
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
<!-- 견적서에 따른 업체명, 수주금액 로딩 함수 -->
$("#order_et_id").on("change",function(e){
	et_id=$("#order_et_id").val();
		
	$.ajax({
		type:"GET",
        url:"./orderselectbox.jsp",
        data:{et_id:et_id},
        dataType:"html",
        success:function(data){
			var d=JSON.parse(data);
			$("#order_com_id").val(d.company);
			$("#order_price").val(d.price);
		}
	});
});
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