module butterflyd.exceptions;

public class ButterflyException : Exception
{
    this(string message)
    {
        super(message);
    }
}