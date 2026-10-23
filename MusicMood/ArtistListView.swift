import SwiftUI

// ✅ Modèle représentant un artiste
struct Artist: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let quotes: [String]
    let style: [String]// liste de citations
}

// ✅ Ta bibliothèque (liste d'artistes)
let artistsLibrary = [
    Artist(
        name: "Beyoncé",
        imageName: "beyonce",
        quotes: [
            "Music's got me feeling so free.",
            "We’re up all night to get lucky."
        ],
        style: ["POP"]
    ),
    Artist(
        name: "Bob Marley",
        imageName: "bob",
        quotes: [
            "People haven’t always been there for me but music always has.",
            "Be yourself, chase your dreams, and just never say never."
        ],
        style: ["POP"]
    ),
    Artist(
        name: "Bob Marley",
        imageName: "bob",
        quotes: [
            "People haven’t always been there for me but music always has.",
            "Be yourself, chase your dreams, and just never say never."
        ],
        style: ["POP"]
    ),
    Artist(
        name: "Kendrick Lamar",
        imageName: "kendrick",
        quotes: [
            "People haven’t always been there for me but music always has.",
            "Be yourself, chase your dreams, and just never say never."
        ],
        style: ["RAP"]
    ),
    Artist(
        name: "Kendrick Lamar",
        imageName: "kendrick",
        quotes: [
            "People haven’t always been there for me but music always has.",
            "Be yourself, chase your dreams, and just never say never."
        ],
        style: ["RAP"]
    ),
    Artist(
        name: "Kendrick Lamar",
        imageName: "kendrick",
        quotes: [
            "People haven’t always been there for me but music always has.",
            "Be yourself, chase your dreams, and just never say never."
        ],
        style: ["R&B"]
    ),
    Artist(
        name: "Kendrick Lamar",
        imageName: "kendrick",
        quotes: [
            "People haven’t always been there for me but music always has.",
            "Be yourself, chase your dreams, and just never say never."
        ],
        style: ["R&B"]
    ),
    Artist(
        name: "Kendrick Lamar",
        imageName: "beyonce",
        quotes: [
            "People haven’t always been there for me but music always has.",
            "Be yourself, chase your dreams, and just never say never."
        ],
        style: ["ROCK"]
    )
]


// Fonction pour générer le dictionnaire
func groupArtistsByStyle(_ artists: [Artist]) -> [String: [Artist]] {
    var dict = [String: [Artist]]()
    
    for artist in artists {
        for style in artist.style {
            if dict[style] != nil {
                dict[style]?.append(artist)
            } else {
                dict[style] = [artist]
            }
        }
    }
    
    return dict
}

// Exemple d'utilisation
let artistsByStyle = groupArtistsByStyle(artistsLibrary)




struct Search: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.quaternary, in: Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}




// Vue principale


struct ArtistListView: View {
    let artistsByStyle: [String: [Artist]]
    let artists: [Artist]
    
    @State private var favoriteArtists: [Artist] = []

    
    @State private var searchText = ""
    @State private var selectedArtists: Set<UUID> = []
    @State private var goToNextPage = false // variable pour déclencher la navigation
    @State private var showLimitMessage = false
    @State private var cancelSearch = false
    @State private var needArtist = false
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ZStack(alignment: .top){
                    if !selectedArtists.isEmpty {
                        ZStack(alignment: .trailing) {
                            VStack(spacing: 10) {
                                
                                
                                
                                
                                // 👇 Liste horizontale des artistes sélectionnés
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 25) {
                                        ForEach(artists.filter { selectedArtists.contains($0.id) }) { artist in
                                            Image(artist.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 90, height: 90)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                                .onTapGesture { toggleSelection(artist) }
                                                
                                        }
                                    }.padding(.top,2)
                                    .padding(.bottom,2)
                                    .padding(.horizontal)
                                }
                                if showLimitMessage {
                                        Text("GO PREMIUM TO ADD MORE")
                                            .foregroundColor(.black)
                                            .bold()
                                            .transition(.move(edge: .top).combined(with: .opacity))
                                            .padding(.top,5)
                                            .animation(.easeInOut, value: showLimitMessage)
                                    }

                                
                            }
                            .padding(.vertical, 5)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .padding(.top, 50)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut, value: selectedArtists.isEmpty)
                            
                            
                            
                        }
                        
                            
                        }
                    VStack{
                        Text("SELECT YOUR FAV ARTISTS")
                            .font(.title)
                            .padding(.bottom, 30)
                            .bold()
                            
                    
                    ScrollView {
                        
                        
                        ForEach(artistsByStyle.keys.sorted(), id: \.self) { style in
                            let filteredArtists = artistsByStyle[style]!.filter {
                                searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
                            }
                            
                            if !filteredArtists.isEmpty {
                                VStack(alignment: .leading) {
                                    Text(style)
                                        .font(.title3)
                                        .bold()
                                        .padding(.leading)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 15) {
                                            ForEach(filteredArtists) { artist in
                                                VStack {
                                                    Image(artist.imageName)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(Circle())
                                                        .overlay(
                                                            Circle().stroke(selectedArtists.contains(artist.id) ? Color.blue : Color.white, lineWidth: 3)
                                                        )
                                                        .shadow(radius: 2)
                                                        .onTapGesture { toggleSelection(artist) }
                                                    
                                                    Text(artist.name)
                                                        .font(.caption)
                                                        .frame(width: 100)
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(selectedArtists.contains(artist.id) ? .blue : .primary)
                                                }
                                            }
                                        }
                                        .padding(.top,5)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        Spacer().frame(height: 120)
                        
                    }.padding(.top, showLimitMessage ? 120 : (selectedArtists.isEmpty ? 0 : 80))
                    
                }
                
                }
                
            
                // Champ de recherche + bouton confirmer
                VStack( spacing: 10) {
                    TextField("Search for an artist...", text: $searchText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        if selectedArtists.count == 3 {
                            search() // ou goToNextPage = true
                        }
                    }) {
                        Text(buttonText)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedArtists.count == 3 ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    
                    // NavigationLink invisible
                    NavigationLink(
                        destination: SetupTheWidgetView(favoriteArtists: getSelectedArtists()),
                        isActive: $goToNextPage,
                        label: { EmptyView() }
                    )
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 4)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    func toggleSelection(_ artist: Artist) {
        withAnimation(.spring()) {
            if selectedArtists.contains(artist.id) {
                // Si déjà sélectionné → on retire
                selectedArtists.remove(artist.id)
            } else {
                // Sinon, on ajoute seulement s’il y a de la place
                if selectedArtists.count < 3 {
                    selectedArtists.insert(artist.id)

                } else {
                    // Petite vibration ou message optionnel
                    showLimitMessage = true
                }
                
            }
            if selectedArtists.count < 3 {
                        showLimitMessage = false
                    }
        }
    }
    
    var buttonText: String {
        let remaining = 3 - selectedArtists.count
        if remaining > 0 {
            return "Select \(remaining) more artist\(remaining > 1 ? "s" : "")"
        } else {
            return "Continue"
        }
    }
    
    func getSelectedArtists() -> [Artist] {
        return artists.filter { selectedArtists.contains($0.id) }
    }
    func search() {
        let selected = artists.filter { selectedArtists.contains($0.id) }
        favoriteArtists = selected
        goToNextPage = true
        print("Sélection confirmée : \(favoriteArtists.map { $0.name })")
    }

    func confirmSelection() {
        // Ici tu peux sauvegarder la sélection dans le profil
        print("Sélection confirmée : \(getSelectedArtists().map { $0.name })")
        goToNextPage = true // déclenche la navigation
    }
    
    
    
    
}

// Preview pour Xcode 14
struct ArtistListView_Previews: PreviewProvider {
    static var previews: some View {
        let artistsByStyle = groupArtistsByStyle(artistsLibrary)
        ArtistListView( artistsByStyle: artistsByStyle, artists: artistsLibrary)
    }
}
