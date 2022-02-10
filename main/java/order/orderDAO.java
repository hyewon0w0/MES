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

	// �����ͺ��̽� ���� ���� ���� ����
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs;

	// JDBC ����̹��� �ε��ϴ� ������
	public orderDAO() {
		// JDBC ����̹� �ε�
		try {
			Class.forName(JDBC_DRIVER);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
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
		if(con != null) {
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	//������ �Է�(���)�� ���� �޼ҵ� 
	public int write(orderDTO dto) {
		int k = 0;
		
		try {
			String SQL="INSERT INTO mes.order(item_no, order_com_id, order_date, order_status, part_status, car_name, prod_name, order_price, nego_price, del_date,"
					+ "order_note, item_img, order_et_id, order_num) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
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
			pstmt.setString(11, dto.getO_note());
			pstmt.setString(12, null); //�����̹���
			pstmt.setString(13, dto.getO_et_id());
			pstmt.setInt(14, dto.getO_num());
			
			k = pstmt.executeUpdate();
			
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		
		if(k == 0) {
			try {
				String DEL_DATE="SELECT del_date FROM mes.order WHERE item_no=?";
				String SQL="UPDATE mes.order SET order_com_id=?, order_date=?, order_status=?, part_status=?, car_name=?, "
						+ "prod_name=?, order_price=?, nego_price=?, del_date=?, due_date=?, order_note=?, item_img=?, order_et_id=? WHERE item_no=?";
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
				if(dto.getDel_date()==null||dto.getDel_date().equals("null")) {
					pstmt.setString(9, null);
				}else {
					pstmt.setString(9, dto.getDel_date());
				}
				if(dto.getDue_date()==null||dto.getDue_date().equals("null")) {
					pstmt.setString(10, null);
				}else {
					pstmt.setString(10, dto.getDue_date());
				}
				pstmt.setString(11, dto.getO_note());
				pstmt.setString(12, dto.getImg());
				pstmt.setString(13, dto.getO_et_id());
				pstmt.setString(14, dto.getItem_no());
				
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
	
	//������ ���� �޼ҵ� 
	public int delete(String item_no) {
		String SQL="Delete FROM mes.order WHERE item_no=\'"+item_no+"\'";	// item_no�� ���� ����
		String NUM_SQL="SELECT order_num FROM mes.order WHERE item_no=\'"+item_no+"\'";	// item_no�� ���� order_num ��ȸ
		int num=0;
		int k = -1;
		try {
			connect();
			
			PreparedStatement pstmt2=con.prepareStatement(NUM_SQL);
			PreparedStatement pstmt=con.prepareStatement(SQL);
			
			rs=pstmt2.executeQuery();
			k=pstmt.executeUpdate();
			
			if(rs.next()) {
				num = rs.getInt(1);
			}
			
			SQL = "{CALL decid("+num+", \'mes.order\', \'order_num\')}";	// ������ ���� num �ڵ� ���� ���ν���
			
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
	
	//������ ����Ʈ ��ȸ �޼ҵ�
	public ArrayList<orderDTO> getOrderList(int pagenum) throws ParseException {	
		
		String SQL = "SELECT * FROM mes.order WHERE	order_num<? ORDER BY order_num DESC LIMIT 10";
		ArrayList<orderDTO> list = new ArrayList<orderDTO>();
		try {
			connect();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pagenum-1)*10);
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
				rs_o.setO_num(rs.getInt(16));
								
				//����Ʈ�� �߰�
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
	
	//������ ����Ʈ �˻� �޼ҵ�
	public ArrayList<orderDTO> getOrderList2(int pagenum, String txt_where) throws ParseException{
		ArrayList<orderDTO> list = new ArrayList<orderDTO>();
		String SQL1="SELECT order_num FROM mes.order"+ txt_where + " ORDER BY order_num desc";
		String SQL2="SELECT * FROM mes.order"+ txt_where + " and order_num<? ORDER BY order_num desc limit 10";
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
				rs_o.setO_num(rs.getInt(16));
								
				//����Ʈ�� �߰�
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
	
	// �˻��г� - ������ �������� ����
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
	
	// ������ �޺��ڽ� ������ ����
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
		return list.isEmpty() ? null : list;	//���� ������ ���̸� null ��ȯ ���� �ƴϸ� list �� ��ȯ
	}
	
	// ������ ���ÿ� ���� ���ֱݾ� ����
	public int getorderprice(String et_id) {		
		String SQL = "SELECT et_price FROM mes.estimate WHERE et_id=\'"+et_id+"\' ORDER BY degree desc";
		int price=0;
		
		try {
			connect();
			PreparedStatement pstmt=con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				price=rs.getInt(1);
			}else {
				price=0;
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return price;
	}
	
	// ������ ���ÿ� ���� ��ü�� ����
	public String getcompany(String et_id) {	
		String SQL = "SELECT et_com_id FROM mes.estimate WHERE et_id=\'"+et_id+"\' ORDER BY degree desc";

		String company=null;
		
		try {
			connect();
			PreparedStatement pstmt=con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				company=rs.getString(1);
			}else {
				company="";
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			disconnect();
		}
		return company;
	}
	
	// ��ü�� �޺��ڽ� ������ ����
	public ArrayList<String> getComid() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL="SELECT distinct com_name FROM mes.company";
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
		return list.isEmpty() ? null : list;	//���� ������ ���̸� null ��ȯ ���� �ƴϸ� list �� ��ȯ
	}
	
	// ���ֱ��� �޺��ڽ� ������ ����
	public ArrayList<String> getOrderstatus() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL = "SELECT sub_code FROM mes.common_code WHERE group_name =\'��������\' AND main_code =\'��������\'";
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
	
	// ��ǰ���� �޺��ڽ� ������ ����
	public ArrayList<String> getPartstatus() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL = "SELECT sub_code FROM mes.common_code WHERE group_name =\'�������\' AND main_code =\'��ǰ����\'";
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
	
	// ���� �޺��ڽ� ������ ����
	public ArrayList<String> getCarName() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL = "SELECT materials_name FROM mes.materials";
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
	
	//�� ��ȣ ����
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
		
	//�˻���� �� ������ȣ�� ��(���������̼ǿ��� ����)
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
	
	// ���ֺ��� �޼ҵ� 
	public int copy(orderDTO dto) {
		int k = 0;
		try {
			String SQL="INSERT INTO mes.order(item_no, order_com_id, order_date, order_status, part_status, car_name, prod_name, order_price, nego_price, del_date, "
					+ "order_note, item_img, order_et_id, order_num) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			connect();
			
			PreparedStatement pstmt=con.prepareStatement(SQL);
			
			pstmt.setString(1, dto.getItem_no()+" - �ӽ�");
			pstmt.setString(2, dto.getO_com_id());
			pstmt.setString(3, dto.getO_date());
			pstmt.setString(4, dto.getO_status());
			pstmt.setString(5, dto.getP_status());
			pstmt.setString(6, dto.getC_name());
			pstmt.setString(7, dto.getP_name());
			pstmt.setInt(8, dto.getO_price());
			pstmt.setInt(9, dto.getN_price());
			pstmt.setString(10, dto.getDel_date());
			pstmt.setString(11, dto.getO_note());
			pstmt.setString(12, null);
			pstmt.setString(13, dto.getO_et_id());
			pstmt.setInt(14, dto.getO_num());
			
			k = pstmt.executeUpdate();
			
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return k;
	}
}