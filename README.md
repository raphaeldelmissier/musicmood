# MusicMood — widget iOS d'artistes

Une app iOS en SwiftUI avec un **widget d'écran d'accueil** (WidgetKit) qui affiche un artiste et une de ses citations,
et change régulièrement.

- **App** (`MusicMood/`) : choix des artistes suivis (`ArtistListView`), profil, et un guide pour installer le widget (`SetupTheWidgetView`).
- **Widget** (`MusicMoodWidget/`) : un `TimelineProvider` fait tourner les artistes choisis, avec leur photo, leur nom, une citation et leur style (POP, RAP…).
  Une Live Activity est aussi préparée.
- Les choix passent de l'app au widget par un App Group partagé.

## Lancer

Ouvrez `MusicMood.xcodeproj` dans Xcode, choisissez un simulateur iOS et lancez.
Pour tester le widget, ajoutez-le à l'écran d'accueil du simulateur.
