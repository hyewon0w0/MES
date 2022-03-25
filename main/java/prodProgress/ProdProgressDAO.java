package prodProgress;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONObject;

import dbconn.DBconn;

public class ProdProgressDAO {
	private DBconn db;
	
	private Connection con;
	private Statement stmt;
	private PreparedStatement pstmt;
	private CallableStatement cstmt;
	private ResultSet rs;
	
	public ProdProgressDAO() {
		db = new DBconn();
	}
	
	public List<String> getItemNO(){ //Order(수주) Table의 금형번호를 들고옴(콤보박스 용)
		List<String> list = new ArrayList<String>();
		
		try {
			String sql = "SELECT item_no FROM mes.order";
			con = db.getCon();
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				list.add(rs.getString("item_no"));
			}
			
			rs.close();
			stmt.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			db.close();
		}
		
		return list.isEmpty() ? null : list;
	}
	
	public List<String> getProcess(){ //process(표준공정) Table의 공정명을 가져옴
		List<String> list = new ArrayList<String>();
		
		try {
			String sql = "SELECT process_name FROM mes.process ORDER BY process_name";
			con = db.getCon();
			stmt = con.createStatement();
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				list.add(rs.getString("process_name"));
			}
			
			rs.close();
			stmt.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			db.close();
		}
		
		return list.isEmpty() ? null : list;
	}
	
	public List<OrderPartsDTO> getOrderParts(String itemno){ //선택한 수주의 부품 리스트를 가져옴
		List<OrderPartsDTO> list = new ArrayList<OrderPartsDTO>();
		
		try {
			String sql = "SELECT * FROM mes.parts_by_order WHERE mes.parts_by_order.order=?";
			
			con = db.getCon();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, itemno);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				OrderPartsDTO dto = new OrderPartsDTO();
				dto.setPbo_id(rs.getInt("pbo_id"));
				dto.setOrder(rs.getString("order"));
				dto.setPart(rs.getString("part"));
				dto.setQuantity(rs.getInt("quantity"));
				dto.setOrder_status(rs.getString("order_status"));
				dto.setLayer(rs.getString("layer"));
				
				list.add(dto);
			}
			
			rs.close();
			pstmt.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			db.close();
		}
		
		return list.isEmpty() ? null : list;
	}
	
	public ProdProgressOrderDTO getOrderInfo(String itemno) { //선택한 수주 정보를 가져옴
		ProdProgressOrderDTO result = null;
		
		try {
			String sql = "SELECT * FROM mes.order WHERE item_no=?";
			
			con = db.getCon();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, itemno);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				result = new ProdProgressOrderDTO();
				result.setItem_no(rs.getString("item_no"));
				result.setOrder_com_id(rs.getString("order_com_id"));
				result.setOrder_date(rs.getString("order_date"));
				result.setPart_status(rs.getString("part_status"));
				result.setCar_name(rs.getString("car_name"));
				result.setOrder_price(rs.getInt("order_price"));
				result.setDel_date(rs.getString("del_date"));
				result.setDue_date(rs.getString("due_date"));
				result.setProc_end_date(rs.getString("proc_end_date"));
				result.setOrder_note(rs.getString("order_note"));
			}
			
			rs.close();
			pstmt.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			db.close();
		}
		
		return result;
	}
	
	public int getNext(){ //부품관리 - PK 카운트
	      int res = -1;
	      try {
	         String sql = "SELECT pbo_id FROM mes.parts_by_order ORDER BY pbo_id DESC";
	         
	         con = db.getCon();
	         pstmt = con.prepareStatement(sql);
	         rs = pstmt.executeQuery();
	         if(rs.next()) {
	            res = rs.getInt(1)+1;
	         }else {
	            res = 1;
	         }
	         
	         rs.close();
	         pstmt.close();
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         db.close();
	      }
	      return res;
	   }
	   
	   public void allDelParts(String itemno){ //부품관리 - 전체삭제(선택한 수주에 해당하는 부품 전체 삭제)
	      ArrayList<OrderPartsDTO> list = new ArrayList<OrderPartsDTO>();
	      try {
	         String sql = "DELETE FROM mes.parts_by_order WHERE mes.parts_by_order.order=?";
	         
	         con=db.getCon();
	         pstmt=con.prepareStatement(sql);
	         pstmt.setString(1, itemno);
	         pstmt.executeUpdate();
	         
	         pstmt.close();
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         db.close();
	      }
	   }
	   
	   public int writeOrderParts(OrderPartsDTO dto) { //부품관리 - 저장(입력한 부품 데이터 저장) 
	      int res=0;
	      try {
	         String sql="INSERT INTO mes.parts_by_order VALUES(?,?,?,?,?,?)";
	         
	         con=db.getCon();
	         pstmt=con.prepareStatement(sql);
	         pstmt.setInt(1, dto.getPbo_id());
	         pstmt.setString(2, dto.getOrder());
	         pstmt.setString(3, dto.getPart());
	         pstmt.setInt(4, dto.getQuantity());
	         pstmt.setString(5, dto.getOrder_status());
	         pstmt.setString(6, dto.getLayer());
	         
	         res=pstmt.executeUpdate();
	         pstmt.close();
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         db.close();
	      }
	      return res;
	   }
	   
	
	public List<String> getComid() { // 업체명 콤보박스 데이터 세팅
		List<String> list = new ArrayList<String>();
		String SQL="SELECT distinct com_name FROM mes.company WHERE client_outsourcing = '고객사'";
		try {
			con = db.getCon();
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				list.add(rs.getString("com_name"));
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
	
	
		public ArrayList<String> getPartstatus() {// 부품구분 콤보박스 데이터 세팅
			ArrayList<String> list = new ArrayList<String>();
			String SQL = "SELECT sub_code FROM mes.code_sub WHERE main_code =\'부품구분\'";
			try {
				con = db.getCon();
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
				db.close();
			}
			return list.isEmpty() ? null : list;
		}
	
		
		public ArrayList<String> getCarName() { // 제품명 콤보박스 데이터 세팅
			ArrayList<String> list = new ArrayList<String>();
			String SQL = "SELECT materials_name FROM mes.materials";
			try {
				con = db.getCon();
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
				db.close();
			}
			return list.isEmpty() ? null : list;
		}
		
		public List<OrderToolsDTO> getOrderTools(String itemno, String partsname){ //선택한 수주와 해당 부품에 대한 공구 리스트 불러옴.
	         List<OrderToolsDTO> list = new ArrayList<OrderToolsDTO>();
	         
	         try {
	            String sql = "SELECT * FROM mes.tool WHERE mes.tool.order_name=? AND mes.tool.part_name=?";
	            
	            con = db.getCon();
	            pstmt = con.prepareStatement(sql);
	            pstmt.setString(1, itemno);
	            pstmt.setString(2, partsname);
	            rs = pstmt.executeQuery();
	            
	            while(rs.next()) {
	               OrderToolsDTO dto = new OrderToolsDTO();
	               dto.setOrder_name(rs.getString("order_name"));
	               dto.setPart_name(rs.getString("part_name"));
	               dto.setTool_name(rs.getString("tool_name"));
	               dto.setUnit_price(rs.getInt("unit_price"));
	               dto.setStock(rs.getInt("stock"));
	               dto.setPrice(rs.getInt("price"));
	               
	               list.add(dto);
	            }
	            
	            rs.close();
	            pstmt.close();
	            
	         } catch (Exception e) {
	            e.printStackTrace();
	         }finally {
	            db.close();
	         }
	         
	         return list.isEmpty() ? null : list;
	      }
		
		public List<String> getTools(){ //공구 콤보박스 내용 들고오는 메소드
			List<String> list = new ArrayList<String>();
			
			try {
				String sql = "SELECT materials_name FROM mes.materials";
				
				con = db.getCon();
				stmt = con.createStatement();
				rs = stmt.executeQuery(sql);
				
				while(rs.next()) {
					list.add(rs.getString("materials_name"));
				}
				
				rs.close();
				stmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				db.close();
			}
			
			return list.isEmpty() ? null : list;
		}
		
		public List<OrderPartDetailDTO> getOrderPartDetail(String itemno){ //수주에 따른 부품 세부사항 조회
			List<OrderPartDetailDTO> list = new ArrayList<OrderPartDetailDTO>();
			String sql = null;
			int status = 3;
			//0은 시작대기 1은 진행중 2는 완료
			
			try {
				sql = "SELECT parts_by_order.order, parts_by_order.part, quantity, order_status, unit_price, standard, parts_by_order.layer "
						+ "FROM parts_by_order, part WHERE parts_by_order.part=part.part_name AND parts_by_order.order = ?";
				
				con = db.getCon();
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, itemno);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					OrderPartDetailDTO dto = new OrderPartDetailDTO();
					dto.setOrder(rs.getString("order"));
					dto.setPart(rs.getString("part"));
					dto.setQuantity(rs.getInt("quantity"));
					dto.setOrder_status(rs.getString("order_status"));
					dto.setStandard(rs.getString("standard") != null ? rs.getString("standard") : "");
					dto.setType(rs.getString("layer"));
					
					list.add(dto);
				}
				
				rs.close();
				pstmt.close();
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				db.close();
			}
			
			try {
				for(OrderPartDetailDTO dto : list) {
					int wt = 0;
					int price = 0;
					
					if(dto.getOrder_status().equals("내부")) {
						sql = "SELECT * FROM prodprogressview WHERE order_name = ? AND part_name = ? AND proctype = '사내'";
						
						con = db.getCon();
						pstmt = con.prepareStatement(sql);
						pstmt.setString(1, dto.getOrder());
						pstmt.setString(2, dto.getPart());
						rs = pstmt.executeQuery();
						
						if(rs.isBeforeFirst() == false) {
							status = 0;
						}
						
						while(rs.next()) {
							JSONObject partwork = new JSONObject();
							
							String process = rs.getString("process");
							partwork.put("process", process);
							
							String facilities = rs.getString("facilities") != null ? rs.getString("facilities") : "";
							partwork.put("facilities", facilities);
							
							String start = rs.getString("start_date") != null ? rs.getString("start_date") : "";
							partwork.put("work_start", start);
							
							String end = rs.getString("end_date") != null ? rs.getString("end_date") : "";
							partwork.put("work_end", end);
							
							String faulty = rs.getString("faulty");
							partwork.put("faulty", faulty);
							
							if(start.length() > 0) {
								if(end.length() > 0) {
									partwork.put("workstatus", "completebox");
									
									int pwt = rs.getInt("no_men_processing_time") + rs.getInt("work_time");
									int pp = 0;
									
									if(faulty.equals("N")) {
										wt += pwt;
										
										try {
											sql = "SELECT pay FROM mes.process WHERE process_name=?";
											PreparedStatement pstmt2 = con.prepareStatement(sql);
											pstmt2.setString(1, process);
											ResultSet rs2 = pstmt2.executeQuery();
											
											if(rs2.next()) {
												pp = pwt * rs2.getInt("pay");
												price += pp;
											}
											
											rs2.close();
											pstmt2.close();
											
										}catch(Exception e) {
											e.printStackTrace();
										}
										
										if(status == 0) {
											status = 1;
										}else if(status == 3){
											status = 2;
										}
										
										partwork.put("worktime", pwt);
										partwork.put("pr", pp);
									}
									
								}else {
									partwork.put("workstatus", "progbox");
									status = 1;
								}
							}else {
								partwork.put("workstatus", "readybox");
								
								if(status == 1 || status == 2) {
									status = 1;
								}else {
									status = 0;
								}
								
							}
							
							if(faulty.equals("Y")) {
								partwork.put("workstatus", "faultybox");
							}
							
							dto.addProcess(partwork);
						}
						
						switch(status) {
						case 0:
							dto.setStatus_color("background-color: rgb(170, 170, 170)");
							break;
						case 1:
							dto.setStatus_color("background-color: rgb(70, 211, 191)");
							break;
						case 2:
							dto.setStatus_color("background-color: rgb(94, 169, 255)");
							break;
						}
						
						dto.setTotal_work_time(wt);
						dto.setPrice(price);
					}
					
					//발주 부분
					else {
						try {
							sql = "SELECT * FROM mes.place_order WHERE part_name = ? AND order_name = ? ORDER BY p_date DESC";
							
							con = db.getCon();
							pstmt = con.prepareStatement(sql);
							pstmt.setString(1, dto.getPart());
							pstmt.setString(2, dto.getOrder());
							
							rs = pstmt.executeQuery();
							
							if(rs.next()) {
								dto.setStatus_color("background-color: rgb(70, 211, 191); border: 3px dashed black");
								
								if(rs.getString("receiving_status").equals("Y")) {
									dto.setStatus_color("background-color: rgb(94, 169, 255); border: 3px dashed black");
								}
							}else {
								dto.setStatus_color("background-color: rgb(170, 170, 170); border: 3px dashed black");
							}
							
						}catch(Exception e) {
							e.printStackTrace();
						}
					}
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				db.close();
			}
			
			
			
			return list.isEmpty() ? null : list;
		}
		
		public void allDelTools(String itemno, String partsname) {   // 공구등록 - 전체 삭제
	         try {
	            String sql = "DELETE FROM mes.tool WHERE mes.tool.order_name=? AND mes.tool.part_name=?";
	            
	            con=db.getCon();
	            pstmt=con.prepareStatement(sql);
	            pstmt.setString(1, itemno);
	            pstmt.setString(2, partsname);
	            pstmt.executeUpdate();
	            
	            pstmt.close();
	         }catch(Exception e) {
	            e.printStackTrace();
	         }finally {
	            db.close();
	         }
	      }
		
		public int writeOrderTools(OrderToolsDTO dto) { //공구등록 - 저장(입력한 공구 데이터 저장) 
            int res=0;
            try {
               String sql="INSERT INTO mes.tool VALUES(?,?,?,?,?,?)";
               
               con=db.getCon();
               pstmt=con.prepareStatement(sql);
               pstmt.setString(1, dto.getOrder_name());
               pstmt.setString(2, dto.getPart_name());
               pstmt.setString(3, dto.getTool_name());
               pstmt.setInt(4, dto.getUnit_price());
               pstmt.setInt(5, dto.getStock());
               pstmt.setInt(6, dto.getPrice());
               
               res=pstmt.executeUpdate();
               pstmt.close();
            }catch(Exception e) {
               e.printStackTrace();
            }finally {
               db.close();
            }
            return res;
         }
		
		public int writeOrderRequest(OrderRequestDTO dto) { //발주 요청(place_order 저장)
			int result = 0;
			
			try {
				String sql = "INSERT INTO place_order VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
				
				con = db.getCon();
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, dto.getPorder_no());
				pstmt.setString(2, dto.getPart_name());
				pstmt.setString(3, dto.getType());
				pstmt.setInt(4, dto.getNumber_of_request());
				pstmt.setString(5, dto.getPorder_company());
				pstmt.setString(6, dto.p_date());
				pstmt.setNull(7, java.sql.Types.VARCHAR);
				pstmt.setString(8, "N");
				pstmt.setString(9, "");
				pstmt.setInt(10, dto.getUnit_price());
				pstmt.setString(11, "");
				pstmt.setString(12, dto.getOrder_name());
				pstmt.setString(13, dto.getExp_date());
				
				result = pstmt.executeUpdate();
				
				pstmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				db.close();
			}
			
			return result;
		}
		
		public int getPorder_numNext() { //place_order porder_no 다음 번호 불러오기
			int next = 0;
			
			try {
				String sql = "SELECT porder_no FROM place_order ORDER BY porder_no DESC";
				
				con = db.getCon();
				stmt = con.createStatement();
				rs = stmt.executeQuery(sql);
				
				if(rs.next()) {
					next = rs.getInt("porder_no") + 1;
				}
				
				rs.close();
				stmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				db.close();
			}
			
			return next;
		}
		
		public List<String> getCompany(){ //발주 요청을 위한 업체 불러오기
			List<String> company = new ArrayList<String>();
			
			try {
				String sql = "SELECT com_name FROM mes.company";
				
				con = db.getCon();
				stmt = con.createStatement();
				rs = stmt.executeQuery(sql);
				
				while(rs.next()) {
					company.add(rs.getString("com_name"));
				}
				
				rs.close();
				stmt.close();
				
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			return company;
		}
		
		public List<JSONObject> getExpdate(String itemno){ //완료예상날짜 들고오기
			List<JSONObject> list = new ArrayList<JSONObject>();
			
			try {
				String sql = "SELECT * FROM pl_process_expdate WHERE itemno = ? ORDER BY process_name";
				
				con = db.getCon();
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, itemno);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					JSONObject pe = new JSONObject();
					pe.put("process", rs.getString("process_name"));
					
					String ed = rs.getString("exp_date") == null ? "" : rs.getString("exp_date");
					pe.put("expd", ed);
					list.add(pe);
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
		
		public int exp_write(String itemno, String procname, String expdate) {//완료예상날자 등록 및 수정\
			
			int res=0;
			try {
				String sql="INSERT INTO mes.pl_process_expdate VALUES(?,?,?)";
				
				con=db.getCon();
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1, itemno);
				pstmt.setString(2, procname);
				
				if(expdate == null) {
					pstmt.setNull(3, java.sql.Types.DATE);
				}else {
					if(expdate.length() == 0) {
						pstmt.setNull(3, java.sql.Types.DATE);
					}else {
						pstmt.setString(3, expdate);
					}
				}
				
				res=pstmt.executeUpdate();
				
				pstmt.close();
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				db.close();
			}
			
			if(res == 0) {
				try {
					String sql="UPDATE mes.pl_process_expdate SET exp_date = ? WHERE itemno = ? AND process_name = ?";
					
					con=db.getCon();
					pstmt=con.prepareStatement(sql);
					
					if(expdate == null) {
						pstmt.setNull(1, java.sql.Types.DATE);
					}else {
						if(expdate.length() == 0) {
							pstmt.setNull(1, java.sql.Types.DATE);
						}else {
							pstmt.setString(1, expdate);
						}
					}
					
					pstmt.setString(2, itemno);
					pstmt.setString(3, procname);
					
					res=pstmt.executeUpdate();
					
					pstmt.close();
					
				}catch(Exception e) {
					e.printStackTrace();
				}finally {
					db.close();
				}
			}
			
			return res;
		}
}
