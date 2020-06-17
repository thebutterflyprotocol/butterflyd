import std.stdio;

import server.server : ButterflyServer;
import std.socket : Address, parseAddress;

void main()
{
	writeln("Starting butterflyd...");

	/* Start the server */
	Address address = parseAddress("0.0.0.0", 2223);
	ButterflyServer server = new ButterflyServer(address);
}
