module butterflyd.handler;

import std.socket : Socket, AddressFamily, SocketType, UnixAddress, SocketOSException, AddressException;
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
            handlerSocket.listen(1); /* todo: vALUE HERE */
        }
        catch(AddressException)
        {
            throw new ButterflyException("Address format incorrect");
        }
        catch(SocketOSException)
        {
            throw new ButterflyException("Error in setting up handler socket");
        }
    }
}