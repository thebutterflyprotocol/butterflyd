module client.client;

import core.thread : Thread;
import std.socket : Socket, AddressFamily, SocketType, ProtocolType, parseAddress, Address, SocketOSException;
import bmessage;
import std.stdio;
import std.json;
import std.string;
import client.mail;
import server.server;
import std.conv : to;
import client.exceptions;
import std.file;
import std.exception;
import std.datetime.systime : Clock, SysTime;
import server.listener : ButterflyListener;
import gogga;

public final class ButterflyClient : Thread
{
    /**
    * The associated listener
    */
    private ButterflyListener listener;

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

    this(ButterflyListener listener, Socket clientSocket)
    {
        super(&run);
        this.clientSocket = clientSocket;
        this.listener = listener;
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
        string message;

        /**
        * TODO: My error handling in bformat is not good.
        * A dead connection sitll returns successful write.
        */

        /* TODO: Implement loop read-write here */
        while(active)
        {
            gprintln("Awaiting command from client...");

            /* Await a message from the client */
            bool recvStatus = receiveMessage(clientSocket, receivedBytes);
            gprintln(recvStatus);

            /* If the receive succeeded */
            if(recvStatus)
            {
                /* Reset the response JSON */
                responseBlock = JSONValue();
                message.length = 0;
                status = 0;

                /* TODO: Add error handling catch for all JSON here */

                try
                {
                    /* Parse the incoming JSON */
                    commandBlock = parseJSON(cast(string)receivedBytes);
                    gprintln("Received response: "~commandBlock.toPrettyString());

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

                        /* Attempt to register the new account */
                        register(regUsername, regPassword);
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
                            Mail storedMail = storeMail(storeFolder, mailBlock);

							/* Set the response to be the mail message's ID */
							JSONValue response;
							response["mailID"] = storedMail.getMailID();
                            responseBlock["response"] = response;
                        }
                        else
                        {
                            /* TODO: Add error handling */
                        }
                    }
                    else if(cmp(command, "editMail") == 0)
                    {
                        /* Make sure the connection is from a client */
                        if(connectionType == ClientType.CLIENT)
                        {
                            /* Get the mail block */
                            JSONValue mailBlock = commandBlock["request"]["mail"];

							/* Get the folder the mail message wanting to be edited resides in */
                            Folder storeFolder = new Folder(mailbox, commandBlock["request"]["folder"].str());

							/* Get the mail message wanting to be edited */
							Mail messageOriginal = new Mail(mailbox, storeFolder, commandBlock["request"]["mailID"].str());

                            /* Update the message with the new data */
                            Mail updatedMail = editMail(messageOriginal, storeFolder, mailBlock);

                            responseBlock["response"]["mailID"] = updatedMail.getMailID();
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
                            /* Deliver the mail message from the remote host */
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
                            /* Create the new folder */
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
                            /* The folder to be deleted */
                            Folder deleteFolder = new Folder(mailbox, commandBlock["request"]["folder"].str());
                            
                            /* Delete the folder */
                            deleteFolder.deleteFolder();
                        }
                        else
                        {
                            /* TODO: Add error handling */
                        }
                    }
                    else if(cmp(command, "deleteMail") == 0)
                    {
                        /* Make sure the connection is from a client */
                        if(connectionType == ClientType.CLIENT)
                        {
							/* The folder the mail wanting to be deleted resides in */
							Folder mailDirectory = new Folder(mailbox, commandBlock["request"]["folder"].str());

                            /* The mail message to be deleted */
                            Mail mailToDelete = new Mail(mailbox, mailDirectory, commandBlock["request"]["mailID"].str());
                            
                            mailToDelete.deleteMessage();
                        }
                        else
                        {
                            /* TODO: Add error handling */
                        }
                    }
                    else if(cmp(command, "moveFolder") == 0)
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
                    else if(cmp(command, "moveMail") == 0)
                    {
                        /* Make sure the connection is from a client */
                        if(connectionType == ClientType.CLIENT)
                        {
                            /* The folder of the original mail message */
                            Folder originalMessageFolder = new Folder(mailbox, commandBlock["request"]["originalFolder"].str());
                            
                            /* The original mail message */
                            Mail originalMailMessage = new Mail(mailbox, originalMessageFolder, commandBlock["request"]["mailID"].str());
                            
                            /* The folder to move the mail message to */
                            Folder newMailFolder = new Folder(mailbox, commandBlock["request"]["newFolder"].str());
                            
                            /* Move mail message */
                            Mail newMail = moveMail(originalMessageFolder, originalMailMessage, newMailFolder);
                            
                            /* Set the response */
                            JSONValue response;
                            response["mailID"] = newMail.getMailID();
                            responseBlock["response"] = response;
                        }
                        else
                        {
                            /* TODO: Add error handling */
                        }
                    }
                    else if(cmp(command, "listMail") == 0)
                    {
                        /* Make sure the connection is from a client */
                        if(connectionType == ClientType.CLIENT)
                        {
                            /* Get the folder wanting to be listed */
                            Folder listFolder = new Folder(mailbox, commandBlock["request"]["folderName"].str());

                            /* Write back an array of mailIDs */
                            JSONValue response;
                            response["mailIDs"] = parseJSON(to!(string)(listFolder.getMessages()));
                            responseBlock["response"] = response;
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
                            /* Get the folder wanting to be listed */
                            Folder listFolder = new Folder(mailbox, commandBlock["request"]["folderName"].str());

							/* Write back an array of folder names */
                            JSONValue response;
                            response["folders"] = parseJSON(to!(string)(listFolder.getFolders()));
                            responseBlock["response"] = response;
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
                catch(JSONException e)
                {
                    /* TODO: Set error message and status code */
                    status = -2;
                    message = e.msg;
                }
                catch(FileException e)
                {
                    /* Status=-1 :: I/O error */
                    status = -1;
                    message = e.msg;
                }
                catch(ErrnoException e)
                {
                    /* Status=-1 :: I/O error */
                    status = -1;
                    message = e.msg;
                }
                catch(ButterflyException e)
                {
                    /* Set the status */
                    status = e.status;
                    message = e.msg;
                }

                /* Generate the `status` block */
                JSONValue statusBlock;
                statusBlock["code"] = status;
                statusBlock["message"] = message;

                /* Set the `status` field of the response block */
                responseBlock["status"] = statusBlock;

                /* Write the response block to the client */
                gprintln("Writing back response: "~responseBlock.toPrettyString());
                bool sendStatus = sendMessage(clientSocket, cast(byte[])toJSON(responseBlock));
                gprintln(sendStatus);

                /* If there was an error writing the response back */
                if(!sendStatus)
                {
                    /* End the session */
                    gprintln("Response write back failed");
                    break;
                }
            }
            else
            {
                /**
                * If we failed to receive, then close the connection
                */
                break;
            }
        }

        gprintln("Closing session...");

        /* Close the socket */
        clientSocket.close();
    }


	/**
	 * Moves message from one folder, `srcFolder`, to another folder,
	 * `dstFolder`.
	 */
	private Mail moveMail(Folder srcFolder, Mail ogMessage, Folder dstFolder)
	{
		/* Store a copy of the message in the destination folder `dstFolder` */
		Mail newMessage = storeMail(dstFolder, ogMessage.getMessage());
		
		/* Delete the original message */
		ogMessage.deleteMessage();
		
		return newMessage;
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
    
    /**
     * Updates the given mail message in the
     * provided folder with a new message.
     */
    private Mail editMail(Mail messageOriginal, Folder storeFolder, JSONValue mailBlock)
    {
		Mail updatedMail;
		
		/* Delete the old message */
		messageOriginal.deleteMessage();
		
		/* Store the new message in the same folder */
		updatedMail = Mail.createMail(mailbox, storeFolder, mailBlock);
		
		return updatedMail;
	}

    private bool authenticate(string username, string password)
    {
        /* TODO: Implement me */

        return true;
    }

    private void register(string username, string password)
    {
        /**
        * Check if the account already exists.
        * If it does then throw an exception.
        */
        if(exists("accounts/"~username))
        {
            /* Status=1 :: Account exists */
            throw new ButterflyException(1);
        }

        /* Create the mailbox for the new user */
        Mailbox.createMailbox(username);

        /* Create the account */
        /* TODO: Implement me */
    }

    /**
    * Create a folder in your mailbox
    */
    private Folder createFolder(string folderName)
    {
        /* Strip infront or behind slashes */
        folderName = strip(folderName, "/");

        /* Seperated paths */
        string[] seperatedPaths = split(folderName, "/");

        /* The newly created Folder */
        Folder newFolder;

        /* If it is a base folder wanting to be created */
        if(seperatedPaths.length)
        {
            newFolder = mailbox.addBaseFolder(folderName);
        }
        /* If it is a nested folder wanting to be created */
        else
        {
            string folderPathExisting = folderName[0..lastIndexOf(folderName, "/")];
            Folder endDirectoryExisting = new Folder(mailbox, folderPathExisting);
            newFolder = endDirectoryExisting.createFolder(folderName[lastIndexOf(folderName, "/")+1..folderName.length]);
        }

        return newFolder;
    }

    /**
    * Given the address of the mail block, applying incoming
    * mail filters to the mail message.
    *
    * Returns `true` if we are to outright reject this incoming
    * mail.
    */
    private bool filterMailIncoming(JSONValue* mailBlock)
    {
        /* Add the received time stamp */
        (*mailBlock)["receivedTimestamp"] = Clock.currTime().toString();

        /* TODO: Add plugin-based filtering here */
        /* TODO: Filter using bester */

        /* TODO: Implement rejection */
        return false;
    }

    /**
    * Delivers the mail to the local users
    */
    private void deliverMail(JSONValue mailBlock)
    {
        /* Filter the mail */
        bool reject = filterMailIncoming(&mailBlock);

        /* Check to see if we must reject this mail */
        if(reject)
        {
            /* TODO: Implement me */
        }

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
            if(cmp(domain, listener.getDomain()) == 0)
            {
                gprintln("Storing mail message to "~recipient~" ...");

                /* Get the Mailbox of a given user */
                Mailbox userMailbox = new Mailbox(username);

                /* Get the Inbox folder */
                Folder inboxFolder = new Folder(userMailbox, "Inbox");

                /* Store the message in their Inbox folder */
                Mail.createMail(userMailbox, inboxFolder, mailBlock);

                gprintln("Stored mail message");
            }
        }
    }

    /**
    * Given the address of the mail block, applying outgoing
    * mail filters to the mail message.
    *
    * Returns `true` if we are to outright reject this outgoing
    * mail.
    */
    private bool filterMailOutgoing(JSONValue* mailBlock)
    {
        /* Add the from field to the mail block */
        (*mailBlock)["from"] = mailbox.username~"@"~listener.getDomain();

        /* Add the sent time stamp */
        (*mailBlock)["sentTimestamp"] = Clock.currTime().toString();

        /* TODO: Add plugin-based filtering here */
        /* TODO: Filter using bester */

        /* TODO: Implement rejection */
        return false;
    }

    /**
    * Sends the mail message `mail` to the servers
    * listed in the recipients field.
    */
    private void sendMail(JSONValue mailBlock)
    {
        /* Filter the mail */
        bool reject = filterMailOutgoing(&mailBlock);

        /* Check to see if we must reject this mail */
        if(reject)
        {
            /* TODO: Implement me */
        }

        /* Get a list of the recipients of the mail message */
        string[] recipients;
        foreach(JSONValue recipient; mailBlock["recipients"].array())
        {
            recipients ~= recipient.str();
        }


        /* List of server's failed to deliver to */
        string[] failedRecipients;

        /* List of remote recipients */
        string[] remoteRecipients;

        /* Send the mail to each of the recipients */
        foreach(string recipient; recipients)
        {
            gprintln("Sending mail message to "~recipient~" ...");

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
            if(listener.getServer().isLocalDomain(domain))
            {
                gprintln("Local delivery occurring...");

                /* TODO: Add failed delivery here too */
                if(!Mailbox.isMailbox(username))
                {
                    /* Append failed recipient to array of failed recipients */
                    failedRecipients ~= recipient;
                    continue;
                }

                /* Get the Mailbox of a given user */
                Mailbox userMailbox = new Mailbox(username);

                /* Get the Inbox folder */
                Folder inboxFolder = new Folder(userMailbox, "Inbox");

                /* Filter mail incoming (for local) */
                reject = filterMailIncoming(&mailBlock);

                /* Check to see if we must reject this mail */
                if(reject)
                {
                    /* TODO: Implement me */
                }

                /* Store the message in their Inbox folder */
                Mail.createMail(userMailbox, inboxFolder, mailBlock);
            }
            else
            {
                /* Tally up all non-local recipients for off-thread delivery */
                remoteRecipients ~= recipient;
            }
        }


        import client.sender : MailSender;

        /**
        * Create a new MailSender for delivering remote mail
        * off of this thread
        */
        MailSender remoteMailSender = new MailSender(remoteRecipients, mailBlock, failedRecipients);


        gprintln("Mail delivered (there may be remote mail delivery ongoing)");


        /* Store the message in this user's "Sent" folder */
        Folder sentFolder = new Folder(mailbox, "Sent");

        /* Store the message in their Inbox folder */
        Mail.createMail(mailbox, sentFolder, mailBlock);

        gprintln("Saved mail message to sent folder");
    }
}
