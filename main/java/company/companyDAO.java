package company;

import java.sql.*;
import java.text.ParseException;
import java.util.ArrayList;

import company.companyDTO;

public class companyDAO {
	private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
	private static final String JDBC_URL = "jdbc:mysql://192.168.0.115:3306/mes?useSSL=false&serverTimezone=UTC";
	private static final String USER = "Usera";
	private static final String PASSWD = "1234";
	
	// 데이터베이스 연결 관련 변수 선언
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs;
	
	// JDBC 드라이버를 로드하는 생성자
	public companyDAO() {
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
	
	//데이터 리스트 조회 메소드
	public ArrayList<companyDTO> getCompanyList1(int pagenum) throws ParseException {	
		
		String SQL = "SELECT * FROM mes.company WHERE com_id<? ORDER BY com_id DESC LIMIT 10";
		ArrayList<companyDTO> list = new ArrayList<companyDTO>();
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pagenum-1)*10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				companyDTO rs_c = new companyDTO();
				rs_c.setCom_id(rs.getInt(1));
				rs_c.setCom_name (rs.getString(2));
				rs_c.setAbbreviation(rs.getString(3));
				rs_c.setCustomers_sortation(rs.getString(4));
				rs_c.setClientstatus(rs.getString(5));
				rs_c.setCustomers_group(rs.getString(6));
				rs_c.setRepresentative(rs.getString(7));
				rs_c.setPostal_code(rs.getString(8));
				rs_c.setAddress(rs.getString(9));
				rs_c.setDetailed_address(rs.getString(10));
				rs_c.setCom_registration_num(rs.getString(11));
				if(rs.getString(12)==null) {
					rs_c.setPhone(" ");
				}else {
					rs_c.setPhone(rs.getString(12));
				}
				rs_c.setFax(rs.getString(13));
				if(rs.getString(14)==null) {
					rs_c.setManager_name(" ");
				}else {
					rs_c.setManager_name(rs.getString(14));
				}
				rs_c.setManager_phone(rs.getString(15));
				rs_c.setEmail(rs.getString(16));
				rs_c.setCompanyusing(rs.getString(17));
				rs_c.setMain_task(rs.getString(18));
				rs_c.setNote(rs.getString(19));
								
				//리스트에 추가
				list.add(rs_c);
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
	public ArrayList<companyDTO> getCompanyList2(int pagenum, String txt_where) throws ParseException{
		ArrayList<companyDTO> list = new ArrayList<companyDTO>();
		String SQL1="SELECT com_id FROM mes.company"+ txt_where + " ORDER BY com_id desc";
		String SQL2="SELECT * FROM mes.company"+ txt_where + " and com_id<? ORDER BY com_id desc limit 10";
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
				companyDTO rs_c = new companyDTO();
				rs_c.setCom_id(rs.getInt(1));
				rs_c.setCom_name (rs.getString(2));
				rs_c.setAbbreviation(rs.getString(3));
				rs_c.setCustomers_sortation(rs.getString(4));
				rs_c.setClientstatus(rs.getString(5));
				rs_c.setCustomers_group(rs.getString(6));
				rs_c.setRepresentative(rs.getString(7));
				rs_c.setPostal_code(rs.getString(8));
				rs_c.setAddress(rs.getString(9));
				rs_c.setDetailed_address(rs.getString(10));
				rs_c.setCom_registration_num(rs.getString(11));
				if(rs.getString(12)==null) {
					rs_c.setPhone(" ");
				}else {
					rs_c.setPhone(rs.getString(12));
				}
				rs_c.setFax(rs.getString(13));
				if(rs.getString(14)==null) {
					rs_c.setManager_name(" ");
				}else {
					rs_c.setManager_name(rs.getString(14));
				}
				rs_c.setManager_phone(rs.getString(15));
				rs_c.setEmail(rs.getString(16));
				rs_c.setCompanyusing(rs.getString(17));
				rs_c.setMain_task(rs.getString(18));
				rs_c.setNote(rs.getString(19));
								
				//리스트에 추가
				list.add(rs_c);
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
	
	//데이터 삭제 메소드 
	public int delete(String com_id) {
		String SQL="Delete FROM mes.company WHERE com_id=\'"+com_id+"\'";	// item_no에 따른 삭제
		
		int k = -1;
		try {
			connect();

			PreparedStatement pstmt=con.prepareStatement(SQL);
			
			k=pstmt.executeUpdate();
	
			
			SQL = "{CALL decid("+com_id+", \'mes.company\', \'com_id\')}";	// 삭제에 따른 num 자동 감소 프로시wj
			
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
	
	//회사 번호 세팅
	public int getNext() {
		String SQL = "SELECT com_id FROM mes.company ORDER BY com_id DESC";
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
				
		String SQL = "select count(*) as rownum from mes.company" + txt_where;
		
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
	//데이터 입력(등록)및 수정 메소드 
		public int write(companyDTO dto) {
			int k = 0;
			
			try {
				String SQL="INSERT INTO mes.company(com_id, com_name, abbreviation, customers_sortation, client_outsourcing, customers_group, representative, postal_code, address, detailed_address, com_registration_num,"
						+ "phone, fax, manager_name, manager_phone, email, com_using, main_task, note) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				connect();
				
				PreparedStatement pstmt=con.prepareStatement(SQL);
				
				pstmt.setInt(1, getNext());
				pstmt.setString(2, dto.getCom_name());
				pstmt.setString(3, dto.getAbbreviation());
				pstmt.setString(4, dto.getCustomers_sortation());
				pstmt.setString(5, dto.getClientstatus());
				pstmt.setString(6, dto.getCustomers_group());
				pstmt.setString(7, dto.getRepresentative());
				pstmt.setString(8, dto.getPostal_code());
				pstmt.setString(9, dto.getAddress());
				pstmt.setString(10, dto.getDetailed_address());
				pstmt.setString(11, dto.getCom_registration_num());
				pstmt.setString(12, dto.getPhone());
				pstmt.setString(13, dto.getFax()); 
				pstmt.setString(14, dto.getManager_name());
				pstmt.setString(15, dto.getManager_phone());
				pstmt.setString(16, dto.getEmail());
				pstmt.setString(17, dto.getCompanyusing());
				pstmt.setString(18, dto.getMain_task());
				pstmt.setString(19, dto.getNote());
				
				k = pstmt.executeUpdate();
				
				pstmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			} finally {
				disconnect();
			}
			
			if(k == 0) {
				try {
					String SQL="UPDATE mes.company SET com_name=?, abbreviation=?, customers_sortation=?, client_outsourcing=?, customers_group=?, "
							+ "representative=?, postal_code=?, address=?, detailed_address=?, com_registration_num=?, phone=?, fax=?, manager_name=?, manager_phone=?, "
							+ "email=?, com_using=?, main_task=?, note=? WHERE com_id=?";
					connect();
					PreparedStatement pstmt=con.prepareStatement(SQL);
					
					pstmt.setString(1, dto.getCom_name());
					pstmt.setString(2, dto.getAbbreviation());
					pstmt.setString(3, dto.getCustomers_sortation());
					pstmt.setString(4, dto.getClientstatus());
					pstmt.setString(5, dto.getCustomers_group());
					pstmt.setString(6, dto.getRepresentative());
					pstmt.setString(7, dto.getPostal_code());
					pstmt.setString(8, dto.getAddress());
					pstmt.setString(9, dto.getDetailed_address());
					pstmt.setString(10, dto.getCom_registration_num());
					pstmt.setString(11, dto.getPhone());
					pstmt.setString(12, dto.getFax()); 
					pstmt.setString(13, dto.getManager_name());
					pstmt.setString(14, dto.getManager_phone());
					pstmt.setString(15, dto.getEmail());
					pstmt.setString(16, dto.getCompanyusing());
					pstmt.setString(17, dto.getMain_task());
					pstmt.setString(18, dto.getNote());
					pstmt.setInt(19, dto.getCom_id());
					
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
}
