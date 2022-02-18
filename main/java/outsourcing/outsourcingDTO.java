package outsourcing;

public class outsourcingDTO {
	int outsourcing_no;
	String order_name;
	String prod_name;
	String process;
	String type;
	String company;
	String price;
	String warehousing_exp_date;
	String warehousing_date;
	String faulty;
	String outstart_date;
	String outend_date;
	String status;
	
	
	public outsourcingDTO() {
		super();
	}
	
	public int getOutsourcing_no() {
		return outsourcing_no;
	}
	public void setOutsourcing_no(int outsourcing_no) {
		this.outsourcing_no = outsourcing_no;
	}
	public String getOrder_name() {
		return order_name;
	}
	public void setOrder_name(String order_name) {
		this.order_name = order_name;
	}
	public String getProd_name() {
		return prod_name;
	}
	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
	public String getProcess() {
		return process;
	}
	public void setProcess(String process) {
		this.process = process;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getWarehousing_date() {
		return warehousing_date;
	}
	public void setWarehousing_date(String warehousing_date) {
		this.warehousing_date = warehousing_date;
	}
	public String getFaulty() {
		return faulty;
	}
	public void setFaulty(String faulty) {
		this.faulty = faulty;
	}

	public String getOutstart_date() {
		return outstart_date;
	}

	public void setOutstart_date(String outstart_date) {
		this.outstart_date = outstart_date;
	}

	public String getOutend_date() {
		return outend_date;
	}

	public void setOutend_date(String outend_date) {
		this.outend_date = outend_date;
	}

	public String getWarehousing_exp_date() {
		return warehousing_exp_date;
	}

	public void setWarehousing_exp_date(String warehousing_exp_date) {
		this.warehousing_exp_date = warehousing_exp_date;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
}
