import std.stdio;

import server.server : ButterflyServer;
import std.socket : Address, parseAddress;
import std.file;
import std.json : JSONValue, parseJSON;
import std.conv : to;

void main()
{
	writeln("Starting butterflyd...");

	JSONValue config;

	File configFile;
	configFile.open("butterflyd.json", "rb");
	byte[] bytes;
	bytes.length = configFile.size();
	bytes = configFile.rawRead(bytes);
	configFile.close();

	config = parseJSON(cast(string)bytes);

	/* Start the server */
	Address address = parseAddress(config["address"].str(), cast(ushort)config["port"].uinteger());
	ButterflyServer server = new ButterflyServer(address, config["domain"].str());
}
