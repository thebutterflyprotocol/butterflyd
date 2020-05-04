module butterflyd.app;

import std.stdio;
import butterflyd.handler.handler : ButterflyHandler;

void main(string[] args)
{
	/* Make sure we have atleast 2 arguments */
	if(args.length >= 2)
	{
		/* Firstly construct a handler */
		string tempSocketPath = "/home/deavmi/Documents/Projects/bester/besterd/aSock";
		ButterflyHandler handler = new ButterflyHandler(tempSocketPath);
		handler.dispatch();
	}
	else
	{
		writeln("Missing server configuration argument");
	}
}
