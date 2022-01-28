<%@ page import="javax.security.auth.callback.ConfirmationCallback" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.*" %>
<%@ page import="java.util.ArrayList" %>


<jsp:useBean id="boardDAO" class="board.boardDAO" scope="page"/> 

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>


<title>OwO</title>
<style type="text/css">
	a,a:hover{
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	int pageNumber=1;
	if(request.getParameter("pageNumber")!=null){
		pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
	}
%>
<nav class="navbar navbar-default">
	
	<div class="container">
		<div class="row">
		<div>
			<table class="table table-striped" style="text-align:left; border:1px solid #dddddd; width:750px" >
				<thead>
					<tr>
						<th colspan="4"
								style="background-color: #eeeeee; text-align: left;">게시판 리스트
						</th>
					</tr>
					<tr>
						<th style="background-color: #eeeeee; text-align: left;">No.</th>
						<th style="background-color: #eeeeee; text-align: left;">제목</th>
						<th style="background-color: #eeeeee; text-align: left;">작성자</th>
						<th style="background-color: #eeeeee; text-align: left;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						boardDAO BoardDAO=new boardDAO();
						ArrayList<boardDTO> list = BoardDAO.getBoardList(pageNumber);
						for(int i=0; i<list.size(); i++){
					%>
					<tr>
						<td><%=list.get(i).getId()%></td>
						<td><a href="board.jsp?Id=<%=list.get(i).getId()%>"> <%= list.get(i).getTitle() %> </a></td>
						<td><%=list.get(i).getWriter()%></td>
						<td><%=list.get(i).getRegdate()%></td>
					</tr>
					
					<%
					}
					%>
				</tbody>
			</table>
			<%
				if(pageNumber != 1){
			%>
			<a href="board.jsp?pageNumber=<%=pageNumber-1%>"
				class="btn btn-success btn-arrow-left">이전</a>
			<%
				}
				if(boardDAO.nextPage(pageNumber)){
			%>
			<a href="board.jsp?pageNumber=<%=pageNumber+1%>"
				class="btn btn-success btn-arrow-left">다음</a>
			<%
				}		
			%>
		</div>
		<div>
			<form method="post" action="writeAction.jsp">
				<table class="table table-striped"
					style="text-align:left; border: 1px solid #dddddd; width:750px ">
					<thead>
						<tr>
							<th colspan="2"
								style="background-color: #eeeeee; text-align: left;">게시판 등록/수정
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
								게시판 번호<input id="bid" type="text" class="form-control" name="id" maxlength="25" value=<%=boardDAO.getNext()%> readonly />
							</td>
						</tr>
						<tr>
							<td>
								작성일자<input id="bregdate" type="text" class="form-control" name="regdate" maxlength="25" value=<%=boardDAO.getDate()%> readonly />
							</td>
						</tr>
						<tr>
							<td>
								게시판 제목<input id="btitle" type="text" class="form-control" name="title" maxlength="50"/>
							</td>
						</tr>
						<tr>
							<td>
								게시판 내용<textarea id="bcontent" class="form-control" placeholder="글 내용" name="content" maxlength="2048" style="height: 200px;"></textarea>
							<input type="reset" class="btn btn-primary pull-right" value="초기화" />
							<input type="submit" class="btn btn-primary pull-right" value="저장" />
							<input type="button" class="btn btn-primary pull-right" value="삭제" onclick="deleteb()" />
							</td>
							
							<script>
							function deleteb(){
								var bid=document.getElementById('bid').value;
								location.href='deleteAction.jsp?Id='+bid;
							}
							</script>
							
						</tr>
					</tbody>
					<script>
					<%
					String id = (String)request.getParameter("Id");
					if(id!=null){
					boardDTO boarddto=BoardDAO.Bquery(id);
					%>
						$("#bid").val("<%= boarddto.getId() %>");
						$("#bregdate").val("<%=boarddto.getRegdate() %>");
						$("#btitle").val("<%=boarddto.getTitle() %>");
						$("#bcontent").val("<%=boarddto.getContent() %>");

						<%
					}
						%>
					</script>			
				</form>
				
			</div>
		</div>
	</div>

</nav>

</body>
</html>