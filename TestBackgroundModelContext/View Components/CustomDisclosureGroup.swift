//
//  CustomDisclosureGroup.swift
//  PersonalJourney
//
//  Created by Nick Selvitelli on 6/27/23.
//

import SwiftUI

struct CustomDisclosureGroup<Content: View> : View {
    
    var imageScale : Double
    let disclosureSpacing : CGFloat
    @ViewBuilder let content: () -> Content
    
    init(imageScale: Double = 1.5, disclosureSpacing: CGFloat = 30, @ViewBuilder content: @escaping () -> Content) {
        self.imageScale = imageScale
        self.disclosureSpacing = disclosureSpacing
        self.content = content
    }
    
    var body: some View {
        DisclosureGroup("") {
            VStack(spacing: disclosureSpacing, content: content)
            .padding([.top], disclosureSpacing)
            .foregroundColor(Color.white)
        }
        .disclosureGroupStyle(CustomDisclosureStyle(imageScale: imageScale, disclosureSpacing: disclosureSpacing))
        .padding(disclosureSpacing)
    }
}
