import SwiftUI
import WidgetKit

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct SetupTheWidgetView: View {
    // MARK: - Données simulées
    let favoriteArtists: [Artist]
    @State private var isEditing = false
    
    @State private var topHeight: CGFloat = 0
    @State private var selectedRefreshInterval = 1
    @State private var enableSpotifyAccess = false
    @State private var showRandomQuote = true
    @State private var selectedTheme = 0
    @State private var showTheTitle = false
    @State private var showArtistImage = false
    @State private var showArtistName = false
    
    
    @State private var stackSize: CGSize = .zero
    
    
    let refreshIntervals = [1, 3, 6, 12] // en heures
    let themes = ["Light", "Dark", "Colorful"]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top){
                ZStack(alignment: .bottom){
                    ScrollView {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            // MARK: - Artistes préférés
                            Text("Your favourite Artists")
                                .font(.title2)
                                .bold()
                                .padding()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(favoriteArtists) { artist in
                                        ZStack {
                                            VStack {
                                                Image(artist.imageName)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 80, height: 80)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                                                
                                                Text(artist.name)
                                                    .font(.caption)
                                                    .lineLimit(1)
                                                
                                            }
                                            if isEditing {
                                                Image(systemName: "gearshape.fill")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 30))
                                                    .onTapGesture {
                                                        modifyArtist(artist)
                                                    }
                                                
                                            }
                                        }
                                    }
                                    if !isEditing{
                                        
                                        VStack{
                                            Button(action: {
                                                withAnimation(.spring()) {
                                                    isEditing = true
                                                }
                                            }) {
                                                Image(systemName: "gear.circle.fill")
                                                    .font(.system(size: 80))
                                                    .foregroundColor(.white)
                                                    .frame(width: 80, height: 80)
                                                    .background(Color.blue)
                                                    .clipShape(Circle())
                                                    .padding(.top, 0)
                                                
                                            }
                                            Text("Modify")
                                                .font(.caption)
                                                .lineLimit(1)
                                                .bold()
                                        }
                                    }
                                    
                                    if isEditing {
                                        VStack{
                                            Button(action: {
                                                withAnimation(.spring()) {
                                                    isEditing = false
                                                }
                                            }) {
                                                
                                                Image(systemName: "pencil")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(.white)
                                                    .frame(width: 80, height: 80)
                                                    .background(Color.blue)
                                                    .clipShape(Circle())
                                                    .padding(.top, 0)
                                                
                                                
                                                
                                            }
                                            Text("Confirm")
                                                .font(.caption)
                                                .lineLimit(1)
                                                .bold()
                                            
                                            
                                        }
                                        
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.top, 5)
                                
                                
                                //                        .padding(.horizontal, UIScreen.main.bounds.width * 0.1) //10% padding de cxhaque coté
                                
                                Button(action: goPremium) {
                                    Text("Go Premium to unlock full access")
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                    
                                }.padding(.horizontal, UIScreen.main.bounds.width * 0.1) //10% padding de cxhaque coté
                                
                                
                                
                            }
                            // MARK: - Citation aléatoire
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Random Quote")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                    Toggle(isOn: $showRandomQuote) {
                                        Text("")
                                    }
                                    .labelsHidden()
                                }
                                
                                
                                
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Change it every ...")
                                        .font(.title2)
                                        .bold()
                                    
                                    // Intervalle de refresh
                                    Picker("Changer la citation toutes les", selection: $selectedRefreshInterval) {
                                        ForEach(refreshIntervals, id: \.self) { interval in
                                            Text("\(interval) h").tag(interval)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    
                                    
                                    // Accès Spotify
                                    Toggle(isOn: $enableSpotifyAccess) {
                                        Text("Autoriser l'accès à Spotify")
                                    }
                                    
                                    if enableSpotifyAccess {
                                        Button(action: openSpotify) {
                                            HStack {
                                                Image(systemName: "play.circle.fill")
                                                Text("Écouter vos artistes")
                                            }
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.green)
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding(.top, 10)
                                
                                VStack(){
                                    HStack {
                                        Text("Show the Artist Name")
                                            .font(.title2)
                                            .bold()
                                        Spacer()
                                        Toggle("", isOn: $showArtistName)
                                            .onChange(of: showArtistName) { newValue in
                                                saveWidgetSettings() // ← sauvegarde à chaque changement
                                            }
                                            .labelsHidden()
                                        
                                        
                                    }
                                    .padding(.top, 10)
                                    
                                    HStack {
                                        Text("Show the Artist Picture")
                                            .font(.title2)
                                            .bold()
                                        Spacer()
                                        Toggle("", isOn: $showArtistImage)
                                            .onChange(of: showArtistImage) { newValue in
                                                saveWidgetSettings() // ← sauvegarde à chaque changement
                                            }
                                        .labelsHidden()
                                    }
                                    .padding(.top, 10)
                                    
                                    
                                    
                                }
                                
                                
                                
                            }
                            .padding(.horizontal)
                            .padding(.top, 15)
                            
                            // MARK: - Paramètres du widget
                            
                            
                            
                            // MARK: - Bouton sauvegarder / confirmer
                            
                            
                        }
                        // VStack principale
                        
                    }
                    
                    
                    
//                    Button(action: saveSettings) {
//                        Text("Sauvegarder les paramètres")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 20)
//                    .padding(.bottom, 20)
//
                    
                }.padding(.top, 160)
                .cornerRadius(10)// ScrollView
                
                    VStack(){
                        
                        
                        Text("CONFIGURE THE WIDGET")
                            .bold()
                            .font(.title)
                        
                        
                        HStack(spacing: 6){
                            if showArtistImage , let random = getRandomQuote() {
                                Image(random.artist.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
                                    .border(Color.white)
                                    .cornerRadius(15)
                                    .shadow(radius: 3)
                            }
                            
                            if let random = getRandomQuote(){
                                VStack{
                                    Text("“\(random.quote)”")
                                    
                                        .font(.headline)
                                        .italic()
                                    
                                        .shadow(radius: 0)
                                        .bold()
                                    
                                    if showArtistName {
                                        HStack{
                                            Spacer()
                                            Text("\(random.artist.name)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .frame(alignment: .trailing)
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(12)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: ViewHeightKey.self, value: geo.size.height)
                        }
                                            )
                    
                    
                    
                
            }
            
        }     // NavigationView
    }
    
    // MARK: - Fonctions utilitaires
    func goPremium(){
        print("Implement the premium access")
    }
    
        
        func modifyArtist(_ artist: Artist) {
                print("🔧 Modifier \(artist.name)")
                // 👉 Ici, tu pourrais ouvrir une page pour en choisir un autre
            }
    private func getRandomQuote() -> (artist: Artist, quote: String)? {
            guard let artist = favoriteArtists.randomElement(),
                  let quote = artist.quotes.randomElement() else {
                return nil
            }
            return (artist, quote)
        }
    
    func saveWidgetSettings() {
        let defaults = UserDefaults(suiteName: "group.com.mondomaine.MusicMood")
        
        // Exemple : ids des artistes sélectionnés
        let selectedIDs = favoriteArtists.map { $0.id.uuidString }
        defaults?.set(selectedIDs, forKey: "selectedArtistIDs")
        
        // Exemple : toggles
        defaults?.set(showArtistImage, forKey: "showArtistImage")
        defaults?.set(showArtistName, forKey: "showArtistName")
        
        // Rafraîchir le widget
        WidgetCenter.shared.reloadAllTimelines()
    }

    
    
    
    
    func openSpotify() {
        // Exemple simple d'ouverture de Spotify
        if let url = URL(string: "spotify://") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Spotify n’est pas installé")
            }
        }
    }
    
    func saveSettings() {
        // Ici tu peux sauvegarder les paramètres du widget dans UserDefaults ou CoreData
        print("Paramètres sauvegardés")
        print("Refresh interval: \(selectedRefreshInterval)h")
        print("Thème: \(themes[selectedTheme])")
        print("Spotify access: \(enableSpotifyAccess)")
    }
}

struct SetupTheWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SetupTheWidgetView(favoriteArtists: [
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
                name: "Kendrick Lamar",
                imageName: "kendrick",
                quotes: [
                    "People haven’t always been there for me but music always has.",
                    "Be yourself, chase your dreams, and just never say never."
                ],
                style: ["RAP"]
            ),
        ])
    }
}
