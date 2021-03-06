module server.server;

import std.socket : Socket, Address, SocketType, ProtocolType;
import client.client : ButterflyClient;
import std.file : mkdir, exists, isDir;
import server.listener : ButterflyListener;
import std.stdio : writeln;
import std.string : cmp;
import gogga;

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

    this(ButterflyListener[] listeners)
    {
        /**
        * Create the needed directories (if not already present)
        */
        directoryCheck();

        /**
        * Set all the listeners
        */
        this.listeners = listeners;

        /**
        * Set the server of all listeners to this server
        */
        foreach(ButterflyListener listener; listeners)
        {
            listener.setServer(this);
        }
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

    public void run()
    {
        /* Start the listeners */
        foreach(ButterflyListener listener; listeners)
        {
            gprintln("Starting listener \"" ~ listener.getName() ~"\" ...");
            gprintln("Listener is using configuration: "~listener.getConfig().toPrettyString());
            listener.start();
            gprintln("Listener \"" ~ listener.getName() ~ "\" started");
        }
    }

    public bool isLocalDomain(string domain)
    {
        /**
        * Loop through each listener and check if the requested domain
        * appears in one of them.
        */ 
        foreach(ButterflyListener listener; listeners)
        {
            if(cmp(listener.getDomain(), domain) == 0)
            {
                return true;
            }
        }

        return false;
    }

}