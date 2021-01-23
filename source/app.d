import std.stdio;

import server.server : ButterflyServer;
import std.socket : Address, parseAddress;
import std.file;
import std.json : JSONValue, parseJSON;
import std.conv : to;
import server.listener : ButterflyListener;
import server.listeners;
import std.string : cmp;
import gogga;

void main()
{
	gprintln("Starting butterflyd...");

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

	/* Create the server */
	ButterflyServer server = new ButterflyServer(listeners);

	/* Start the server */
	server.run();
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
		gprintln("Constructing listener \"" ~ listener ~ "\" ...");

		if(cmp(listenersBlock[listener]["type"].str(), "ipv4") == 0)
		{
			listeners ~= new IPv4Listener(listener, listenersBlock[listener]);
		}
		else if(cmp(listenersBlock[listener]["type"].str(), "ipv6") == 0)
		{
			listeners ~= new IPv6Listener(listener, listenersBlock[listener]);
		}

		gprintln("Listener \"" ~ listener ~ "\" constructed");
	}

	return listeners;
}
