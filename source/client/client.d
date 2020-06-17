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

    /**
    * The type of connection
    */
    private enum ClientType
    {
        SERVER,
        CLIENT
    }

    private ClientType clientType;

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
                    /* TODO: Implement authentication */

                    /**
                    * If the auth if successful then upgrade to
                    * a client-type connection.
                    */
                    clientType = ClientType.CLIENT;
                }
                else if(cmp(command, "sendMail") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(clientType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "storeMail") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(clientType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "deliverMail") == 0)
                {
                    Mail mail = new Mail(commandBlock["request"]["mail"]);
                    deliverMail(mail);
                }
                else if(cmp(command, "fetchMail") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(clientType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "createFolder") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(clientType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "deleteFolder") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(clientType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "addToFolder") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(clientType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "removeFromFolder") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(clientType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "listFolder") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(clientType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
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
    * Delivers the mail to the local users
    */
    private void deliverMail(Mail mail)
    {
        /* Get a list of the recipients of the mail message */
        string[] recipients = mail.getRecipients();

        /* Store the mail to each of the recipients */
        foreach(string recipient; recipients)
        {
            

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
            if(cmp(domain, server.domain) == 0)
            {
                writeln("Storing mail message to "~recipient~" ...");

                /* Get the Mailbox of a given user */
                Mailbox userMailbox = new Mailbox(username);

                /* Get the Inbox folder */
                Folder inboxFolder = new Folder(userMailbox, null, "Inbox");

                /* Store the message in their Inbox folder */
                userMailbox.storeMessage(inboxFolder, mail);

                writeln("Stored mail message");
            }
        }
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
            if(cmp(domain, server.domain) == 0)
            {
                /* Get the Mailbox of a given user */
                Mailbox userMailbox = new Mailbox(username);

                /* Get the Inbox folder */
                Folder inboxFolder = new Folder(userMailbox, null, "Inbox");

                /* Store the message in their Inbox folder */
                userMailbox.storeMessage(inboxFolder, mail);
            }
            else
            {
                /* TODO: Do remote mail delivery */

                /**
                * Construct the server message to send to the
                * remote server.
                */
                JSONValue messageBlock;
                messageBlock["command"] = "deliverMail";
                JSONValue mailBlock;
                mailBlock["recipients"] = null; /* TODO: Get JSON array of strings */
                mailBlock["message"] = mail.getMessage();
                JSONValue requestBlock;
                requestBlock["mail"] = mailBlock;
            }

            writeln("Sent mail message");
        }
    }
}