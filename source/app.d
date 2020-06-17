import std.stdio;

import server.server : ButterflyServer;
import std.socket : Address, parseAddress;

void main()
{
	writeln("Edit source/app.d to start your project.");

	Address address;

	address = parseAddress("0.0.0.0", 2223);


	ButterflyServer server = new ButterflyServer(address);
}
