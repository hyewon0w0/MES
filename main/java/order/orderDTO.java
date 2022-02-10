package order;

public class orderDTO {

	private String item_no;
	private String o_com_id;
	private String o_date;
	private String o_status;
	private String p_status;
	private String c_name;
	private String p_name;
	private int o_price;
	private int n_price;
	private String del_date;
	private String p_e_date;
	private String due_date;
	private String o_note;
	private String img;
	private String o_et_id;
	private int o_num;
	
	public orderDTO() {
		super();
	}

	public orderDTO(String item_no, String o_com_id, String o_date, String o_status, String p_status, String c_name,
			String p_name, int o_price, int n_price, String del_date, String p_e_date, String due_date, String o_note,
			String img, String o_et_id, int o_num) {
		super();
		this.item_no = item_no;
		this.o_com_id = o_com_id;
		this.o_date = o_date;
		this.o_status = o_status;
		this.p_status = p_status;
		this.c_name = c_name;
		this.p_name = p_name;
		this.o_price = o_price;
		this.n_price = n_price;
		this.del_date = del_date;
		this.p_e_date = p_e_date;
		this.due_date = due_date;
		this.o_note = o_note;
		this.img = img;
		this.o_et_id = o_et_id;
		this.o_num = o_num;
	}
	
	public String getItem_no() {
		return item_no;
	}

	public void setItem_no(String item_no) {
		this.item_no = item_no;
	}

	public String getO_com_id() {
		return o_com_id;
	}

	public void setO_com_id(String o_com_id) {
		this.o_com_id = o_com_id;
	}

	public String getO_date() {
		return o_date;
	}

	public void setO_date(String o_date) {
		this.o_date = o_date;
	}

	public String getO_status() {
		return o_status;
	}

	public void setO_status(String o_status) {
		this.o_status = o_status;
	}

	public String getP_status() {
		return p_status;
	}

	public void setP_status(String p_status) {
		this.p_status = p_status;
	}

	public String getC_name() {
		return c_name;
	}

	public void setC_name(String c_name) {
		this.c_name = c_name;
	}

	public String getP_name() {
		return p_name;
	}

	public void setP_name(String p_name) {
		this.p_name = p_name;
	}

	public int getO_price() {
		return o_price;
	}

	public void setO_price(int o_price) {
		this.o_price = o_price;
	}

	public int getN_price() {
		return n_price;
	}

	public void setN_price(int n_price) {
		this.n_price = n_price;
	}

	public String getDel_date() {
		return del_date;
	}

	public void setDel_date(String del_date) {
		this.del_date = del_date;
	}

	public String getP_e_date() {
		/*
		String r_p_e_date = p_e_date;
		if(p_e_date != null) {
			r_p_e_date = p_e_date.substring(0,10);
		}
		
		return r_p_e_date;
		*/
		return p_e_date;
	}

	public void setP_e_date(String p_e_date) {
		this.p_e_date = p_e_date;
	}

	public String getDue_date() {
		/*
		String r_due_date = due_date;
		if(due_date != null) {
			r_due_date = due_date.substring(0,10);
		}
		
		return r_due_date;
		*/
		return due_date;
	}

	public void setDue_date(String due_date) {
		this.due_date = due_date;
	}

	public String getO_note() {
		return o_note;
	}

	public void setO_note(String o_note) {
		this.o_note = o_note;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public String getO_et_id() {
		return o_et_id;
	}

	public void setO_et_id(String o_et_id) {
		this.o_et_id = o_et_id;
	}

	public int getO_num() {
		return o_num;
	}

	public void setO_num(int o_num) {
		this.o_num = o_num;
	}

}
