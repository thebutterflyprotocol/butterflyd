module server.listeners;

import core.thread : Thread;
import server.listener : ButterflyListener;
import std.socket : Socket, Address, SocketType, ProtocolType;
import std.json : JSONValue;

public class IPv4Listener : ButterflyListener
{

    private Socket serverSocket;

    this(string name, JSONValue config)
    {
        super(name, config);

        Address bindAddress;
        /**
        * Instantiate a new Socket for the given Address
        * `bindAddress` of which it will bind to.
        */
        serverSocket = new Socket(bindAddress.addressFamily, SocketType.STREAM, ProtocolType.TCP);
        serverSocket.bind(bindAddress);

        
    }

    public override void run()
    {

    }
}