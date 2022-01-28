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

<h2>데이터베이스 드라이버 연결 점검 프로그램 </h2>
<%
try {
    String driverName = "com.mysql.cj.jdbc.Driver";
    String dbURL = "jdbc:mysql://localhost:3306/testdb?useSSL=false&serverTimezone=UTC";

    Class.forName(driverName);
    Connection con = DriverManager.getConnection(dbURL, "root", "owo0905");
    out.println("MySql 데이터베이스에 성공적으로 접속했습니다");
    con.close();
}
catch (Exception e) {
	out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
    out.println(e.getMessage());
    e.printStackTrace();
}
%>

</body>
</html>