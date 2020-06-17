module client.client;

import core.thread : Thread;
import std.socket : Socket;
import bmessage;
import std.stdio;
import std.json;
import std.string;
import client.mail;
import server.server;

public final class ButterflyClient : Thread
{
    /**
    * The associated server
    */
    private ButterflyServer server;

    /**
    * Socket of the client connection
    */
    private Socket clientSocket;

    /**
    * Whether or not the server is active
    */
    private bool active = true;

    this(ButterflyServer server, Socket clientSocket)
    {
        super(&run);
        this.clientSocket = clientSocket;
        this.server = server;
    }

    private void run()
    {
        /* The received command block */
        JSONValue commandBlock;

        /* The received bytes */
        byte[] receivedBytes;

        /* TODO: Implement loop read-write here */
        while(active)
        {
            writeln("Awaiting command from client...");

            /* Await a message from the client */
            bool recvStatus = receiveMessage(clientSocket, receivedBytes);
            
            if(recvStatus)
            {
                /* TODO: Add error handling catch for all JSON here */

                /* Parse the incoming JSON */
                commandBlock = parseJSON(cast(string)receivedBytes);

                /* Get the command */
                string command = commandBlock["command"].str();

                /* TODO: Add command handling here */
                if(cmp(command, "auth") == 0)
                {

                }
                else if(cmp(command, "sendMail") == 0)
                {

                }
                else if(cmp(command, "storeMail") == 0)
                {

                }
                else if(cmp(command, "deliverMail") == 0)
                {

                }
                else if(cmp(command, "fetchMail") == 0)
                {

                }
                else if(cmp(command, "createFolder") == 0)
                {

                }
                else if(cmp(command, "deleteFolder") == 0)
                {

                }
                else if(cmp(command, "addToFolder") == 0)
                {

                }
                else if(cmp(command, "removeFromFolder") == 0)
                {

                }
                else if(cmp(command, "listFolder") == 0)
                {

                }
                else
                {
                    /* TODO: Add error handling for invalid commands */
                }
            }
            else
            {
                /* TODO: Add error handling here */
            }
        }

        /* Close the socket */
        clientSocket.close();
    }

    /**
    * Sends the mail message `mail` to the servers
    * listed in the recipients field.
    */
    private void sendMail(Mail mail)
    {
        /* Get a list of the recipients of the mail message */
        string[] recipients = mail.getRecipients();

        /* Send the mail to each of the recipients */
        foreach(string recipient; recipients)
        {
            writeln("Sending mail message to "~recipient~" ...");

            /* Get the mail address */
            string[] mailAddress = split(recipient, "@");

            /* Get the username */
            string username = mailAddress[0];

            /* Get the domain */
            string domain = mailAddress[1];

            /**
            * Check if the domain of this recipient is this server
            * or if it is a remote server.
            */
            if(cmp(domain, ""))
            {

            }
            else
            {

            }
        }
    }
}