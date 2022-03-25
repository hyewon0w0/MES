package statusProgress;

public class processProgressDTO {
	private int work_id;
	private String item_no;
	private String process;
	private String enddate;
	private String proc_expdate;
	private String startdate;
	private int betweendate;
	
	public int getWork_id() {
		return work_id;
	}
	public void setWork_id(int work_id) {
		this.work_id = work_id;
	}
	public String getItem_no() {
		return item_no;
	}
	public void setItem_no(String item_no) {
		this.item_no = item_no;
	}
	public String getProcess() {
		return process;
	}
	public void setProcess(String process) {
		this.process = process;
	}
	public String getEnddate() {
		return enddate;
	}
	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}
	public String getProc_expdate() {
		return proc_expdate;
	}
	public void setProc_expdate(String proc_expdate) {
		this.proc_expdate = proc_expdate;
	}
	public String getStartdate() {
		return startdate;
	}
	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}
	public int getBetweendate() {
		return betweendate;
	}
	public void setBetweendate(int betweendate) {
		this.betweendate = betweendate;
	}
	
}
