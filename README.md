# 🎬 MovieApp

A modern iOS application for browsing and viewing movie details, built with **Clean MVVM Architecture**, **Combine** for reactive programming. The app prioritizes offline-first behavior with a robust caching mechanism using **Core Data**.

---

## 🚀 Technologies Used

- **Swift 5.10+**: Modern, type-safe programming language.
- **iOS 13+**: Minimum deployment target for broad compatibility.
- **UIKit**: For building the user interface and navigation.
- **Combine**: Reactive programming for state management and data binding.
- **Core Data**: Local persistence for offline caching.
- **URLSession**: Networking layer for remote API requests.
- **Dependency Injection**: Ensures decoupled, testable components.

---

## 🏗️ Architecture

The app follows **Clean MVVM** principles to ensure modularity, testability, and maintainability:

- **Domain Layer**:
  - **Entities**: Core business models (`MovieEntity`, `MoviesListEntity`) representing pure data.
  - **Use Cases**: Business logic encapsulation (e.g., `FetchMoviesUseCase`) for reusable application logic.

- **Data Layer**:
  - **Repository**: Implements `MoviesRepositoryProtocol` to coordinate data from remote and local sources.
  - **Data Sources**:
    - `MoviesRemoteDataSource`: Handles API requests.
    - `MoviesLocalDataSource`: Manages Core Data read/write operations.

- **Presentation Layer**:
  - **ViewModels**: `MoviesListViewModel`, `MovieDetailsViewModel` manage state, side effects, and data binding.
  - **ViewControllers**: `MoviesListViewController`, `MovieDetailsViewController` use UIKit and subscribe to ViewModel state publishers.

---

## 🔄 UI State Management

Each ViewModel exposes a single `Publisher<ViewState>` as the source of truth for its screen's UI state. The state is represented as an `enum`:

```swift
enum MoviesListViewState {
    case loading
    case success([MovieEntity])
    case error(AppError)
    case empty
}
```

- **ViewController Behavior**:
  - `.loading`: Displays an activity indicator.
  - `.success`: Renders the movie list.
  - `.error`: Shows an error UI with retry option.
  - `.empty`: Displays an empty state UI.

**Benefits**:
- Single source of truth per screen.
- Unidirectional Data Flow (UDF) for predictable state changes.
- Loosely coupled, testable ViewModels.

---

## 💾 Offline-First Caching

The app leverages **Core Data** for a seamless offline-first experience:

- **Initial Fetch Flow**:
  1. Repository loads cached movies from Core Data.
  2. If cache exists, data is returned immediately for fast UI rendering.
 
- **Remote Response Handling**:
  - On success, Core Data is updated with new results (page-based replacement).
  - Updated cache triggers a ViewModel update, refreshing the UI.
  - On failure, cached data serves as a fallback, ensuring usability without network connectivity.

---

## 📱 Features

- **Browse Movies**: Paginated list of movies with smooth scrolling.
- **Movie Details**: View poster, backdrop, rating, release date, and overview.
- **Favorites**: Mark/unmark movies as favorites, persisted locally.
- **Offline Support**: Core Data caching ensures functionality without network.
- **Reactive UI**: Combine-driven, enum-based state management for responsive interfaces.
- **Dark Mode Support**: Fully adaptive UI that seamlessly supports both light and dark appearances.
---

## 🛠️ Getting Started

1. **Prerequisites**:
   - Xcode 16.0+
   - iOS 13.0+ device/simulator
   - Swift Package Manager for dependencies (if any)

2. **Setup**:
   ```bash
   git clone <repository-url>
   cd MovieApp
   open MovieApp.xcodeproj
   ```

3. **Run**:
   - Build and run the project in Xcode.
 
---
 
