module server.server;

import std.socket : Socket, Address, SocketType, ProtocolType;
import client.client : ButterflyClient;
import std.file : mkdir, exists, isDir;

public final class ButterflyServer
{
    /**
    * TODO: Later implement listeners so that we can
    * bind to multiple sockets.
    */

    /**
    * Socket to listen for incoming connections on
    */
    private Socket serverSocket;

    /**
    * Whether or not the server is active
    */
    private bool active = true;

    /* TODO: Server domain */
    public string domain;

    this(Address bindAddress)
    {
        /**
        * Create the needed directories (if not already present)
        */
        directoryCheck();

        /**
        * Instantiate a new Socket for the given Address
        * `bindAddress` of which it will bind to.
        */
        serverSocket = new Socket(bindAddress.addressFamily, SocketType.STREAM, ProtocolType.TCP);
        serverSocket.bind(bindAddress);

        /* TODO: Set this to the correct value */
        domain = "poes";

        /* Start accepting connections */
        run();

        /* Close the socket */
        serverSocket.close();
    }

    private void directoryCheck()
    {
        /* TODO: Create the `mailboxes/` directory, if it does not exist */

        /* Check to make sure there is a fs node at `mailboxes` */
        if(exists("mailboxes"))
        {
            /* Make sure it is a directory */
            if(isDir("mailboxes"))
            {

            }
            else
            {
                /* TODO: Error handling */
            }
        }
        else
        {
            /* Create the `mailboxes` directory */
            mkdir("mailboxes");
        }   
    }

    private void run()
    {
        /* TODO: backlog */
        /* Start accepting incoming connections */
        serverSocket.listen(1);

        /* TODO: Loop here */
        while(active)
        {
            /* Block for an incoming queued connection */
            Socket clientSocket = serverSocket.accept();

            /**
            * Create a new ButterflyClient to represent the
            * client connection.
            */
            ButterflyClient client = new ButterflyClient(this, clientSocket);

            /* Start the client thread */
            client.start();

            /* TODO: Add to array */
        }
    }
}