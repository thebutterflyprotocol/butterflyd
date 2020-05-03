module butterflyd.handler;

import std.socket;

public final class ButterflyHandler
{
    /* Bester handler socket */
    private Socket handlerSocket;

    /**
    * Constructs a new Butterfly message handler
    * bound to the given UNIX domain socket path
    * and starts listening.
    *
    */
    this(string unixSocketPath)
    {
        /* TODO: Add bind here */
        handlerSocket = new Socket(AddressFamily.UNIX, SocketType.STREAM);
        handlerSocket.bind(new UnixAddress(unixSocketPath));
        handlerSocket.listen();
    }
}