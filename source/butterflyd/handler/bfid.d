module butterflyd.handler.bfid;

import std.json;

public final class Bfid
{
    private string bfid;
    private string username;
    private string command;
    private JSONValue data;

    this(string username, string bfid, string command, JSONValue data)
    {
        this.username = username;
        this.bfid = bfid;
        this.command = command;
        this.data = data;
    }

    public string getCommand()
    {
        return command;
    }

    public JSONValue getData()
    {
        return data;
    }

    public string getUsername()
    {
        return username;
    }

    public string getBfid()
    {
        return bfid;
    }

}