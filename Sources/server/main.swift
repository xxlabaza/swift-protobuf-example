/*
 * Copyright 2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import NIO


let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
defer {
  try! group.syncShutdownGracefully()
}

let bootstrap = ServerBootstrap(group: group)
  .serverChannelOption(ChannelOptions.backlog, value: 256)
  .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
  .childChannelInitializer { channel in
    channel.pipeline.addHandler(BackPressureHandler()).flatMap { v in
      channel.pipeline.addHandler(ServerHandler())
    }
  }
  .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
  .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
  .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

let port = 8899
let channel = try! bootstrap.bind(host: "0.0.0.0", port: port).wait()
print("server started at port \(port)\n")

try channel.closeFuture.wait()
