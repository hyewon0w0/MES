package board;

import java.time.LocalDateTime;
import java.util.Date;

public class boardDTO {
	
	private int id;
	private String writer;
	private Date regdate;
	private String title;
	private String content;
	
	public boardDTO() {
		super();
	}
	
	public boardDTO(int id, String writer, Date regdate, String title, String content) {
		super();
		this.id=id;
		this.writer=writer;
		this.regdate=regdate;
		this.title=title;
		this.content=content;
	}
	//자동으로 생성된, 모든 필드에 대한 getter와 setter
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
}
