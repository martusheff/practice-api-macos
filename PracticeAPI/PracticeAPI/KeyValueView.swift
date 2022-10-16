//
//  KeyValueView.swift
//  PracticeAPI
//
//  Created by andronick martusheff on 10/15/22.
//

import SwiftUI

struct KeyValueView: View {
    @Binding var key: String
    @Binding var value: String
    var body: some View {
        HStack {
            TextField("Key", text: $key)
            TextField("Value", text: $value)
        }
    }
}
