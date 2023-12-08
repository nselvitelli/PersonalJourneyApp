//
//  ViewModifiers.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/26/23.
//

import SwiftUI

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}
