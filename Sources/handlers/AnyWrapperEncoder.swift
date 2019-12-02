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


public final class AnyWrapperEncoder: ChannelOutboundHandler {

  public typealias OutboundIn = AnyWrapper
  public typealias OutboundOut = Data

  public init () {
  }

  public func write (context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
    let response: AnyWrapper = unwrapOutboundIn(data)
    let binary: Data
    do {
      binary = try response.serializedData()
    } catch {
      let exception = HandlerErrors.failedToEncodeAnyWrapper(cause: error)
      context.fireErrorCaught(exception)
      return
    }
    let outbound = wrapOutboundOut(binary)
    context.write(outbound, promise: nil)
  }
}
