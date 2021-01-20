module server.listeners;

import core.thread : Thread;
import server.listener : ButterflyListener;
import std.socket : Socket, Address, SocketType, ProtocolType, parseAddress, AddressFamily;
import std.json : JSONValue;
import client.client;
import std.conv : to;


/* TODO: Enforce IPv4 on address */
public class IPv4Listener : ButterflyListener
{

    private Socket serverSocket;

    this(string name, JSONValue config)
    {
        super(name, config["domain"].str(), config);

        Address bindAddress = parseAddress(config["address"].str(), to!(ushort)(config["port"].str()));

		/* TODO: Throw an exception if not IPv4 */
		if(bindAddress.addressFamily() == AddressFamily.INET)
		{
			/**
			* Instantiate a new Socket for the given Address
			* `bindAddress` of which it will bind to.
			*/
			serverSocket = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
			serverSocket.bind(bindAddress);
		}	
		else
		{
			/* TODO: Throw an exception if not IPv4 */
		}
            
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

/* TODO: Enforce IPv6 on address */
public class IPv6Listener : ButterflyListener
{

    private Socket serverSocket;

    this(string name, JSONValue config)
    {
        super(name, config["domain"].str(), config);

        Address bindAddress = parseAddress(config["address"].str(), to!(ushort)(config["port"].str()));

		/* TODO: Throw an exception if not IPv6 */
		if(bindAddress.addressFamily() == AddressFamily.INET6)
		{
			/**
			* Instantiate a new Socket for the given Address
			* `bindAddress` of which it will bind to.
			*/
			serverSocket = new Socket(AddressFamily.INET6, SocketType.STREAM, ProtocolType.TCP);
			serverSocket.bind(bindAddress);
		}	
		else
		{
			/* TODO: Throw an exception if not IPv6 */
		} 
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
