<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>DB test</title>
</head>
<body>

<%@ page import="java.sql.*" %>

<h2>�����ͺ��̽� ����̹� ���� ���� ���α׷� </h2>
<%
try {
    String driverName = "com.mysql.cj.jdbc.Driver";
    String dbURL = "jdbc:mysql://localhost:3306/testdb?useSSL=false&serverTimezone=UTC";

    Class.forName(driverName);
    Connection con = DriverManager.getConnection(dbURL, "root", "owo0905");
    out.println("MySql �����ͺ��̽��� ���������� �����߽��ϴ�");
    con.close();
}
catch (Exception e) {
	out.println("MySql �����ͺ��̽� ���ӿ� ������ �ֽ��ϴ�. <hr>");
    out.println(e.getMessage());
    e.printStackTrace();
}
%>

</body>
</html>