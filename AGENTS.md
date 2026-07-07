# 🕵️‍♂️ System Agents & External Integrations

This document outlines the external agents and third-party services integrated into QuickMart. Each "agent" is a service that performs work on behalf of the application — fetching data, authenticating users, processing payments, or generating AI content.

---

## 1. 🛍️ Shopify Agent (Core E-Commerce Engine)

- **Role:** The primary backend powering the entire e-commerce experience — product catalog, collections, cart management, checkout, and order history.
- **Technology:** Shopify **Storefront GraphQL API** via `Apollo iOS`.
- **Client:** `GraphQLClient` — a custom wrapper around `ApolloClient` supporting typed queries and mutations with Swift Concurrency (`async/await`).
- **Authentication:** `TokenInterceptor` injects the Storefront Access Token (`X-Shopify-Storefront-Access-Token`) and customer session token (`X-Shopify-Customer-Access-Token`) into every outgoing request automatically.
- **Cache Strategy:** `returnCacheDataElseFetch` — serves cached data instantly while refreshing in the background.
- **Configuration:** All keys and URLs are stored in `Info.plist` (injected via `xcconfig`) and accessed through `ShopifyConfig`.

### Capabilities Powered by Shopify

| Feature                | GraphQL Operations                              |
|------------------------|-------------------------------------------------|
| Product Browsing       | Fetch products, collections, brands, categories |
| Product Details        | Get product by ID with variants and options     |
| Search                 | Full-text search with predictive suggestions    |
| Cart                   | Create/update cart, add/remove line items       |
| Checkout               | Create checkout, associate customer, complete   |
| Customer               | Create customer account, recover password       |
| Order History          | Fetch customer orders with line items           |

---

## 2. 🔐 Firebase Auth Agent (Identity Management)

- **Role:** Handles all user authentication flows — registration, login, guest access, and password recovery.
- **Technology:** Firebase Authentication SDK (`FirebaseAuth`).
- **Service:** `FirebaseAuthService` conforming to `FirebaseAuthServiceProtocol` — fully protocol-oriented for testability.
- **Supported Flows:**

| Flow                | Method                                          | Description                              |
|---------------------|-------------------------------------------------|------------------------------------------|
| Email/Password      | `signUp(email:password:)` / `signIn(email:password:)` | Standard registration & login     |
| Guest Browsing      | `signInAnonymously()`                           | Anonymous Firebase user (cart-capable)    |
| Password Recovery   | Shopify `customerRecover` mutation              | Sends reset link to customer's email     |
| Sign Out            | `signOut()`                                     | Clears session + revokes Shopify token   |

- **Session Management:** `SessionManager.shared` observes Firebase auth state and publishes `AppState` (`.loading` → `.unauthenticated` → `.guest` / `.loggedIn`). This drives the root UI — `RootView` reactively switches between Onboarding, Login, or MainTab.

---

## 3. 💰 CurrencyFreaks Agent (Multi-Currency Localization)

- **Role:** Fetches real-time exchange rates to enable dynamic multi-currency pricing throughout the app.
- **Technology:** REST API via `RestClient` (custom `URLSession`-based client with `async/await`).
- **Data Source:** `CurrencyRemoteDataSource` → calls the CurrencyFreaks `/rates/latest` endpoint.
- **Service:** `CurrencyManagerService` (`@EnvironmentObject`) — loaded once at app launch, provides:
  - `format(defultAppCurrency:)` — Converts USD prices to selected currency with locale-aware formatting.
  - `convert(amount:)` — Raw numeric conversion (used for Apple Pay amount calculation).
- **Optimization Strategy:** API is called **only once on launch** and **only if the user selected a non-USD currency** — minimizing network overhead.
- **Persistence:** Selected currency is stored in `@AppStorage("selectedCurrency")` for instant restore on next launch.

---

## 4. 🤖 Google Gemini Agent (AI-Powered Shopping)

- **Role:** Powers all AI features in the app — conversational shopping assistant, product comparison, image-based search, outfit generation, and shopping insights.
- **Technology:** Google Gemini API (`gemini-3.5-flash` model) via raw HTTP REST calls.
- **Client:** `GeminiAPIClient` conforming to `GeminiAPIClientProtocol` — built with:
  - **Rate Limiting:** Thread-safe throttling (4-second minimum interval between requests) to stay within free-tier RPM limits (~15 RPM).
  - **Retry Logic:** Automatic single retry on `429 Too Many Requests` with a 10-second backoff.
  - **Image Compression:** `compressImageForAI()` resizes images to max 512px and re-encodes at 60% JPEG quality before base64 encoding — reducing a 2MB photo to ~30-50KB.
- **Repository:** `AIRepositoryImpl` wraps the client and provides prompt engineering for each use case.

### AI Features

| Feature              | Use Case                   | Model Used    | Max Tokens | Description                                     |
|----------------------|----------------------------|---------------|------------|-------------------------------------------------|
| 💬 Shopping Chat     | `SendChatMessageUseCase`   | `gemini-3.5-flash` | 700   | Conversational assistant with 6-message context window |
| ⚖️ Product Compare   | `CompareProductsUseCase`   | `gemini-3.5-flash` | 1024  | Side-by-side analysis with final recommendation  |
| 📸 Image Search      | `SearchByImageUseCase`     | `gemini-3.5-flash` | 30    | Extracts 2-5 word search query from photo        |
| 👗 Outfit Generator  | `GenerateOutfitUseCase`    | `gemini-3.5-flash` | 800   | 3-4 complementary pieces based on selected item  |
| 📊 Shopping Insights | `GenerateInsightsUseCase`  | `gemini-3.5-flash` | 1000  | Spending patterns analysis from order history    |

### Error Handling

`AIError` enum provides user-friendly messages for all failure modes:

| Case             | Description                           |
|------------------|---------------------------------------|
| `.invalidURL`    | Malformed Gemini endpoint             |
| `.requestFailed` | Non-2xx HTTP status                   |
| `.emptyResponse` | Model returned no content             |
| `.decodingFailed` | Response structure mismatch          |
| `.rateLimited`   | 429 persisted after retry             |

---

## 5. 💳 Apple Pay Agent (Payment Processing)

- **Role:** Provides native Apple Pay checkout experience for seamless, secure payments.
- **Technology:** PassKit framework via `ApplePayService` conforming to `ApplePayServiceProtocol`.
- **Integration:** `RequestApplePayPaymentUseCase` handles the payment sheet presentation and processes the authorization result.
- **Currency-Aware:** Uses `CurrencyManagerService.convert(amount:)` to submit the correct amount in the user's selected currency.

---

## 6. 📦 Core Data Agent (Local Persistence)

- **Role:** Manages offline-first data storage for the Wishlist / Favorites feature.
- **Technology:** Apple Core Data framework with `NSPersistentContainer`.
- **Entity:** `FavouriteProductEntity` stores product snapshots (id, title, image URL, price, vendor).
- **Scoping:** Per-user favorites via `SessionManager.currentUserId` — each Firebase user (including anonymous/guest) has isolated favorites.
- **Architecture:** `FavoriteLocalDataSourceImpl` → `FavoriteRepositoryImpl` → `FavoriteUseCases` — follows the same Clean Architecture pattern.

---

## 7. ☁️ Supabase Storage Agent (File Hosting)

- **Role:** Handles user-generated content uploads, specifically profile avatars.
- **Technology:** Supabase Storage REST API.
- **Service:** `SupabaseStorageService` — simple URLSession-based network client.
- **Configuration:** Keys stored in `SupabaseConfig`.
- **Integration:** `UploadProfileImageUseCase` processes image data, uploads to the `avatars` bucket, and returns a public URL.

---

## 🔄 Agent Interaction Map

```
┌──────────────┐          ┌──────────────┐
│  Firebase    │◀── auth ──│              │
│  Auth Agent  │──────────▶│              │
└──────────────┘           │              │
                           │   QuickMart  │
┌──────────────┐           │     App      │
│   Shopify    │◀─ GraphQL─│              │
│   Agent      │──────────▶│              │
└──────────────┘           │              │
                           │              │
┌──────────────┐           │              │
│ CurrencyFreaks│◀── REST ─│              │
│   Agent      │──────────▶│              │
└──────────────┘           │              │
                           │              │
┌──────────────┐           │              │
│   Gemini     │◀── REST ─ │              │
│   AI Agent   │──────────▶│              │
└──────────────┘           │              │
                           │              │
┌──────────────┐           │              │
│  Apple Pay   │◀─ PassKit─│              │
│   Agent      │──────────▶│              │
└──────────────┘           │              │
                           │              │
┌──────────────┐           │              │
│  Core Data   │◀── local ─│              │
│   Agent      │──────────▶│              │
└──────────────┘           │              │
                           │              │
┌──────────────┐           │              │
│  Supabase    │◀── REST ─ │              │
│Storage Agent │──────────▶│              │
└──────────────┘           └──────────────┘
```
