module butterflyd.app;

import std.stdio;
import butterflyd.handler : ButterflyHandler;

void main()
{
	/* Firstly construct a handler */
	string tempSocketPath = "~/sock";
	ButterflyHandler handler = new ButterflyHandler(tempSocketPath);
}
