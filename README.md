# Farmer Market Price Board

## Project Description
A responsive Flutter dashboard for exploring demonstration agricultural commodity prices across six Indian markets. All prices are local sample values; the application does not connect to live government market feeds or an external API.

## Objectives
- Present minimum, maximum, modal, and previous prices in a readable format.
- Let users search, filter, sort, compare, and save commodities.
- Demonstrate distinct mobile, tablet, and desktop layouts with Flutter widgets.

## Features
- Dashboard statistics, featured prices, and recent sample updates.
- 15 commodities across Cereals, Vegetables, Fruits, Pulses, Spices, and Cash Crops.
- Market selector for Guntur, Vijayawada, Visakhapatnam, Hyderabad, Warangal, and Kurnool. Market choice changes the displayed sample prices.
- Case-insensitive live search, category filters, and five sorting options.
- Favourites that update immediately during the session.
- Commodity details with price history drawn using Flutter's `CustomPainter`.
- An SDG 2 section with a modest, educational relevance statement.

## Technologies Used
- Flutter and Dart
- Material 3
- Flutter SDK widgets only; no external runtime packages, backend, database, or API

## Flutter Concepts Demonstrated
`MaterialApp`, `ThemeData`, `Scaffold`, `AppBar`, `NavigationBar`, `NavigationRail`, responsive sidebar, `StatelessWidget`, `StatefulWidget`, `LayoutBuilder`, `MediaQuery`, `GridView.builder`, `ListView.builder`, `DataTable`, `Card`, `Row`, `Column`, `Expanded`, `TextField`, `DropdownButtonFormField`, `setState`, `Navigator`, and reusable widgets.

## Responsive Breakpoints
- **Mobile:** below 600px. Compact app bar, bottom navigation, full-width search, horizontal category filters, and a single-column commodity list.
- **Tablet:** 600–1023px. Navigation rail, two-column commodity grid, and multi-column dashboard statistics.
- **Desktop:** 1024px and above. Persistent sidebar, wide dashboard sections, horizontal statistics, and a sortable/filterable commodity table layout.

## Folder Structure
```text
lib/
  main.dart
  models/
    commodity.dart
    market.dart
  data/
    sample_data.dart
  screens/
    home_screen.dart
    commodity_details_screen.dart
  widgets/
    app_sidebar.dart
    category_filter.dart
    commodity_card.dart
    commodity_table.dart
    dashboard_stat_card.dart
    price_history_chart.dart
  theme/
    app_theme.dart
  utils/
    app_breakpoints.dart
    app_colors.dart
    formatters.dart
```

The repository also includes generated Flutter platform scaffolding for Android, iOS, Linux, macOS, Web, and Windows. The GitHub Actions workflow builds and publishes the Web target.

## How to Run
With an existing Flutter SDK installed, from the project directory run:

```bash
flutter pub get
flutter run
```

To run in Chrome:

```bash
flutter run -d chrome
```

The GitHub Actions workflow builds Flutter Web and deploys it to GitHub Pages without requiring Flutter on the Windows computer.

## SDG 2 Relevance
SDG 2 is Zero Hunger. Accessible sample price comparisons illustrate how market information can help farmers understand selling options and market conditions. This academic application does not claim or measure real-world impact.

## Screenshots
Add screenshots demonstrating:
1. Mobile at approximately 390px.
2. Tablet at approximately 768px.
3. Desktop at approximately 1440px.
4. Commodity detail/history and search, category, sorting, or favourites.
