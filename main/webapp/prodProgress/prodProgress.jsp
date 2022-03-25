<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.io.File" %>
<jsp:useBean id="dao" class="prodProgress.ProdProgressDAO"/>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
	
        <!--jquery-->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" 
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

        <!--bootstrap-->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    
    	<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>

        <!-- select2 -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

		<!-- Excel -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>
       	
        <link rel="stylesheet" href="prodProgress.css?ver08">
    </head>
    <body>
        <div class="panel panel-default border searchbox">
            <div class="panel-body">
                <span>금형번호:&nbsp;&nbsp;&nbsp;
                <select class="combobox" id="itemnosel">
                <%
                	List<String> itemnosellist = dao.getItemNO();
                
                	if(itemnosellist != null){
                		for(String itemno : itemnosellist){
                %>
                    <option value="<%=itemno %>"><%=itemno %></option>
                <%}} %>
                </select>
                </span>
                <script>
                    $(document).ready(function(){
                        $("#itemnosel").select2();
                        $("#itemnosel").val(null).select2();
                    });
                </script>

                &nbsp;&nbsp;&nbsp;
                <span>제품상태:&nbsp;&nbsp;&nbsp;
                    <div class="statusbox" style="display:table-cell;">
                        <div class="readybox" style="display:table-cell;"></div>
                        <div class="readyexp" style="display:table-cell; background: white;"><h6 style="font-weight: bold; margin: 10px;">시작대기</h6></div>
                        <div class="progbox" style="display:table-cell;"></div>
                        <div class="progexp" style="display:table-cell; background: white;"><h6 style="font-weight: bold; margin: 10px;">진행중</h6></div>
                        <div class="completebox" style="display:table-cell;"></div>
                        <div class="completeexp" style="display:table-cell; background: white;"><h6 style="font-weight: bold; margin: 10px;">완료</h6></div>
                        <div class="orderbox" style="display:table-cell;"></div>
                        <div class="orderexp" style="display:table-cell; background: white;"><h6 style="font-weight: bold; margin: 10px;">발주</h6></div>                    
                    </div>
                </span>
                &nbsp;&nbsp;&nbsp;
                <span>공정상태:&nbsp;&nbsp;&nbsp;
                    <div class="statusbox" style="display:table-cell;">
                        <div class="readybox" style="display:table-cell;"></div>
                        <div class="readyexp" style="display:table-cell; background: white;"><h6 style="font-weight: bold; margin: 10px;">시작대기</h6></div>
                        <div class="progbox" style="display:table-cell;"></div>
                        <div class="progexp" style="display:table-cell; background: white;"><h6 style="font-weight: bold; margin: 10px;">진행중</h6></div>
                        <div class="completebox" style="display:table-cell;"></div>
                        <div class="completeexp" style="display:table-cell; background: white;"><h6 style="font-weight: bold; margin: 10px;">완료</h6></div>
                        <div class="faultybox" style="display:table-cell;"></div>
                        <div class="faultyexp" style="display:table-cell; background: white;"><h6 style="font-weight: bold; margin: 10px;">불량</h6></div>
                        <div class="outbox" style="display:table-cell;"></div>
                        <div class="outexp" style="display:table-cell; background: white;"><h6 style="font-weight: bold; margin: 10px;">외주</h6></div>                    
                    </div>
                </span>
                &nbsp;&nbsp;&nbsp;
                <input id="partsM_modalTogglebtn" type="button" data-toggle="modal" data-target="#partsMmodal" style="display:none;"/>
                <input id="orderI_modalTogglebtn" type="button" data-toggle="modal" data-target="#orderImodal" style="display:none;"/>
                <input id="toolsR_modalTogglebtn" type="button" data-toggle="modal" data-target="#toolsRmodal" style="display:none;"/>
                <input class="btn btn-primary" type="button" id="partsMbtn" value="부품관리">
                <input class="btn btn-primary" type="button" id="orderIbtn" value="수주정보">
            </div>
        </div>

		<div class="row">
            <div class="panel panel-default border listbox col-md-6" id="prodProgresslist">

                <!--계획 공정표-->
                <div class="panel-body">
                    <div id="prodProgressT"></div>
                </div>
            </div>
        </div>
        
       <!-- 부품관리 modal -->
       <div class="modal fade" id="partsMmodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="partsMclose" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <input class="btn btn-danger" style="float: right; margin-right: 15px;" type="button" id="alldelbtn" value="전체삭제" onclick="partsM_alldelInsert()">
                    <input class="btn btn-primary" style="float: right; margin-right: 5px;" type="button" id="insertrowbtn" value="추가">
                    <input class="btn btn-primary" style="float: right; margin-right: 5px;" type="button" id="exceldisplaybtn" value="Excel Import" onclick="excelbtnevent()"/>
                    <input style="display:none;" type="file" id="excelbtn" onchange="readExcel()">
                    <h4 class="modal-title" id="myModalLabel">부품등록</h4>
                </div>
                <div class="modal-body">
                    <form id="partsMform">
                        <div id="partsMinputbody">
                            <table id="partsMtable" style="border-spacing: 15px; border-collapse: separate; width:100%;">
                                <thead class="table_head">
                                    <tr>
                                        <th style="width:30%;">LAYER</th>
                                        <th style="width:30%;">부품명</th>
                                        <th style="width:20%;">수량</th>
                                        <th style="width:15%;">발주여부</th>
                                        <th style="width:5%;"></th>
                                    </tr>
                                </thead>
                                <tbody>                   
                                    <tr id="addpartMData"></tr>
                                </tbody>
                            </table>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="insertpartsMbtn">저장</button>
                </div>
            </div>
            </div>
        </div>
        
       <!-- 수주정보 -->
       <div class="modal fade" id="orderImodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="orderIclose" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">수주정보</h4>
                </div>
                <div class="modal-body">
                    <form id="orderIform">
                        <div id="orderIinputbody">
                            <table style="border: 0; width: 98%;">
                                <tr>
                                    <td>
                                        <div class="form-group" style="float: left; width: 48%;">
                                            <label for="order_company">고객사명</label>
                                            <select id="order_company" class="form-control">
                                                <%
					                              List<String> com_list=dao.getComid();
					                              for(int i=0; i<com_list.size(); i++){
					                           %>
					                              <option value= "<%= com_list.get(i) %>"><%= com_list.get(i) %></option>
					                           <%
					                                 }
					                           %>
                                            </select>
                                        </div>
                                        <div class="form-group orderI_col" style="float: right; width: 48%;">
                                            <label for="order_price">수주금액</label>
                                            <input id="order_price" type="number" class="form-control">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="form-group orderI_col3">
                                            <label for="parts_status">부품구분</label>
                                            <select id="parts_status" class="form-control">
                                                <%
												List<String> partS_list=dao.getPartstatus();
												for(int i=0; i<partS_list.size(); i++){
												%>
													<option value= "<%= partS_list.get(i) %>"><%= partS_list.get(i) %></option>
												<%
														}
												%>
                                            </select>
                                        </div>
                                        <div class="form-group orderI_col3">
                                            <label for="car_name">제품명</label>
                                            <select id="car_name" class="form-control">
                                                <%
												List<String> CarName_list = dao.getCarName();
												for(int i=0; i<CarName_list.size(); i++){
												%>
													<option value= "<%= CarName_list.get(i) %>"><%= CarName_list.get(i) %></option>
												<%
														}
												%>
                                            </select>
                                        </div>
                                        <div class="form-group orderI_col3">
                                            <label for="item_no">금형번호</label>
                                            <input id="item_no" type="text" class="form-control">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="form-group orderI_col4">
                                            <label for="order_date">수주일</label>
                                            <input type="date" id="order_date" class="form-control">
                                        </div>
                                        <div class="form-group orderI_col4">
                                            <label for="proc_end_date">공정완료일</label>
                                            <input type="date" id="proc_end_date" class="form-control">
                                        </div>
                                        <div class="form-group orderI_col4">
                                            <label for="exp_date">출하(납기예정일)</label>
                                            <input type="date" id="exp_date" class="form-control">
                                        </div>
                                        <div class="form-group orderI_col4">
                                            <label for="due_date">납기완료일</label>
                                            <input type="date" id="due_date" class="form-control">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="form-group orderI_col">
                                            <label for="remarks">비고</label>
                                            <input type="text" id="remarks" class="form-control">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
            </div>
        </div>
        
        <!-- 공구 -->
        <div class="modal fade" id="toolsRmodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="toolsRclose" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <input class="btn btn-danger" style="float: right; margin-right: 15px;" type="button" id="alldelbtn" value="전체삭제" onclick="toolsR_alldelInsert()">
                    <input class="btn btn-primary" style="float: right; margin-right: 5px;" type="button" id="toolsR_insertrowbtn" value="추가">
                    <h4 class="modal-title" id="myModalLabel">공구등록</h4>
                </div>
                <div class="modal-body">
                    <form id="toolsRform">
                        <div id="toolsRinputbody">
                            <table id="toolsRtable" style="border-spacing: 15px; border-collapse: separate; width:100%;">
                                <thead class="table_head">
                                    <tr>
                                        <th style="width:30%;">공구</th>
                                        <th style="width:15%;">단가</th>
                                        <th style="width:15%;">수량</th>
                                        <th style="width:30%;">금액</th>
                                        <th style="width:10%;"></th>
                                    </tr>
                                </thead>
                                <tbody>                   
                                    <tr id="addtoolData"></tr>
                                </tbody>
                            </table>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="inserttoolsRbtn" onclick = "toolsInsert(this)">저장</button>
                    <input type='text' id='toolsPart' style='display:none;'/>
                </div>
            </div>
            </div>
        </div>
        
        <!-- 발주요청 -->
        <div class="modal fade" id="orderRmodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="orderRclose" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">수주정보</h4>
                </div>
                <div class="modal-body">
                    <form id="orderRform">
                        <div id="orderRinputbody">
                            <table id="orderRtable" style="border-spacing: 15px; border-collapse: separate; width:100%;">
                                <tr>
                                   <td>
                                      <div class="form-group" style="float:left; width: 48%;">
                                         <label for="order_request_company">업체<span style="color: red;">*</span></label>
                                         <select id="order_request_company" class="form-control" required name="porder_c">
                                         <%
                                         List<String> company = dao.getCompany();
                                         for(String c:company){
                                         %>
                                            <option value="<%=c%>"><%=c %></option>
                                         <%
                                         }
                                         %>
                                         </select>
                                      </div>
                                      <div class="form-group" style="float: right; width: 48%;">
                                         <label for="order_request_price">단가<span style="color: red;">*</span></label>
                                         <input id="order_request_price" type="number" class="form-control" required name="u_price">
                                      </div>
                                   </td>
                                </tr>
                                <tr>
                                   <td>
                                      <div class="form-group" style="float:left; width: 48%;">
                                         <label for="order_request_expdate">입고예정일<span style="color: red;">*</span></label>
                                         <input id="order_request_expdate" type="date" class="form-control" required name="exp_d">
                                      </div>
                                      <div class="form-group" style="float: right; width: 48%;">
                                         <label for="order_request_amount">수량<span style="color: red;">*</span></label>
                                         <input id="order_request_amount" type="number" class="form-control" required name="noreq">
                                      </div>
                                   </td>
                                </tr>
                            </table>
                        </div>
                        
                        <input type='text' id='partname' style='display:none;' name="partsname"/>
                   		<input type='text' id='parttype' style='display:none;' name="type"/>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="insertorderrequestRbtn" onclick = "requestInsert(this)">저장</button>
                </div>
            </div>
            </div>
        </div>
       
       <script>
          var indexx = 0;
          var indexy = 0;

          $("#partsMbtn").on("click",function(){
              let itemno = $("#itemnosel").val();
              partsM_alldelInsert();
              indexx = 0;
              
              if(itemno != null){
                 if(itemno.length > 0){
                    $.ajax({
                       type:"POST",
                       url:"./SearchInfo",
                       data:{mode:"partinfo", "itemno":itemno},
                       dataType:"JSON",
                       success:function(data){
                          for(var i in data){
                             $("#insertrowbtn").click();
                             var partinfo = data[i];
                             $("#partsMlayer" + i).val(partinfo["layer"]);
                             $("#partsMlayer" + i).attr("readonly",true);
                             $("#partsMpartsname" + i).val(partinfo["part"]);
                             $("#partsMquantity" + i).val(partinfo["quantity"]);
                             $("#partsMorderstatus" + i).val(partinfo["order_status"]).prop("selected",true);
                             $("#partsMorderstatus" + i).attr("readonly",true);
                          }
                       },
                       error:function(){
                          alert("error");
                       }
                    });
                    
                     $("#partsM_modalTogglebtn").click();
                 }else{
                    alert("금형번호를 선택해주세요");
                 }
              }else{
                  alert("금형번호를 선택해주세요");
              }
          });
          
          $(document).on("click","#insertpartsMbtn", function(){
        	let itemno = $("#itemnosel").val();
  			var partform = $("#partsMform").serialize();
  			partform += "&mode=partinsert";
  			partform += ("&itemno=" + itemno);
  			$.ajax({
				type:"POST",
				url:"./InsertInfo",
				data:partform,
				dataType:"JSON",
				success:function(data){
					if(data["result"] == 1){
						alert("등록 혹은 삭제되었습니다.");
						$("#partsMclose").click();
						tsetting(itemno);
					}else{
						$("#partsMclose").click();
						alert("일부 데이터 등록에 실패하였습니다.");
						tsetting(itemno);
					}
				}
			})
          });
      
          $("#orderIbtn").on("click",function(){
              let itemno = $("#itemnosel").val();
              
              $("#orderIform").each(function() {
                  this.reset();
              });
              
              if(itemno != null){
                 if(itemno.length > 0){
                	 $.ajax({
 		                type:"POST",
 		                url:"./SearchInfo",
 		                data:{"itemno":itemno, "mode":"orderinfo"},
 		                dataType:"JSON",
 		                success:function(data){
 		                   $("#order_company").val(data["order_com_id"]);
 		                   $("#order_price").val(data["order_price"]);
 		                   $("#parts_status").val(data["part_status"]);
 		                   $("#car_name").val(data["car_name"]);
 		                   $("#item_no").val(data["item_no"]);
 		                   $("#order_date").val(data["order_date"].substring(0,10));
 		                   
 		                   if(data["proc_end_date"] != null){
 		                	  $("#proc_end_date").val(data["proc_end_date"].substring(0,10));
 		                   }
 		                   if(data["del_date"] != null){
 		                	  $("#exp_date").val(data["del_date"].substring(0,10));
 		                   }
 		                   if(data["due_date"] != null){
 		                	  $("#due_date").val(data["due_date"].substring(0,10));
 		                   }
 		                   
 		                   $("#remarks").val(data["order_note"]);
 		                },
 		                error:function(){
 		                   alert("실패");
 		                }
 		             }); 
                	 
                     $("#orderI_modalTogglebtn").click();
                 }else{
                    alert("금형번호를 선택해주세요");
                 }
              }else{
                  alert("금형번호를 선택해주세요");
              }
          });
          
          document.addEventListener("DOMContentLoaded", function(){
            tsetting(null);
          });
          
          $("#itemnosel").on("change",function(){
        	  let ino = $("#itemnosel").val();
        	  tsetting(ino);
          });
          
          function tsetting(ino){
        	  $("#prodProgressT").html(null); 
        	 
             $.ajax({
                 type:"GET",
                 url:"./prodProgressSearch.jsp",
                 data:{itemno:ino},
                 dataType:"html",
                 success:function(data){
                    $("#prodProgressT").html(data);
                 }
              });
          }
          
          $("#insertrowbtn").on("click",function(){
              var rowItem="<tr id='partsMaddbody'>";
                  rowItem+="<td class='form-group'>";
                  rowItem+="<input type='text' id='partsMlayer" + indexx +"' class='form-control' name='partsMlayer' required>";
                  rowItem+="</td>";
                  rowItem+="<td class='form-group'>";
                  rowItem+="<input type='text' id='partsMpartsname" + indexx +"' class='form-control' name='partsMpartsname' required>";
                  rowItem+="</td>";
                  rowItem+="<td class='form-group'>";
                  rowItem+="<input type='number' id='partsMquantity" + indexx +"' class='form-control' name='partsMquantity' required>";
                  rowItem+="</td>";
                  rowItem+="<td class='form-group'>";
                  rowItem+="<select id='partsMorderstatus" + indexx +"' class='form-control' name='partsMorderstatus'>";
                  rowItem+="<option value='내부'>내부</option>";
                  rowItem+="<option value='발주'>발주</option>";
                  rowItem+="</select>";
                  rowItem+="</td>";
                  rowItem+="<td>";
                  rowItem+="<input type='button' id='partsMdelbtn' class='btn btn-common' name='partsMinput' value='삭제' onclick='delInsert(this)'>";
                  rowItem+="</td>";
                  rowItem+="</tr>";
                  
                  $("#addpartMData").before(rowItem);
                  indexx += 1;
          });
          
          function delInsert(obj){
              var number = obj.parentNode.parentNode.children[4].children[0].value;

              var div=$(obj).parent().parent();
              div.remove();
           
           }

          function partsM_alldelInsert(){
              $("tr[id=partsMaddbody]").remove();
           }
            
          $("#toolsR_insertrowbtn").on("click",function(){
              var rowItem="<tr id='toolsRaddbody'>";
                  rowItem+="<td class='form-group'>";
                  rowItem+="<select id='toolsRtool" + indexy + "' class='form-control' name='toolsRtool'>";
           <%
                 List<String> tlist = dao.getTools();
                 for(String t : tlist){
           %>
                  rowItem+="<option value='<%=t%>'><%=t%></option>";
           <%
                 }
           %>
                  rowItem+="</select>";
                  rowItem+="</td>";
                  rowItem+="<td class='form-group'>";
                  rowItem+="<input type='number' id='toolsRunitprice" + indexy + "' class='form-control' name='toolsRunitprice' onchange='calcPrice_uprice(this)'>";
                  rowItem+="</td>";
                  rowItem+="<td class='form-group'>";
                  rowItem+="<input type='number' id='toolsRamount" + indexy + "' class='form-control' name='toolsRamount' onchange='calcPrice_amount(this)'>";
                  rowItem+="</td>";
                  rowItem+="<td class='form-group'>";
                  rowItem+="<input type='number' id='toolsRprice" + indexy + "' class='form-control' name='toolsRprice' readonly>";
                  rowItem+="</td>";
                  rowItem+="<td>";
                  rowItem+="<input type='button' id='toolsRdelbtn' class='btn btn-common' name='toolsRinput' value='삭제' onclick='delInsert(this)'>";
                  rowItem+="</td>";
                  rowItem+="</tr>";

                  $("#addtoolData").before(rowItem);
                  indexy += 1;
          });

            
          function toolsR_alldelInsert(){
              $("tr[id=toolsRaddbody]").remove();
           }
              
              <!-- Excel -->
              
              function excelbtnevent(){
            	  $("#excelbtn").click();
              };
				
				function readExcel() {
					let itemno = $("#itemnosel").val();
					let mode = "partexcelinsert";
					
	                let input = event.target;
	                let reader = new FileReader();
	                let success = 1;
	                
	                reader.onload = function () {
	                    let data = reader.result;
	                    let workBook = XLSX.read(data, { type: 'binary' });
	                    let rows = XLSX.utils.sheet_to_json(workBook.Sheets['Sheet1']);
	                     
	                    rows.forEach(element => {
	                    	let partsMpartsname = element["파트"];
	                		let partsMlayer = element["CORE"];
	                		let partsMquantity = element["수량"];
	                		let partsMorderstatus = element["발주여부(내부/발주)"];
	                		
	                		$.ajax({
	                			type:"POST",
	                			url:"./InsertInfo",
	                			data:{"partsMpartsname":partsMpartsname, "partsMlayer":partsMlayer, 
	                				"partsMquantity":partsMquantity, "partsMorderstatus":partsMorderstatus,
	                				"itemno":itemno, "mode":mode},
	                			dataType:"JSON",
	                			success:function(data){
	                				if(data["result"] == 0){
	                					success = 0;
	                				}
	                			},
	                			error:function(){
	                				alert("error");
	                			}
	                		});
	                		
	                		sleep(200);
	                    });
	                    
	                    if(success == 1){
	                    	alert("등록에 성공하였습니다.");
	                    }else{
	                    	alert("일부 데이터 등록에 실패하였습니다.");
	                    }
	                    
	                    $("#partsMclose").click();
	                    tsetting();
	                }
	                reader.readAsBinaryString(input.files[0]);
				}
				function sleep(ms) {
	        		  const wakeUpTime = Date.now() + ms;
	        		  while (Date.now() < wakeUpTime) {}
	        	}
				
				function toolsClick(t){
	                  indexy = 0;
	                     let itemno = $("#itemnosel").val();
	                     let partsname = t.parentNode.getAttribute("id");
	                     $("#toolsPart").val(partsname);

	                     toolsR_alldelInsert();
	                     
	                     if(itemno != null && partsname != null){
	                        if(itemno.length > 0 && partsname.length > 0){
	                           $.ajax({
	                              type:"POST",
	                              url:"./SearchInfo",
	                              data:{mode:"toolsinfo", "itemno":itemno, "partsname":partsname},
	                              dataType:"JSON",
	                              success:function(data){
	                                 for(var i in data){
	                                    $("#toolsR_insertrowbtn").click();
	                                    var toolsinfo = data[i];
	                                    $("#toolsRtool" + i).val(toolsinfo["tool_name"]);
	                                    $("#toolsRunitprice" + i).val(toolsinfo["unit_price"]);
	                                    $("#toolsRamount" + i).val(toolsinfo["stock"]);
	                                    $("#toolsRprice" + i).val(toolsinfo["price"]);
	                                 }
	                              },
	                              error:function(){
	                                 alert("error");
	                              }
	                           });
	                           $("#toolsR_modalTogglebtn").click();
	                        }else{
	                           alert("오류");
	                        }
	                     }else{
	                        alert("오류");
	                     }
	                  }
	             
	             function toolsInsert(t){
	                     let itemno = $("#itemnosel").val();
	                     let partsname = $("#toolsPart").val();
	                     
	                     var partform = $("#toolsRform").serialize();
	                     partform += "&mode=toolsinsert";
	                     partform += ("&itemno=" + itemno);
	                     partform += ("&partsname=" + partsname);
	                     
	                     $.ajax({
	                           type:"POST",
	                           url:"./InsertInfo",
	                           data:partform,
	                           dataType:"JSON",
	                           success:function(data){
	                              if(data["result"] == 1){
	                                 alert("등록 혹은 삭제되었습니다.");
	                                 $("#toolsRclose").click();
	                                 tsetting(itemno);
	                              }else{
	                                 $("#toolsRclose").click();
	                                 alert("일부 데이터 등록에 실패하였습니다.");
	                                 tsetting(itemno);
	                              }
	                           }
	                        })
	                     
	             };
	             
	             function calcPrice_uprice(t){
	                var amount = t.parentNode.parentNode.children[2].children[0].value;
	                var uprice = t.value;
	                
	                t.parentNode.parentNode.children[3].children[0].value = amount * uprice;
	             }
	             
	             function calcPrice_amount(t){
	                var amount = t.value;
	                var uprice = t.parentNode.parentNode.children[1].children[0].value;
	                
	                t.parentNode.parentNode.children[3].children[0].value = amount * uprice;
	             }
	             
	             function orderRequestClick(t){
	                 $("#orderR_modalTogglebtn").click();
	                 
	                 var p = t.parentNode.getAttribute("id");
	                 var tp = t.parentNode.getAttribute("name");
	                 
	                 $("#partname").val(p);
	                 $("#parttype").val(tp);
	              }
	             
	             function requestInsert (){
	            	 var orderRform = $("#orderRform").serialize();
	            	 
	            	 let itemno = $("#itemnosel").val();
	            	 orderRform += ("&itemno=" + itemno);
	            	 orderRform += ("&mode=OrderRequest");
	            	 
	            	 $.ajax({
                         type:"POST",
                         url:"./InsertInfo",
                         data: orderRform,
                         dataType:"JSON",
                         success:function(data){
                            if(data["result"] == 1){
                               alert("등록되었습니다.");
                               $("#orderRclose").click();
                               tsetting(itemno);
                            }else{
                               alert("등록에 실패하였습니다.");
                            }
                         }
                      })
	            	 
	             };
	             
	        	<!-- 작공 -->
	        	function exceldownload(t){
	        		$.ajax({
	        			type:"POST",
                        url:"./SearchInfo",
                        data: {"mode":"excelinfo"},
                        dataType:"JSON",
                        success:function(data){
                        	alert(data["rp"]);
                        }
	        		});
	        	}
	        	
	        	<!--계획공정 예상날짜 입력-->
	        	
	        	$(document).ready(function(){
	        		$(".expdayinput").hover(
	        			function(){$(this).attr("placeholder","____-__-__");},
	        			function(){$(this).removeAttr("placeholder");});
	        	});

	        	$(document).on("keyup", ".expdayinput", function(e) {
	        		$(this).val( $(this).val().replace(/[^0-9-]/gi,"") );
	        		$(this).val(date_mask($(this).val()));
	        		
	        		if(e.keyCode == 13){
	        			var itemno = $("#itemnosel").val();
	        			var procname = $(this).parent().attr("id");
	        			var exp_date = $(this).val();
	        			
	        			$.ajax({
	        				type:"POST",
	        				url:"./InsertInfo",
	        				data:{"mode": "pedinsert", "itemno":itemno, "procname":procname, "expdate":exp_date},
	        				dataType:"JSON",
	        				success:function(data){
	        					if(data["result"] == 1){
	        						alert("저장되었습니다.");
	        						tsetting(itemno);
	        					}else{
	        						alert("실패하였습니다.");
	        						tsetting(itemno);
	        					}
	        				},
	        				error:function(){
	        					alert("error");
	        				}
	        			})
	        		}
	        	});

     </script>
    </body>
</html>
<%
File dir = new File("C:\\Users");
File files[] = dir.listFiles();

for (int i = 0; i < files.length; i++) {
    System.out.println("file: " + files[i]);
}
%>