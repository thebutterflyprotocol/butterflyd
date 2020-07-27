module server.listeners;

import core.thread : Thread;
import server.listener : ButterflyListener;
import std.socket : Socket, Address, SocketType, ProtocolType;

public class IPv4Listener : ButterflyListener
{

    private Socket serverSocket;

    this(Address bindAddress)
    {

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