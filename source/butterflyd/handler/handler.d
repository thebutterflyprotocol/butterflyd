module butterflyd.handler.handler;

import std.socket : Socket, AddressFamily, SocketType, UnixAddress, SocketOSException, AddressException;
import butterflyd.exceptions : ButterflyException;
import butterflyd.client : ButterflyClient;
import std.json : JSONValue;
import butterflyd.handler.bfid : Bfid;
import std.string : cmp;

/**
* Represents the message handler for the
* Bester server it is attached to (via
* a UNIX domain socket).
* This dispatches new connections from the
* server to that socket to client handlers
* that handle each connection from the Bester
* server wishing to get a handler response.
*/
public final class ButterflyHandler
{
    /* Bester handler socket */
    private Socket handlerSocket;

    /* Associative array for bfids */
    /* TODO: Implement me */
    private Bfid[] bfids;

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
            handlerSocket.listen(1); /* TODO: Value here */
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

    /**
    * Loops forever accepting new connections
    * from the connection queue by dequeuing
    * them, spawning a new `ButterflyClient`
    * object and then starting its respective
    * worker thread.
    */
    public void dispatch()
    {
        bool isActive = true;
        while(isActive)
        {
            /* Accept a connection from the backlog */
            Socket connection = handlerSocket.accept();

            /* Spawn a new butterfly client */
            ButterflyClient client = new ButterflyClient(connection);

            /* Start the thread */
            client.start();
        }
    }

    public bool isBfid(string bfid)
    {
        return true;
    }

    /* Matches to all bfids excluding unmatched usernames */
    public Bfid findBfid(string username, string bfid)
    {
        Bfid foundBfid;

        for(ulong i = 0; i < bfids.length; i++)
        {
            Bfid currentBfid = bfids[i];

            if(cmp(currentBfid.getUsername(), username) == 0 && cmp(currentBfid.getBfid(), bfid) == 0)
            {
                foundBfid = currentBfid;
                break;
            }
        }

        return foundBfid;
    }

    public void addBfid(string username, string bfid, string command, JSONValue data)
    {
        /* Create the Bfid */
        Bfid newBfid = new Bfid(username, bfid, command, data);

        /* Todo: Dup check */

        /* Add the bfid */
        bfids ~= newBfid;
    }
}