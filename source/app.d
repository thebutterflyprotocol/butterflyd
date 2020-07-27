import std.stdio;

import server.server : ButterflyServer;
import std.socket : Address, parseAddress;
import std.file;
import std.json : JSONValue, parseJSON;
import std.conv : to;
import server.listener : ButterflyListener;
import server.listeners;

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

	/* Construct the listeners form the config file */
	ButterflyListener[] listeners = constructListeners(config["listeners"]);

	/* Start the server */
	Address address = parseAddress(config["address"].str(), to!(ushort)(config["port"].str()));
	ButterflyServer server = new ButterflyServer(listeners, config["domain"].str());
}

private ButterflyListener[] constructListeners(JSONValue listenersBlock)
{
	ButterflyListener[] listeners;
	
	string[] enabledListeners;
	foreach(JSONValue listenerType; listenersBlock["enabled"].array())
	{
		enabledListeners ~= listenerType.str();
	}

	foreach(string listener; enabledListeners)
	{
		writeln("Constructing listener \"" ~ listener ~ "\" ...");

		

		writeln("Listener \"" ~ listener ~ "\"constructed");
	}

	return listeners;
}
