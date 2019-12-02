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

import struct SwiftProtobuf.Google_Protobuf_Any
import protocol SwiftProtobuf.Message
import protocol SwiftProtobuf.ExtensionMap
import struct SwiftProtobuf.BinaryDecodingOptions
import struct Foundation.Data


public struct AnyWrapper {

  fileprivate let anyObject: Google_Protobuf_Any

  public init (
    message: Message,
    partial: Bool = false
  ) throws {
    anyObject = try Google_Protobuf_Any(
      message: message,
      partial: partial
    )
  }

  public init (
    serializedData data: Data,
    extensions: ExtensionMap? = nil,
    partial: Bool = false,
    options: BinaryDecodingOptions = BinaryDecodingOptions()
  ) throws {
    anyObject = try Google_Protobuf_Any(
      serializedData: data,
      extensions: extensions,
      partial: partial,
      options: options
    )
  }

  public func serializedData (partial: Bool = false) throws -> Data {
    return try anyObject.serializedData(partial: partial)
  }

  public func isA<M: Message>(_ type: M.Type) -> Bool {
    return anyObject.isA(type)
  }
}

extension Message {

  public init(
    unpackingAny: AnyWrapper,
    extensions: ExtensionMap? = nil,
    options: BinaryDecodingOptions = BinaryDecodingOptions()
  ) throws {
    try self.init(
      unpackingAny: unpackingAny.anyObject,
      extensions: extensions,
      options: options
    )
  }
}
