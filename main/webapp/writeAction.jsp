<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.boardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<jsp:useBean id="boardDTO" class="board.boardDTO" scope="page"/> 
<jsp:setProperty name="boardDTO" property="title"/>
<jsp:setProperty name="boardDTO" property="content"/>
<jsp:setProperty name="boardDTO" property="id"/>
<%
	System.out.println(boardDTO);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" content="text/html; charset=UTF-8">
<title>jsp 웹사이트</title>
</head>
<body>
<% 
	if(boardDTO.getTitle()==null||boardDTO.getContent()==null){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안된 사항이 있습니다')");
		script.println("history.back()");
		script.println("</script>");
	}else{
		int result_w=-1;
		int result_u=-1;
		boardDAO boardDAO = new boardDAO();
		if(boardDTO.getId()==boardDAO.getNext())
			result_w=boardDAO.write(boardDTO.getTitle(),boardDTO.getContent(),boardDTO.getWriter());
		else{
		result_u=boardDAO.update(boardDTO.getId(),boardDTO.getTitle(),boardDTO.getContent());
		}
		if(result_w==-1){
			if(result_u==-1){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('글쓰기에 실패했습니다')");
			script.println("history.back()");
			script.println("</script>");
			}else{
				PrintWriter script=response.getWriter();
				script.println("<script>");
				script.println("location.href='board.jsp'");
				script.println("location.replace(\'board.jsp\');");
				script.println("</script>");
			}
		}else{
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("location.href='board.jsp'");
			script.println("location.replace(\'board.jsp\');");
			script.println("</script>");
		}
	}
%>
</body>
</html>