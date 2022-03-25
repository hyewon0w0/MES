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

@WebServlet("/prodProgress/InsertInfo")
public class InsertInfo extends HttpServlet {

    public InsertInfo() {
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
      int success = 1;
      
      
      switch(mode) {
      
      case "partinsert":
         ordername = request.getParameter("itemno");
         success = 1;
         result = new JSONObject();
         
         if(request.getParameterValues("partsMlayer") != null && request.getParameterValues("partsMpartsname") != null
               && request.getParameterValues("partsMquantity") != null && request.getParameterValues("partsMorderstatus") != null) {
         
            String[] layer = request.getParameterValues("partsMlayer");
            String[] partname = request.getParameterValues("partsMpartsname");
            String[] quantity = request.getParameterValues("partsMquantity");
            String[] o_status = request.getParameterValues("partsMorderstatus");
            
            dao.allDelParts(ordername);
            
            for(int i=0; i<layer.length; i++) {
               OrderPartsDTO dto = new OrderPartsDTO();
               
               if(layer[i].length() == 0 || o_status[i].length() == 0 ||
                     partname[i].length() == 0 || quantity[i].length() == 0 ||
                     ordername.length() == 0) {
                  success = 0;
                  continue;
               }
               
               dto.setLayer(layer[i]);
               dto.setOrder(ordername);
               dto.setOrder_status(o_status[i]);
               dto.setPart(partname[i]);
               dto.setQuantity(Integer.parseInt(quantity[i]));
               dto.setPbo_id(dao.getNext());
               
               dao.writeOrderParts(dto);
            }
            
            result.put("result", success);
         }else {
            dao.allDelParts(ordername);
            result.put("result", 1);
         }
         break;
         
      case "toolsinsert":
         ordername = request.getParameter("itemno");
         partsname = request.getParameter("partsname");
         success = 1;
         result = new JSONObject();
         
         if(request.getParameterValues("toolsRtool") != null && request.getParameterValues("toolsRunitprice") != null
               && request.getParameterValues("toolsRamount") != null && request.getParameterValues("toolsRprice") != null) {
            String[] toolsname = request.getParameterValues("toolsRtool");
            String[] toolsunitprice = request.getParameterValues("toolsRunitprice");
            String[] toolsamount = request.getParameterValues("toolsRamount");
            String[] toolsprice = request.getParameterValues("toolsRprice");
         
            dao.allDelTools(ordername,partsname);
            
            for(int i=0; i<toolsname.length; i++) {
               OrderToolsDTO dto = new OrderToolsDTO();
               
               if(toolsname[i].length() == 0 || toolsunitprice[i].length() == 0 ||
                     toolsamount[i].length() == 0 || toolsprice[i].length() == 0 ||
                     ordername.length() == 0 || partsname.length() == 0) {
                  success = 0;
                  continue;
               }
               
               dto.setOrder_name(ordername);
               dto.setPart_name(partsname);
               dto.setTool_name(toolsname[i]);
               dto.setUnit_price(Integer.parseInt(toolsunitprice[i]));
               dto.setStock(Integer.parseInt(toolsamount[i]));
               dto.setPrice(Integer.parseInt(toolsprice[i]));;
               
               dao.writeOrderTools(dto);
            }
            result.put("result", success);
         }else {
            dao.allDelTools(ordername, partsname);
            result.put("result", 1);
         }
         break;
         
      case "partexcelinsert":
         ordername = request.getParameter("itemno");
         success = 1;
         result = new JSONObject();
         
         if(request.getParameterValues("partsMlayer") != null && request.getParameterValues("partsMpartsname") != null
               && request.getParameterValues("partsMquantity") != null && request.getParameterValues("partsMorderstatus") != null) {
         
            String layer = request.getParameter("partsMlayer");
            String partname = request.getParameter("partsMpartsname");
            String quantity = request.getParameter("partsMquantity");
            String o_status = request.getParameter("partsMorderstatus");
            
            OrderPartsDTO dto = new OrderPartsDTO();
            
            if(layer.length() == 0 || o_status.length() == 0 ||
                  partname.length() == 0 || quantity.length() == 0 ||
                  ordername.length() == 0) {
               success = 0;
            }else {
            
               dto.setLayer(layer);
               dto.setOrder(ordername);
               dto.setOrder_status(o_status);
               dto.setPart(partname);
               dto.setQuantity(Integer.parseInt(quantity));
               dto.setPbo_id(dao.getNext());
               
               dao.writeOrderParts(dto);
            }
            
            result.put("result", success);
         }else {
            result.put("result", 0);
         }
         break;
         
      case "OrderRequest":
    	  OrderRequestDTO dto = new OrderRequestDTO(dao.getPorder_numNext());
    	  result = new JSONObject();
    	  
    	  dto.setOrder_name(request.getParameter("itemno"));
    	  dto.setPart_name(request.getParameter("partsname"));
    	  dto.setType(request.getParameter("type"));
    	  
    	  int noreq = 0;
    	  if(request.getParameter("noreq") != null) {
    		  try {
    			  noreq = Integer.parseInt(request.getParameter("noreq"));
    		  }catch(NumberFormatException e) {
    			  result.put("result", 0);
    			  break;
    		  }
    	  }
    	  
    	  dto.setNumber_of_request(noreq);
    	  dto.setPorder_company(request.getParameter("porder_c"));
    	  dto.setExp_date(request.getParameter("exp_d"));
    	  
    	  int u_price = 0;
    	  if(request.getParameter("u_price") != null) {
    		  try {
    			  noreq = Integer.parseInt(request.getParameter("u_price"));
    		  }catch(NumberFormatException e) {
    			  result.put("result", 0);
    			  break;
    		  }
    	  }
    	  
    	  dto.setNumber_of_request(u_price);
    	  
    	  result.put("result",dao.writeOrderRequest(dto));
    	  
    	  break;
    	  
      case "pedinsert":
    	  result = new JSONObject();
    	  
    	  ordername = request.getParameter("itemno");
    	  String procname = request.getParameter("procname");
    	  String expdate = request.getParameter("expdate");
    	  
    	  int res = dao.exp_write(ordername, procname, expdate);
    	  result.put("result", res);
    	  
    	  break;
      }
      
      writer.print(result);
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      doGet(request, response);
   }

}