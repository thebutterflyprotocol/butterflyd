module client.client;

import core.thread : Thread;
import std.socket : Socket;
import bmessage;
import std.stdio;
import std.json;

public final class ButterflyClient : Thread
{
    /**
    * Socket of the client connection
    */
    private Socket clientSocket;

    /**
    * Whether or not the server is active
    */
    private bool active = true;

    this(Socket clientSocket)
    {
        super(&run);
        this.clientSocket = clientSocket;
    }

    private void run()
    {
        /* The received command block */
        JSONValue commandBlock;

        /* The received bytes */
        byte[] receivedBytes;

        /* TODO: Implement loop read-write here */
        while(active)
        {
            writeln("Awaiting command from client...");

            /* Await a message from the client */
            bool recvStatus = receiveMessage(clientSocket, receivedBytes);
            
            if(recvStatus)
            {
                /* TODO: Add error handling catch for all JSON here */

                /* Parse the incoming JSON */
                commandBlock = parseJSON(cast(string)receivedBytes);

                /* Get the command */
                string command = commandBlock["command"].str();

                /* TODO: Add command handling here */
            }
            else
            {
                /* TODO: Add error handling here */
            }
        }

        /* Close the socket */
        clientSocket.close();
    }
}