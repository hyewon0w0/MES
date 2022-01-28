<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 스타일시트 참조 -->
<link rel="stylesheet" href="css/bootstrap.css">
<title>jsp 게시판</title>
</head>
<body>
<div>
<h4>작업 관리 / 게시판 </h4>
</div>
<hr>
<div class="container">
<fieldset>
<label> 제목 :</label>
<input id=title_Search type="text" name=titleSearch>
<label> 작성일 </label>
<input id=date_Search type="date" name=dateSearch>
</fieldset>
</div>

	<%@ page import="java.util.ArrayList, board.boardDTO, java.text.SimpleDateFormat" %>
	<jsp:useBean id="boarddb" class="board.boardDAO" scope="page" />
	<% 
		ArrayList<boardDTO> list = boarddb.getBoardList(100); 
	   	int counter = list.size();
	   	int row = 0;
	   	
	   	if (counter > 0) {
	%>
    <table width=800 border=0 cellpadding=1 cellspacing=3>
    
    <tr>
       <th><font color=blue><b>번호</b></font></th>
       <th><font color=blue><b>제목</b></font></th>
       <th><font color=blue><b>작성자</b></font></th>
       <th><font color=blue><b>작성일</b></font></th>
    </tr>
	<%
		//게시 등록일을 2010-3-15 10:33:21 형태로 출력하기 위한 클래스 
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		for( boardDTO brd : list ) {
			//홀짝으로 다르게 색상 지정
			String color = "papayawhip";
			if ( ++row % 2 == 0 ) color = "white"; 
	%>
    <tr bgcolor=<%=color %> 
		onmouseover="this.style.backgroundColor='SkyBlue'"
    	onmouseout="this.style.backgroundColor='<%=color %>'">
		<!-- 수정과 삭제를 위한 링크로 id를 전송 -->
       	<td align=left><a href="editboard.jsp?id=<%= brd.getId()%>"><%= brd.getId()%></a></td>
       	<td align=left><%= brd.getTitle() %></td>
		<!-- 게시 작성일을 2010-3-15 10:33:21 형태로 출력 -->
		<td align=left><%= brd.getWriter() %></td>
       	<td align=left><%= df.format(brd.getRegdate()) %></td>

       
    </tr>
	<%
	    }
	%>
	</table>
<% 	}
%>
<hr width=90%>
<p>조회된 게시판 목록 수가 <%=counter%>개 입니다.
<hr>
<center>
<form name=form method=post action=editboard.jsp>
      <input type=submit value="게시등록"> 
</form>
</center>

</body>
</html>
