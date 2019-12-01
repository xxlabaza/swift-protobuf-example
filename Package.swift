// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

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

import PackageDescription

let package = Package(
  name: "protobuf_example",

  products: [
    .executable(name: "server", targets: ["server"]),
    .executable(name: "client", targets: ["client"]),
    .library(name: "model", targets: ["model"]),
  ],

  dependencies: [
    .package(url: "https://github.com/apple/swift-nio.git", .exact("2.10.1")),
    .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.7.0"),
  ],

  targets: [
    .target(name: "model", dependencies: [
      "SwiftProtobuf",
    ]),
    .target(name: "server", dependencies: [
      "model",
      "NIO",
      "NIOFoundationCompat",
    ]),
    .target(name: "client", dependencies: [
      "model",
      "NIO",
      "NIOFoundationCompat",
    ]),
  ]
)
