module client.mail;

import std.json;
import std.file;

/* TODO: Ref counter garbage collector for mail */

/**
* Mailbox
*
* This represents an in-memory representation of a user's
* mailbox.
*/
public final class Mailbox
{

    /**
    * The owner of this Mailbox
    */
    private string username;

    // public static bool isMailbox(string username)
    // {
    //     return true;
    // }

    public static Mailbox createMailbox(string username)
    {
        Mailbox newMailbox;

        /* TODO: Implement me */

        /* TODO: Create folder for mailbox as `mailboxes/<username>` */

        /* Create the mailbox directory */
        mkdir("mailboxes/"~username); /* TODO: Error handling */

        newMailbox = new Mailbox(username);

        /* TODO: Create the base set of folders */
        newMailbox.addBaseFolder("Inbox");
        newMailbox.addBaseFolder("Drafts");
        newMailbox.addBaseFolder("Outbox");
        newMailbox.addBaseFolder("Sent");
        newMailbox.addBaseFolder("Trash");

        return newMailbox;
    }

    this(string username)
    {
        this.username = username;
    }

    public Folder[] getFolders()
    {
        Folder[] folders;

        /* TODO: Implement me */

        return folders;
    }

    public Folder addBaseFolder(string folderName)
    {
        Folder newFolder;

        /* TODO: Implement folder creation */

        mkdir("mailboxes/"~username~"/"~folderName);

        // newFolder = new Folder(this, null, folderName);

        return newFolder;
    }

    public void storeMessage(Folder folder, Mail message)
    {
        /* TODO: Traverse the folder path */
        string kaka;
        string filename = folder.folderPath~kaka;

        /* TODO: Store the message in file `filename` */
    }

    public void deleteMailbox()
    {
        /* TODO: Run deletion on all folders */
        Folder[] folders = getFolders();

        foreach(Folder folder; folders)
        {
            /* Delete the folder */
            folder.deleteFolder();
        }

        /* TODO: Delete the mailbox directory */
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
    * The path of this folder
    */
    private string folderPath;

    /**
    * The associated Mailbox
    */
    private Mailbox mailbox;

    /**
    * Constructs a new Folder object which represents an
    * existing folder in a user's Mailbox.
    *
    * The Mailbox is specified by `mailbox` and the location
    * of the folder within the mailbox by `folderPath`.
    */
    this(Mailbox mailbox, string folderPath)
    {
        /* Ensure that the folder exists */
        if(!(exists("mailboxes/"~mailbox.username~"/"~folderPath) && isDir("mailboxes/"~mailbox.username~"/"~folderPath)))
        {
            /* TODO: Throw exception */
        }

        this.folderPath = folderPath;
        this.mailbox = mailbox;
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

        /* Get a list of all the directories within this directory */
        foreach(DirEntry directory; dirEntries(folderPath, SpanMode.shallow))
        {
            /* Only append fodlers */
            if(directory.isDir())
            {
                folders ~= new Folder(mailbox, folderPath~"/"~directory.name());
            }
        }
        
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
        Folder newFolder;

        /* TODO: Create here */

        mkdir("mailboxes/"~mailbox.username~"/"~folderPath~"/"~folderName);

        // newFolder = new Folder(mailbox, this, folderName);


        return newFolder;
    }

    private void generateFolderPath()
    {
        /* TODO: Build path gpijg upwards */
        folderPath = "path";
    }

    override public string toString()
    {
        return folderPath;
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

    private string id;

    public static Mail createMail(Mailbox mailbox, JSONValue mailBlock)
    {
        Mail newMail;

        /* TODO: Store to disk in mailstore */
        //mailbox.getIDFor(mailBlock);

        /* TODO: Re think our system */
        return newMail;
    }

    this(string id)
    {
        this.id = id;

        /* TODO: Fetch mail here, or rather in a method */
    }

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