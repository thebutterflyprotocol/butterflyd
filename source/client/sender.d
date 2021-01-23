module client.sender;

import core.thread;

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
    * Constructs a new MailSender with the given
    * email to be delivered (remotely)
    */
}