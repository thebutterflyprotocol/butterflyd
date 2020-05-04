module butterflyd.data.message;

import std.json : JSONValue;

public final class MailMessage
{

    private string[] destinations;
    private string source;
    private string subject;
    private string[] attachments;
    private string body;

    this(JSONValue message)
    {
        createMessage(message);
    }

    private void createMessage(JSONValue message)
    {
        /* Get destination */
        JSONValue[] jsonDestinations = message["destination"].array();
        for(ulong i = 0; i < jsonDestinations.length; i++)
        {
            destinations ~= jsonDestinations[i].str();
        }

        /* Get source */
        source = message["source"].str();

        /* Get the subject field */
        subject = message["subject"].str();

        /* Get the attachements */
        JSONValue[] jsonAttachments = message["attachments"].array();
        for(ulong i = 0; i < jsonAttachments.length; i++)
        {
            attachments ~= jsonAttachments[i].str();
        }
        
        /* Get the body */
        body = message["body"].str();
    }
}