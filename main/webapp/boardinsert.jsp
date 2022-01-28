<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>조회를 시작해봅시다</title>
</head>
<body>

<%@ page import="java.sql.*" %>

<h2>조회 </h2>

<hr><center>
<h2>게시판 조회</h2>

<%
    Connection con = null;
    Statement stmt = null;
    String driverName = "com.mysql.cj.jdbc.Driver";
    String dbURL = "jdbc:mysql://localhost:3306/testdb?useSSL=false&serverTimezone=UTC";

    try {
        Class.forName(driverName);
        con = DriverManager.getConnection(dbURL, "root", "owo0905");
        stmt = con.createStatement();
        ResultSet result = stmt.executeQuery("select * from board;");
%>
    <table width=100% border=2 cellpadding=1>
    <tr>
       <td align=center><b>아이디</b></td>
       <td align=center><b>작성일자</b></td>
       <td align=center><b>제목</b></td>
       <td align=center><b>내용</b></td>
       <td align=center><b>작성자</b></td>
    </tr>
<%
        while (result.next()) {
%>
    <tr>
       <td align=center><%= result.getString(1) %></td>
       <td align=center><%= result.getString(2) %></td>
       <td align=center><%= result.getString(3) %></td>
       <td align=center><%= result.getString(4) %></td>
       <td align=center><%= result.getString(5) %></td>
    </tr>
<%
        }
        result.close();
    }
    catch(Exception e) {
    	out.println("MySql 데이터베이스 조회에 문제가 있습니다. <hr>");
        out.println(e.toString());
        e.printStackTrace();
    }
    finally {
        if(stmt != null) stmt.close();
        if(con != null) con.close();
    }
%>
</table>
</center>

</body>
</html>
