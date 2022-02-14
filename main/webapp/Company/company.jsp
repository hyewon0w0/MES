<!-- 업체관리 메인 jsp -->
<%@ page import="javax.security.auth.callback.ConfirmationCallback" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="company.*" %>
<%@ page import="java.util.ArrayList" %>

<jsp:useBean id="companyDAO" class="company.companyDAO" scope="page"/>
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
    <link rel="stylesheet" href="companycontent.css?after">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

	<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>
	</head>
	<body>
	<div class=title>업체 관리</div>
	
	<div class="panel panel-default border searchbox">
		<div class="panel-body">
			검색 &nbsp;&nbsp; 
			<input type="text" class="form-control searchtitle" id="searchbox">
			
			<script>
				var pnum="1"
				var input="";
				
				$(document).ready(function(){
					TableSetting();
				});
				function TableSetting(){
					$.ajax({
						type:"GET",
						url:"./companysearch.jsp",
				        data:{page:pnum},	// 페이지 데이터 넘김
				        dataType:"html",
				        success:function(data){
				            $("#companyt").html(data);	
						}	
					});
				}
				// 검색 처리
				$("#searchbox").on("keydown",function(e){	// 검색 창에 값이 입력됨에 따른 이벤트 처리
					if(e.keyCode==13){	// 엔터가 입력 됐을 때 
						input=$("#searchbox").val();
						
						$.ajax({
							type:"GET",
					        url:"./companysearch.jsp",
					        data:{page:"1", input:input},
					        dataType:"html",
					        success:function(data){
					            $("#companyt").html(data);
							}	
						});
					}
				});
			</script>
		</div>
	</div>
	
	<div class="row">
		<div class="panel panel-default border companylistbox col-md-6">
			<div class="panel-heading">
				<h5 class="panel-title" style="display:inline-block;">업체관리</h5>
				<label class="btn btn-primary excel" for="excelbtn">Excel import</label><input style="display:none;" class="excel" type="file" id="excelbtn" onchange="readExcel()"/>
			</div>
			<div class="panel-body">
			<!-- 데이터 리스트 -->
			<div id="companyt"></div>
			</div>
		</div>
		<div class="panel panel-default border companyinputbox col-md-6">
			<div class="panel-heading">
				<h5 class="panel-title">업체 등록/수정</h5>
			</div>
			
			<div class="panel-body">
	
				<form action="companyinsert.jsp" method="post">	
					<table style="border: 0; width: 98%">
					
						<tr>
							<td id="cover">
								<div class="form-group com_name">
									<label for="com_name">상호(이름)<span style="color: red;">*</span></label>
									<input type="text" id="com_name" class="form-control" name="com_name">
								</div>
								<div class="form-group abbreviation">
									<label for="abbreviation">약어</label>
									<input type="text" id="abbreviation" class="form-control" name="abbreviation">
								</div>
								<div class="form-group customers_sortation">
									<label for="customers_sortation">거래처 구분</label>
									<input type="text" id="customers_sortation" class="form-control" name="customers_sortation">
								</div>
							</td>
						</tr>
						<tr>
							<td id="cover">
								<div class="form-group client_status">
									<label for="client_status">고객/외주<span style="color: red;">*</span></label>
									<select id="client_status" name="client_status" class="form-control">
										<option value="고객사">고객사</option>
										<option value="외주사">외주사</option>
									</select>
								</div>
								<div class="form-group customers_group">
									<label for="customers_group">거래처 그룹</label>
									<input type="text" id="customers_group" class="form-control" name="customersgroup">
								</div>
								<div class="form-group representative">
									<label for="representative">대표자명</label>
									<input type="text" id="representative" class="form-control" name="representative">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-group postal_code">
									<label for="postal_code">우편번호</label>
									<input type='number' id="postal_code" class="form-control" name="postal_code">
								</div>
								<div class="form-group address">
									<label for="address">주소</label>
									<input type="text" id="address" class="form-control" name="address">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-group detailed_address">
									<label for="detailed_address">상세주소</label>
									<input type="text" id="detailed_address" class="form-control" name="detailed_address">
								</div>
							</td>
						</tr>
						<tr>
							<td id="cover">
								<div class="form-group com_registration_num">
									<label for="com_registration_num">사업자 등록번호</label>
									<input type="text" id="com_registration_num" class="form-control" name="com_registration_num">
								</div>
								<div class="form-group phone">
									<label for="phone">전화번호</label>
									<input type="text" id="phone" class="form-control" name="phone">
								</div>
								<div class="form-group fax">
									<label for="fax">팩스번호</label>
									<input type="text" id="fax" class="form-control" name="fax">
								</div>
								<div class="form-group manager_name">
									<label for="manager_name">담당자 명</label>
									<input type="text" id="manager_name" class="form-control" name="manager_name">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-group manager_phone">
									<label for="manager_phone">담당자 핸드폰 번호</label>
									<input type='number' id="manager_phone" class="form-control" name="manager_phone">
								</div>
								<div class="form-group email">
									<label for="email">이메일</label>
									<input type="text" id="email" class="form-control" name="email">
								</div>
								<div class="form-group using_YN">
									<label for="using_YN">사용여부</label>
									<select id="using_YN" name="usingYN" class="form-control">
										<option value="Y">Y</option>
										<option value="N">N</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-group main_task">
									<label for="main_task">주요업무</label>
									<input type="text" id="main_task" class="form-control" name="main_task">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="form-group note">
									<label for="note">비고</label>
									<input type="text" id="note" class="form-control" name="note">
								</div>
							</td>
						</tr>
						<tr style='display:none'>
							<td>
								<div class="form-group note">
									<label for="com_id">회사아이디</label>
									<input type="text" id="com_id" class="form-control" name="com_id">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="buttongruops">
									<input class="btn btn-primary" type="reset" value="초기화" id="companyreset">
									<input class="btn btn-primary" type="submit" value="등록" id="companyinsert">
									<input class="btn btn-danger" type="button" value="삭제" id="companydelete" onclick="delete_company()" >
								</div>
							</td>
							<script>
								<!-- 삭제버튼에 따른 이벤트 함수 -->
								function delete_company(){
									var comid=document.getElementById('com_id').value;	// id값이 item_no에 담긴 데이터를 orderdelete로 전송
									location.href='companydelete.jsp?com_id='+comid;
								}
								
								<!-- Excel -->
								
								function readExcel() {
					                let input = event.target;
					                let reader = new FileReader();
					                reader.onload = function () {
					                    let data = reader.result;
					                    let workBook = XLSX.read(data, { type: 'binary' });
					                    let rows = XLSX.utils.sheet_to_json(workBook.Sheets['Sheet1']);
					                    rows.forEach(element => {
					                    	//let e_comid = 0;
					                    	let e_com_name = element["상호"];
					                		let e_abbreviation = element["약어"];
					                		let e_customers_sortation = element["거래처 구분"];
					                		let e_client_outsourcing = element["고객/외주 구분"];
					                		let e_customers_group = element["거래처 그룹"];
					                		let e_representative = element["대표자명"];
					                		let e_postal_code = element["우편번호"];
					                		let e_address = element["주소"];
					                		let e_detailed_address = element["상세주소"];
					                		let e_com_registration_num = element["사업자 등록번호"];
					                		let e_phone = element["전화번호"];
					                		let e_fax = element["팩스번호"];
					                		let e_manager_name = element["담당자명"];
					                		let e_manager_phone = element["담당자 핸드폰 번호"];
					                		let e_email = element["이메일"];
					                		let e_com_using = element["사용여부(Y/N)"];
					                		let e_main_task = element["주요업무"];
					                		let e_note = element["비고"];
					                		
					                		$.ajax({
					                			type:"POST",
					                			url:"./companyinsert.jsp",
					                			data:{com_name:e_com_name, abbreviation:e_abbreviation, customers_sortation:e_customers_sortation, 
					                				client_status:e_client_outsourcing, customers_group:e_customers_group, representative:e_representative, 
					                				postal_code:e_postal_code, address:e_address, detailed_address:e_detailed_address, com_registration_num:e_com_registration_num, 
					                				phone:e_phone, fax:e_fax, manager_name:e_manager_name, manager_phone:e_manager_phone, email:e_email, usingYN:e_com_using,
					                				main_task:e_main_task, note:e_note},
					                			dataType:"html",
					                			success:function(data){
					                				
					                			},
					                			error:function(){
					                				alert("error");
					                			}
					                		});
					                		
					                		sleep(200);
					                    });
					                    TableSetting();
					                }
					                reader.readAsBinaryString(input.files[0]);
								}
								function sleep(ms) {
					        		  const wakeUpTime = Date.now() + ms;
					        		  while (Date.now() < wakeUpTime) {}
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