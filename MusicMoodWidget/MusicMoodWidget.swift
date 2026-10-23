import SwiftUI
import WidgetKit



struct Artist: Identifiable, Codable {
    let id = UUID()
    let name: String
    let imageName: String
    let quotes: [String]
    let style: [String]
}


struct ArtistEntry: TimelineEntry {
    let date: Date
    let artist: Artist
    let quote: String
    let showImage: Bool
    let showName: Bool
}

struct ArtistProvider: TimelineProvider {
    let allArtists = [
        Artist(name: "Beyoncé", imageName: "beyonce", quotes: ["Music's got me feeling so free."], style: ["POP"]),
        Artist(name: "Bob Marley", imageName: "bob", quotes: ["Be yourself"], style: ["POP"]),
        Artist(name: "Kendrick Lamar", imageName: "kendrick", quotes: ["Stay true"], style: ["RAP"])
    ]
    
    func getSelectedArtists() -> [Artist] {
        let defaults = UserDefaults(suiteName: "group.com.tonapp.MusicMood")
        guard let ids = defaults?.array(forKey: "selectedArtistIDs") as? [String] else { return [] }
        return allArtists.filter { ids.contains($0.id.uuidString) }
    }
    
    func getShowImage() -> Bool {
        UserDefaults(suiteName: "group.com.tonapp.MusicMood")?.bool(forKey: "showArtistImage") ?? true
    }
    
    func getShowName() -> Bool {
        UserDefaults(suiteName: "group.com.tonapp.MusicMood")?.bool(forKey: "showArtistName") ?? true
    }
    
    func placeholder(in context: Context) -> ArtistEntry {
        ArtistEntry(date: Date(), artist: allArtists[0], quote: allArtists[0].quotes[0], showImage: true, showName: true)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ArtistEntry) -> ()) {
        let selected = getSelectedArtists()
        let artist = selected.randomElement() ?? allArtists[0]
        let entry = ArtistEntry(date: Date(), artist: artist, quote: artist.quotes.randomElement() ?? "", showImage: getShowImage(), showName: getShowName())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ArtistEntry>) -> ()) {
        let selected = getSelectedArtists()
        let artist = selected.randomElement() ?? allArtists[0]
        let entry = ArtistEntry(date: Date(), artist: artist, quote: artist.quotes.randomElement() ?? "", showImage: getShowImage(), showName: getShowName())
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60*60)))
        completion(timeline)
    }
}



struct MusicMoodWidgetEntryView : View {
    var entry: ArtistEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Color.clear // Fond transparent simulé pour iOS 14-16
            
            switch family {
            case .systemSmall:
                VStack {
                    if entry.showImage {
                        Image(entry.artist.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                    Text("“\(entry.quote)”")
                        .font(.headline)
                        .italic()
                        .multilineTextAlignment(.center)
                    if entry.showName {
                        Text(entry.artist.name)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
            case .systemMedium:
                HStack {
                    if entry.showImage {
                        Image(entry.artist.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading) {
                        Text("“\(entry.quote)”")
                            .font(.headline)
                            .italic()
                            .lineLimit(3)
                        if entry.showName {
                            Text(entry.artist.name)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
            @unknown default:
                Text("Unsupported size")
            }
        }
        .cornerRadius(12)
    }
}



struct MusicMoodWidget: Widget {
    let kind: String = "MusicMoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ArtistProvider()) { entry in
            MusicMoodWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("MusicMood Widget")
        .description("Displays your favorite artist and a random quote.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct MusicMoodWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MusicMoodWidgetEntryView(
                entry: ArtistEntry(
                    date: Date(),
                    artist: Artist(name: "Beyoncé", imageName: "beyonce", quotes: ["Music's got me feeling so free."], style: ["POP"]),
                    quote: "Music's got me feeling so free.",
                    showImage: true,
                    showName: true
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            MusicMoodWidgetEntryView(
                entry: ArtistEntry(
                    date: Date(),
                    artist: Artist(name: "Bob Marley", imageName: "bob", quotes: ["Be yourself"], style: ["POP"]),
                    quote: "Be yourself",
                    showImage: true,
                    showName: true
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
