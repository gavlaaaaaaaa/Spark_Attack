package StreamReader;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;



public class ServerSocketHelper implements Runnable{

	protected int          serverPort   = 20000;
	protected ServerSocket serverSocket = null;
	protected boolean      isStopped    = false;
	protected Thread       runningThread= null;
	
	
	
	public ServerSocketHelper(int port){
		this.serverPort = port;
	}

	
	public void run(){
		synchronized(this){
			this.runningThread = Thread.currentThread();
		}
		
		openServerSocket();
		
		while (!isStopped()){
			Socket clientSocket = null;
			try {
				clientSocket = this.serverSocket.accept();
			} catch (IOException e) {
				if(isStopped()) {
					System.out.println("Server Stopped.") ;
					return;
				}
				throw new RuntimeException("Error accepting client connection", e);
			}
			new Thread(new ResultSocket(clientSocket, "Multithreaded Server")).start();
		}
	}


	private synchronized boolean isStopped() {
		return isStopped;
	}

	public synchronized void stop(){
		isStopped = true;
		try {
			serverSocket.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void openServerSocket() {
		try {
			serverSocket = new ServerSocket(serverPort);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}