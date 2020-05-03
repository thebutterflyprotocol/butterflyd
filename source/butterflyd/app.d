module butterflyd.app;

import std.stdio;
import butterflyd.handler : ButterflyHandler;

void main(string[] args)
{
	/* Make sure we have atleast 2 arguments */
	if(args.length >= 2)
	{
		/* Firstly construct a handler */
		string tempSocketPath = "~/sock";
		ButterflyHandler handler = new ButterflyHandler(tempSocketPath);
	}
	else
	{
		writeln("Missing server configuraiton argument");
	}
}
