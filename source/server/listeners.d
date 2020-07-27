module server.listeners;

import core.thread : Thread;
import server.listener : ButterflyListener;
import std.socket : Socket, Address, SocketType, ProtocolType, parseAddress;
import std.json : JSONValue;
import client.client;
import std.conv : to;

public class IPv4Listener : ButterflyListener
{

    private Socket serverSocket;

    this(string name, JSONValue config)
    {
        super(name, config["domain"].str(), config);

        Address bindAddress = parseAddress(config["address"].str(), to!(ushort)(config["port"].str()));

        /**
        * Instantiate a new Socket for the given Address
        * `bindAddress` of which it will bind to.
        */
        serverSocket = new Socket(bindAddress.addressFamily, SocketType.STREAM, ProtocolType.TCP);
        serverSocket.bind(bindAddress);

        
    }

    public override void run()
    {
        serverSocket.listen(1); //TODO: backlog

        while(true)
        {
            /* Accept the queued connection */
            Socket clientConnection = serverSocket.accept();


            ButterflyClient client = new ButterflyClient(this, clientConnection);

            /* Start the client handler */
            client.start();
        }
    }
}