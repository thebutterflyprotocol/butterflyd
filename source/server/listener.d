module server.listener;

import core.thread : Thread;
import server.server : ButterflyServer;

public abstract class ButterflyListener : Thread
{
    private ButterflyServer server;

    this()
    {
        super(&run);
    }

    public abstract void run();

    public void setServer(ButterflyServer server)
    {
        this.server = server;
    }

}