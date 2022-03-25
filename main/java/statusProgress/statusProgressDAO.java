package statusProgress;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import dbconn.DBconn;

public class statusProgressDAO {
private DBconn db;
	
	private Connection con;
	private Statement stmt;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public statusProgressDAO() {
		db = new DBconn();
	}
	
	public List<statusProgressDTO> getList(){ //Order(수주) Table의 금형번호를 들고옴(콤보박스 용)
		List<statusProgressDTO> list = new ArrayList<statusProgressDTO>();
		
		try {
			String sql = "SELECT item_no, order_com_id, car_name, del_date, order_date, due_date FROM mes.order";
			con = db.getCon();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery(sql);
			
			while(rs.next()) {
				statusProgressDTO dto=new statusProgressDTO();
				dto.setItem_no(rs.getString(1));
				dto.setCompany(rs.getString(2));
				dto.setCname(rs.getString(3));
				
				String a=rs.getString(4)==null ? "" : rs.getString(4).substring(0,10);
				dto.setExpdate(a);
				String b=rs.getString(5)==null ? "" : rs.getString(5).substring(0,10);
				dto.setStartdate(b);
				String c=rs.getString(6)==null ? "" : rs.getString(6).substring(0,10);
				dto.setEnddate(c);
				
				if(rs.getString(4)!=null) {
					LocalDate expDate = LocalDate.parse(a);
					LocalDate startDate = LocalDate.parse(b);
					int betDate = (int)ChronoUnit.DAYS.between(startDate, expDate);
					dto.setBetweendate(betDate);
				}else {
					dto.setBetweendate(0);
				}
				list.add(dto);
			}
			
			rs.close();
			pstmt.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			db.close();
		}
		
		return list.isEmpty() ? null : list;
	}
	
	public List<processProgressDTO> getProcList(String itemno) throws ParseException{
		List<processProgressDTO> list = new ArrayList<processProgressDTO>();
		try {
			String sql = "SELECT work_id, order_name, mes.my_work.process, work_end FROM mes.my_work WHERE mes.my_work.order_name=? AND work_start IS NOT NULL";
			
			con=db.getCon();
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1,itemno);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				processProgressDTO dto = new processProgressDTO();
				dto.setWork_id(rs.getInt(1));
				dto.setItem_no(rs.getString(2));
				dto.setProcess(rs.getString(3));
				String a=rs.getString(4)==null ? "" : rs.getString(4).substring(0,10);
				dto.setEnddate(a);
				
				list.add(dto);
			}
			
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			db.close();
		}
		
		return list.isEmpty() ? null : list;
	}
	
	public String getProcExpdate(String itemno, String procname) throws ParseException{
		String res = null;
		try {
			String sql = "SELECT exp_date FROM mes.pl_process_expdate WHERE itemno=? AND process_name=?";
			
			con=db.getCon();
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, itemno);
			pstmt.setString(2, procname);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				processProgressDTO dto = new processProgressDTO();
				dto.setProc_expdate(rs.getString(1));
				
				res = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			db.close();
		}
		
		return res == null ? "" : res;
	}
	
	public String getProcStartdate(String itemno, String procname) throws ParseException{
		String res = null;
		try {
			String sql="SELECT work_start FROM mes.my_work WHERE order_name=? AND my_work.process=? AND work_start IS NOT NULL ORDER BY work_start ASC";
			
			con=db.getCon();
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, itemno);
			pstmt.setString(2, procname);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				processProgressDTO dto = new processProgressDTO();
				String a=rs.getString(1)==null ? "" : rs.getString(1).substring(0,10);
				
				res = a;
				dto.setStartdate(a);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			db.close();
		}
		
		return res == null ? "" : res;
	}
	
	public String getProcEnddate(String itemno, String procname) throws ParseException{
		String res = null;
		try {
			String sql="SELECT work_end FROM mes.my_work WHERE order_name=? AND my_work.process=? ORDER BY work_end DESC";
			
			con=db.getCon();
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, itemno);
			pstmt.setString(2, procname);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				processProgressDTO dto = new processProgressDTO();
				String a=rs.getString(1)==null ? "" : rs.getString(1).substring(0,10);
				
				res = a;
				dto.setEnddate(a);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			db.close();
		}

		return res == null ? "" : res;
	}
	
	public int getProcBetDate(String itemno, String procname) throws ParseException{
		processProgressDTO dto = new processProgressDTO();
		int betDate = 0;
		LocalDate startdate=null;
		LocalDate expdate=null;
		if(getProcStartdate(itemno, procname)!="") {
			startdate = LocalDate.parse(getProcStartdate(itemno, procname));
		}else {
			startdate = null;
		}
		if(getProcExpdate(itemno, procname)!="") {
			expdate = LocalDate.parse(getProcExpdate(itemno, procname));
		}else {
			expdate = null;
		}
		if(startdate!=null && expdate!=null) {
			betDate = (int)ChronoUnit.DAYS.between(startdate, expdate);
			dto.setBetweendate(betDate);
		}else {
			betDate=0;
			dto.setBetweendate(betDate);
		}
		return betDate;
	}
}
