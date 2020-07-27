module server.server;

import std.socket : Socket, Address, SocketType, ProtocolType;
import client.client : ButterflyClient;
import std.file : mkdir, exists, isDir;
import server.listener : ButterflyListener;

public final class ButterflyServer
{
    /**
    * TODO: Later implement listeners so that we can
    * bind to multiple sockets.
    */
    private ButterflyListener[] listeners;

    /**
    * Socket to listen for incoming connections on
    */
    private Socket serverSocket;

    /**
    * Whether or not the server is active
    */
    private bool active = true;

    /* TODO: Server domain */
    public string domain;

    this(ButterflyListener[] listeners, string domain)
    {
        /**
        * Create the needed directories (if not already present)
        */
        directoryCheck();

        /**
        * Set all the listeners
        */
        this.listeners = listeners;

        /* Set the domain of the server */
        this.domain = domain;

        /* Start accepting connections */
        run();
    }

    private void directoryCheck()
    {
        /* TODO: Create the `mailboxes/` directory, if it does not exist */

        /* Check to make sure there is n FS node at `mailboxes` */
        if(exists("mailboxes"))
        {
            /* Make sure it is a directory */
            if(isDir("mailboxes"))
            {

            }
            else
            {
                /* TODO: Error handling */
            }
        }
        else
        {
            /* Create the `mailboxes` directory */
            mkdir("mailboxes");
        }  

        /* Check to make sure there is an FS node at `accounts/` */
        if(exists("accounts"))
        {
            /* Make sure it is a directory */
            if(isDir("accounts"))
            {

            }
            else
            {
                /* TODO: Error handling */
            }
        }
        else
        {
            /* Create the `accounts` directory */
            mkdir("accounts");
        }  
    }

    private void run()
    {
        /* Start the listeners */
        foreach(ButterflyListener listener; listeners)
        {
            listener.start();
        }
    }

}