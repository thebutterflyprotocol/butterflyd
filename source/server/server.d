module server.server;

import core.thread : Thread;
import std.socket : Socket;

public final class ButterflyServer
{

    /**
    * Socket to listen for incoming connections on
    */
    private Socket serverSocket;

    /**
    * Whether or not the server is active
    */
    private bool active;

    this()
    {
        
    }

    public void run()
    {
        /* TODO: Loop here */
        while(active)
        {
            /* Block for an incoming queued connection */
            Socket clientSocket = serverSocket.accept();

            /* TODO: Add to array, create client and start client */
        }

    }
}