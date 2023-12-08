//
//  MapMenu.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/13/23.
//

import SwiftUI

struct MapMenu : View {
    
    @Environment(\.modelContext) var modelContext
        
    var body : some View {
        CustomDisclosureGroup {
            
            TimeMenu()
            
            NavigationLink(destination: MainPlaylistView()) {
                Image(systemName: "checklist")
                    .scaleEffect(CGSize(width: DropdownButton.imageScale, height: DropdownButton.imageScale))
                    .foregroundColor(Color.white)
            }
            .buttonStyle(.bordered)
            
            NavigationLink(destination: Settings()) {
                Image(systemName: "gear")
                    .scaleEffect(CGSize(width: DropdownButton.imageScale, height: DropdownButton.imageScale))
                    .foregroundColor(Color.white)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ZStack {
        Color(.black)
        
        HStack {
            Spacer()
            VStack {
                Spacer()
                MapMenu()
                
            }
        }
    }
}
