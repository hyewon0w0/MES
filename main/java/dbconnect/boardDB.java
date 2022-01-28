package dbconnect;

public class boardDB {
	
	public static final String DRIVER = "";
	public static final String URL = "jdbc:mysql://localhost:3306/testdb?useSSL=false&serverTimezone=UTC"; 
	public static final String USERID = "root";
	public static final String USERPW = "owo0905";
	public static final String SQL_WRITE_INSERT = 
			"INSERT INTO board" 
					+ "(id, wirtetime, title, content, writer)" 
					+ "VALUES(?, ?, ?, ?, ?)";

}
