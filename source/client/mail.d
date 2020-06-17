module client.mail;

import std.json;

/* TODO: Ref counter garbage collector for mail */

/**
* Mailbox
*
* This represents an in-memory representation of a user's
* mailbox.
*/
public final class Mailbox
{

    public static Mailbox createMailbox(string username)
    {
        /* TODO: Implement me */
        return new Mailbox("");
    }

    this(string username)
    {
        /* TODO: Implement fetching of mailbox-by-username here */
    }

    public Folder[] getFolders()
    {
        Folder[] folders;

        /* TODO: Implement me */

        return folders;
    }

    public Folder addBaseFolder(string folderName)
    {
        return null;
    }

    public void storeMessage(Folder folder, Mail message)
    {

    }

    public void deleteMail()
    {

    }
}

/**
* Folder
*
* This represents an in-memory representation of a folder
* that resides in another folder or mailbox.
*/
public final class Folder
{
    /**
    * The parent folder of this folder
    */
    private Folder parentFolder;

    /**
    * The name of this folder
    */
    private string folderName;

    /**
    * The associated Mailbox
    */
    private Mailbox mailbox;

    this(Mailbox mailbox, Folder parentFolder, string folderName)
    {
        this.parentFolder = parentFolder;
        this.folderName = folderName;
        this.mailbox = mailbox;

        /* TODO: Add parent discovery and shit */
    }

    /**
    * Get the mail inside this folder
    */
    public Mail[] getMessages()
    {
        Mail[] messages;

        /* TODO: Implement me */

        return messages;
    }

    /**
    * Get the folders within this folder
    */
    public Folder[] getFolders()
    {
        Folder[] folders;

        /* TODO: Implement me */

        return folders;
    }

    /**
    * Delete this folder
    *
    * This deletes all the sub-folders and the mail
    * within each.
    */
    public void deleteFolder()
    {
        /* TODO: Implement me */
    }

    /**
    * Create a new Folder
    */
    public Folder createChildFolder(string folderName)
    {
        return null;
    }


}

/**
* Mail
*
* This represents an in-memory representation of a mail message.
*/
public final class Mail
{

    private JSONValue messageBlock;

    /* TODO (think about): Before id of mail (for creating) and also for existing */
    private string[] recipients;

    this(JSONValue mailBlock)
    {
        /* TODO: */
        this.messageBlock = mailBlock["message"];

        /* Populate the array of recipients */
        JSONValue[] recipientArray = mailBlock["recipients"].array();
        foreach(JSONValue recipient; recipientArray)
        {
            recipients ~= recipient.str();
        }

        /* Perform a sanity check on the mail message */
        sanityCheck();
    }

    private void sanityCheck()
    {
        /* TODO: Throw error if the message is somehow malformed */
    }

    public string[] getRecipients()
    {
        return recipients;
    }


    public JSONValue getMessage()
    {
        return messageBlock;
    }
}