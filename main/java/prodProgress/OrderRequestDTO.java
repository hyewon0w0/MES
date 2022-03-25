package prodProgress;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class OrderRequestDTO {
	private int porder_no;
	private String order_name;
	private String part_name;
	private String type;
	private int number_of_request;
	private String porder_company;
	private String exp_date;
	private String p_date;
	private int unit_price;
	
	public OrderRequestDTO(int nextnum) {
		this.porder_no = nextnum;
		
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String dateToStr = dateFormat.format(date);
		this.p_date = dateToStr;
	}

	public int getPorder_no() {
		return porder_no;
	}
	public String p_date() {
		return p_date;
	}
	public String getOrder_name() {
		return order_name;
	}

	public void setOrder_name(String order_name) {
		this.order_name = order_name;
	}

	public String getPart_name() {
		return part_name;
	}

	public void setPart_name(String part_name) {
		this.part_name = part_name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getNumber_of_request() {
		return number_of_request;
	}

	public void setNumber_of_request(int number_of_request) {
		this.number_of_request = number_of_request;
	}

	public String getPorder_company() {
		return porder_company;
	}

	public void setPorder_company(String porder_company) {
		this.porder_company = porder_company;
	}

	public String getExp_date() {
		return exp_date;
	}

	public void setExp_date(String exp_date) {
		this.exp_date = exp_date;
	}

	public int getUnit_price() {
		return unit_price;
	}

	public void setUnit_price(int unit_price) {
		this.unit_price = unit_price;
	}
	
	
}
