module client.exceptions;

/* TODO: Add error message */
public class ButterflyException : Exception
{

    public long status;

    this(long status)
    {
        super("");
        this.status = status;
    }
}