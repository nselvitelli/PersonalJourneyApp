//
//  PlaylistView.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/13/23.
//

import SwiftUI
import SwiftData

struct MainPlaylistView : View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var playlists : [Playlist]
        
    @State var showCreate : Bool = false
    
    @State var searchString = ""
    
    @State var newPlaylist : Playlist?
    
    
    var body : some View {
        
        VStack {
            List {
                ForEach(playlists.filter(searchFilter)) { playlist in
                    
                    NavigationLink(destination: PlaylistForm(playlist: playlist)) {
                        HStack {
                            
                            Text(playlist.name)
                            
                            Spacer()
                            
                            let total = Double(playlist.places.count)
                            if total > 0 {
                                let numVisited = Double(BackgroundSingleton.shared.getNumberOfPlacesVisited(playlist: playlist))
                                let progress = numVisited / total
                                
                                Text("\(Int(progress * 100))%")
                                CircularProgressView(progress: .constant(progress))
                            }
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            modelContext.delete(playlist)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
            }
            .searchable(text: $searchString)
            .autocorrectionDisabled()
        }
        .toolbar {
                        
            ToolbarItem {
                Button(action: {
                    let tempPlaylist = Playlist()
                    modelContext.insert(tempPlaylist)
                    newPlaylist = tempPlaylist
                    showCreate.toggle()
                }, label: {
                    Label("Add Item", systemImage: "plus")
                })
            }
        }
        .navigationBarTitle("Placelists", displayMode: .large)
        .sheet(isPresented: $showCreate, content: {
            if let playlist = newPlaylist {
                NavigationStack() {
                    PlaylistForm(playlist: playlist)
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        })
        .onChange(of: showCreate, { old, new in
            if(!showCreate) {
                if let playlist = newPlaylist {
                    if(playlist.name.isEmpty) {
                        modelContext.delete(playlist)
                    }
                    newPlaylist = nil
                }
            }
        })
    }
    
    
    func searchFilter(_ playlist: Playlist) -> Bool {
        return searchString.isEmpty 
        || playlist.name.localizedStandardContains(searchString)
        || playlist.places.contains(where: { loc in
            loc.name.localizedStandardContains(searchString)
        })
    }
}
