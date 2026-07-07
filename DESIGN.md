# 🎨 System Design & Architecture

## 📱 UI/UX Philosophy

QuickMart is designed as a **modern, premium e-commerce experience** built with 100% native **SwiftUI**. The design philosophy prioritizes clarity, speed, and a polished aesthetic that inspires trust and engagement.

- **Visual Style:** Adaptive Light/Dark theme system with a curated color palette anchored by a **Cyan primary accent** (`cyanPrimary`) against clean backgrounds (`backGround`). All 18+ color tokens defined in `Assets.xcassets` with both appearance variants.
- **Typography:** Unified type scale using `SF Pro` through 7 custom `AppTextStyle` levels — from `.heading1` (28pt Bold) for screen titles down to `.caption` (12pt Regular) for subtle hints — enforced via a single `.appTextStyle()` ViewModifier. No system font shortcuts allowed.
- **Navigation:** Custom floating `CustomTabBar` with 5 tabs (**Home**, **Search**, **Cart**, **Wishlist**, **Profile**) powered by a centralized `AppRouter` using SwiftUI's `NavigationPath` for type-safe, programmatic routing.
- **Components:** 9 battle-tested reusable components (`AppButton`, `CustomTextField`, `ProductCard`, `FavoriteButton`, `SectionHeader`, `CustomLoadingView`, `CheckboxRowView`, `CollapsibleFilterSection`, `CustomToolbar`) — each built as self-contained, themeable building blocks.

---

## 🏗️ Architectural Pattern: Clean Architecture + MVVM

The project strictly follows **Clean Architecture** to ensure separation of concerns, testability, and scalability. Every feature module is internally divided into three layers with a strict dependency rule:

```
┌────────────────────────────────────────────────────────────┐
│                    Presentation Layer                      │
│  SwiftUI Views + @MainActor ViewModels (ObservableObject)  │
│  Depends on: Domain only                                   │
└──────────────────────┬─────────────────────────────────────┘
                       │ calls UseCases
┌──────────────────────▼─────────────────────────────────────┐
│                      Domain Layer                          │
│  Entities, UseCaseProtocols, RepositoryProtocols           │
│  Depends on: NOTHING (zero framework imports)              │
└──────────────────────▲─────────────────────────────────────┘
                       │ implements protocols
┌──────────────────────┴─────────────────────────────────────┐
│                       Data Layer                           │
│  RemoteDataSources, DTOs, Mappers, RepositoryImpl          │
│  Depends on: Domain only                                   │
└────────────────────────────────────────────────────────────┘
```

### Why Clean Architecture?

| Benefit          | How We Achieve It                                                              |
|------------------|--------------------------------------------------------------------------------|
| **Testability**  | Domain layer has zero dependencies — UseCases and Entities are pure Swift       |
| **Flexibility**  | Swap data sources (e.g., mock → Shopify) without touching Views or ViewModels   |
| **Scalability**  | Each module is self-contained; adding features doesn't affect existing modules   |
| **Readability**  | Clear folder structure (`Data/Domain/Presentation`) makes navigation intuitive  |

---

## 📦 Module Architecture

The app is organized into **feature-based modules**, each following the same Clean Architecture pattern:

```
QuickMart/
├── App/                        ← Entry point & root orchestration
│   ├── QuickMartApp.swift      ← @main, Firebase config, environment setup
│   ├── RootView.swift          ← Auth-state driven root (Onboarding → Login → MainTab)
│   ├── MainTabView.swift       ← Tab container reading from AppRouter.selectedTab
│   └── RootViewModel.swift     ← Cart badge count, global notifications
│
├── Core/                       ← Shared foundation (imported by all modules)
│   ├── AI/                     ← Gemini-powered AI features (own Data/Domain/Presentation)
│   ├── Components/             ← 9 reusable UI building blocks
│   ├── DI/                     ← DIContainer + per-domain extensions
│   ├── Network/                ← GraphQLClient, RestClient, Apollo interceptors
│   ├── Navbar/                 ← CustomTabBar + TabItem model
│   ├── Route/                  ← Route enum (40+ cases) + AppRouter
│   ├── Services/               ← Firebase Auth, Currency service
│   ├── theme/                  ← Color tokens + AppTextStyle
│   └── Utilities/              ← AppStrings, SessionManager, Constants
│
└── Modules/                    ← Feature modules
    ├── Authentication/         ← Login, Signup, Forgot Password
    ├── Home/                   ← Home feed, Brands, Categories, Product Details
    ├── Search/                 ← Full-text search, Predictive, Filters, Sort
    ├── Cart/                   ← Cart management (CRUD, quantity)
    ├── Checkout/               ← Order placement, Apple Pay
    ├── Wishlist/               ← Favorites (Core Data, per-user scoped)
    ├── Profile/                ← User profile, Orders, Settings, FAQs, Legal
    ├── Address/                ← Shipping address CRUD + country picker
    ├── Onboarding/             ← First-launch walkthrough
    └── Common/                 ← Shared domain logic (AddToCartUseCase)
```

---

## 💉 Dependency Injection

We implemented a **Native DI Container** (`DIContainer`) as a `@MainActor` singleton to manage all dependencies centrally. Views and ViewModels never instantiate their own dependencies — everything is injected via the container to maintain clean decoupling.

```swift
// Private assembly: build data-layer objects
private func makeCartRepository() -> CartRepository { ... }
private func makeCartUseCases() -> CartUseCases { ... }

// Public factory: expose only ViewModel constructors
func makeCartViewModel() -> CartViewModel {
    CartViewModel(useCases: makeCartUseCases())
}
```

### DI Extensions (Split by Domain)

| Extension                   | Wires                                    |
|-----------------------------|------------------------------------------|
| `DIContainer+Auth.swift`    | Login, Signup, ForgotPassword ViewModels |
| `DIContainer+Profile.swift` | Profile, OrderHistory ViewModels         |
| `DIContainer+Checkout.swift`| Checkout assembly                        |
| `DIContainer+Currency.swift`| Currency rates pipeline                  |
| `DIContainer+Network.swift` | GraphQL client singleton                 |

---

## 🗄️ State Management & Persistence

| Mechanism             | Scope                  | Usage                                                         |
|-----------------------|------------------------|---------------------------------------------------------------|
| `@EnvironmentObject`  | Global (App-wide)      | `SessionManager` (auth state), `CurrencyManagerService` (rates + formatting) |
| `@Environment`        | Global (App-wide)      | `AppRouter` (navigation state via `@Observable`)               |
| `@StateObject`        | View-scoped            | ViewModel lifecycle ownership inside views                     |
| `@Published`          | ViewModel-scoped       | Reactive UI state (loading, errors, data lists)                |
| `@AppStorage`         | UserDefaults           | `isDarkMode`, `selectedCurrency`, `hasSeenOnboarding`          |
| `UserDefaults`        | Lightweight prefs      | `customerAccessToken` (Shopify session)                        |
| `Core Data`           | Local database         | Wishlist / Favorites (`FavouriteProductEntity`, per-user scoped) |
| `Apollo Cache`        | In-memory              | GraphQL query cache (`returnCacheDataElseFetch` policy)        |

### Session State Machine

```
AppState: .loading → .unauthenticated → .guest / .loggedIn
                              ↑                       │
                              └── logout() ────────────┘
```

`SessionManager.shared` drives `RootView` to switch between `OnboardingView`, `LoginView`, or `MainTabView` reactively.

---

## 🎯 Design System Quick Reference

### Color Tokens

| Token                    | Light      | Dark       | Usage                   |
|--------------------------|------------|------------|-------------------------|
| `.backGround`            | `#FAFAFA`  | `#0A0A0F`  | Screen backgrounds      |
| `.cyanPrimary`           | Cyan       | Cyan       | Primary brand accent    |
| `.appBlack` / `.appWhite`| Black      | White      | High-contrast surfaces  |
| `.grey50/100/150`        | Grays      | Grays      | Neutral/secondary text  |
| `.appRed`                | Red        | Red        | Errors, destructive     |
| `.cardBackground`        | Light card | Dark card  | Card surfaces           |

### Typography Scale

| Style       | Size | Weight   | Use Case           |
|-------------|------|----------|--------------------|
| `.heading1` | 28pt | Bold     | Screen titles      |
| `.heading2` | 24pt | Bold     | Section titles     |
| `.heading3` | 20pt | Bold     | Sub-sections       |
| `.body`     | 14pt | Regular  | Body text          |
| `.button`   | 16pt | Semibold | Button labels      |
| `.label`    | 14pt | Medium   | Form labels        |
| `.caption`  | 12pt | Regular  | Hints, timestamps  |

### Component Catalog

| Component                  | Purpose                                      |
|----------------------------|----------------------------------------------|
| `AppButton`                | Primary CTA button with customizable padding |
| `CustomTextField`          | Text input with title label and secure mode  |
| `ProductCard`              | Product grid card (image, title, price, fav) |
| `FavoriteButton`           | Animated heart toggle                        |
| `SectionHeader`            | Title + "See All" navigation                 |
| `CustomLoadingView`        | Full-screen translucent loading overlay       |
| `CustomToolbar`            | Home screen navigation bar                   |
| `CheckboxRowView`          | Filter option with checkbox                  |
| `CollapsibleFilterSection` | Expandable/collapsible filter group           |
