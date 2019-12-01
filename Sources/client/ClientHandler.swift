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

import model
import NIO
import NIOFoundationCompat
import struct Foundation.Data


final class ClientHandler: ChannelInboundHandler {

  typealias InboundIn = ByteBuffer
  typealias OutboundOut = ByteBuffer

  public func channelActive (context: ChannelHandlerContext) {
    let request = RegistrationRequest.with {
      $0.application = "popa"
      $0.deviceIdentifier = "0000"
    }
    print("request: \(request)")
    let binary: Data = try! request.serializedData()
    var buffer = context.channel.allocator.buffer(capacity: binary.count)
    binary.forEach { byte in
      buffer.writeInteger(byte as UInt8)
    }
    let outbound = wrapOutboundOut(buffer)
    context.writeAndFlush(outbound, promise: nil)
  }

  public func channelRead (context: ChannelHandlerContext, data: NIOAny) {
    let buffer = unwrapInboundIn(data)
    guard let data = buffer.getData(at: buffer.readerIndex, length: buffer.readableBytes) else {
      print("error, during reading the response")
      return
    }
    let response = try! RegistrationResponse(serializedData: data)
    context.close(promise: nil)
    print("response: \(response)")
  }
}
