# 🛍️ QuickMart

> A premium native **iOS e-commerce application** built with **SwiftUI**, powered by **Shopify Storefront GraphQL API**, and enhanced with **Google Gemini AI** for intelligent shopping experiences.

[![Platform](https://img.shields.io/badge/Platform-iOS%2017+-blue.svg)]()
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)]()
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20+%20MVVM-green.svg)]()
[![Backend](https://img.shields.io/badge/Backend-Shopify%20GraphQL-96bf48.svg)]()
[![AI](https://img.shields.io/badge/AI-Google%20Gemini-4285F4.svg)]()

---

## ✨ Features

### 🛒 Core Shopping Experience
| Feature | Description |
|---------|-------------|
| **Home Feed** | Dynamic banners, categories grid, featured brands carousel |
| **Product Details** | Image gallery, variant/option selector, quantity picker, ratings |
| **Smart Search** | Full-text search with predictive suggestions, brand/category/price filters, and sort options |
| **Cart Management** | Add/remove items, update quantities, real-time totals |
| **Checkout** | Address selection, order summary, Apple Pay integration |
| **Wishlist** | Offline-first favorites stored in Core Data (per-user scoped) |
| **Multi-Currency** | Dynamic pricing with real-time exchange rates (CurrencyFreaks API) |

### 🤖 AI-Powered Features (Google Gemini)
| Feature | Description |
|---------|-------------|
| **💬 Shopping Chat** | Conversational AI assistant grounded in your catalog |
| **⚖️ Product Compare** | Side-by-side AI analysis with final recommendation |
| **📸 Image Search** | Snap a photo → AI extracts search terms → finds matching products |
| **👗 Outfit Generator** | AI-suggested complete outfits based on a selected item |
| **📊 Shopping Insights** | AI-driven spending patterns and purchase analysis |

### 🔐 Authentication & Profile
| Feature | Description |
|---------|-------------|
| **Email/Password** | Registration & login via Firebase Authentication |
| **Guest Browsing** | Anonymous Firebase user with full cart capability |
| **Password Recovery** | Reset link via Shopify customer recovery |
| **Profile** | Customer info, order history, address book, settings |
| **Dark Mode** | System-wide theme toggle persisted in UserDefaults |

---

## 🏗️ Architecture

The project follows a **feature-based modular architecture** with **Clean Architecture** internally and **MVVM** in the presentation layer:

```
QuickMart/
├── 📱 App/                     ← Entry point & root orchestration
│   ├── QuickMartApp.swift      ← @main, Firebase config, environment injection
│   ├── RootView.swift          ← Auth-state driven root
│   └── MainTabView.swift       ← 5-tab container
│
├── ⚙️ Core/                    ← Shared foundation
│   ├── AI/                     ← Gemini AI features (own Data/Domain/Presentation)
│   ├── Components/             ← 9 reusable UI components
│   ├── DI/                     ← DIContainer + domain extensions
│   ├── Network/                ← GraphQL + REST clients
│   ├── Route/                  ← Centralized AppRouter + Route enum
│   ├── Services/                ← Firebase Auth, Currency
│   ├── theme/                  ← Design tokens (colors, typography)
│   └── Utilities/               ← Localization, session, constants
│
└── 📦 Modules/                 ← Feature modules
    ├── Authentication/         ├── Home/
    ├── Search/                 ├── Cart/
    ├── Checkout/               ├── Wishlist/
    ├── Profile/                ├── Address/
    ├── Onboarding/             └── Common/
```

Each module internally follows: **`Data → Domain ← Presentation`**

> 📖 See [DESIGN.md](DESIGN.md) for the complete design system, DI architecture, and state management details.

---

## 🛠️ Tech Stack

| Category           | Technology                                     |
|--------------------|------------------------------------------------|
| **UI Framework**   | SwiftUI (100% native, zero UIKit views)        |
| **Architecture**   | Clean Architecture + MVVM                      |
| **API**            | Shopify Storefront GraphQL API                 |
| **GraphQL Client** | Apollo iOS                                     |
| **Authentication** | Firebase Authentication                        |
| **AI Engine**      | Google Gemini API (`gemini-3.5-flash`)          |
| **Currency**       | CurrencyFreaks REST API                        |
| **Payments**       | Apple Pay (PassKit)                            |
| **Storage**        | Supabase Storage API                           |
| **Local Storage**  | Core Data (Wishlist) + UserDefaults (Prefs)    |
| **DI**             | Custom native DIContainer (manual, no libs)    |
| **Navigation**     | Centralized AppRouter + NavigationPath         |
| **Code Gen**       | Apollo CLI (GraphQL schema → Swift types)      |

> 📖 See [AGENTS.md](AGENTS.md) for a deep dive into each external service integration.

---

## 📋 Requirements

| Requirement     | Version     |
|-----------------|-------------|
| **Xcode**       | 15.0+       |
| **iOS Target**  | 17.0+       |
| **Swift**       | 5.9+        |
| **macOS**       | Sonoma 14+  |

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-org/quick-mart.git
cd quick-mart
```

### 2. Configure API keys

Create `QuickMart/App/Config.local.xcconfig` (`.gitignore`'d for security):

```ini
// Shopify
STORE_URL = https://your-store.myshopify.com/api/2024-10/graphql.json
ADMIN_STORE_URL = https://your-store.myshopify.com/admin/api/2024-10/graphql.json
STOREFRONT_TOKEN = your-storefront-access-token
API_KEY = your-api-key
API_SECRET_KEY = your-api-secret
ADMIN_TOKEN = your-admin-token

// Google Gemini
GEMINI_API_KEY = your-gemini-api-key

// CurrencyFreaks
CURRENCY_API_KEY = your-currency-api-key
CURRENCY_BASE_URL = https://api.currencyfreaks.com/v2.0

// Supabase
SUPABASE_PROJECT_URL = https://your-project.supabase.co
SUPABASE_ANON_KEY = your-anon-key
SUPABASE_BUCKET_NAME = your-bucket-name
```

### 3. Firebase setup

- Place your `GoogleService-Info.plist` in `QuickMart/`.
- Enable **Email/Password** and **Anonymous** sign-in in [Firebase Console](https://console.firebase.google.com/).

### 4. Install dependencies

Open `QuickMart.xcodeproj` in Xcode — Swift Package Manager will auto-resolve:

| Package               | Purpose               |
|-----------------------|-----------------------|
| `Apollo`              | GraphQL client        |
| `Firebase`            | Authentication        |
| `GoogleGenerativeAI`  | Gemini AI SDK         |

### 5. Build & Run

```
Xcode → Select Simulator → ⌘R
```

---

## 📁 Documentation

| Document                                  | Description                                               |
|-------------------------------------------|-----------------------------------------------------------|
| 🎨 [DESIGN.md](DESIGN.md)                | System design, architecture, DI, state management, design system |
| 🕵️ [AGENTS.md](AGENTS.md)               | External integrations: Shopify, Firebase, Gemini, Apple Pay |
| 🌐 [Layers/AGENTS.md](Layers/AGENTS.md)  | Network layer deep-dive: clients, error handling, data flows |
| 📏 [.agents/AGENTS.md](.agents/AGENTS.md) | Development rules & conventions for AI agents             |

---

## 🎨 Coding Conventions at a Glance

```swift
// ✅ Colors — use static properties
Text("Hello").foregroundColor(.cyanPrimary)

// ❌ Never use string-based colors
Text("Hello").foregroundColor(Color("cyanPrimary"))

// ✅ Typography — use AppTextStyle modifier
Text("Title").appTextStyle(.heading1, color: .appBlack)

// ❌ Never use system fonts
Text("Title").font(.title)

// ✅ Strings — use AppStrings
Text(AppStrings.Auth.login)

// ❌ Never hardcode
Text("Login")

// ✅ Navigation — use AppRouter
router.push(.productDetails(productId: "123"))

// ❌ Never use NavigationLink directly
NavigationLink("Details") { ProductDetailsView() }
```

---

## 👥 Team

- Ahmed El Sayyad (siam)
- Alaa Ayman
- Mina Wagdy
- Ibrahim Siam

---

## 📄 License

This project is developed as part of the **ITI (Information Technology Institute) — JETS Mobile Lab** iOS development program.
