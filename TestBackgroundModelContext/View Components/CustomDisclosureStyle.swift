//
//  CustomDisclosureGroupStyle.swift
//  PersonalJourney
//
//  Created by Nick Selvitelli on 6/27/23.
//

import SwiftUI

struct CustomDisclosureStyle: DisclosureGroupStyle {
    
    let imageScale : Double
    let disclosureSpacing : CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .trailing) {
            
            if configuration.isExpanded {
                configuration.content
            }
                        
            Button {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            } label: {
                Image(systemName: configuration.isExpanded ? "xmark" : "line.3.horizontal")
                    .foregroundColor(.white)
                    .scaleEffect(CGSize(width: imageScale, height: imageScale))
                    .animation(nil, value: configuration.isExpanded)
            }
            .buttonStyle(.bordered)
            .padding(.top, disclosureSpacing)
            
        }
    }
}
