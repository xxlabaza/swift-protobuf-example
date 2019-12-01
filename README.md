# Swift Protobuf example

Swift NIO + Protobuf example

## Compile protobuf

The sub-module `model` contains **proto** directory, which contains `*.proto`-files, just run `proto_compile.sh` (at project's root directory) shell script to compile all of them.

## Usage

To start the server:

```bash
$> swift run server
server started at port 8899

```

To start the client:

```bash
$> swift run client
...
```

After those two actions, you see sending a message from the `client` to the `server` and receiving the response.
