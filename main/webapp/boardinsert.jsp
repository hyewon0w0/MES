<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>��ȸ�� �����غ��ô�</title>
</head>
<body>

<%@ page import="java.sql.*" %>

<h2>��ȸ </h2>

<hr><center>
<h2>�Խ��� ��ȸ</h2>

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
       <td align=center><b>���̵�</b></td>
       <td align=center><b>�ۼ�����</b></td>
       <td align=center><b>����</b></td>
       <td align=center><b>����</b></td>
       <td align=center><b>�ۼ���</b></td>
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
    	out.println("MySql �����ͺ��̽� ��ȸ�� ������ �ֽ��ϴ�. <hr>");
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
