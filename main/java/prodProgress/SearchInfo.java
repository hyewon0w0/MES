package prodProgress;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import org.json.simple.JSONObject;

@WebServlet("/prodProgress/SearchInfo")
public class SearchInfo extends HttpServlet {
    public SearchInfo() {
        super();
    }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.setCharacterEncoding("UTF-8");
      PrintWriter writer = response.getWriter();
      JSONObject result = null;
      
      String mode = request.getParameter("mode");
      ProdProgressDAO dao = new ProdProgressDAO();
      String ordername = null;
      String partsname = null;
      
      
      switch(mode) {
      
      case "partinfo":
         ordername = request.getParameter("itemno");
         List<OrderPartsDTO> partlist = null;
         result = new JSONObject();
         
         if(ordername != null){
            partlist = dao.getOrderParts(ordername);
         }
         if(partlist != null) {
            int index = 0;
            for(OrderPartsDTO dto : partlist) {
               JSONObject data = new JSONObject();
               
               data.put("pbo_id", dto.getPbo_id());
               data.put("order", dto.getOrder());
               data.put("part", dto.getPart());
               data.put("quantity", dto.getQuantity());
               data.put("order_status", dto.getOrder_status());
               data.put("layer", dto.getLayer());
               
               result.put(index, data);
               index += 1;
            }
         }
         break;
         
      case "orderinfo":
         ordername = request.getParameter("itemno");
         ProdProgressOrderDTO dto = null;
         
         if(ordername != null){
            dto = dao.getOrderInfo(ordername);
         }
         if(dto!= null) {
            result = new JSONObject();
            result.put("order_com_id",dto.getOrder_com_id());
            result.put("order_price",dto.getOrder_price());
            result.put("part_status",dto.getPart_status());
            result.put("car_name",dto.getCar_name());
            result.put("item_no",dto.getItem_no());
            result.put("order_date",dto.getOrder_date());
            result.put("proc_end_date",dto.getProc_end_date());
            result.put("del_date",dto.getDel_date());
            result.put("due_date",dto.getDue_date());
            result.put("order_note",dto.getOrder_note());
         }
         break;
         
      case "toolsinfo":
         ordername = request.getParameter("itemno");
         partsname = request.getParameter("partsname");
         List<OrderToolsDTO> toolslist = null;  
         result = new JSONObject();
         
         if(ordername != null){
            toolslist = dao.getOrderTools(ordername, partsname);
         }
         if(toolslist!= null) {
            int index = 0;
            for(OrderToolsDTO t_dto : toolslist) {
               JSONObject data = new JSONObject();
               
               data.put("order_name", t_dto.getOrder_name());
               data.put("part_name", t_dto.getPart_name());
               data.put("tool_name", t_dto.getTool_name());
               data.put("unit_price", t_dto.getUnit_price());
               data.put("stock", t_dto.getStock());
               data.put("price", t_dto.getPrice());
               
               result.put(index, data);
               index +=1;
            }
         }
         break;
      
      case "excelinfo":
    	  result = new JSONObject();
    	  String excelfrompath = request.getSession().getServletContext().getRealPath("excelforms");
    	  
    	  //response.setContentType();
    	  
    	  break;
      }
      
      if(result != null) {
    	  writer.print(result);
      }
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      doGet(request, response);
   }

}