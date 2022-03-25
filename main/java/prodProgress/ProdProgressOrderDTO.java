package prodProgress;

public class ProdProgressOrderDTO {
	private String order_com_id;
	private int order_price;
	private String part_status;
	private String car_name;
	private String item_no;
	private String order_date;
	private String proc_end_date;
	private String del_date;
	private String due_date;
	private String order_note;
	
	public String getOrder_com_id() {
		return order_com_id;
	}
	public void setOrder_com_id(String order_com_id) {
		this.order_com_id = order_com_id;
	}
	public int getOrder_price() {
		return order_price;
	}
	public void setOrder_price(int order_price) {
		this.order_price = order_price;
	}
	public String getPart_status() {
		return part_status;
	}
	public void setPart_status(String part_status) {
		this.part_status = part_status;
	}
	public String getCar_name() {
		return car_name;
	}
	public void setCar_name(String car_name) {
		this.car_name = car_name;
	}
	public String getItem_no() {
		return item_no;
	}
	public void setItem_no(String item_no) {
		this.item_no = item_no;
	}
	public String getOrder_date() {
		return order_date;
	}
	public void setOrder_date(String order_date) {
		this.order_date = order_date;
	}
	public String getProc_end_date() {
		return proc_end_date;
	}
	public void setProc_end_date(String proc_end_date) {
		this.proc_end_date = proc_end_date;
	}
	public String getDel_date() {
		return del_date;
	}
	public void setDel_date(String del_date) {
		this.del_date = del_date;
	}
	public String getDue_date() {
		return due_date;
	}
	public void setDue_date(String due_date) {
		this.due_date = due_date;
	}
	public String getOrder_note() {
		return order_note;
	}
	public void setOrder_note(String order_note) {
		this.order_note = order_note;
	}
	
	
}
