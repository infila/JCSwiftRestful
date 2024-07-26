//
//  Double+Ext.swift
//  JCSwiftCommon
//
//  Created by Regina Buerano on 2/24/23.
//

import Foundation

public extension Double {    
    func roundDecimal(_ format: Int = 2) -> String {
        return String(format: "%.\(format)f", self)
    }
}
