module butterflyd.client;

import core.thread : Thread;
import std.socket : Socket;
import bmessage;
import std.json : JSONValue;
import std.stdio;
import std.string;
import butterflyd.management.manager;

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

        /* Make sure we store the `bfid` */
        string bfid = serverMessage["bfid"].str();

        /* We need a command */
        string commandField = serverMessage["command"].str();
        writeln("Command is: " ~ commandField);

        /**
        * If the user wants to register.
        * This "requires" no bfid as it is one-shot.
        */
        if(cmp(commandField, "register") == 0)
        {
            /* Get the registration details */
            JSONValue accountDetails = serverMessage["account"];
            writeln("Account data: " ~ accountDetails.toPrettyString());

            /* Get the username and password */
            string username = accountDetails["username"].str(), password = accountDetails["password"].str();

            bool registrationSucess = Manager.registerAccount(username, password);

        }
    }
}