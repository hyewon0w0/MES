package dbconn;

import java.sql.*;

public class DBconn {
	private String driver = "com.mysql.cj.jdbc.Driver";
	private String url = "jdbc:mysql://192.168.0.115:3306/mes?" + "useUnicode=true&characterEncoding=utf8"; 
	private String id = "Usera";
	private String pw = "1234";
	private Connection con;
	
	public DBconn() {
		try {
			Class.forName(driver);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public Connection getCon(){
		try {
			con = DriverManager.getConnection(url, id, pw);
		}catch(Exception e) {
			e.printStackTrace();
		}
		return con;
	}
	
	public void close() {
		try {
			con.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}