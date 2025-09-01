
# Event Management iOS Demo

This project is a **SwiftUI-based iOS application** built as part of an iOS developer assessment.
It demonstrates fetching, displaying, and interacting with event data from a remote API.
The project follows **MVVM architecture** and is designed to be clean, scalable, and easy to understand.

---

## 🚀 Features Implemented

### 1. EventList Screen
- Displays a paginated list of events fetched from the API.
- Includes event image, name, date, and ticket price.
- Supports **pull-to-refresh** to reload the list.
- Integrated **search bar**:
  - Filters events locally once user types 3+ characters.
  - Restores the full list on cancel.
- Uses **image caching** to reduce redundant network calls.

### 2. Event Details Screen
- Displays complete event details:
  - Event name, description, date.
  - Multiple event images (gallery-style).
  - Category, ticket price, attendee count, and organizer email.
- Layout optimized to fit neatly within the screen (no scrolling needed unless required).
- Attractive card-style design with bold section titles.

### 3. Event Map Screen
- All events with coordinates are plotted as markers on a **MapKit** map.
- Selecting a marker shows an **event detail card** at the bottom.
- **Swipe gestures** on the card:
  - Swipe left → Previous event.
  - Swipe right → Next event.
- Includes a **Close button** (top-right corner) to dismiss the map.
- Smooth map animation centers on the selected event.

---

## 🏗️ Architecture & Project Structure
The project follows the **MVVM (Model–View–ViewModel)** pattern.

```
Event_Management_Task/
│
├── Models/          # Codable models for API responses
├── ViewModels/      # Business logic & state management
├── Views/           # SwiftUI UI screens (List, Detail, Map, Components)
├── Services/        # APIService for network calls
└── Utilities/       # Helpers (e.g., caching)
```

- **Models**: Represent API data (`Event`, `EventListResponse`, `EventDetailResponse`).
- **ViewModels**: Handle data fetching, search, refresh, and pagination.
- **Views**:
  - `EventListView` → Discover screen with search & refresh.
  - `EventDetailView` → Detailed info for a single event.
  - `EventMapView` → Interactive map with swiping between events.
  - `EventRowView`, `EventCardView` → Reusable UI components.
- **Services**: `APIService` handles network requests with async/await and error handling.

---

## 📡 API Integration
- Events fetched from `http://18.208.147.119/events` (and details by ID).
- Supports optional query parameters:
  - `search` → filter by event name.
  - `event_category_id`, `start_date`, `end_date` → available for extensions.
- Network layer uses **URLSession** with `async/await`.
- JSON parsing via **Swift Codable models**.

---

## 📱 Requirements
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

---

## ▶️ How to Run
1. Clone the repository or unzip the project.
2. Open `Event_Management_Task.xcodeproj` in Xcode.
3. Run on iOS Simulator or device (iOS 16+).

---

## ✨ Highlights
- Clean, minimalistic **SwiftUI UI**.
- **Local search filter** (after 3 characters).
- **Pull-to-refresh** integrated.
- **MapKit integration** with swipe gestures.
- **Image caching** for efficiency.
- MVVM structure for maintainability.
