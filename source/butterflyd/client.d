module butterflyd.client;

import core.thread : Thread;
import std.socket : Socket;
import bmessage;
import std.json : JSONValue;
import std.stdio;

public class ButterflyClient : Thread
{

    /* Socket to the bester server */
    private Socket handle;

    /**
    * Constructs a new `ButterflyClient`
    * to the bester server over the given
    * socket, `handle`.
    */
    this(Socket handle)
    {
        super(&worker);
        this.handle = handle;
    }

    /**
    * Called on thread start. This function waits
    * for a message from the bester server, processes
    * it and then send a response and closes the connection.
    */
    public void worker()
    {
        /* TODO: Add receive here, work out, then send and exit */
        JSONValue serverMessage;
        receiveMessage(handle, serverMessage);

        writeln(serverMessage);
    }
}