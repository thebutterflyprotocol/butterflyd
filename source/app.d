import std.stdio;

import server.server : ButterflyServer;
import std.socket : Address, parseAddress;

void main()
{
	writeln("Starting butterflyd...");

	/* Start the server */
	Address address = parseAddress("0.0.0.0", 6969);
	ButterflyServer server = new ButterflyServer(address);
}
