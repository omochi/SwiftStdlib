// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 1)
//===--- Mirrors.swift.gyb - Common _Mirror implementations ---*- swift -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 37)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Float : CustomReflectable {
  /// A mirror that reflects the `Float` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Float : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Float` instance.
  @available(*, deprecated, message: "Float.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .float(self)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Double : CustomReflectable {
  /// A mirror that reflects the `Double` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Double : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Double` instance.
  @available(*, deprecated, message: "Double.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .double(self)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Bool : CustomReflectable {
  /// A mirror that reflects the `Bool` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Bool : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Bool` instance.
  @available(*, deprecated, message: "Bool.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .bool(self)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension String : CustomReflectable {
  /// A mirror that reflects the `String` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension String : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `String` instance.
  @available(*, deprecated, message: "String.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .text(self)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Character : CustomReflectable {
  /// A mirror that reflects the `Character` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Character : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Character` instance.
  @available(*, deprecated, message: "Character.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .text(String(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Unicode.Scalar : CustomReflectable {
  /// A mirror that reflects the `Unicode.Scalar` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Unicode.Scalar : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Unicode.Scalar` instance.
  @available(*, deprecated, message: "Unicode.Scalar.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension UInt8 : CustomReflectable {
  /// A mirror that reflects the `UInt8` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension UInt8 : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `UInt8` instance.
  @available(*, deprecated, message: "UInt8.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Int8 : CustomReflectable {
  /// A mirror that reflects the `Int8` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Int8 : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Int8` instance.
  @available(*, deprecated, message: "Int8.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension UInt16 : CustomReflectable {
  /// A mirror that reflects the `UInt16` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension UInt16 : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `UInt16` instance.
  @available(*, deprecated, message: "UInt16.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Int16 : CustomReflectable {
  /// A mirror that reflects the `Int16` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Int16 : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Int16` instance.
  @available(*, deprecated, message: "Int16.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension UInt32 : CustomReflectable {
  /// A mirror that reflects the `UInt32` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension UInt32 : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `UInt32` instance.
  @available(*, deprecated, message: "UInt32.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Int32 : CustomReflectable {
  /// A mirror that reflects the `Int32` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Int32 : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Int32` instance.
  @available(*, deprecated, message: "Int32.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension UInt64 : CustomReflectable {
  /// A mirror that reflects the `UInt64` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension UInt64 : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `UInt64` instance.
  @available(*, deprecated, message: "UInt64.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Int64 : CustomReflectable {
  /// A mirror that reflects the `Int64` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Int64 : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Int64` instance.
  @available(*, deprecated, message: "Int64.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension UInt : CustomReflectable {
  /// A mirror that reflects the `UInt` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension UInt : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `UInt` instance.
  @available(*, deprecated, message: "UInt.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 39)

extension Int : CustomReflectable {
  /// A mirror that reflects the `Int` instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}

extension Int : _CustomPlaygroundQuickLookable {
  /// A custom playground Quick Look for the `Int` instance.
  @available(*, deprecated, message: "Int.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/Mirrors.swift.gyb", line: 55)

#if !os(Windows) && (arch(i386) || arch(x86_64))
extension Float80 : CustomReflectable {
  /// A mirror that reflects the Float80 instance.
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
#endif

// Local Variables:
// eval: (read-only-mode 1)
// End:
