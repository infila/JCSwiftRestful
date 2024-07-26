//
//  JCBundleFileLoader.swift
//  JCSwiftCommon
//
//  Created by James Chen on 2022/10/18.
//

import Foundation

public struct JCBundleFileLoader {
  /// Load a plist as a Model object
  public static func loadPlist<T: Decodable>(from fileName: String, decodeType: T.Type) -> T? {
    if let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
       let xml = FileManager.default.contents(atPath: path),
       let plistInfo = try? PropertyListDecoder().decode(T.self, from: xml) {
      return plistInfo
    }
    assert(false, "Loading plist failed: \(fileName)")
    return nil
  }

  /// Load a json file as a Model object
  public static func loadJsonFile<T: Decodable>(from fileName: String, decodeType: T.Type) -> T? {
    var data = Data()

    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil)
    else {
      assert(false, "Couldn't find \(fileName) in main bundle.")
      return nil
    }
    do {
      data = try Data(contentsOf: file)
    } catch {
      assert(false, "Couldn't load \(fileName) from main bundle:\n\(error)")
    }
    return JCSerialization.decode(from: data, decodeType: decodeType)
  }
}
