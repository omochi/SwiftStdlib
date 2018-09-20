// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1)
//===--- ExistentialCollection.swift.gyb ----------------------*- swift -*-===//
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

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 21)

// TODO: swift-3-indexing-model: perform type erasure on the associated
// `Indices` type.

import SwiftShims

@inline(never)
@usableFromInline
internal func _abstract(
  file: StaticString = #file,
  line: UInt = #line
) -> Never {
  fatalError("Method must be overridden", file: file, line: line)
}

//===--- Iterator ---------------------------------------------------------===//
//===----------------------------------------------------------------------===//

/// A type-erased iterator of `Element`.
///
/// This iterator forwards its `next()` method to an arbitrary underlying
/// iterator having the same `Element` type, hiding the specifics of the
/// underlying `IteratorProtocol`.
@_fixed_layout
public struct AnyIterator<Element> {
  @usableFromInline
  internal let _box: _AnyIteratorBoxBase<Element>

  /// Creates an iterator that wraps a base iterator but whose type depends
  /// only on the base iterator's element type.
  ///
  /// You can use `AnyIterator` to hide the type signature of a more complex
  /// iterator. For example, the `digits()` function in the following example
  /// creates an iterator over a collection that lazily maps the elements of a
  /// `Range<Int>` instance to strings. Instead of returning an
  /// iterator with a type that encapsulates the implementation of the
  /// collection, the `digits()` function first wraps the iterator in an
  /// `AnyIterator` instance.
  ///
  ///     func digits() -> AnyIterator<String> {
  ///         let lazyStrings = (0..<10).lazy.map { String($0) }
  ///         let iterator:
  ///             LazyMapIterator<IndexingIterator<Range<Int>>, String>
  ///             = lazyStrings.makeIterator()
  ///
  ///         return AnyIterator(iterator)
  ///     }
  ///
  /// - Parameter base: An iterator to type-erase.
  @inlinable
  public init<I : IteratorProtocol>(_ base: I) where I.Element == Element {
    self._box = _IteratorBox(base)
  }

  /// Creates an iterator that wraps the given closure in its `next()` method.
  ///
  /// The following example creates an iterator that counts up from the initial
  /// value of an integer `x` to 15:
  ///
  ///     var x = 7
  ///     let iterator: AnyIterator<Int> = AnyIterator {
  ///         defer { x += 1 }
  ///         return x < 15 ? x : nil
  ///     }
  ///     let a = Array(iterator)
  ///     // a == [7, 8, 9, 10, 11, 12, 13, 14]
  ///
  /// - Parameter body: A closure that returns an optional element. `body` is
  ///   executed each time the `next()` method is called on the resulting
  ///   iterator.
  @inlinable
  public init(_ body: @escaping () -> Element?) {
    self._box = _IteratorBox(_ClosureBasedIterator(body))
  }

  @inlinable
  internal init(_box: _AnyIteratorBoxBase<Element>) {
    self._box = _box
  }
}

extension AnyIterator: IteratorProtocol {
  /// Advances to the next element and returns it, or `nil` if no next element
  /// exists.
  ///
  /// Once `nil` has been returned, all subsequent calls return `nil`.
  @inlinable
  public func next() -> Element? {
    return _box.next()
  }
}

/// Every `IteratorProtocol` can also be a `Sequence`.  Note that
/// traversing the sequence consumes the iterator.
extension AnyIterator: Sequence { }

@usableFromInline
@_fixed_layout
internal struct _ClosureBasedIterator<Element> : IteratorProtocol {
  @inlinable
  internal init(_ body: @escaping () -> Element?) {
    self._body = body
  }
  @inlinable
  internal func next() -> Element? { return _body() }
  @usableFromInline
  internal let _body: () -> Element?
}

@_fixed_layout
@usableFromInline
internal class _AnyIteratorBoxBase<Element> : IteratorProtocol {
  @inlinable // FIXME(sil-serialize-all)
  internal init() {}

  @inlinable // FIXME(sil-serialize-all)
  deinit {}
  /// Advances to the next element and returns it, or `nil` if no next element
  /// exists.
  ///
  /// Once `nil` has been returned, all subsequent calls return `nil`.
  ///
  /// - Note: Subclasses must override this method.
  @inlinable // FIXME(sil-serialize-all)
  internal func next() -> Element? { _abstract() }
}

@_fixed_layout
@usableFromInline
internal final class _IteratorBox<
  Base : IteratorProtocol
> : _AnyIteratorBoxBase<Base.Element> {
  @inlinable
  internal init(_ base: Base) { self._base = base }
  @inlinable // FIXME(sil-serialize-all)
  deinit {}
  @inlinable
  internal override func next() -> Base.Element? { return _base.next() }
  @usableFromInline
  internal var _base: Base
}

//===--- Sequence ---------------------------------------------------------===//
//===----------------------------------------------------------------------===//

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 167)

@_fixed_layout
@usableFromInline
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 171)
internal class _AnySequenceBox<Element>
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 183)
{

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 186)
  @inlinable // FIXME(sil-serialize-all)
  internal init() { }

  @inlinable
  internal func _makeIterator() -> AnyIterator<Element> { _abstract() }

  @inlinable
  internal var _underestimatedCount: Int { _abstract() }

  @inlinable
  internal func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    _abstract()
  }

  @inlinable
  internal func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    _abstract()
  }

  @inlinable
  internal func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    _abstract()
  }

  @inlinable
  internal func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    _abstract()
  }

  @inlinable
  internal func __preprocessingPass<R>(
    _ preprocess: () throws -> R
  ) rethrows -> R? {
    _abstract()
  }

  @inlinable
  internal func __copyToContiguousArray() -> ContiguousArray<Element> {
    _abstract()
  }

  @inlinable
  internal func __copyContents(initializing buf: UnsafeMutableBufferPointer<Element>)
    -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    _abstract()
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 242)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 244)
  @inlinable // FIXME(sil-serialize-all)
  deinit {}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 248)
  @inlinable
  internal  func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnySequenceBox<Element> {
    _abstract()
  }

  @inlinable
  internal  func _dropFirst(_ n: Int) -> _AnySequenceBox<Element> {
    _abstract()
  }

  @inlinable
  internal  func _dropLast(_ n: Int) -> _AnySequenceBox<Element> {
    _abstract()
  }

  @inlinable
  internal  func _prefix(_ maxLength: Int) -> _AnySequenceBox<Element> {
    _abstract()
  }

  @inlinable
  internal  func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnySequenceBox<Element> {
    _abstract()
  }

  @inlinable
  internal  func _suffix(_ maxLength: Int) -> _AnySequenceBox<Element> {
    _abstract()
  }

  @inlinable
  internal func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnySequence<Element>] {
    _abstract()
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 373)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 382)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 391)
}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 167)

@_fixed_layout
@usableFromInline
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 173)
internal class _AnyCollectionBox<Element> : _AnySequenceBox<Element>
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 183)
{

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 242)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 244)
  @inlinable // FIXME(sil-serialize-all)
  deinit {}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 248)
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnyCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _dropLast(_ n: Int) -> _AnyCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _prefix(_ maxLength: Int) -> _AnyCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _suffix(_ maxLength: Int) -> _AnyCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyCollection<Element>] {
    _abstract()
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 291)
  @inlinable
  internal subscript(i: _AnyIndexBox) -> Element { _abstract() }

  @inlinable
  internal func _index(after i: _AnyIndexBox) -> _AnyIndexBox { _abstract() }

  @inlinable
  internal func _formIndex(after i: _AnyIndexBox) { _abstract() }

  @inlinable
  internal func _index(
    _ i: _AnyIndexBox, offsetBy n: Int
  ) -> _AnyIndexBox {
    _abstract()
  }

  @inlinable
  internal func _index(
    _ i: _AnyIndexBox, offsetBy n: Int, limitedBy limit: _AnyIndexBox
  ) -> _AnyIndexBox? {
    _abstract()
  }

  @inlinable
  internal func _formIndex(_ i: inout _AnyIndexBox, offsetBy n: Int) {
    _abstract()
  }

  @inlinable
  internal func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int, limitedBy limit: _AnyIndexBox
  ) -> Bool {
    _abstract()
  }

  @inlinable
  internal func _distance(
    from start: _AnyIndexBox, to end: _AnyIndexBox
  ) -> Int {
    _abstract()
  }

  // TODO: swift-3-indexing-model: forward the following methods.
  /*
  var _indices: Indices

  func prefix(upTo end: Index) -> SubSequence

  func suffix(from start: Index) -> SubSequence

  func prefix(through position: Index) -> SubSequence

  var isEmpty: Bool { get }
  */

  @inlinable // FIXME(sil-serialize-all)
  internal var _count: Int { _abstract() }

  // TODO: swift-3-indexing-model: forward the following methods.
  /*
  func _customIndexOfEquatableElement(element: Element) -> Index??
  func _customLastIndexOfEquatableElement(element: Element) -> Index??
  */

  @inlinable // FIXME(sil-serialize-all)
  internal var _first: Element? { _abstract() }

  @inlinable
  internal init(
    _startIndex: _AnyIndexBox,
    endIndex: _AnyIndexBox
  ) {
    self._startIndex = _startIndex
    self._endIndex = endIndex
  }

  @usableFromInline
  internal let _startIndex: _AnyIndexBox

  @usableFromInline
  internal let _endIndex: _AnyIndexBox
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 373)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 376)
  @inlinable
  internal  subscript(
    start start: _AnyIndexBox,
    end end: _AnyIndexBox
  ) -> _AnyCollectionBox<Element> { _abstract() }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 382)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 391)
}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 167)

@_fixed_layout
@usableFromInline
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 175)
internal class _AnyBidirectionalCollectionBox<Element>
  : _AnyCollectionBox<Element>
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 183)
{

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 242)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 244)
  @inlinable // FIXME(sil-serialize-all)
  deinit {}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 248)
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _dropLast(_ n: Int) -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _prefix(_ maxLength: Int) -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _suffix(_ maxLength: Int) -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyBidirectionalCollection<Element>] {
    _abstract()
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 373)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 376)
  @inlinable
  internal override subscript(
    start start: _AnyIndexBox,
    end end: _AnyIndexBox
  ) -> _AnyBidirectionalCollectionBox<Element> { _abstract() }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 382)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 384)
  @inlinable
  internal func _index(before i: _AnyIndexBox) -> _AnyIndexBox { _abstract() }
  @inlinable
  internal func _formIndex(before i: _AnyIndexBox) { _abstract() }
  @inlinable
  internal var _last: Element? { _abstract() }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 391)
}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 167)

@_fixed_layout
@usableFromInline
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 178)
internal class _AnyRandomAccessCollectionBox<Element>
  : _AnyBidirectionalCollectionBox<Element>
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 183)
{

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 242)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 244)
  @inlinable // FIXME(sil-serialize-all)
  deinit {}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 248)
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _dropLast(_ n: Int) -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _prefix(_ maxLength: Int) -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal override func _suffix(_ maxLength: Int) -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }

  @inlinable
  internal func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyRandomAccessCollection<Element>] {
    _abstract()
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 373)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 376)
  @inlinable
  internal override subscript(
    start start: _AnyIndexBox,
    end end: _AnyIndexBox
  ) -> _AnyRandomAccessCollectionBox<Element> { _abstract() }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 382)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 391)
}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 394)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 407)



@_fixed_layout
@usableFromInline
internal final class _SequenceBox<S : Sequence> : _AnySequenceBox<S.Element>
{
  @usableFromInline
  internal typealias Element = S.Element

  @inline(__always)
  @inlinable
  internal override func _makeIterator() -> AnyIterator<Element> {
    return AnyIterator(_base.makeIterator())
  }
  @inlinable
  internal override var _underestimatedCount: Int {
    return _base.underestimatedCount
  }
  @inlinable
  internal override func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _base.map(transform)
  }
  @inlinable
  internal override func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _base.filter(isIncluded)
  }
  @inlinable
  internal override func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _base.forEach(body)
  }
  @inlinable
  internal override func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _base._customContainsEquatableElement(element)
  }
  @inlinable
  internal override func __preprocessingPass<R>(
    _ preprocess: () throws -> R
  ) rethrows -> R? {
    return try _base._preprocessingPass(preprocess)
  }
  @inlinable
  internal override func __copyToContiguousArray() -> ContiguousArray<Element> {
    return _base._copyToContiguousArray()
  }
  @inlinable
  internal override func __copyContents(initializing buf: UnsafeMutableBufferPointer<Element>)
    -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _base._copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnySequenceBox<Element> {
    return try _SequenceBox<S.SubSequence>(_base: _base.drop(while: predicate))
  }
  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnySequenceBox<Element> {
    return _SequenceBox<S.SubSequence>(_base: _base.dropFirst(n))
  }
  @inlinable
  internal override func _dropLast(_ n: Int) -> _AnySequenceBox<Element> {
    return _SequenceBox<S.SubSequence>(_base: _base.dropLast(n))
  }
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnySequenceBox<Element> {
    return try _SequenceBox<S.SubSequence>(_base: _base.prefix(while: predicate))
  }
  @inlinable
  internal override func _prefix(_ maxLength: Int) -> _AnySequenceBox<Element> {
    return _SequenceBox<S.SubSequence>(_base: _base.prefix(maxLength))
  }
  @inlinable
  internal override func _suffix(_ maxLength: Int) -> _AnySequenceBox<Element> {
    return _SequenceBox<S.SubSequence>(_base: _base.suffix(maxLength))
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnySequence<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnySequence(_box: _SequenceBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 509)

  @inlinable // FIXME(sil-serialize-all)
  deinit {}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 514)
  @inlinable
  internal init(_base: S) {
    self._base = _base
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 646)
  @usableFromInline
  internal var _base: S
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 407)



@_fixed_layout
@usableFromInline
internal final class _CollectionBox<S : Collection> : _AnyCollectionBox<S.Element>
{
  @usableFromInline
  internal typealias Element = S.Element

  @inline(__always)
  @inlinable
  internal override func _makeIterator() -> AnyIterator<Element> {
    return AnyIterator(_base.makeIterator())
  }
  @inlinable
  internal override var _underestimatedCount: Int {
    return _base.underestimatedCount
  }
  @inlinable
  internal override func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _base.map(transform)
  }
  @inlinable
  internal override func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _base.filter(isIncluded)
  }
  @inlinable
  internal override func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _base.forEach(body)
  }
  @inlinable
  internal override func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _base._customContainsEquatableElement(element)
  }
  @inlinable
  internal override func __preprocessingPass<R>(
    _ preprocess: () throws -> R
  ) rethrows -> R? {
    return try _base._preprocessingPass(preprocess)
  }
  @inlinable
  internal override func __copyToContiguousArray() -> ContiguousArray<Element> {
    return _base._copyToContiguousArray()
  }
  @inlinable
  internal override func __copyContents(initializing buf: UnsafeMutableBufferPointer<Element>)
    -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _base._copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyCollectionBox<Element> {
    return try _CollectionBox<S.SubSequence>(_base: _base.drop(while: predicate))
  }
  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnyCollectionBox<Element> {
    return _CollectionBox<S.SubSequence>(_base: _base.dropFirst(n))
  }
  @inlinable
  internal override func _dropLast(_ n: Int) -> _AnyCollectionBox<Element> {
    return _CollectionBox<S.SubSequence>(_base: _base.dropLast(n))
  }
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyCollectionBox<Element> {
    return try _CollectionBox<S.SubSequence>(_base: _base.prefix(while: predicate))
  }
  @inlinable
  internal override func _prefix(_ maxLength: Int) -> _AnyCollectionBox<Element> {
    return _CollectionBox<S.SubSequence>(_base: _base.prefix(maxLength))
  }
  @inlinable
  internal override func _suffix(_ maxLength: Int) -> _AnyCollectionBox<Element> {
    return _CollectionBox<S.SubSequence>(_base: _base.suffix(maxLength))
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnySequence<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnySequence(_box: _CollectionBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyCollection<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnyCollection(_box: _CollectionBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 509)

  @inlinable // FIXME(sil-serialize-all)
  deinit {}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 519)
  @inlinable
  internal init(_base: S) {
    self._base = _base
    super.init(
      _startIndex: _IndexBox(_base: _base.startIndex),
      endIndex: _IndexBox(_base: _base.endIndex))
  }

  @inlinable
  internal func _unbox(
    _ position: _AnyIndexBox, file: StaticString = #file, line: UInt = #line
  ) -> S.Index {
    if let i = position._unbox() as S.Index? {
      return i
    }
    fatalError("Index type mismatch!", file: file, line: line)
  }

  @inlinable
  internal override subscript(position: _AnyIndexBox) -> Element {
    return _base[_unbox(position)]
  }

  @inlinable
  internal override subscript(start start: _AnyIndexBox, end end: _AnyIndexBox)
    -> _AnyCollectionBox<Element>
  {
    return _CollectionBox<S.SubSequence>(_base:
      _base[_unbox(start)..<_unbox(end)]
    )
  }

  @inlinable
  internal override func _index(after position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(after: _unbox(position)))
  }

  @inlinable
  internal override func _formIndex(after position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(after: &p._base)
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox, offsetBy n: Int
  ) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(_unbox(i), offsetBy: numericCast(n)))
  }

  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox,
    offsetBy n: Int,
    limitedBy limit: _AnyIndexBox
  ) -> _AnyIndexBox? {
    return _base.index(
        _unbox(i),
        offsetBy: numericCast(n),
        limitedBy: _unbox(limit))
      .map { _IndexBox(_base: $0) }
  }

  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int
  ) {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(&box._base, offsetBy: numericCast(n))
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int, limitedBy limit: _AnyIndexBox
  ) -> Bool {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(
        &box._base,
        offsetBy: numericCast(n),
        limitedBy: _unbox(limit))
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override func _distance(
    from start: _AnyIndexBox,
    to end: _AnyIndexBox
  ) -> Int {
    return numericCast(_base.distance(from: _unbox(start), to: _unbox(end)))
  }

  @inlinable
  internal override var _count: Int {
    return numericCast(_base.count)
  }

  @inlinable
  internal override var _first: Element? {
    return _base.first
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 644)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 646)
  @usableFromInline
  internal var _base: S
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 407)



@_fixed_layout
@usableFromInline
internal final class _BidirectionalCollectionBox<S : BidirectionalCollection> : _AnyBidirectionalCollectionBox<S.Element>
{
  @usableFromInline
  internal typealias Element = S.Element

  @inline(__always)
  @inlinable
  internal override func _makeIterator() -> AnyIterator<Element> {
    return AnyIterator(_base.makeIterator())
  }
  @inlinable
  internal override var _underestimatedCount: Int {
    return _base.underestimatedCount
  }
  @inlinable
  internal override func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _base.map(transform)
  }
  @inlinable
  internal override func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _base.filter(isIncluded)
  }
  @inlinable
  internal override func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _base.forEach(body)
  }
  @inlinable
  internal override func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _base._customContainsEquatableElement(element)
  }
  @inlinable
  internal override func __preprocessingPass<R>(
    _ preprocess: () throws -> R
  ) rethrows -> R? {
    return try _base._preprocessingPass(preprocess)
  }
  @inlinable
  internal override func __copyToContiguousArray() -> ContiguousArray<Element> {
    return _base._copyToContiguousArray()
  }
  @inlinable
  internal override func __copyContents(initializing buf: UnsafeMutableBufferPointer<Element>)
    -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _base._copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyBidirectionalCollectionBox<Element> {
    return try _BidirectionalCollectionBox<S.SubSequence>(_base: _base.drop(while: predicate))
  }
  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnyBidirectionalCollectionBox<Element> {
    return _BidirectionalCollectionBox<S.SubSequence>(_base: _base.dropFirst(n))
  }
  @inlinable
  internal override func _dropLast(_ n: Int) -> _AnyBidirectionalCollectionBox<Element> {
    return _BidirectionalCollectionBox<S.SubSequence>(_base: _base.dropLast(n))
  }
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyBidirectionalCollectionBox<Element> {
    return try _BidirectionalCollectionBox<S.SubSequence>(_base: _base.prefix(while: predicate))
  }
  @inlinable
  internal override func _prefix(_ maxLength: Int) -> _AnyBidirectionalCollectionBox<Element> {
    return _BidirectionalCollectionBox<S.SubSequence>(_base: _base.prefix(maxLength))
  }
  @inlinable
  internal override func _suffix(_ maxLength: Int) -> _AnyBidirectionalCollectionBox<Element> {
    return _BidirectionalCollectionBox<S.SubSequence>(_base: _base.suffix(maxLength))
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnySequence<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnySequence(_box: _BidirectionalCollectionBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyCollection<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnyCollection(_box: _BidirectionalCollectionBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyBidirectionalCollection<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnyBidirectionalCollection(_box: _BidirectionalCollectionBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 509)

  @inlinable // FIXME(sil-serialize-all)
  deinit {}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 519)
  @inlinable
  internal init(_base: S) {
    self._base = _base
    super.init(
      _startIndex: _IndexBox(_base: _base.startIndex),
      endIndex: _IndexBox(_base: _base.endIndex))
  }

  @inlinable
  internal func _unbox(
    _ position: _AnyIndexBox, file: StaticString = #file, line: UInt = #line
  ) -> S.Index {
    if let i = position._unbox() as S.Index? {
      return i
    }
    fatalError("Index type mismatch!", file: file, line: line)
  }

  @inlinable
  internal override subscript(position: _AnyIndexBox) -> Element {
    return _base[_unbox(position)]
  }

  @inlinable
  internal override subscript(start start: _AnyIndexBox, end end: _AnyIndexBox)
    -> _AnyBidirectionalCollectionBox<Element>
  {
    return _BidirectionalCollectionBox<S.SubSequence>(_base:
      _base[_unbox(start)..<_unbox(end)]
    )
  }

  @inlinable
  internal override func _index(after position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(after: _unbox(position)))
  }

  @inlinable
  internal override func _formIndex(after position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(after: &p._base)
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox, offsetBy n: Int
  ) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(_unbox(i), offsetBy: numericCast(n)))
  }

  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox,
    offsetBy n: Int,
    limitedBy limit: _AnyIndexBox
  ) -> _AnyIndexBox? {
    return _base.index(
        _unbox(i),
        offsetBy: numericCast(n),
        limitedBy: _unbox(limit))
      .map { _IndexBox(_base: $0) }
  }

  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int
  ) {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(&box._base, offsetBy: numericCast(n))
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int, limitedBy limit: _AnyIndexBox
  ) -> Bool {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(
        &box._base,
        offsetBy: numericCast(n),
        limitedBy: _unbox(limit))
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override func _distance(
    from start: _AnyIndexBox,
    to end: _AnyIndexBox
  ) -> Int {
    return numericCast(_base.distance(from: _unbox(start), to: _unbox(end)))
  }

  @inlinable
  internal override var _count: Int {
    return numericCast(_base.count)
  }

  @inlinable
  internal override var _first: Element? {
    return _base.first
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 626)
  @inlinable
  internal override func _index(before position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(before: _unbox(position)))
  }

  @inlinable
  internal override func _formIndex(before position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(before: &p._base)
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override var _last: Element? {
    return _base.last
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 644)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 646)
  @usableFromInline
  internal var _base: S
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 407)



@_fixed_layout
@usableFromInline
internal final class _RandomAccessCollectionBox<S : RandomAccessCollection> : _AnyRandomAccessCollectionBox<S.Element>
{
  @usableFromInline
  internal typealias Element = S.Element

  @inline(__always)
  @inlinable
  internal override func _makeIterator() -> AnyIterator<Element> {
    return AnyIterator(_base.makeIterator())
  }
  @inlinable
  internal override var _underestimatedCount: Int {
    return _base.underestimatedCount
  }
  @inlinable
  internal override func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _base.map(transform)
  }
  @inlinable
  internal override func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _base.filter(isIncluded)
  }
  @inlinable
  internal override func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _base.forEach(body)
  }
  @inlinable
  internal override func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _base._customContainsEquatableElement(element)
  }
  @inlinable
  internal override func __preprocessingPass<R>(
    _ preprocess: () throws -> R
  ) rethrows -> R? {
    return try _base._preprocessingPass(preprocess)
  }
  @inlinable
  internal override func __copyToContiguousArray() -> ContiguousArray<Element> {
    return _base._copyToContiguousArray()
  }
  @inlinable
  internal override func __copyContents(initializing buf: UnsafeMutableBufferPointer<Element>)
    -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _base._copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyRandomAccessCollectionBox<Element> {
    return try _RandomAccessCollectionBox<S.SubSequence>(_base: _base.drop(while: predicate))
  }
  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnyRandomAccessCollectionBox<Element> {
    return _RandomAccessCollectionBox<S.SubSequence>(_base: _base.dropFirst(n))
  }
  @inlinable
  internal override func _dropLast(_ n: Int) -> _AnyRandomAccessCollectionBox<Element> {
    return _RandomAccessCollectionBox<S.SubSequence>(_base: _base.dropLast(n))
  }
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyRandomAccessCollectionBox<Element> {
    return try _RandomAccessCollectionBox<S.SubSequence>(_base: _base.prefix(while: predicate))
  }
  @inlinable
  internal override func _prefix(_ maxLength: Int) -> _AnyRandomAccessCollectionBox<Element> {
    return _RandomAccessCollectionBox<S.SubSequence>(_base: _base.prefix(maxLength))
  }
  @inlinable
  internal override func _suffix(_ maxLength: Int) -> _AnyRandomAccessCollectionBox<Element> {
    return _RandomAccessCollectionBox<S.SubSequence>(_base: _base.suffix(maxLength))
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnySequence<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnySequence(_box: _RandomAccessCollectionBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyCollection<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnyCollection(_box: _RandomAccessCollectionBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyBidirectionalCollection<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnyBidirectionalCollection(_box: _RandomAccessCollectionBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 495)
  @inlinable
  internal override func _split(
    maxSplits: Int, omittingEmptySubsequences: Bool,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyRandomAccessCollection<Element>] {
    return try _base.split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
      .map {
        AnyRandomAccessCollection(_box: _RandomAccessCollectionBox<S.SubSequence>(_base: $0))
      }
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 509)

  @inlinable // FIXME(sil-serialize-all)
  deinit {}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 519)
  @inlinable
  internal init(_base: S) {
    self._base = _base
    super.init(
      _startIndex: _IndexBox(_base: _base.startIndex),
      endIndex: _IndexBox(_base: _base.endIndex))
  }

  @inlinable
  internal func _unbox(
    _ position: _AnyIndexBox, file: StaticString = #file, line: UInt = #line
  ) -> S.Index {
    if let i = position._unbox() as S.Index? {
      return i
    }
    fatalError("Index type mismatch!", file: file, line: line)
  }

  @inlinable
  internal override subscript(position: _AnyIndexBox) -> Element {
    return _base[_unbox(position)]
  }

  @inlinable
  internal override subscript(start start: _AnyIndexBox, end end: _AnyIndexBox)
    -> _AnyRandomAccessCollectionBox<Element>
  {
    return _RandomAccessCollectionBox<S.SubSequence>(_base:
      _base[_unbox(start)..<_unbox(end)]
    )
  }

  @inlinable
  internal override func _index(after position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(after: _unbox(position)))
  }

  @inlinable
  internal override func _formIndex(after position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(after: &p._base)
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox, offsetBy n: Int
  ) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(_unbox(i), offsetBy: numericCast(n)))
  }

  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox,
    offsetBy n: Int,
    limitedBy limit: _AnyIndexBox
  ) -> _AnyIndexBox? {
    return _base.index(
        _unbox(i),
        offsetBy: numericCast(n),
        limitedBy: _unbox(limit))
      .map { _IndexBox(_base: $0) }
  }

  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int
  ) {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(&box._base, offsetBy: numericCast(n))
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int, limitedBy limit: _AnyIndexBox
  ) -> Bool {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(
        &box._base,
        offsetBy: numericCast(n),
        limitedBy: _unbox(limit))
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override func _distance(
    from start: _AnyIndexBox,
    to end: _AnyIndexBox
  ) -> Int {
    return numericCast(_base.distance(from: _unbox(start), to: _unbox(end)))
  }

  @inlinable
  internal override var _count: Int {
    return numericCast(_base.count)
  }

  @inlinable
  internal override var _first: Element? {
    return _base.first
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 626)
  @inlinable
  internal override func _index(before position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(before: _unbox(position)))
  }

  @inlinable
  internal override func _formIndex(before position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(before: &p._base)
    }
    fatalError("Index type mismatch!")
  }

  @inlinable
  internal override var _last: Element? {
    return _base.last
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 644)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 646)
  @usableFromInline
  internal var _base: S
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 650)

@usableFromInline
@_fixed_layout
internal struct _ClosureBasedSequence<Iterator : IteratorProtocol> {
  @usableFromInline
  internal var _makeUnderlyingIterator: () -> Iterator

  @inlinable
  internal init(_ makeUnderlyingIterator: @escaping () -> Iterator) {
    self._makeUnderlyingIterator = makeUnderlyingIterator
  }
}

extension _ClosureBasedSequence: Sequence {
  @inlinable
  internal func makeIterator() -> Iterator {
    return _makeUnderlyingIterator()
  }
}

/// A type-erased sequence.
///
/// An instance of `AnySequence` forwards its operations to an underlying base
/// sequence having the same `Element` type, hiding the specifics of the
/// underlying sequence.
//@usableFromInline
@_fixed_layout
public struct AnySequence<Element> {
  @usableFromInline
  internal let _box: _AnySequenceBox<Element>
  
  /// Creates a sequence whose `makeIterator()` method forwards to
  /// `makeUnderlyingIterator`.
  @inlinable
  public init<I : IteratorProtocol>(
    _ makeUnderlyingIterator: @escaping () -> I
  ) where I.Element == Element {
    self.init(_ClosureBasedSequence(makeUnderlyingIterator))
  }

  @inlinable
  internal init(_box: _AnySequenceBox<Element>) {
    self._box = _box
  }
}

extension  AnySequence: Sequence {
  public typealias Iterator = AnyIterator<Element>

  /// Creates a new sequence that wraps and forwards operations to `base`.
  @inlinable
  public init<S : Sequence>(_ base: S)
    where
    S.Element == Element {
    self._box = _SequenceBox(_base: base)
  }
}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 709)
extension AnySequence {
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 711)
  /// Returns an iterator over the elements of this sequence.
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 715)
  @inline(__always)
  @inlinable
  public func makeIterator() -> Iterator {
    return _box._makeIterator()
  }

  @inlinable
  public var underestimatedCount: Int {
    return _box._underestimatedCount
  }

  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _box._map(transform)
  }

  @inlinable
  public func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _box._filter(isIncluded)
  }

  @inlinable
  public func forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _box._forEach(body)
  }

  @inlinable
  public func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnySequence<Element> {
    return try AnySequence(_box: _box._drop(while: predicate))
  }

  @inlinable
  public func dropFirst(_ n: Int) -> AnySequence<Element> {
    return AnySequence(_box: _box._dropFirst(n))
  }

  @inlinable
  public func dropLast(_ n: Int) -> AnySequence<Element> {
    return AnySequence(_box: _box._dropLast(n))
  }

  @inlinable
  public func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnySequence<Element> {
    return try AnySequence(_box: _box._prefix(while: predicate))
  }

  @inlinable
  public func prefix(_ maxLength: Int) -> AnySequence<Element> {
    return AnySequence(_box: _box._prefix(maxLength))
  }

  @inlinable
  public func suffix(_ maxLength: Int) -> AnySequence<Element> {
    return AnySequence(_box: _box._suffix(maxLength))
  }

  @inlinable
  public func split(
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnySequence<Element>] {
    return try _box._split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
  }

  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _box.__customContainsEquatableElement(element)
  }

  @inlinable
  public func _preprocessingPass<R>(
    _ preprocess: () throws -> R
  ) rethrows -> R? {
    return try _box.__preprocessingPass(preprocess)
  }

  @inlinable
  public func _copyToContiguousArray() -> ContiguousArray<Element> {
    return self._box.__copyToContiguousArray()
  }

  @inlinable
  public func _copyContents(initializing buf: UnsafeMutableBufferPointer<Element>)
  -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _box.__copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 709)
extension AnyCollection {
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 713)
  /// Returns an iterator over the elements of this collection.
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 715)
  @inline(__always)
  @inlinable
  public func makeIterator() -> Iterator {
    return _box._makeIterator()
  }

  @inlinable
  public var underestimatedCount: Int {
    return _box._underestimatedCount
  }

  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _box._map(transform)
  }

  @inlinable
  public func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _box._filter(isIncluded)
  }

  @inlinable
  public func forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _box._forEach(body)
  }

  @inlinable
  public func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyCollection<Element> {
    return try AnyCollection(_box: _box._drop(while: predicate))
  }

  @inlinable
  public func dropFirst(_ n: Int) -> AnyCollection<Element> {
    return AnyCollection(_box: _box._dropFirst(n))
  }

  @inlinable
  public func dropLast(_ n: Int) -> AnyCollection<Element> {
    return AnyCollection(_box: _box._dropLast(n))
  }

  @inlinable
  public func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyCollection<Element> {
    return try AnyCollection(_box: _box._prefix(while: predicate))
  }

  @inlinable
  public func prefix(_ maxLength: Int) -> AnyCollection<Element> {
    return AnyCollection(_box: _box._prefix(maxLength))
  }

  @inlinable
  public func suffix(_ maxLength: Int) -> AnyCollection<Element> {
    return AnyCollection(_box: _box._suffix(maxLength))
  }

  @inlinable
  public func split(
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyCollection<Element>] {
    return try _box._split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
  }

  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _box.__customContainsEquatableElement(element)
  }

  @inlinable
  public func _preprocessingPass<R>(
    _ preprocess: () throws -> R
  ) rethrows -> R? {
    return try _box.__preprocessingPass(preprocess)
  }

  @inlinable
  public func _copyToContiguousArray() -> ContiguousArray<Element> {
    return self._box.__copyToContiguousArray()
  }

  @inlinable
  public func _copyContents(initializing buf: UnsafeMutableBufferPointer<Element>)
  -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _box.__copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 709)
extension AnyBidirectionalCollection {
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 713)
  /// Returns an iterator over the elements of this collection.
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 715)
  @inline(__always)
  @inlinable
  public func makeIterator() -> Iterator {
    return _box._makeIterator()
  }

  @inlinable
  public var underestimatedCount: Int {
    return _box._underestimatedCount
  }

  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _box._map(transform)
  }

  @inlinable
  public func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _box._filter(isIncluded)
  }

  @inlinable
  public func forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _box._forEach(body)
  }

  @inlinable
  public func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyBidirectionalCollection<Element> {
    return try AnyBidirectionalCollection(_box: _box._drop(while: predicate))
  }

  @inlinable
  public func dropFirst(_ n: Int) -> AnyBidirectionalCollection<Element> {
    return AnyBidirectionalCollection(_box: _box._dropFirst(n))
  }

  @inlinable
  public func dropLast(_ n: Int) -> AnyBidirectionalCollection<Element> {
    return AnyBidirectionalCollection(_box: _box._dropLast(n))
  }

  @inlinable
  public func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyBidirectionalCollection<Element> {
    return try AnyBidirectionalCollection(_box: _box._prefix(while: predicate))
  }

  @inlinable
  public func prefix(_ maxLength: Int) -> AnyBidirectionalCollection<Element> {
    return AnyBidirectionalCollection(_box: _box._prefix(maxLength))
  }

  @inlinable
  public func suffix(_ maxLength: Int) -> AnyBidirectionalCollection<Element> {
    return AnyBidirectionalCollection(_box: _box._suffix(maxLength))
  }

  @inlinable
  public func split(
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyBidirectionalCollection<Element>] {
    return try _box._split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
  }

  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _box.__customContainsEquatableElement(element)
  }

  @inlinable
  public func _preprocessingPass<R>(
    _ preprocess: () throws -> R
  ) rethrows -> R? {
    return try _box.__preprocessingPass(preprocess)
  }

  @inlinable
  public func _copyToContiguousArray() -> ContiguousArray<Element> {
    return self._box.__copyToContiguousArray()
  }

  @inlinable
  public func _copyContents(initializing buf: UnsafeMutableBufferPointer<Element>)
  -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _box.__copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 709)
extension AnyRandomAccessCollection {
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 713)
  /// Returns an iterator over the elements of this collection.
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 715)
  @inline(__always)
  @inlinable
  public func makeIterator() -> Iterator {
    return _box._makeIterator()
  }

  @inlinable
  public var underestimatedCount: Int {
    return _box._underestimatedCount
  }

  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _box._map(transform)
  }

  @inlinable
  public func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _box._filter(isIncluded)
  }

  @inlinable
  public func forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _box._forEach(body)
  }

  @inlinable
  public func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyRandomAccessCollection<Element> {
    return try AnyRandomAccessCollection(_box: _box._drop(while: predicate))
  }

  @inlinable
  public func dropFirst(_ n: Int) -> AnyRandomAccessCollection<Element> {
    return AnyRandomAccessCollection(_box: _box._dropFirst(n))
  }

  @inlinable
  public func dropLast(_ n: Int) -> AnyRandomAccessCollection<Element> {
    return AnyRandomAccessCollection(_box: _box._dropLast(n))
  }

  @inlinable
  public func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyRandomAccessCollection<Element> {
    return try AnyRandomAccessCollection(_box: _box._prefix(while: predicate))
  }

  @inlinable
  public func prefix(_ maxLength: Int) -> AnyRandomAccessCollection<Element> {
    return AnyRandomAccessCollection(_box: _box._prefix(maxLength))
  }

  @inlinable
  public func suffix(_ maxLength: Int) -> AnyRandomAccessCollection<Element> {
    return AnyRandomAccessCollection(_box: _box._suffix(maxLength))
  }

  @inlinable
  public func split(
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [AnyRandomAccessCollection<Element>] {
    return try _box._split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: isSeparator)
  }

  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _box.__customContainsEquatableElement(element)
  }

  @inlinable
  public func _preprocessingPass<R>(
    _ preprocess: () throws -> R
  ) rethrows -> R? {
    return try _box.__preprocessingPass(preprocess)
  }

  @inlinable
  public func _copyToContiguousArray() -> ContiguousArray<Element> {
    return self._box.__copyToContiguousArray()
  }

  @inlinable
  public func _copyContents(initializing buf: UnsafeMutableBufferPointer<Element>)
  -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _box.__copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 820)

//===--- Index ------------------------------------------------------------===//
//===----------------------------------------------------------------------===//

@usableFromInline
internal protocol _AnyIndexBox : class {
  var _typeID: ObjectIdentifier { get }

  func _unbox<T : Comparable>() -> T?

  func _isEqual(to rhs: _AnyIndexBox) -> Bool

  func _isLess(than rhs: _AnyIndexBox) -> Bool
}

@_fixed_layout
@usableFromInline
internal final class _IndexBox<
  BaseIndex : Comparable
> : _AnyIndexBox {
  @usableFromInline
  internal var _base: BaseIndex

  @inlinable
  internal init(_base: BaseIndex) {
    self._base = _base
  }

  @inlinable
  internal func _unsafeUnbox(_ other: _AnyIndexBox) -> BaseIndex {
    return unsafeDowncast(other, to: _IndexBox.self)._base
  }

  @inlinable
  internal var _typeID: ObjectIdentifier {
    return ObjectIdentifier(type(of: self))
  }

  @inlinable
  internal func _unbox<T : Comparable>() -> T? {
    return (self as _AnyIndexBox as? _IndexBox<T>)?._base
  }

  @inlinable
  internal func _isEqual(to rhs: _AnyIndexBox) -> Bool {
    return _base == _unsafeUnbox(rhs)
  }

  @inlinable
  internal func _isLess(than rhs: _AnyIndexBox) -> Bool {
    return _base < _unsafeUnbox(rhs)
  }
}

/// A wrapper over an underlying index that hides the specific underlying type.
@_fixed_layout
public struct AnyIndex {
  @usableFromInline
  internal var _box: _AnyIndexBox

  /// Creates a new index wrapping `base`.
  @inlinable
  public init<BaseIndex : Comparable>(_ base: BaseIndex) {
    self._box = _IndexBox(_base: base)
  }

  @inlinable
  internal init(_box: _AnyIndexBox) {
    self._box = _box
  }

  @inlinable
  internal var _typeID: ObjectIdentifier {
    return _box._typeID
  }
}

extension AnyIndex : Comparable {
  /// Returns a Boolean value indicating whether two indices wrap equal
  /// underlying indices.
  ///
  /// The types of the two underlying indices must be identical.
  ///
  /// - Parameters:
  ///   - lhs: An index to compare.
  ///   - rhs: Another index to compare.
  @inlinable
  public static func == (lhs: AnyIndex, rhs: AnyIndex) -> Bool {
    _precondition(lhs._typeID == rhs._typeID, "Base index types differ")
    return lhs._box._isEqual(to: rhs._box)
  }

  /// Returns a Boolean value indicating whether the first argument represents a
  /// position before the second argument.
  ///
  /// The types of the two underlying indices must be identical.
  ///
  /// - Parameters:
  ///   - lhs: An index to compare.
  ///   - rhs: Another index to compare.
  @inlinable
  public static func < (lhs: AnyIndex, rhs: AnyIndex) -> Bool {
    _precondition(lhs._typeID == rhs._typeID, "Base index types differ")
    return lhs._box._isLess(than: rhs._box)
  }
}

//===--- Collections ------------------------------------------------------===//
//===----------------------------------------------------------------------===//

public // @testable
protocol _AnyCollectionProtocol : Collection {
  /// Identifies the underlying collection stored by `self`. Instances
  /// copied or upgraded/downgraded from one another have the same `_boxID`.
  var _boxID: ObjectIdentifier { get }
}

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 940)
/// A type-erased wrapper over any collection with indices that
/// support forward traversal.
///
/// An `AnyCollection` instance forwards its operations to a base collection having the
/// same `Element` type, hiding the specifics of the underlying
/// collection.
@_fixed_layout
public struct AnyCollection<Element> {
  @usableFromInline
  internal let _box: _AnyCollectionBox<Element>

  @inlinable
  internal init(_box: _AnyCollectionBox<Element>) {
    self._box = _box
  }
}

extension AnyCollection: Collection {
  public typealias Indices = DefaultIndices<AnyCollection>
  public typealias Iterator = AnyIterator<Element>
  public typealias Index = AnyIndex
  public typealias SubSequence = AnyCollection<Element> 

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 965)
  /// Creates a type-erased collection that wraps the given collection.
  ///
  /// - Parameter base: The collection to wrap.
  ///
  /// - Complexity: O(1).
  @inlinable
  public init<C : Collection>(_ base: C) where C.Element == Element {
    // Traversal: Forward
    // SubTraversal: Forward
    self._box = _CollectionBox<C>(
      _base: base)
  }

  /// Creates an `AnyCollection` having the same underlying collection as `other`.
  ///
  /// - Complexity: O(1)
  @inlinable
  public init(_ other: AnyCollection<Element>) {
    self._box = other._box
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 965)
  /// Creates a type-erased collection that wraps the given collection.
  ///
  /// - Parameter base: The collection to wrap.
  ///
  /// - Complexity: O(1).
  @inlinable
  public init<C : BidirectionalCollection>(_ base: C) where C.Element == Element {
    // Traversal: Forward
    // SubTraversal: Bidirectional
    self._box = _BidirectionalCollectionBox<C>(
      _base: base)
  }

  /// Creates an `AnyCollection` having the same underlying collection as `other`.
  ///
  /// - Complexity: O(1)
  @inlinable
  public init(_ other: AnyBidirectionalCollection<Element>) {
    self._box = other._box
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 965)
  /// Creates a type-erased collection that wraps the given collection.
  ///
  /// - Parameter base: The collection to wrap.
  ///
  /// - Complexity: O(1).
  @inlinable
  public init<C : RandomAccessCollection>(_ base: C) where C.Element == Element {
    // Traversal: Forward
    // SubTraversal: RandomAccess
    self._box = _RandomAccessCollectionBox<C>(
      _base: base)
  }

  /// Creates an `AnyCollection` having the same underlying collection as `other`.
  ///
  /// - Complexity: O(1)
  @inlinable
  public init(_ other: AnyRandomAccessCollection<Element>) {
    self._box = other._box
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 986)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1003)

  /// The position of the first element in a non-empty collection.
  ///
  /// In an empty collection, `startIndex == endIndex`.
  @inlinable
  public var startIndex: Index {
    return AnyIndex(_box: _box._startIndex)
  }

  /// The collection's "past the end" position---that is, the position one
  /// greater than the last valid subscript argument.
  ///
  /// `endIndex` is always reachable from `startIndex` by zero or more
  /// applications of `index(after:)`.
  @inlinable
  public var endIndex: Index {
    return AnyIndex(_box: _box._endIndex)
  }

  /// Accesses the element indicated by `position`.
  ///
  /// - Precondition: `position` indicates a valid position in `self` and
  ///   `position != endIndex`.
  @inlinable
  public subscript(position: Index) -> Element {
    return _box[position._box]
  }

  @inlinable
  public subscript(bounds: Range<Index>) -> SubSequence {
    return AnyCollection(_box:
      _box[start: bounds.lowerBound._box, end: bounds.upperBound._box])
  }

  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
    // Do nothing.  Doing a range check would involve unboxing indices,
    // performing dynamic dispatch etc.  This seems to be too costly for a fast
    // range check for QoI purposes.
  }

  @inlinable
  public func _failEarlyRangeCheck(_ range: Range<Index>, bounds: Range<Index>) {
    // Do nothing.  Doing a range check would involve unboxing indices,
    // performing dynamic dispatch etc.  This seems to be too costly for a fast
    // range check for QoI purposes.
  }

  @inlinable
  public func index(after i: Index) -> Index {
    return AnyIndex(_box: _box._index(after: i._box))
  }

  @inlinable
  public func formIndex(after i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(after: i._box)
    }
    else {
      i = index(after: i)
    }
  }

  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    return AnyIndex(_box: _box._index(i._box, offsetBy: n))
  }

  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    return _box._index(i._box, offsetBy: n, limitedBy: limit._box)
      .map { AnyIndex(_box:$0) }
  }

  @inlinable
  public func formIndex(_ i: inout Index, offsetBy n: Int) {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n)
    } else {
      i = index(i, offsetBy: n)
    }
  }

  @inlinable
  public func formIndex(
    _ i: inout Index,
    offsetBy n: Int,
    limitedBy limit: Index
  ) -> Bool {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n, limitedBy: limit._box)
    }
    if let advanced = index(i, offsetBy: n, limitedBy: limit) {
      i = advanced
      return true
    }
    i = limit
    return false
  }

  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return _box._distance(from: start._box, to: end._box)
  }

  /// The number of elements.
  ///
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1113)
  /// To check whether a collection is empty, use its `isEmpty` property
  /// instead of comparing `count` to zero. Calculating `count` can be an O(*n*)
  /// operation.
  ///
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1118)
  /// - Complexity: O(*n*)
  @inlinable
  public var count: Int {
    return _box._count
  }

  @inlinable
  public var first: Element? {
    return _box._first
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1150)
}

extension AnyCollection: _AnyCollectionProtocol {
  /// Uniquely identifies the stored underlying collection.
  @inlinable
  public // Due to language limitations only
  var _boxID: ObjectIdentifier {
    return ObjectIdentifier(_box)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 940)
/// A type-erased wrapper over any collection with indices that
/// support bidirectional traversal.
///
/// An `AnyBidirectionalCollection` instance forwards its operations to a base collection having the
/// same `Element` type, hiding the specifics of the underlying
/// collection.
@_fixed_layout
public struct AnyBidirectionalCollection<Element> {
  @usableFromInline
  internal let _box: _AnyBidirectionalCollectionBox<Element>

  @inlinable
  internal init(_box: _AnyBidirectionalCollectionBox<Element>) {
    self._box = _box
  }
}

extension AnyBidirectionalCollection: BidirectionalCollection {
  public typealias Indices = DefaultIndices<AnyBidirectionalCollection>
  public typealias Iterator = AnyIterator<Element>
  public typealias Index = AnyIndex
  public typealias SubSequence = AnyBidirectionalCollection<Element> 

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 965)
  /// Creates a type-erased collection that wraps the given collection.
  ///
  /// - Parameter base: The collection to wrap.
  ///
  /// - Complexity: O(1).
  @inlinable
  public init<C : BidirectionalCollection>(_ base: C) where C.Element == Element {
    // Traversal: Bidirectional
    // SubTraversal: Bidirectional
    self._box = _BidirectionalCollectionBox<C>(
      _base: base)
  }

  /// Creates an `AnyBidirectionalCollection` having the same underlying collection as `other`.
  ///
  /// - Complexity: O(1)
  @inlinable
  public init(_ other: AnyBidirectionalCollection<Element>) {
    self._box = other._box
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 965)
  /// Creates a type-erased collection that wraps the given collection.
  ///
  /// - Parameter base: The collection to wrap.
  ///
  /// - Complexity: O(1).
  @inlinable
  public init<C : RandomAccessCollection>(_ base: C) where C.Element == Element {
    // Traversal: Bidirectional
    // SubTraversal: RandomAccess
    self._box = _RandomAccessCollectionBox<C>(
      _base: base)
  }

  /// Creates an `AnyBidirectionalCollection` having the same underlying collection as `other`.
  ///
  /// - Complexity: O(1)
  @inlinable
  public init(_ other: AnyRandomAccessCollection<Element>) {
    self._box = other._box
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 986)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 988)
  /// Creates an `AnyBidirectionalCollection` having the same underlying collection as `other`.
  ///
  /// If the underlying collection stored by `other` does not satisfy
  /// `BidirectionalCollection`, the result is `nil`.
  ///
  /// - Complexity: O(1)
  @inlinable
  public init?(_ other: AnyCollection<Element>) {
    guard let box =
      other._box as? _AnyBidirectionalCollectionBox<Element> else {
      return nil
    }
    self._box = box
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1003)

  /// The position of the first element in a non-empty collection.
  ///
  /// In an empty collection, `startIndex == endIndex`.
  @inlinable
  public var startIndex: Index {
    return AnyIndex(_box: _box._startIndex)
  }

  /// The collection's "past the end" position---that is, the position one
  /// greater than the last valid subscript argument.
  ///
  /// `endIndex` is always reachable from `startIndex` by zero or more
  /// applications of `index(after:)`.
  @inlinable
  public var endIndex: Index {
    return AnyIndex(_box: _box._endIndex)
  }

  /// Accesses the element indicated by `position`.
  ///
  /// - Precondition: `position` indicates a valid position in `self` and
  ///   `position != endIndex`.
  @inlinable
  public subscript(position: Index) -> Element {
    return _box[position._box]
  }

  @inlinable
  public subscript(bounds: Range<Index>) -> SubSequence {
    return AnyBidirectionalCollection(_box:
      _box[start: bounds.lowerBound._box, end: bounds.upperBound._box])
  }

  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
    // Do nothing.  Doing a range check would involve unboxing indices,
    // performing dynamic dispatch etc.  This seems to be too costly for a fast
    // range check for QoI purposes.
  }

  @inlinable
  public func _failEarlyRangeCheck(_ range: Range<Index>, bounds: Range<Index>) {
    // Do nothing.  Doing a range check would involve unboxing indices,
    // performing dynamic dispatch etc.  This seems to be too costly for a fast
    // range check for QoI purposes.
  }

  @inlinable
  public func index(after i: Index) -> Index {
    return AnyIndex(_box: _box._index(after: i._box))
  }

  @inlinable
  public func formIndex(after i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(after: i._box)
    }
    else {
      i = index(after: i)
    }
  }

  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    return AnyIndex(_box: _box._index(i._box, offsetBy: n))
  }

  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    return _box._index(i._box, offsetBy: n, limitedBy: limit._box)
      .map { AnyIndex(_box:$0) }
  }

  @inlinable
  public func formIndex(_ i: inout Index, offsetBy n: Int) {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n)
    } else {
      i = index(i, offsetBy: n)
    }
  }

  @inlinable
  public func formIndex(
    _ i: inout Index,
    offsetBy n: Int,
    limitedBy limit: Index
  ) -> Bool {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n, limitedBy: limit._box)
    }
    if let advanced = index(i, offsetBy: n, limitedBy: limit) {
      i = advanced
      return true
    }
    i = limit
    return false
  }

  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return _box._distance(from: start._box, to: end._box)
  }

  /// The number of elements.
  ///
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1113)
  /// To check whether a collection is empty, use its `isEmpty` property
  /// instead of comparing `count` to zero. Calculating `count` can be an O(*n*)
  /// operation.
  ///
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1118)
  /// - Complexity: O(*n*)
  @inlinable
  public var count: Int {
    return _box._count
  }

  @inlinable
  public var first: Element? {
    return _box._first
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1130)
  @inlinable
  public func index(before i: Index) -> Index {
    return AnyIndex(_box: _box._index(before: i._box))
  }

  @inlinable
  public func formIndex(before i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(before: i._box)
    }
    else {
      i = index(before: i)
    }
  }

  @inlinable
  public var last: Element? {
    return _box._last
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1150)
}

extension AnyBidirectionalCollection: _AnyCollectionProtocol {
  /// Uniquely identifies the stored underlying collection.
  @inlinable
  public // Due to language limitations only
  var _boxID: ObjectIdentifier {
    return ObjectIdentifier(_box)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 940)
/// A type-erased wrapper over any collection with indices that
/// support random access traversal.
///
/// An `AnyRandomAccessCollection` instance forwards its operations to a base collection having the
/// same `Element` type, hiding the specifics of the underlying
/// collection.
@_fixed_layout
public struct AnyRandomAccessCollection<Element> {
  @usableFromInline
  internal let _box: _AnyRandomAccessCollectionBox<Element>

  @inlinable
  internal init(_box: _AnyRandomAccessCollectionBox<Element>) {
    self._box = _box
  }
}

extension AnyRandomAccessCollection: RandomAccessCollection {
  public typealias Indices = DefaultIndices<AnyRandomAccessCollection>
  public typealias Iterator = AnyIterator<Element>
  public typealias Index = AnyIndex
  public typealias SubSequence = AnyRandomAccessCollection<Element> 

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 965)
  /// Creates a type-erased collection that wraps the given collection.
  ///
  /// - Parameter base: The collection to wrap.
  ///
  /// - Complexity: O(1).
  @inlinable
  public init<C : RandomAccessCollection>(_ base: C) where C.Element == Element {
    // Traversal: RandomAccess
    // SubTraversal: RandomAccess
    self._box = _RandomAccessCollectionBox<C>(
      _base: base)
  }

  /// Creates an `AnyRandomAccessCollection` having the same underlying collection as `other`.
  ///
  /// - Complexity: O(1)
  @inlinable
  public init(_ other: AnyRandomAccessCollection<Element>) {
    self._box = other._box
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 986)

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 988)
  /// Creates an `AnyRandomAccessCollection` having the same underlying collection as `other`.
  ///
  /// If the underlying collection stored by `other` does not satisfy
  /// `RandomAccessCollection`, the result is `nil`.
  ///
  /// - Complexity: O(1)
  @inlinable
  public init?(_ other: AnyCollection<Element>) {
    guard let box =
      other._box as? _AnyRandomAccessCollectionBox<Element> else {
      return nil
    }
    self._box = box
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 988)
  /// Creates an `AnyRandomAccessCollection` having the same underlying collection as `other`.
  ///
  /// If the underlying collection stored by `other` does not satisfy
  /// `RandomAccessCollection`, the result is `nil`.
  ///
  /// - Complexity: O(1)
  @inlinable
  public init?(_ other: AnyBidirectionalCollection<Element>) {
    guard let box =
      other._box as? _AnyRandomAccessCollectionBox<Element> else {
      return nil
    }
    self._box = box
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1003)

  /// The position of the first element in a non-empty collection.
  ///
  /// In an empty collection, `startIndex == endIndex`.
  @inlinable
  public var startIndex: Index {
    return AnyIndex(_box: _box._startIndex)
  }

  /// The collection's "past the end" position---that is, the position one
  /// greater than the last valid subscript argument.
  ///
  /// `endIndex` is always reachable from `startIndex` by zero or more
  /// applications of `index(after:)`.
  @inlinable
  public var endIndex: Index {
    return AnyIndex(_box: _box._endIndex)
  }

  /// Accesses the element indicated by `position`.
  ///
  /// - Precondition: `position` indicates a valid position in `self` and
  ///   `position != endIndex`.
  @inlinable
  public subscript(position: Index) -> Element {
    return _box[position._box]
  }

  @inlinable
  public subscript(bounds: Range<Index>) -> SubSequence {
    return AnyRandomAccessCollection(_box:
      _box[start: bounds.lowerBound._box, end: bounds.upperBound._box])
  }

  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
    // Do nothing.  Doing a range check would involve unboxing indices,
    // performing dynamic dispatch etc.  This seems to be too costly for a fast
    // range check for QoI purposes.
  }

  @inlinable
  public func _failEarlyRangeCheck(_ range: Range<Index>, bounds: Range<Index>) {
    // Do nothing.  Doing a range check would involve unboxing indices,
    // performing dynamic dispatch etc.  This seems to be too costly for a fast
    // range check for QoI purposes.
  }

  @inlinable
  public func index(after i: Index) -> Index {
    return AnyIndex(_box: _box._index(after: i._box))
  }

  @inlinable
  public func formIndex(after i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(after: i._box)
    }
    else {
      i = index(after: i)
    }
  }

  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    return AnyIndex(_box: _box._index(i._box, offsetBy: n))
  }

  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    return _box._index(i._box, offsetBy: n, limitedBy: limit._box)
      .map { AnyIndex(_box:$0) }
  }

  @inlinable
  public func formIndex(_ i: inout Index, offsetBy n: Int) {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n)
    } else {
      i = index(i, offsetBy: n)
    }
  }

  @inlinable
  public func formIndex(
    _ i: inout Index,
    offsetBy n: Int,
    limitedBy limit: Index
  ) -> Bool {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n, limitedBy: limit._box)
    }
    if let advanced = index(i, offsetBy: n, limitedBy: limit) {
      i = advanced
      return true
    }
    i = limit
    return false
  }

  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return _box._distance(from: start._box, to: end._box)
  }

  /// The number of elements.
  ///
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1118)
  /// - Complexity: O(1)
  @inlinable
  public var count: Int {
    return _box._count
  }

  @inlinable
  public var first: Element? {
    return _box._first
  }

// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1130)
  @inlinable
  public func index(before i: Index) -> Index {
    return AnyIndex(_box: _box._index(before: i._box))
  }

  @inlinable
  public func formIndex(before i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(before: i._box)
    }
    else {
      i = index(before: i)
    }
  }

  @inlinable
  public var last: Element? {
    return _box._last
  }
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1150)
}

extension AnyRandomAccessCollection: _AnyCollectionProtocol {
  /// Uniquely identifies the stored underlying collection.
  @inlinable
  public // Due to language limitations only
  var _boxID: ObjectIdentifier {
    return ObjectIdentifier(_box)
  }
}
// ###sourceLocation(file: "/Users/omochi/work/swift-source/swift/stdlib/public/core/ExistentialCollection.swift.gyb", line: 1161)

// Local Variables:
// eval: (read-only-mode 1)
// End: