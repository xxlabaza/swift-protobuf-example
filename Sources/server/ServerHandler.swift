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


final class ServerHandler: ChannelInboundHandler {

  typealias InboundIn = ByteBuffer
  typealias OutboundOut = ByteBuffer

  public func channelRead (context: ChannelHandlerContext, data: NIOAny) {
    let inboundBuffer = unwrapInboundIn(data)
    let offset = inboundBuffer.readerIndex
    let length = inboundBuffer.readableBytes
    guard let data = inboundBuffer.getData(at: offset, length: length) else {
      print("error, during reading the request")
      return
    }
    let request = try! RegistrationRequest(serializedData: data)
    print("request: \(request)")

    let response = RegistrationResponse.with {
      $0.isRegistered = true
    }
    print("response: \(response)")
    let binary: Data = try! response.serializedData()
    var outboundBuffer = context.channel.allocator.buffer(capacity: binary.count)
    binary.forEach { byte in
      outboundBuffer.writeInteger(byte as UInt8)
    }
    let outbound = wrapOutboundOut(outboundBuffer)
    context.writeAndFlush(outbound).whenSuccess {
      context.close(promise: nil)
    }
  }
}
