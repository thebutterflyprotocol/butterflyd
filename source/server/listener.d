module server.listener;

import core.thread : Thread;
import server.server : ButterflyServer;
import std.json : JSONValue;

public abstract class ButterflyListener : Thread
{
    private ButterflyServer server;
    private string listenerName;
    private JSONValue config;
    private string domain;

    this(string listenerName, string domain, JSONValue config)
    {
        super(&run);
        this.listenerName = listenerName;
        this.config = config;
        this.domain = domain;
    }

    public abstract void run();

    public void setServer(ButterflyServer server)
    {
        this.server = server;
    }

    public ButterflyServer getServer()
    {
        return server;
    }

    public string getName()
    {
        return listenerName;
    }

    public string getDomain()
    {
        return domain;
    }

    public JSONValue getConfig()
    {
        return config;
    }

}