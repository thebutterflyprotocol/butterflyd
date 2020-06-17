butterflyd
==========

[![Build Status](https://travis-ci.org/thebutterflyprotocol/butterflyd.svg?branch=master)](https://travis-ci.org/thebutterflyprotocol/butterflyd)

**Butterfly** is an easy-to-use email protocol replacement. It aims at being easy to extend on the client end by using JSON as the basis for the majority of the protocol.

## Protocol

### Authentication

To connect to a Butterfly server one must first autheticate themselves with the server. The JSON provided and returned for this are shown below:

JSON sent:

```json
{
	"command" : "auth",
	"request" : {
		"username" : "<username>",
		"password" : "<password>"
	}
}
```

JSON received:

```json
{
	"status" : <status>,
	"response" : {
		"token" : "<authenticationToken>"
	}
}
```

All further commands, that require authentication, will require this token.

### Sending mail

To send mail the following TODO

JSON sent:

```json
{
	"command" : "sendMail",
	"request" : {
		"authenticationToken" : "<authenticationToken>",
		"mail" : {
			"recipients" : [],
			"message" : ...
		}
	}
}
```

JSON received:

```json
{
	"status" : <statusCode>
}
```

### Storing a mail message

You might want to simply save a mail message into a folder, perhaps for later editing.

JSON sent:

```json
{
	"command" : "storeMail",
	"request" : {
		"authenticationToken" : "<authenticationToken>",
		"mail" : {
			"recipients" : [],
			"message" : ...
		},
		"folder" : "<folderName>"
	}
}
```

JSON received:

```json
{
	"status" : <statusCode>
}
```

### Transporting mail

This is done by the server to forward mail to recipients not on the local server.

JSON sent:

```json
{
	"command" : "deliverMail",
	"request" : {
		"mail" : {
			"recipients" : [],
			"message" : ...
		}
	}
}
```

JSON received:

```json
{
	"status" : <statusCode>
}
```

### Receiving mail

Receiving a message from the mail box, given the mail ID.

JSON sent:

```json
{
	"command" : "fetchMail",
	"request" : {
		"id" : <mailID>
	}
}
```

JSON received:

```json
{
	"status" : <statusCode>,
	"mail" : {
		"recipients" : [],
		"message" : ...
	}
}
```

### Managing your mailbox

#### Adding a folder

JSON sent:

```json
{
	"command" : "createFolder",
	"request" : {
		"folderName" : "<newFolderName>"
	}
}
```

TODO: received

#### Removing a folder

JSON sent:

```json
{
	"command" : "deleteFolder",
	"request" : {
		"folderName" : "<folderName>"
	}
}
```

TODO: received

#### Adding a mail message to a folder

Binds a message by `"mailID"` to the given folder `"<folderName>"`.

JSON sent:

```json
{
	"command" : "addToFolder",
	"request" : {
		"folderName" : "<folderName>",
		"mailID" : <mailID>
	}
}
```

TODO: received

#### Removing a mail message from a folder

Unbinds a message by `"mailID"` to the given folder `"<folderName>"`.

JSON sent:

```json
{
	"command" : "removeFromFolder",
	"request" : {
		"folderName" : "<folderName>",
		"mailID" : <mailID>
	}
}
```

TODO: received

#### Getting a list of all mailIDs in a folder

Retrieves a list of mail IDs on the given folder `"<folderName>"`.

JSON sent:

```json
{
	"command" : "listFolder",
	"request" : {
		"folderName" : "<folderName>"
	}
}
```

TODO: received

#### Deleting mail

Mail messages just exist but are bound to folders. As soon as it has no references, it gets deleted.

JSON sent:

etc. **TODO**



Later
TODO: Since we going to do push too, we will therefore need to have eventIDs on send to do matching up.