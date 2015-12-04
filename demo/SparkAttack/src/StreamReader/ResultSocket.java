package StreamReader;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class ResultSocket implements Runnable{

    protected Socket clientSocket = null;
    protected String serverText   = null;

    public ResultSocket(Socket clientSocket, String serverText) {
        this.clientSocket = clientSocket;
        this.serverText   = serverText;
    }

    public void run() {
        try {
            InputStream input  = clientSocket.getInputStream();
            OutputStream output = clientSocket.getOutputStream();
            
            
            //TODO read

            output.close();
            input.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}