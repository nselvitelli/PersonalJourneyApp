//
//  SearchLocationView.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/26/23.
//

import SwiftUI
import MapKit


struct SearchLocationView : View {
    
    @Binding var selectedPlace : MKMapItem?
    @Binding var isPresented : Bool
    
    @State var search : String = ""
    
    @State private var locationSearchService = LocationSearchService(completer: .init())
    
    var body: some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
            
            TextField("Search", text: $search)
                .autocorrectionDisabled()
            
            if !search.isEmpty {
                Button(action: {
                    search = ""
                    locationSearchService.clearResults()
                }, label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                })
            }
                            
        }
        .modifier(TextFieldGrayBackgroundColor())
        .padding()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        
        
        List {
            ForEach(locationSearchService.completions) { completion in
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(completion.title)
                            .font(.headline)
                            .fontDesign(.rounded)
                        Text(completion.subTitle)
                    }
                    
                    Button("Add") {
                        selectedPlace = completion.mapItem
                        isPresented.toggle()
                    }
                    .buttonStyle(.bordered)
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .onChange(of: search) {
            locationSearchService.update(queryFragment: search)
        }
    }
}


#Preview {
    SearchLocationView(selectedPlace: .constant(nil), isPresented: .constant(true))
}
