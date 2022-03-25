<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="prodProgress.OrderPartsDTO" %>
<%@ page import="prodProgress.OrderPartDetailDTO" %>
<%@ page import="org.json.simple.JSONObject" %>
<jsp:useBean id="dao" class="prodProgress.ProdProgressDAO"/>
<% request.setCharacterEncoding("UTF-8");
String itemno = request.getParameter("itemno"); %>

<%
List<OrderPartDetailDTO> orderpartdetaillist = dao.getOrderPartDetail(itemno);
%>
<!-- 계획공정 표 -->
<div id="pptablediv">
	<table class="table table-bordered pptable">
       <tr class="tablehead">
           <th rowspan="5" style="text-align: right; padding: 0px;">
               <div class="pptableheaddiv">계획공정</div>
               <div class="pptableheaddiv">WT(H)</div>
               <div class="pptableheaddiv">비용(원)</div>
               <div class="pptableheaddiv">완료예상날짜</div>
           </th>
        <%
        	List<String> processlist = dao.getProcess();
        	if(processlist != null){
        		for(String p : processlist){
        %>
           <th><%=p %></th>
		<%
        		}
        	}
		%>
       </tr>
       <tr class="tablecontent" id="pptableWT"> 
		<%
				for(String p : processlist){
					int WT = 0;
					if(orderpartdetaillist != null){
						for(OrderPartDetailDTO dto : orderpartdetaillist){
							for(JSONObject proc : dto.getProcess()){
								
								if(proc.get("process").equals(p) && proc.get("workstatus").equals("completebox")){
									WT += (int)proc.get("worktime");
								}
							}
						}
					}
					%>
			           <td><%=WT %></td>
			       <%
				}
       %>
       </tr>
       <tr class="tablecontent" id="pptablePrice"> 
		<%
				for(String p : processlist){
					int pr = 0;
					if(orderpartdetaillist != null){
						for(OrderPartDetailDTO dto : orderpartdetaillist){
							for(JSONObject proc : dto.getProcess()){
								
								if(proc.get("process").equals(p) && proc.get("workstatus").equals("completebox")){
									pr += (int)proc.get("pr");
								}
							}
						}
					}
					%>
			           <td><%=pr %></td>
			       <%
				}
       %>
       </tr>
       <tr class="tablecontent" id="pptableExpday"> 
		<%
				int explistindex = 0;
				List<JSONObject> explist = dao.getExpdate(itemno);
				for(String p:processlist){
					if(explist != null){
						if(explistindex < explist.size()){
							if(explist.get(explistindex).get("process").equals(p)){
		%>
			<td id="<%=p%>"><input type="text" class="expdayinput" maxlength="10" value="<%=explist.get(explistindex).get("expd") %>"/></td>
			
		<%					
								explistindex += 1;
							}else{
		%>
           <td id="<%=p%>"><input type="text" class="expdayinput" maxlength="10"/></td>
       <%
							}
						}else{
		%>
           <td id="<%=p%>"><input type="text" class="expdayinput" maxlength="10"/></td>
       <%
						}
					}else{
		%>
           <td id="<%=p%>"><input type="text" class="expdayinput" maxlength="10"/></td>
       <%
        			}
        		}
       %>
       </tr>
   </table>
</div>

<!--진행사항-->
<div id="detailtablediv">
	<table class="table table-bordered detailTable" style="border-spacing: 0px 15px">
<%
	
	if(orderpartdetaillist != null){
		int idindex = 1;
		for(OrderPartDetailDTO dto : orderpartdetaillist){
%>
		<tr>
	        <td style="padding-right: 20px;"><%=idindex %></td>
	        <td style="<%=dto.getStatus_color() %>; color:white;" >
	            <div>
	                부품명 : <%=dto.getPart() %><br>
	                <span style="padding-right:40px;">WT : <%=dto.getTotal_work_time() %></span><span>제조원가 : <%=dto.getPrice() %></span>
	            </div>
	            <div style="margin-top: 10px; text-align: center;" id="<%=dto.getPart()%>" name="<%= dto.getType() %>">
	     <%
	     	if(dto.getOrder_status().equals("내부")){
	     		String dpn = "";
	     		if(dto.getStatus_color().equals("rgb(94, 169, 255)")){
	     			dpn = "display: none;";
	     		}
	     %>
	                <input type="button" value="공구" class="btn btn-default" id="toolbtn" onclick = "toolsClick(this)" style="<%=dpn %>"/>
	                <input type="button" value="작공" class="btn btn-default" onclick="exceldownload(this)"/>
	                <input type="button" value="인쇄" class="btn btn-default"/>
	     <%
	     	}else{
	     		String dpn = "";
	     		if(dto.getStatus_color().equals("background-color: rgb(70, 211, 191); border: 3px dashed black")
	     				|| dto.getStatus_color().equals("background-color: rgb(94, 169, 255); border: 3px dashed black")){
	     			dpn = "display: none;";
	     		}
	     %>
	     			<input id="orderR_modalTogglebtn" type="button" data-toggle="modal" data-target="#orderRmodal" style="display:none";/>
	     			<input type="button" value="발주요청" class="btn btn-default" id="requestbtn" onclick="orderRequestClick(this)" style="<%=dpn %>"/>
	     <%
	     	}
	     %>
	            </div>
	        </td>
	        <td style="padding-right: 50px;">
	            유형 : 금형부품 <br>
	            규격 : <%=dto.getStandard() %><br>
	            수량 : <%=dto.getQuantity() %> <br>
	        </td>
	        <%
	        if(dto.getOrder_status().equals("내부")){
	        %>
	        <td>
	            공정<br>
	            설비<br>
	            시작<br>
	            종료
	        </td>
	        <%
	        }else{
	        %>
	        <td>
	            공정<br>
	            설비<br>
	            ST<br>
	            제.가
	        </td>
	        <%} %>
	     <%
	     	for(JSONObject processwork: dto.getProcess()){
	     %>
	        <td style="padding:0px;">
	            <div style="width: 170px; height: 25px; margin: 3px; margin-bottom: 3px;" class="<%=processwork.get("workstatus") %>">
	                <%= processwork.get("process") %>
	            </div>
	            <div style="width: 95%; text-align: center; margin: 8px; margin-top: 0px;">
	                <%=processwork.get("facilities") %><br>
	                <%=processwork.get("work_start") %><br>
	                <%=processwork.get("work_end") %>
	            </div>
	        </td>
<%
	     	}
	     
			idindex++;
		}
	}
%>
	</table>
</div>
<script>


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