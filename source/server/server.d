module server.server;

import std.socket : Socket, Address, SocketType, ProtocolType;
import client.client : ButterflyClient;

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

    this(Address bindAddress)
    {
        /**
        * Instantiate a new Socket for the given Address
        * `bindAddress` of which it will bind to.
        */
        serverSocket = new Socket(bindAddress.addressFamily, SocketType.STREAM, ProtocolType.TCP);
        serverSocket.bind(bindAddress);

        /* Start accepting connections */
        run();

        /* Close the socket */
        serverSocket.close();
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
            ButterflyClient client = new ButterflyClient(clientSocket);

            /* Start the client thread */
            client.start();

            /* TODO: Add to array */
        }
    }
}