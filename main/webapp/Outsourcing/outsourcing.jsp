<!-- 외주관리 메인 jsp -->
<%@ page import="javax.security.auth.callback.ConfirmationCallback" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="outsourcing.*" %>
<%@ page import="java.util.ArrayList" %>

<jsp:useBean id="outsourcingDAO" class="outsourcing.outsourcingDAO" scope="page"/>
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
    <link rel="stylesheet" href="outsourcingcontent.css?ver02">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

	<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>
	</head>
<body id="outsourcingp">
<div class=title>발주입고 관리 / 외주 관리</div>
	
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
			        url:"./outsourcingsearch.jsp",
			        data:{page:pnum},	// 페이지 데이터 넘김
			        dataType:"html",
			        success:function(data){
			            $("#outsourcingt").html(data);	// 요청 성공 시 ordert에 데이터를 세팅 
					}	
				});
			});
			</script>			
			&nbsp;&nbsp;&nbsp;&nbsp;입고예정일&nbsp;&nbsp;
			<input type="text" name="dates" class="form-control searchtitle">
			
			<label class="btn btn-primary Warehousing" id="warehousing" for="Warehousingbtn">입고</label>
			<input style="display:none;" class="warehousing" type="button" id="Warehousingbtn" data-toggle="modal" data-target="#warehousingmodal"/>
			<!-- 검색 -->
			<script>	
			// 수주일 세팅
			$('input[name="dates"]').daterangepicker({ // .daterangepicker = 시작일시와 종료일시를 받는 컴포넌트
				timePicker: false,	// 시간 노출 여부 false
				locale:{	
					format: 'YY/MM/DD'	// 일시 노출 포맷
				},
				"startDate": "<%=outsourcingDAO.getstartdate()%>",	
				"endDate": "<%=outsourcingDAO.getenddate()%>"
			});
			
			// 검색과 수주일 처리
			$('input[name="dates"]').on("change",function(){	// 날짜 변경에 대한 이벤트 처리 
				dates=$('input[name="dates"]').val();	// 입력한 날짜 값 저장
				input=$("#searchbox").val();	// 검색 창에 입력한 값 저장
				
				$.ajax({
					type:"GET",
			        url:"./outsourcingsearch.jsp",
			        data:{page:"1", date:dates, input:input},	// 페이지=1, 입력한 날짜 및 검색 조건 넘김
			        dataType:"html",
			        success:function(data){
			            $("#outsourcingt").html(data);
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
				        url:"./outsourcingsearch.jsp",
				        data:{page:"1", input:input, date:dates},
				        dataType:"html",
				        success:function(data){
				            $("#outsourcingt").html(data);
						}	
					});
				}
			});
			
			$(document).on("click", "#insertwhbtn", function(){
				var wDay = $("#warehousingday").val();
				$("input:checkbox[name=chkbox]:checked").each(function(){
					$.ajax({
			              type:"POST",
			              async:false,
			              url:"./outsourcingwarehousing.jsp",
			              data:{"chk_arr":this.value, Wday:wDay},
			              success:function(data){

			            },
			            error:function(){
			               alert("error");
			            }
			           });
				});
				if(this.value!=null){
					alert("성공");
					location.reload();
				}else{
					alert("실패");
				}
			});
			
			</script>
		</div>
	</div>
	
    <div class="modal fade" id="warehousingmodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
            <button id="warehousingclose" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="myModalLabel">입고일</h4>
            </div>
            <div class="modal-body">
             <form id="warehousingform">
                 <div id="warehousinginputbody">
                     <div>
                         <div class="form-group warehousinginput">
                             <label for="warehousingday">시작시간</label>
                             <input type="date" id="warehousingday" class="form-control" name="whinput">
                         </div>
                     </div>
                 </div>          
             </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="insertwhbtn">등록</button>
            </div>
        </div>
        </div>
    </div>
	
	<div class="row">
		<div class="panel panel-default border outsourcinglistbox col-md-6">
			<div class="panel-heading">
				<h5 class="panel-title" style="display:inline-block;">외주 관리</h5>
				<!-- 완료/비상 -->
				<div class="warningbox" style="float: right;">
					<div class="warningredbox" style="display:table-cell;"></div>
                	<div class="warningboxexp" style="display:table-cell; background: white;"><h4 style="font-weight: bold; margin: 10px;">비상</h4></div>
				</div>
			<div class="panel-body">
				<!-- 데이터 리스트 -->
				<div id="outsourcingt" class="coutsourcingtable"></div>
			</div>
			</div>
		</div>
	</div>
</body>
</html>