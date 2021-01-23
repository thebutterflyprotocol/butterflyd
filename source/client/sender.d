module client.sender;

import core.thread;
import std.json : JSONValue, JSONException, parseJSON, toJSON;
import bmessage;
import std.socket;
import gogga;
import std.string;
import std.conv : to;

/**
* The MailSender class is used to instantiate an object
* which is used to start its own thread which will deliver
* mail (remote-only) to the respective recipients of the mail
* message specified. This is done such that the user need not
* wait and hang whilst mail is being delivered
*/
public final class MailSender : Thread
{
    /**
    * Delivery information
    */
    private string[] remoteRecipients;
    private JSONValue mailBlock;

    /* Failed recipients (at the beginning it will be only local) */
    private string[] failedRecipients;

    /**
    * Constructs a new MailSender with the given
    * email to be delivered (remotely)
    */
    this(string[] remoteRecipients, JSONValue mailBlock, string[] failedRecipients)
    {
        /* Set the worker function */
        super(&run);

        /* Save delivery information */
        this.remoteRecipients = remoteRecipients;
        this.mailBlock = mailBlock;

        /* Save the failed local recipients */
        this.failedRecipients = failedRecipients;

        /* Start the delivery */
        start();
    }

    private void run()
    {
        /* Deliver mail to each recipient */
        foreach (string remoteRecipient; remoteRecipients)
        {
            /* TODO: Do remote mail delivery */
            gprintln("Remote delivery occurring...");

            /* Get the mail address */
            string[] mailAddress = split(remoteRecipient, "@");

            /* Get the username */
            string username = mailAddress[0];

            /* Get the domain */
            string domain = mailAddress[1];

            try
            {
                /**
                * Construct the server message to send to the
                * remote server.
                */
                JSONValue messageBlock;
                messageBlock["command"] = "deliverMail";

                JSONValue requestBlock;
                requestBlock["mail"] = mailBlock;
                messageBlock["request"] = requestBlock;

                /* Deliver the mail to the remote server */
                Socket remoteServer = new Socket(AddressFamily.INET,
                        SocketType.STREAM, ProtocolType.TCP);

                /* TODO: Add check over here to make sure these are met */
                string remoteHost = split(domain, ":")[0];
                ushort remotePort = to!(ushort)(split(domain, ":")[1]);

                remoteServer.connect(parseAddress(remoteHost, remotePort));
                bool sendStatus = sendMessage(remoteServer, cast(byte[]) toJSON(messageBlock));

                if (!sendStatus)
                {
                    goto deliveryFailed;
                }

                byte[] receivedBytes;
                bool recvStatus = receiveMessage(remoteServer, receivedBytes);

                if (!recvStatus)
                {
                    goto deliveryFailed;
                }

                /* Close the connection with the remote host */
                remoteServer.close();

                JSONValue responseBlock = parseJSON(cast(string) receivedBytes);

                /* TODO: Get ["status"]["code"] code here an act on it */
                if (responseBlock["status"]["code"].integer() == 0)
                {
                    gprintln("Message delivered to user " ~ remoteRecipient);
                }
                else
                {
                    goto deliveryFailed;
                }
            }
            catch (SocketOSException)
            {
                goto deliveryFailed;
            }
            catch (JSONException)
            {
                /* When delivery fails */
            deliveryFailed:
                gprintln("Error delivering to " ~ remoteRecipient);

                /* Append failed recipient to array of failed recipients */
                failedRecipients ~= remoteRecipient;

                continue;
            }
        }

        gprintln("Sent mail message to " ~ remoteRecipients);
    }
}
