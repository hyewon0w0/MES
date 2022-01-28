package board;

import java.sql.*;
import java.util.ArrayList;


public class boardDAO {
	// �����ͺ��̽� ���� ���� ��� ����
	
	private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
	private static final String JDBC_URL = "jdbc:mysql://localhost:3306/testdb?useSSL=false&serverTimezone=UTC";
	private static final String USER = "root";
	private static final String PASSWD = "owo0905";

	// �����ͺ��̽� ���� ���� ���� ����
	private Connection con = null;
	private Statement stmt = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs;

	// JDBC ����̹��� �ε��ϴ� ������
	public boardDAO() {
		// JDBC ����̹� �ε�
		try {
			Class.forName(JDBC_DRIVER);
			con=DriverManager.getConnection(JDBC_URL, USER, PASSWD);
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	public String getDate() {	// ���� �ð� �������� �Լ�
		String SQL="SELECT NOW()";
		String kk="";
		try {
			connect();
			
			PreparedStatement pstmt=con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				kk = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return kk; //DB ����
	}
	
	public int getNext() {		// �Խ��� ��ȣ �������� �Լ�
		String SQL="SELECT id FROM board ORDER BY id DESC";
		int k = -1;
		try {
			connect();
			
			PreparedStatement pstmt=con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				k = rs.getInt(1)+1;
			}
			else {
				k = 1;
			}// 1��° �Խù��� ���
			
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return k;	// DB ����
	}
	public boardDTO Bquery(String id) {		// �Խ��� ��ȣ �������� �Լ�
		boardDTO boarddto=null;
		String SQL="SELECT * FROM board WHERE id="+id;
		try {
			connect();
			
			PreparedStatement pstmt=con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				boarddto = new boardDTO(rs.getInt(1), rs.getString(5), rs.getDate(2), rs.getString(3), rs.getString(4));
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		
		if(boarddto == null)
			System.out.println("�� ���� ��������");
		return boarddto; 
	}
	public int bdelete(int id) {
		String SQL="Delete FROM board Where id="+id;
		int k = -1;
		try {
			connect();
			
			PreparedStatement pstmt=con.prepareStatement(SQL);
			k=pstmt.executeUpdate();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return k;
	}
	
	public int write(String title, String content, String writer) {
		String SQL="INSERT INTO board VALUES(?,?,?,?,?)";
		int k = -1;
		try {
			connect();
			
			PreparedStatement pstmt=con.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, getDate());
			pstmt.setString(3, title);
			pstmt.setString(4, content);
			pstmt.setString(5, "admin");
			
			k = pstmt.executeUpdate();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return k;
	}
	
	public int update(int id, String title, String content) {
		String SQL="UPDATE board SET title=?, content=? WHERE id=?";
		int k = -1;
		try {
			connect();
			
			PreparedStatement pstmt=con.prepareStatement(SQL);
			pstmt.setString(1, title);
			pstmt.setString(2, content);
			pstmt.setInt(3, id);
			
			k = pstmt.executeUpdate();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			disconnect();
		}
		return k;
	}
	
	// �����ͺ��̽� ���� �޼ҵ�
	public void connect() {
		try {
			// �����ͺ��̽��� ����, Connection ��ü ���� 
			con = DriverManager.getConnection(JDBC_URL, USER, PASSWD);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// �����ͺ��̽� ���� ���� �޼ҵ� 
	public void disconnect() {
		if(stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} 
		if(con != null) {
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
			
	public ArrayList<boardDTO> getBoardList(int pageNumber) {	
		
		String SQL = "SELECT * FROM board WHERE id<? ORDER BY id DESC LIMIT 10";
		ArrayList<boardDTO> list = new ArrayList<boardDTO>();
		try {
			connect();
			
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber-1)*10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				boardDTO brd = new boardDTO();
				brd.setId ( rs.getInt(1));
				brd.setRegdate ( rs.getTimestamp(2) );
				brd.setTitle ( rs.getString(3));
				brd.setContent ( rs.getString(4));
				brd.setWriter ( rs.getString(5));
								
				//����Ʈ�� �߰�
				list.add(brd);
			}
			rs.close();	
			pstmt.close();
					
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return list;
	}
	
	public boolean nextPage(int pageNumber) {
		String SQL="SELECT * FROM board WHERE id<? ORDER BY id DESC LIMIT 10";
		ArrayList<boardDTO>list=new ArrayList<boardDTO>();
		try {
			connect();
			
			PreparedStatement pstmt=con.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber-1)*10);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				rs.close();
				pstmt.close();	
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		} try {
			rs.close();
			pstmt.close();
		} catch(Exception e){
			e.printStackTrace();
		}
		return false;
	}
}