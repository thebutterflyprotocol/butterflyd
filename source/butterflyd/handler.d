module butterflyd.handler;

import std.socket;
import butterflyd.exceptions : ButterflyException;

public final class ButterflyHandler
{
    /* Bester handler socket */
    private Socket handlerSocket;

    /**
    * Constructs a new Butterfly message handler
    * bound to the given UNIX domain socket path,
    * `unixSocketPath` and starts listening.
    *
    * Throws a `ButterflyException` on any error
    * regarding address format, binding or listening.
    */
    this(string unixSocketPath)
    {
        try
        {
            handlerSocket = new Socket(AddressFamily.UNIX, SocketType.STREAM);
            handlerSocket.bind(new UnixAddress(unixSocketPath));
            handlerSocket.listen();
        }
        catch(SocketOSException)
        {
            throw new ButterflyException("Error in setting up handler socket");
        }
        catch(AddressException)
        {
            throw new ButterflyException("Address format incorrect");
        }
    }
}