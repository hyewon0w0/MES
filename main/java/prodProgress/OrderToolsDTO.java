package prodProgress;

public class OrderToolsDTO {
   private String order_name;
   private String part_name;
   private String tool_name;
   private int unit_price;
   private int stock;
   private int price;
   
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
   public String getTool_name() {
      return tool_name;
   }
   public void setTool_name(String tool_name) {
      this.tool_name = tool_name;
   }
   public int getUnit_price() {
      return unit_price;
   }
   public void setUnit_price(int unit_price) {
      this.unit_price = unit_price;
   }
   public int getStock() {
      return stock;
   }
   public void setStock(int stock) {
      this.stock = stock;
   }
   public int getPrice() {
      return price;
   }
   public void setPrice(int price) {
      this.price = price;
   }
}