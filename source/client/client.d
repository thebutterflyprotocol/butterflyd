module client.client;

import core.thread : Thread;
import std.socket : Socket;

public final class ButterflyClient : Thread
{
    this()
    {
        super(&run);
    }

    private void run()
    {
        /* TODO: Implement loop read-write here */
    }
}