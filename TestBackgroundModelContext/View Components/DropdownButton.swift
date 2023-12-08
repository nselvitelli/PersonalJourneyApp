//
//  DropdownButton.swift
//  PersonalJourney
//
//  Created by Nick Selvitelli on 6/28/23.
//

import SwiftUI

struct DropdownButton : View {
    
    let systemName: String
    let action: () -> Void
    
    @State private var isPresentingConfirm: Bool = false
    
    static let imageScale : Double = 2.0
    
    
    init(systemName: String,
         action: @escaping () -> Void) {
        self.systemName = systemName
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action) {
            Image(systemName: self.systemName)
                .scaleEffect(CGSize(width: DropdownButton.imageScale, height: DropdownButton.imageScale))
                .foregroundColor(Color.white)
        }
        .buttonStyle(.bordered)
    }
}


#Preview {
    ZStack {
        Color(.black)
        DropdownButton(systemName: "plus") {
            print("w")
        }
    }
}
