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

import handlers
import model
import NIO


final class ClientHandler: ChannelInboundHandler {

  typealias InboundIn = AnyWrapper
  typealias OutboundOut = AnyWrapper

  public func channelActive (context: ChannelHandlerContext) {
    let request = RegistrationRequest.with {
      $0.application = "popa"
      $0.deviceIdentifier = "0000"
    }
    print("request: \(request)")
    let anyOut = try! AnyWrapper(message: request)
    let outbound = wrapOutboundOut(anyOut)
    context.writeAndFlush(outbound, promise: nil)
  }

  public func channelRead (context: ChannelHandlerContext, data: NIOAny) {
    let anyIn = unwrapInboundIn(data)
    if anyIn.isA(RegistrationResponse.self) == false {
      print("error")
      return
    }

    let response = try! RegistrationResponse(unpackingAny: anyIn)
    context.close(promise: nil)
    print("response: \(response)")
  }
}
