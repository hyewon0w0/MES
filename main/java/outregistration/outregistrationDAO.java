package outregistration;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import outregistration.outregistrationDTO;

public class outregistrationDAO {
	private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
	private static final String JDBC_URL = "jdbc:mysql://192.168.0.115:3306/mes?useSSL=false&serverTimezone=UTC";
	private static final String USER = "Usera";
	private static final String PASSWD = "1234";

	// 데이터베이스 연결 관련 변수 선언
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs;

	// JDBC 드라이버를 로드하는 생성자
	public outregistrationDAO() {
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
	
	public ArrayList<String> getordercombo(){
		ArrayList<String> list = new ArrayList<String>();
		String SQL="SELECT distinct item_no FROM mes.order";
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
	
	public ArrayList<String> getprod() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL = "SELECT distinct part_name FROM mes.part";
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
		return list.isEmpty() ? null : list;
	}
	
	public ArrayList<String> getprocess() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL = "SELECT distinct process_name FROM mes.process";
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
		return list.isEmpty() ? null : list;
	}
	
	public ArrayList<String> getcompany() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL = "SELECT distinct com_name FROM mes.company WHERE client_outsourcing='외주사'";
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
		return list.isEmpty() ? null : list;
	}
	
	public int getNext() {
		String SQL="SELECT outsourcing_no FROM mes.outsourcing ORDER BY outsourcing_no DESC";
		int res=-1;
		try {
			connect();
			PreparedStatement pstmt=con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				res=rs.getInt(1)+1;
			}else {
				res=1;
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return res;
	}
	
	public ArrayList<outregistrationDTO> getOutList() throws ParseException{
		String SQL="SELECT * FROM mes.outsourcing WHERE outsourcing.status=0";
		ArrayList<outregistrationDTO> list=new ArrayList<outregistrationDTO>();
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				outregistrationDTO rs_o = new outregistrationDTO();
				rs_o.setOutsourcing_no(rs.getInt(1));
				rs_o.setOrder_name(rs.getString(2));
				rs_o.setProd_name(rs.getString(3));
				rs_o.setProcess(rs.getString(4));
				rs_o.setType(rs.getString(5));
				rs_o.setCompany(rs.getString(6));
				rs_o.setPrice(rs.getInt(7));
				rs_o.setWarehousing_exp_date(rs.getString(8));
				rs_o.setFaulty(rs.getString(9));
				rs_o.setOutstart_date(rs.getString(10));
				rs_o.setOutend_date(rs.getString(11));
				rs_o.setStatus(rs.getBoolean(12));
				rs_o.setWarehousing_date(rs.getString(13));
				rs_o.setWorker(rs.getString(14));
				rs_o.setReg_date(rs.getString(15));
				
				list.add(rs_o);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return list;
	}
	
	public int write(outregistrationDTO dto) {
		int result = 0;
		try {
			String sql = "INSERT INTO mes.outsourcing VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			connect();
			
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, dto.getOutsourcing_no());
			pstmt.setString(2, dto.getOrder_name());
			pstmt.setString(3, dto.getProd_name());
			pstmt.setString(4, dto.getProcess());
			pstmt.setString(5, dto.getType());
			pstmt.setString(6, dto.getCompany());
			pstmt.setInt(7, dto.getPrice());
			
			if(dto.getWarehousing_exp_date().length() != 0) {
				pstmt.setString(8, dto.getWarehousing_exp_date());
			}else {
				pstmt.setNull(8, java.sql.Types.DATE);
			}
			
			pstmt.setString(9, "N");

			if(dto.getOutstart_date().length() != 0) {
				pstmt.setString(10, dto.getOutstart_date());
			}else {
				pstmt.setNull(10, java.sql.Types.DATE);
			}
			
			if(dto.getOutend_date().length() != 0) {
				pstmt.setString(11, dto.getOutend_date());
			}else {
				pstmt.setNull(11, java.sql.Types.DATE);
			}
			
			pstmt.setBoolean(12, dto.isStatus());
			
			pstmt.setNull(13, java.sql.Types.DATE);
			
			pstmt.setString(14, dto.getWorker());
			pstmt.setString(15, dto.getReg_date());
			
			result = pstmt.executeUpdate();
			
			pstmt.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		
		if(result == 0) {
			try {
				String SQL="UPDATE mes.outsourcing SET price=?, warehousing_exp_date=?, outstart_date=?, outend_date=? WHERE outsourcing_no=?";
				connect();
				PreparedStatement pstmt=con.prepareStatement(SQL);
				
				pstmt.setInt(1, dto.getPrice());
				if(dto.getWarehousing_exp_date().length() != 0) {
					pstmt.setString(2, dto.getWarehousing_exp_date());
				}else {
					pstmt.setNull(2, java.sql.Types.DATE);
				}
				if(dto.getOutstart_date().length() != 0) {
					pstmt.setString(3, dto.getOutstart_date());
				}else {
					pstmt.setNull(3, java.sql.Types.DATE);
				}
				if(dto.getOutend_date().length() != 0) {
					pstmt.setString(4, dto.getOutend_date());
				}else {
					pstmt.setNull(4, java.sql.Types.DATE);
				}
				pstmt.setInt(5, dto.getOutsourcing_no());
				
				result=pstmt.executeUpdate();
				
				pstmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				disconnect();
			}
		}
		return result;
	}
	
	public int delete(int num) {
		String SQL="DELETE FROM mes.outsourcing WHERE outsourcing_no="+num;
		int k=-1;
		try {
			connect();
			PreparedStatement pstmt=con.prepareStatement(SQL);
			
			k=pstmt.executeUpdate();
			
			SQL = "{CALL decid("+num+", \'mes.outsourcing\', \'outsourcing_no\')}";	// 삭제에 따른 num 자동 감소 프로시저
		
			CallableStatement cstmt=con.prepareCall(SQL);
			cstmt.execute();
			
			rs.close();
			cstmt.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return k;
	}
	
	public void clearFaulty() {
		try {
			String SQL="UPDATE mes.outsourcing SET faulty='N'";
			connect();
			PreparedStatement pstmt=con.prepareStatement(SQL);
			pstmt.executeUpdate();
			
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
	}
	
	public int settingFaulty(int num) {
		int result = 0;
		try {
			String SQL="UPDATE mes.outsourcing SET faulty='Y' WHERE outsourcing_no="+num;
			connect();
			PreparedStatement pstmt=con.prepareStatement(SQL);
			result = pstmt.executeUpdate();
			
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return result;
	}
}
