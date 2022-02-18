package outsourcing;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import order.orderDTO;
import outsourcing.outsourcingDTO;

public class outsourcingDAO {
	private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
	private static final String JDBC_URL = "jdbc:mysql://192.168.0.115:3306/mes?useSSL=false&serverTimezone=UTC";
	private static final String USER = "Usera";
	private static final String PASSWD = "1234";

	// 데이터베이스 연결 관련 변수 선언
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs;

	// JDBC 드라이버를 로드하는 생성자
	public outsourcingDAO() {
		// JDBC 드라이버 로드
		try {
			Class.forName(JDBC_DRIVER);
		} catch(Exception e) {
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
		if(con != null) {
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	//열 번호 세팅
	public int getNext() {
		String SQL = "select outsourcing_no from mes.outsourcing order by outsourcing_no desc";
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
				
		String SQL = "select count(*) as rownum from mes.outsourcing" + txt_where;
		
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
	
	//데이터 리스트 조회 메소드
	public ArrayList<outsourcingDTO> getOutList(int pagenum) throws ParseException {	
		
		String SQL = "SELECT * FROM mes.outsourcing WHERE outsourcing_no<? AND outsourcing.status=0 ORDER BY outsourcing_no DESC LIMIT 10";
		ArrayList<outsourcingDTO> list = new ArrayList<outsourcingDTO>();
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pagenum-1)*10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				outsourcingDTO rs_o = new outsourcingDTO();
				rs_o.setOutsourcing_no(rs.getInt(1));
				rs_o.setOrder_name(rs.getString(2));
				rs_o.setProd_name(rs.getString(3));
				rs_o.setProcess(rs.getString(4));
				rs_o.setType(rs.getString(5));
				rs_o.setCompany(rs.getString(6));
				rs_o.setPrice(rs.getString(7));
				rs_o.setWarehousing_exp_date(rs.getString(8));
				rs_o.setFaulty(rs.getString(9));
				rs_o.setOutstart_date(rs.getString(10));
				rs_o.setOutend_date(rs.getString(11));
								
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
	public ArrayList<outsourcingDTO> getOutList2(int pagenum, String txt_where) throws ParseException{
		ArrayList<outsourcingDTO> list = new ArrayList<outsourcingDTO>();
		String SQL1="SELECT outsourcing_no FROM mes.outsourcing"+ txt_where + " and outsourcing.status=0 ORDER BY outsourcing_no desc";
		String SQL2="SELECT * FROM mes.outsourcing"+ txt_where + " and outsourcing_no<? and outsourcing.status=0 ORDER BY outsourcing_no desc limit 10";
		int num=-1;
		
		try {
			connect();
			PreparedStatement pstmt=con.prepareStatement(SQL1);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				num=rs.getInt(1)+1;
			}else {
				num=1;
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL2);
			pstmt.setInt(1, num-(pagenum-1)*10);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				outsourcingDTO rs_o=new outsourcingDTO();
				
				rs_o.setOutsourcing_no(rs.getInt(1));
				rs_o.setOrder_name(rs.getString(2));
				rs_o.setProd_name(rs.getString(3));
				rs_o.setProcess(rs.getString(4));
				rs_o.setType(rs.getString(5));
				rs_o.setCompany(rs.getString(6));
				rs_o.setPrice(rs.getString(7));
				rs_o.setWarehousing_exp_date(rs.getString(8));
				rs_o.setFaulty(rs.getString(9));
				rs_o.setOutstart_date(rs.getString(10));
				rs_o.setOutend_date(rs.getString(11));
								
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
	
	// 검색패널 - 수주일 시작일자 세팅
	public String getstartdate() {
		String SQL="SELECT warehousing_exp_date FROM mes.outsourcing order by warehousing_exp_date";
		String result=null;
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				result=rs.getString(1);
			}else {
				result="2022-01-01";
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
	
	public String getenddate() {
		String SQL="SELECT warehousing_exp_date FROM mes.outsourcing order by warehousing_exp_date desc";
		String result=null;
		
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				result=rs.getString(1);
			}else {
				
				SimpleDateFormat trasFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				result=trasFormat.format(new Date());
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

	public int update(String num, String date) {
		String SQL="UPDATE mes.outsourcing SET warehousing_date = ?, outsourcing.status = 1 WHERE outsourcing_no="+num;
		int k=0;
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			
			pstmt.setString(1, date);
			
			k=pstmt.executeUpdate();
			pstmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return k;
	}
}
