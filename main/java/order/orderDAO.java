package order;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import order.orderDTO;

public class orderDAO {

	private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
	private static final String JDBC_URL = "jdbc:mysql://192.168.0.115:3306/mes?useSSL=false&serverTimezone=UTC";
	private static final String USER = "Usera";
	private static final String PASSWD = "1234";

	// 데이터베이스 연결 관련 변수 선언
	private Connection con = null;
	private Statement stmt = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs;

	// JDBC 드라이버를 로드하는 생성자
	public orderDAO() {
		// JDBC 드라이버 로드
		try {
			Class.forName(JDBC_DRIVER);
			con=DriverManager.getConnection(JDBC_URL, USER, PASSWD);
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	public void connect() {
		try {
			// 데이터베이스에 연결, Connection 객체 저장 
			con = DriverManager.getConnection(JDBC_URL, USER, PASSWD);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 데이터베이스 연결 해제 메소드 
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
	
	//데이터 삭제 메소드 
	public int delete(String item_no) {
		String SQL="Delete FROM mes.order Where item_no=\'"+item_no+"\'";
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
	
	//데이터 입력(등록)및 수정 메소드 
	public int write(orderDTO dto) {
		int k = 0;
		try {
			String SQL="INSERT INTO mes.order VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			connect();
			
			PreparedStatement pstmt=con.prepareStatement(SQL);
			
			pstmt.setString(1, dto.getItem_no());
			pstmt.setString(2, dto.getO_com_id());
			pstmt.setString(3, dto.getO_date());
			pstmt.setString(4, dto.getO_status());
			pstmt.setString(5, dto.getP_status());
			pstmt.setString(6, dto.getC_name());
			pstmt.setString(7, dto.getP_name());
			pstmt.setInt(8, dto.getO_price());
			pstmt.setInt(9, dto.getN_price());
			pstmt.setString(10, dto.getDel_date());
			pstmt.setString(11, null);
			pstmt.setString(12, null);
			pstmt.setString(13, dto.getO_note());
			pstmt.setString(14, null);
			pstmt.setString(15, dto.getO_et_id());
			pstmt.setInt(16, dto.getO_num());
			
			k = pstmt.executeUpdate();
			
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		if(k == 0) {
			try {
				String SQL="UPDATE mes.order SET order_com_id=?, order_date=?, order_status=?, part_status=?, car_name=?, "
						+ "prod_name=?, order_price=?, nego_price=?, del_date=?, order_note=?, item_img=?, order_et_id=? WHERE item_no=?";
				connect();
				PreparedStatement pstmt=con.prepareStatement(SQL);
				
				pstmt.setString(1, dto.getO_com_id());
				pstmt.setString(2, dto.getO_date());
				pstmt.setString(3, dto.getO_status());
				pstmt.setString(4, dto.getP_status());
				pstmt.setString(5, dto.getC_name());
				pstmt.setString(6, dto.getP_name());
				pstmt.setInt(7, dto.getO_price());
				pstmt.setInt(8, dto.getN_price());
				pstmt.setString(9, dto.getDel_date());
				pstmt.setString(10, dto.getO_note());
				pstmt.setString(11, dto.getImg());
				pstmt.setString(12, dto.getO_et_id());
				pstmt.setString(13, dto.getItem_no());
				
				k = pstmt.executeUpdate();
				pstmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				disconnect();
			}
		}
		return k;
	}
	
	//데이터 리스트 조회 메소드
	public ArrayList<orderDTO> getOrderList() throws ParseException {	
		
		String SQL = "SELECT * FROM mes.order";
		ArrayList<orderDTO> list = new ArrayList<orderDTO>();
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				orderDTO rs_o = new orderDTO();
				rs_o.setItem_no ( rs.getString(1));
				rs_o.setO_com_id ( rs.getString(2));
				rs_o.setO_date(rs.getString(3));
				rs_o.setO_status ( rs.getString(4));
				rs_o.setP_status ( rs.getString(5));
				rs_o.setC_name ( rs.getString(6));
				rs_o.setP_name(rs.getString(7));
				rs_o.setO_price(rs.getInt(8));
				rs_o.setN_price(rs.getInt(9));
				rs_o.setDel_date(rs.getString(10));
				rs_o.setP_e_date(rs.getString(11));
				rs_o.setDue_date(rs.getString(12));
				rs_o.setO_note ( rs.getString(13));
				rs_o.setImg ( rs.getString(14));
				rs_o.setO_et_id ( rs.getString(15));
								
				//리스트에 추가
				list.add(rs_o);
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
	
	//데이터 리스트 검색 메소드
	public ArrayList<orderDTO> getOrderList2(String txt_where) throws ParseException{
		ArrayList<orderDTO> list = new ArrayList<orderDTO>();
		String SQL="SELECT * FROM mes.order"+ txt_where;
		
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				orderDTO rs_o=new orderDTO();
				
				rs_o.setItem_no ( rs.getString(1));
				rs_o.setO_com_id ( rs.getString(2));
				rs_o.setO_date(rs.getString(3));
				rs_o.setO_status ( rs.getString(4));
				rs_o.setP_status ( rs.getString(5));
				rs_o.setC_name ( rs.getString(6));
				rs_o.setP_name(rs.getString(7));
				rs_o.setO_price(rs.getInt(8));
				rs_o.setN_price(rs.getInt(9));
				rs_o.setDel_date(rs.getString(10));
				rs_o.setP_e_date(rs.getString(11));
				rs_o.setDue_date(rs.getString(12));
				rs_o.setO_note ( rs.getString(13));
				rs_o.setImg ( rs.getString(14));
				rs_o.setO_et_id ( rs.getString(15));
								
				//리스트에 추가
				list.add(rs_o);
			}
			rs.close();
			pstmt.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return list;
	}
	
	public String getstartdate() {
		String SQL="SELECT order_date FROM mes.order order by order_date";
		String result=null;
		
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				result=rs.getString(1);
			}else {
				result="22/01/01";
			}
			
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		if(result!=null) {
			String year=result.substring(2,4);
			String mouth=result.substring(5,7);
			String day=result.substring(8,10);
			result=year.concat("/"+mouth+"/"+day);
		}
		return result;
	}
	
	public ArrayList<String> getEtid() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL="SELECT distinct et_id FROM mes.estimate";
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				list.add(rs.getString(1));
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return list.isEmpty() ? null : list;	//삼항 연산자 빈값이면 null 반환 빈값이 아니면 list 값 반환
	}
	
	public ArrayList<String> getComid() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL="SELECT distinct com_id FROM mes.company";
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				list.add(rs.getString(1));
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return list.isEmpty() ? null : list;	//삼항 연산자 빈값이면 null 반환 빈값이 아니면 list 값 반환
	}
	
	//열 번호 알아내기
		public int getNext() {
			String SQL = "select order_num from mes.order order by order_num desc";
			int res = -1;
			
			try {
				connect();
				PreparedStatement pstmt = con.prepareStatement(SQL);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					res = rs.getInt(1) + 1;
				}
				else {
					res = 1;
				}
				
				rs.close();
				pstmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}finally{
				disconnect();
			}
			return res;
		}
		
	//검색결과 총 금형번호의 수(페이지네이션에서 응용)
	public int getSearchAmount(String txt_where) {
		String SQL = "select count(*) as rownum from mes.order" + txt_where;
		
		int nextnum = -1;
		
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				nextnum = rs.getInt("rownum");
			}
			
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		
		return nextnum;
	}
}
