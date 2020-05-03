module butterflyd.client;

import core.thread : Thread;
import std.socket : Socket;

public class ButterflyClient : Thread
{
    this(Socket handle)
    {
        super(&worker);
    }

    public void worker()
    {
        /* TODO: Add receive here, work out, then send and exit */
    }
}