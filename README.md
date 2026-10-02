# Farmer Market Price Board

## Problem Statement
Farmers and consumers benefit from understanding how everyday agricultural products are priced across local markets. This student project presents a clear, responsive board using sample data.

## Features
- Search products by name and combine the search with a category filter.
- Browse sample prices by Local Market, Main Market, or Farmers Market.
- View price trends, last-updated labels, summary statistics, and product details.
- Responsive layouts for phones, tablets, and desktop screens.
- Clearly labeled demonstration prices; no live market feed is connected.

## Flutter Concepts Used
Material 3, `MaterialApp`, `Scaffold`, `ThemeData`, `LayoutBuilder`, `GridView.builder`, `ListView`, `Card`, `TextField`, `StatefulWidget`, `StatelessWidget`, `showDialog`, and reusable widgets.

## Responsive Breakpoints
- Mobile: < 600px — single-column cards and compact, vertically arranged controls.
- Tablet: 600–1023px — two-column cards and wider shared search/filter rows.
- Desktop: >= 1024px — three-column cards in a centered wide content area.

## SDG 2 Relevance
SDG 2 is Zero Hunger. Accessible agricultural market-price information can improve awareness of food markets and is conceptually related to food security. This sample application does not measure or claim a real-world impact.

## Flutter Web Testing
This source project does not currently include generated platform folders. To add only the Flutter Web runner in an environment that has the Flutter SDK, run `flutter create --platforms=web .`, then `flutter pub get`.

To run with a local Flutter SDK, use `flutter run -d chrome`. For browser-based testing without a local SDK, import the project into a Flutter web sandbox such as Zapp!; its GitHub importer supports Flutter projects and its preview runs in the browser.

## Screenshots
Add screenshots demonstrating:
1. Mobile layout (approximately 390px wide).
2. Tablet layout (approximately 768px wide).
3. Desktop layout (approximately 1440px wide).
4. Product details dialog and search/category filtering.



