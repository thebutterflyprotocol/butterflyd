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

    private ClientType connectionType;

    /**
    * The Mailbox (if client) of the connected
    * user.
    */
    private Mailbox mailbox;

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

        /* The JSON response to be sent */
        JSONValue responseBlock;
        long status = 0;

        /**
        * TODO: My error handling in bformat is not good.
        * A dead connection sitll returns successful write.
        */

        /* TODO: Implement loop read-write here */
        while(active)
        {
            writeln("Awaiting command from client...");

            /* Await a message from the client */
            bool recvStatus = receiveMessage(clientSocket, receivedBytes);
            writeln(recvStatus);

            if(recvStatus)
            {
                /* TODO: Add error handling catch for all JSON here */

                /* Parse the incoming JSON */
                commandBlock = parseJSON(cast(string)receivedBytes);
                writeln("Received response: "~commandBlock.toPrettyString());

                /* Get the command */
                string command = commandBlock["command"].str();

                /* TODO: Add command handling here */
                if(cmp(command, "authenticate") == 0)
                {
                    /* Get the username and password */
                    string authUsername = commandBlock["request"]["username"].str(); 
                    string authPassword = commandBlock["request"]["password"].str();

                    /* TODO: Implement authentication */
                    bool authStatus = authenticate(authUsername, authPassword);

                    if(authStatus)
                    {
                        /**
                        * If the auth if successful then upgrade to
                        * a client-type connection.
                        */
                        connectionType = ClientType.CLIENT;   

                        /**
                        * Set the user's associated Mailbox up
                        */
                        mailbox = new Mailbox(authUsername);
                    }
                    else
                    {
                        /* TODO: Error handling for authentication failure */
                    }
                }
                /* TODO: Add command handling here */
                else if(cmp(command, "register") == 0)
                {
                    /* Get the username and password */
                    string regUsername = commandBlock["request"]["username"].str(); 
                    string regPassword = commandBlock["request"]["password"].str();

                    /* TODO: Implement registration */
                    bool regStatus = register(regUsername, regPassword);

                    if(!regStatus)
                    {
                        /* TODO: Implement error handling for failed registration */
                    }
                }
                else if(cmp(command, "sendMail") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(connectionType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */

                        /* Get the mail block */
                        JSONValue mailBlock = commandBlock["request"]["mail"];

                        /* Send the mail message */
                        sendMail(mailBlock);
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "storeMail") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(connectionType == ClientType.CLIENT)
                    {
                        /* Get the mail block */
                        JSONValue mailBlock = commandBlock["request"]["mail"];

                        /* Get the folder to store the mail message in */
                        Folder storeFolder = new Folder(mailbox, commandBlock["request"]["folder"].str());
                       
                        /* Store the message in the mailbox */
                        storeMail(storeFolder, mailBlock);
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "deliverMail") == 0)
                {
                    /* Make sure the connection is from a server */
                    if(connectionType == ClientType.SERVER)
                    {
                        /* TODO: Implement me */
                        deliverMail(commandBlock["request"]["mail"]);
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "fetchMail") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(connectionType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */

                        /* The folder where the mail message is stored */
                        Folder fetchFolder = new Folder(mailbox, commandBlock["request"]["folder"].str());

                        /* The mail ID of the mail message */
                        string mailID = commandBlock["request"]["id"].str();

                        /* Fetch the Mail */
                        Mail fetchedMail = new Mail(mailbox, fetchFolder, mailID);

                        /* Set the response */
                        JSONValue response;
                        response["mail"] = fetchedMail.getMessage();
                        responseBlock["response"] = response;
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "createFolder") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(connectionType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                        createFolder(commandBlock["request"]["folderName"].str());
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "deleteFolder") == 0)
                {
                    /* Make sure the connection is from a client */
                    if(connectionType == ClientType.CLIENT)
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
                    if(connectionType == ClientType.CLIENT)
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
                    if(connectionType == ClientType.CLIENT)
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
                    if(connectionType == ClientType.CLIENT)
                    {
                        /* TODO: Implement me */
                    }
                    else
                    {
                        /* TODO: Add error handling */
                    }
                }
                else if(cmp(command, "totsiens") == 0)
                {
                    /* Close the connection on next loop condition check */
                    active = false;
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

            /* TODO: Write response here */
            
            /* Generate the `status` field */
            responseBlock["status"] = status;

            /* Write the response block to the client */
            writeln("Writing back response: "~responseBlock.toPrettyString());
            bool sendStatus = sendMessage(clientSocket, cast(byte[])toJSON(responseBlock));
            writeln(sendStatus);

            /* If there was an error writing the response back */
            if(!sendStatus)
            {
                /* End the session */
                active = false;
                writeln("Response write back failed");
            }
        }

        writeln("Closing session...");

        /* Close the socket */
        clientSocket.close();
    }

    /**
    * Stores a mail message in the users Mailbox
    * at in the given Folder, `folder`.
    */
    private Mail storeMail(Folder folder, JSONValue mailBlock)
    {
        /* Create the Mail message to store it */
        Mail savedMail = Mail.createMail(mailbox, folder, mailBlock);

        return savedMail;
    }

    private bool authenticate(string username, string password)
    {
        /* TODO: Implement me */

        return true;
    }

    private bool register(string username, string password)
    {
        /* TODO Implement me */

        /* Return false in the case that registration fails */
        if(Mailbox.isMailbox(username))
        {
            return false;
        }

        Mailbox.createMailbox(username);

        return true;
    }

    /**
    * Create a folder in your mailbox
    */
    private Folder createFolder(string folderName)
    {
        /* The newly created Folder */
        Folder newFolder;

        /**
        * Check if we are creating a base folder
        * or a nested folder.
        */
        bool isBaseFolder = true; /* TODO: Logic work out */

        /* If it is a base folder wanting to be created */
        if(isBaseFolder)
        {
            newFolder = mailbox.addBaseFolder(folderName);
        }
        /* If it is a nested folder wanting to be created */
        else
        {
            //newFolder = ;
        }

        return newFolder;
    }

    /**
    * Delivers the mail to the local users
    */
    private void deliverMail(JSONValue mailBlock)
    {
        /* Get a list of the recipients of the mail message */
        string[] recipients;
        foreach(JSONValue recipient; mailBlock["recipients"].array())
        {
            recipients ~= recipient.str();
        }

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
                Folder inboxFolder = new Folder(userMailbox, "Inbox");

                /* Store the message in their Inbox folder */
                Mail.createMail(userMailbox, inboxFolder, mailBlock);

                writeln("Stored mail message");
            }
        }
    }

    /**
    * Sends the mail message `mail` to the servers
    * listed in the recipients field.
    */
    private void sendMail(JSONValue mailBlock)
    {
        /* Get a list of the recipients of the mail message */
        string[] recipients;
        foreach(JSONValue recipient; mailBlock["recipients"].array())
        {
            recipients ~= recipient.str();
        }

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
                writeln("Local delivery occurring...");

                /* Get the Mailbox of a given user */
                Mailbox userMailbox = new Mailbox(username);

                /* Get the Inbox folder */
                Folder inboxFolder = new Folder(userMailbox, "Inbox");

                /* Store the message in their Inbox folder */
                Mail.createMail(userMailbox, inboxFolder, mailBlock);
            }
            else
            {
                /* TODO: Do remote mail delivery */
                writeln("Remote delivery occurring...");

                /**
                * Construct the server message to send to the
                * remote server.
                */
                JSONValue messageBlock;
                messageBlock["command"] = "deliverMail";

                JSONValue requestBlock;
                requestBlock["mail"] = mailBlock;
                messageBlock["request"] = requestBlock;

                import std.socket : AddressFamily, SocketType, ProtocolType, parseAddress, Address;

                /* Deliver the mail to the remote server */
                Socket remoteServer = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
                
                remoteServer.connect(parseAddress(domain, 6969));
                sendMessage(remoteServer, cast(byte[])toJSON(messageBlock));
                remoteServer.close();
                writeln("Message delivered to server "~domain);
            }

            writeln("Sent mail message");
        }

        /* Store the message in this user's "Sent" folder */
        Folder sentFolder = new Folder(mailbox, "Sent");

        /* Store the message in their Inbox folder */
        Mail.createMail(mailbox, sentFolder, mailBlock);
    }
}