module server.listener;

import core.thread : Thread;
import server.server : ButterflyServer;
import std.json : JSONValue;

public abstract class ButterflyListener : Thread
{
    private ButterflyServer server;
    private string listenerName;
    private JSONValue config;

    this(string listenerName, JSONValue config)
    {
        super(&run);
        this.listenerName = listenerName;
        this.config = config;
    }

    public abstract void run()
    {

    }

    public void setServer(ButterflyServer server)
    {
        this.server = server;
    }

    public string getName()
    {
        return listenerName;
    }

    public JSONValue getConfig()
    {
        return config;
    }

}