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
import NIOFoundationCompat
import struct Foundation.Data


public final class DataDecoder: ChannelInboundHandler {

  public typealias InboundIn = ByteBuffer
  public typealias InboundOut = Data

  public init () {
  }

  public func channelRead (context: ChannelHandlerContext, data: NIOAny) {
    let buffer = unwrapInboundIn(data)
    let offset = buffer.readerIndex
    let length = buffer.readableBytes
    guard let binary = buffer.getData(at: offset, length: length) else {
      let error = HandlerErrors.failedToDecodeData
      context.fireErrorCaught(error)
      return
    }
    let out = wrapInboundOut(binary)
    context.fireChannelRead(out)
  }

  public func channelReadComplete (context: ChannelHandlerContext) {
    context.flush()
  }
}
