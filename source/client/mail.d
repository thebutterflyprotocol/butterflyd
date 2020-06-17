module client.mail;

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
    private Mail[] getMessages()
    {
        Mail[] messages;

        /* TODO: Implement me */

        return messages;
    }

    /**
    * Get the folders within this folder
    */
    private Folder[] getFolders()
    {
        Folder[] folders;

        /* TODO: Implement me */

        return folders;
    }
}

/**
* Mail
*
* This represents an in-memory representation of a mail message.
*/
public final class Mail
{

}