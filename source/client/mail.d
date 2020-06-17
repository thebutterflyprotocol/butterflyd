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

    private Folder[] getFolders()
    {
        Folder[] folders;

        /* TODO: Implement me */

        return folders;
    }

    public Mail getMail()
    {
        Mail mail;

        /* TODO: Implement me */

        return mail;
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
    * The folders within this folder
    */


    this(Folder parentFolder, string folderName)
    {
        this.parentFolder = parentFolder;
        this.folderName = folderName;
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