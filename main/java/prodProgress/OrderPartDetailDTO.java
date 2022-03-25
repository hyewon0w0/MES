package prodProgress;

import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONObject;

public class OrderPartDetailDTO {
	
	private String order;
	private String part;
	private int total_work_time = 0;
	private int price = 0;
	private int quantity = 0;
	private String standard;
	private String order_status;
	private List<JSONObject> process = new ArrayList<JSONObject>();
	private String status_color = "rgb(170, 170, 170)";
	private String type;
	
	
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	public String getPart() {
		return part;
	}
	public void setPart(String part) {
		this.part = part;
	}
	public int getTotal_work_time() {
		return total_work_time;
	}
	public void setTotal_work_time(int total_work_time) {
		this.total_work_time = total_work_time;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public String getStandard() {
		return standard;
	}
	public void setStandard(String standard) {
		this.standard = standard;
	}
	public String getOrder_status() {
		return order_status;
	}
	public void setOrder_status(String order_status) {
		this.order_status = order_status;
	}
	public List<JSONObject> getProcess() {
		return process != null ? process : new ArrayList<JSONObject>();
	}
	public void addProcess(JSONObject process) {
		this.process.add(process);
	}
	public String getStatus_color() {
		return status_color;
	}
	public void setStatus_color(String status_color) {
		this.status_color = status_color;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
	
	

}
