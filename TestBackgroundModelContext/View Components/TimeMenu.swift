//
//  TimeMenu.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 12/5/23.
//

import SwiftUI

struct TimeMenu : View {
    
    @State var selection : DateFilter = .Off
    
    var body: some View {
        
        Menu {
            Picker(selection: $selection, label: EmptyView()) {
                ForEach(DateFilter.allCases, id:\.self) { filter in
                    Text(String(describing: filter))
                }
            }
            
        } label: {
            Image(systemName: "clock.arrow.circlepath")
                .scaleEffect(CGSize(width: DropdownButton.imageScale, height: DropdownButton.imageScale))
                .foregroundColor(Color.white)
        }
        .buttonStyle(.bordered)
        .onChange(of: selection) { old, new in
            BackgroundSingleton.shared.dateFilter = selection
            BackgroundSingleton.shared.updatePoints()
        }
    }
}


#Preview {
    ZStack {
        Color(.black)
        
        HStack {
            VStack {
                TimeMenu()
                
            }
        }
    }
}
