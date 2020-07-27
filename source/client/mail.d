module client.mail;

import std.json;
import std.file;
import std.stdio;
import std.string;

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
    public string username;

    /**
    * Returns `true` if the given mailbox, `username`, exists.
    */
    public static bool isMailbox(string username)
    {
        return exists("mailboxes/"~username) && isDir("mailboxes/"~username);
    }

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

    public void storeMessage(Folder folder, string mailID, JSONValue mailBlock)
    {
        /* Generate the filename to store the message under */
        string filename = "mailboxes/"~username~"/"~folder.folderPath~"/"~mailID;

        /* Save the message to the file system */
        File mailFile;
        mailFile.open(filename, "wb");
        mailFile.rawWrite(cast(byte[])toJSON(mailBlock));
        mailFile.close();
    }

    public void deleteMessage(Folder folder, string mailID)
    {
        /* Generate the filename to store the message under */
        string filename = "mailboxes/"~username~"/"~folder.folderPath~"/"~mailID;

		/* Delete the mail message */
		remove(filename);
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

        /* Get a list of all the files within this directory */
        foreach(DirEntry dirEntry; dirEntries("mailboxes/"~mailbox.username~"/"~folderPath, SpanMode.shallow))
        {
            /* Only append files */
            if(dirEntry.isFile())
            {
                string[] paths = split(dirEntry.name(), "/");
                string mailID = paths[paths.length-1];
                messages ~= new Mail(mailbox, this, mailID);
            }
        }

        writeln("fhjdf");
        return messages;
    }

    /**
    * Get the folders within this folder
    */
    public Folder[] getFolders()
    {
        Folder[] folders;

        /* Get a list of all the directories within this directory */
        foreach(DirEntry dirEntry; dirEntries("mailboxes/"~mailbox.username~"/"~folderPath, SpanMode.shallow))
        {
            /* Only append folders */
            if(dirEntry.isDir())
            {
                folders ~= new Folder(mailbox, folderPath~"/"~dirEntry.name());
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
    public Folder createFolder(string folderName)
    {
        Folder newFolder;

        /* TODO: Create here */

        mkdir("mailboxes/"~mailbox.username~"/"~folderPath~"/"~folderName);

        // newFolder = new Folder(mailbox, this, folderName);


        return newFolder;
    }

    override public string toString()
    {
        string[] paths = split(folderPath, "/");
        string folderName = paths[paths.length-1];
        return "\""~folderName~"\"";
    }
}

/**
* Mail
*
* This represents an in-memory representation of a mail message.
*/
public final class Mail
{

    /**
    * The associated Mailbox
    */
    private Mailbox mailbox;

    /**
    * The associated Folder
    */
    private Folder folder;

    /**
    * The mail message's name
    */
    private string mailID;

    public static Mail createMail(Mailbox mailbox, Folder folder, JSONValue mailBlock)
    {
        Mail newMail;

        /* Generate a unique mailID of this message */
        string mailID = getNameForMail(mailBlock);

        /* Save the mail into the mailbox */
        mailbox.storeMessage(folder, mailID, mailBlock);

        /* fetch the mail object */
        newMail = new Mail(mailbox, folder, mailID);

        /* TODO: Re think our system */
        return newMail;
    }

    /**
    * Returns a name unique to this message
    */
    private static string getNameForMail(JSONValue mailBlock)
    {
        import std.digest.md;
        MD5Digest digester = new MD5Digest();
        
        ubyte[] hash = digester.digest(cast(ubyte[])toJSON(mailBlock));


        /* TODO: Hash message here and return hex of hash */
        return toHexString(hash);
    }

    this(Mailbox mailbox, Folder folder, string mailID)
    {
        this.mailbox = mailbox;
        this.folder = folder;
        this.mailID = mailID;
    }

    private void deleteMessage()
    {
        /* Get the file system path to this message */
        string messageFilePath = mailbox.username~"/"~folder.folderPath~"/"~mailID;

        remove(messageFilePath);
    }

    private void sanityCheck()
    {
        /* TODO: Throw error if the message is somehow malformed */
    }


    

    public JSONValue getMessage()
    {
        JSONValue messageBlock;

        /* Get the file system path to this message */
        string messageFilePath = "mailboxes/"~mailbox.username~"/"~folder.folderPath~"/"~mailID;

        /* TODO: Implement me */
        File file;
        file.open(messageFilePath);

        byte[] fileBytes;
        fileBytes.length = file.size();
        fileBytes = file.rawRead(fileBytes);
        file.close();
        
        messageBlock = parseJSON(cast(string)fileBytes);

        
        
        return messageBlock;
    }

    override public string toString()
    {
        return "\""~mailID~"\"";
    }

    public string getMailID()
    {
        return mailID;
    }
}
