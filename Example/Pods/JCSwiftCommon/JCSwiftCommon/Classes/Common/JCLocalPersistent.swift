//
//  JCLocalPersistent.swift
//  JCSwiftCommon
//
//  Created by James Chen on 2024-07-05.
//

import Foundation

/// A lightweight File Database implemented through reading and writing local files, which is not suitable for handling particularly large volumes of data.

public final class JCLocalPersistent {
  public static let shared = JCLocalPersistent()

  /// Folder path, have default value
  public var baseDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "/var/document"

  /// Will be called before writing to the file. Do any encryption processing if you like.
  public var encryptClosure: ((Data) -> (Data))?
  /// Will be called after loading from the file. If you encrpted the data earlier, don't forget decrypt it.
  public var decryptClosure: ((Data) -> (Data))?

  /// If fileName starts with “/”, it will be treated as an absolute path;
  /// Otherwise, it will be considered a relative path, and the baseDirectory will automatically be prefixed.
  /// And so does every "fileName" in this class.
  @discardableResult
  public func saveData(_ data: Data, toFile fileName: String) -> Bool {
    var data = data
    if let encryptClosure = encryptClosure {
      data = encryptClosure(data)
    }
    let url = URL(fileURLWithPath: exactlyFilePath(forName: fileName))
    let folderUrl = url.deletingLastPathComponent()
    var result = false
    Thread.synchronized(self) {
      if !fileManager.fileExists(atPath: folderUrl.absoluteString) {
        try? fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
      }
      do {
        try data.write(to: url, options: .atomicWrite)
        result = true
      } catch {
        assert(false, "\(error)")
        result = false
      }
    }
    return result
  }

  /// Load from existing file
  public func loadData(fromFile fileName: String) -> Data? {
    if !isFileExist(fileName) {
      return nil
    }
    var data: Data?
    Thread.synchronized(self) {
      data = fileManager.contents(atPath: exactlyFilePath(forName: fileName))
    }
    if let decryptClosure = decryptClosure, data != nil {
      data = decryptClosure(data!)
    }
    return data
  }

  public func isFileExist(_ fileName: String) -> Bool {
    return fileManager.fileExists(atPath: exactlyFilePath(forName: fileName))
  }

  /// Get all file names in baseDirectory if folderName == nil
  public func allFileNames(inFolder folderName: String? = nil) -> [String] {
    var result: [String]?
    let folderName = folderName ?? baseDirectory

    if fileManager.fileExists(atPath: exactlyFilePath(forName: folderName)) {
      result = try? fileManager.contentsOfDirectory(atPath: exactlyFilePath(forName: folderName))
    }
    return result ?? []
  }

  public func remove(_ fileName: String) {
    if !fileManager.fileExists(atPath: exactlyFilePath(forName: fileName)) {
      return
    }
    Thread.synchronized(self) {
      do {
        try fileManager.removeItem(atPath: exactlyFilePath(forName: fileName))
      } catch {
        assert(false, "\(error)")
      }
    }
  }

  private init() { }
  private let fileManager = FileManager()
}

private extension JCLocalPersistent {
  private func exactlyFilePath(forName fileName: String) -> String {
    if fileName.hasPrefix("/") {
      return fileName
    }
    return baseDirectory + "/" + fileName
  }
}

/// Persistent instances by using JCLocalPersistent
/// Save as [instence1, instence2, instence3, ...] at filePath
/// See extension JCPersistentObject for default implementation
public protocol JCPersistentObject: Codable {
  static var filePath: String? { get }
  static func load(byId id: String) -> Self?
  static func clear()

  /// Used to determine save() = append() or save() = update()
  func persistentId() -> String

  /// Save self as an Element in Array to filePath
  /// If self.persistentId already exist in Database, do update()
  /// else do append()
  /// If index is sensitive, use [JCPersistentObject].save()
  func save() -> Bool
}

/// Default implementation for JCPersistentObject
public extension JCPersistentObject {
  /// If fileName starts with “/”, it will be treated as an absolute path;
  /// Otherwise, it will be considered a relative path, and the JCLocalPersistent.shared.baseDirectory will automatically be prefixed.
  static var filePath: String? {
    return String(typeName: Self.self)
  }

  @discardableResult
  func save() -> Bool {
    var result: Array<Self> = []
    if let oldData = JCLocalPersistent.shared.loadData(fromFile: Self.filePath ?? String(typeName: self)) {
      result = JCSerialization.decode(from: oldData, decodeType: Array<Self>.self) ?? []
    }
    let ids = result.map { $0.persistentId() }
    if let index = ids.firstIndex(of: persistentId()) {
      result[index] = self
    } else {
      result.append(self)
    }
    return result.save()
  }

  static func loadAll() -> [Self]? {
    return [Self].load()
  }

  static func load(byId id: String) -> Self? {
    return [Self].load().filter({ $0.persistentId() == id }).first
  }

  static func clear() {
    JCLocalPersistent.shared.remove(Self.filePath ?? String(typeName: self))
  }
}

public extension Array where Element: JCPersistentObject {
  /// Save all Elements to Element.filePath
  /// Override filePath() in Element.swift to any specific path you want.
  @discardableResult
  func save() -> Bool {
    guard let data = JCSerialization.encode(self) else {
      return false
    }
    return JCLocalPersistent.shared.saveData(data, toFile: Element.filePath ?? String(typeName: self))
  }

  /// Load all Elements from Element.filePath
  static func load() -> [Element] {
    if let oldData = JCLocalPersistent.shared.loadData(fromFile: Element.filePath ?? String(typeName: self)) {
      return JCSerialization.decode(from: oldData, decodeType: Array<Element>.self) ?? [Element]()
    }
    return [Element]()
  }
}
