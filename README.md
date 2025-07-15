# 🌱 Agro Zone (Development in progress)

A Flutter app for managing and visualizing agricultural plots with interactive mapping, Supabase backend, and polygon drawing support.

## Features

- 🗺️ **Interactive Map**: View and draw polygons on a map using [flutter_map](https://pub.dev/packages/flutter_map).
- ✍️ **Draw & Save Plots**: Tap to draw plot boundaries and save them as GeoJSON.
- 🗃️ **Supabase Integration**: Store and fetch plot data (including geometry) from a Supabase/PostGIS backend.
- 📋 **Plot List**: View all saved plots in a drawer and tap to display their boundaries on the map.
- 📝 **Add Plot Details**: Save crop type, notes, and geometry for each plot.


## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A [Supabase](https://supabase.com/) project with a PostGIS-enabled table (see below)
- (Optional) [MapTiler](https://www.maptiler.com/cloud/) or other map tile API key for production use

### Clone & Run

```sh
git clone https://github.com/yourusername/agro_zone.git
cd agro_zone
flutter pub get
flutter run
```

### Configuration

Edit main.dart and set your Supabase URL and anon key:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

## Usage

- **Draw a plot:** Tap the ✏️ button, then tap on the map to add points. Tap ✔️ to finish.
- **Save a plot:** Tap ➕, fill in details, and paste or auto-fill the geometry data.
- **View plots:** Open the drawer, tap a plot to display its boundary.

## Folder Structure

```
lib/
  models/
    geo_data.dart
    user_plot_data.dart
  screens/
    map_view.dart
  services/
    polygon_decoder.dart
  supabase/
    dbdata.dart
  widgets/
    drawer.dart
  main.dart
```
