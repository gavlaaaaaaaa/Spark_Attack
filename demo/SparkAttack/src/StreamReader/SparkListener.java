package StreamReader;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

public class SparkListener extends Thread {

	private ServerSocket serverSocket;
	private String result="";
	private int port;
	private boolean isListening;
	
	
	public SparkListener(int port){
		try {
			serverSocket = new ServerSocket(port);
			isListening = true;
			this.port = serverSocket.getLocalPort();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	
	@Override
	public void run(){
		while(isListening) {
			try {
				Socket clientSocket = serverSocket.accept();
				result="";
				BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
				for (String line = in.readLine(); line != null; line = in.readLine()) {
					result = result + line;
				}
				clientSocket.close();
			} catch (IOException e) {
			}
		}
	}
	
	
	public void runSpark(String searchTerms){
		String scriptParams = String.valueOf(port);
		
		if(searchTerms != null){
			scriptParams = scriptParams + " " + searchTerms.replace(",", " ");
		}
		
		String[] args = new String[2];
		
		args[0] = "/home/sparkattack100/demo/run_spark.sh";
		args[1] = scriptParams;
		
		try {
			Runtime.getRuntime().exec(args);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	
	public void stopListening(){
		try {
			if(!serverSocket.isClosed()) {
				serverSocket.close();
				isListening = false;
			}
		} catch (IOException e) {
			//e.printStackTrace();
			System.out.println("Error thrown");
		}
	}
	
	
	public String getResult(){
		return result;
	}
}
