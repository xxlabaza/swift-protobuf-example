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
import struct Foundation.Data


public final class AnyWrapperDecoder: ChannelInboundHandler {

  public typealias InboundIn = Data
  public typealias InboundOut = AnyWrapper

  public init () {
  }

  public func channelRead (context: ChannelHandlerContext, data: NIOAny) {
    let binary: Data = unwrapInboundIn(data)
    let request: AnyWrapper
    do {
      request = try AnyWrapper(serializedData: binary)
    } catch {
      let exception = HandlerErrors.failedToDecodeAnyWrapper(cause: error)
      context.fireErrorCaught(exception)
      return
    }
    let out = wrapInboundOut(request)
    context.fireChannelRead(out)
  }
}
