package SparkUI;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import StreamReader.SparkListener;



/**
 * Servlet implementation class SparkAttack
 */
@WebServlet("/WordCloud")
public class WordClouds extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	
	
	private String jsonResult = "{\"name\": \"flare\",\"children\": [{\"name\": \"\",\"size\": 9,\"type\":\"g\"},{\"name\": \"the\",\"size\": 3,\"type\":\"g\"},{\"name\": \"to\",\"size\": 3,\"type\":\"n\"},{\"name\": \"criticism\",\"size\": 2,\"type\":\"b\"},{\"name\": \"pochettino\",\"size\": 2,\"type\":\"b\"},{\"name\": \"for\",\"size\": 2,\"type\":\"n\"},{\"name\": \"is\",\"size\": 2,\"type\":\"b\"},{\"name\": \"of\",\"size\": 2,\"type\":\"g\"},{\"name\": \"great\",\"size\": 2,\"type\":\"n\"},{\"name\": \"has\",\"size\": 2,\"type\":\"b\"}]}";
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WordClouds() {
        super();
        
        
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public int value = 9;
	public int value2 = 10;
	
	public SparkListener sparkListener;
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	
		String stopSpark = request.getParameter("stopSpark");
		response.setContentType("text/event-stream");
		response.setCharacterEncoding("UTF-8");
		PrintWriter pw = response.getWriter();
		
		
		
		if(stopSpark != null && stopSpark.equals("true")){
			sparkListener.stopListening();
			try {
				sparkListener.join();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			sparkListener = null;
			
			pw.write("stopping");
			pw.flush();
		}
		else {
			String search = request.getParameter("searchTerms");
			
			
			if(sparkListener == null){
				sparkListener = new SparkListener(2001);
			}
			
			if(!sparkListener.isAlive()){
				sparkListener.start();
			//	sparkListener.runSpark(search);
			}
			
			pw.write(sparkListener.getResult());
			pw.flush();
		}
	}

}