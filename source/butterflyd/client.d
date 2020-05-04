module butterflyd.client;

import core.thread : Thread;
import std.socket : Socket;
import bmessage;
import std.json : JSONValue, JSONException;
import std.stdio;
import std.string;
import butterflyd.management.manager;
import butterflyd.data.message;
import std.conv;

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

        

        /* We need a command */
        string commandField = serverMessage["command"].str();
        writeln("Command is: " ~ commandField);


        /* Make sure we store the `bfid` */
        string bfid = serverMessage["bfid"].str();

        try
        {
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
            else if(cmp(commandField, "sendMail") == 0)
            {
                /* TODO: First autheticate, using serverMessage["auth"] */

                /* Get the mail message details */
                JSONValue mailDetails = serverMessage["message"];

                /* Create a message */
                MailMessage message = new MailMessage(mailDetails);

                /* TODO: Send mail */
                bool mailStatus = Manager.sendMail(message);
                writeln("Mail status: " ~ to!(string)(mailStatus));

                if(mailStatus)
                {
                    sendMessage(handle, JSONValue("Yah"));
                    writeln("dfhdfhjfsdk");
                }
            }
        }
        catch(JSONException e)
        {
            /* Construct the full message */
            JSONValue responseMessage;

            /* Construct the `command` block */
            JSONValue commandBlock;
            commandBlock["type"] = "sendClients";
            commandBlock["data"] = [serverMessage["account"]["username"].str()];

            /* Construct the header */
            JSONValue headerBlock;
            headerBlock["command"] = commandBlock;
            headerBlock["status"] = "0";

            /* Attach the `header` block to the response message */
            responseMessage["header"] = headerBlock;

            /* Generate butterfly response */
            JSONValue butterflyResponse;
            butterflyResponse["bfid"] = bfid;

            JSONValue status;
            status["code"] = "1";
            status["message"] = e.toString();
            butterflyResponse["status"] = status;


            /* Set the data */
            responseMessage["data"] = butterflyResponse;
            
            /* Send the response message */
            sendMessage(handle, responseMessage);
        }

        
    }
}