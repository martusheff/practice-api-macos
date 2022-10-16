//
//  NSTextField+Extensions.swift
//  PracticeAPI
//
//  Created by andronick martusheff on 10/15/22.
//

import Foundation
import SwiftUI

// Removing the annoying focus ring.
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
