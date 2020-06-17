module client.client;

import core.thread : Thread;
import std.socket : Socket;

public final class ButterflyClient : Thread
{
    /**
    * Socket of the client connection
    */
    private Socket clientSocket;

    /**
    * Whether or not the server is active
    */
    private bool active;

    this(Socket clientSocket)
    {
        super(&run);
        this.clientSocket = clientSocket;
    }

    private void run()
    {
        /* TODO: Implement loop read-write here */
    }
}