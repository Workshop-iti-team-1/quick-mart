# 🌐 The Agent / Network Layer

## Overview

The Network Layer is the backbone of QuickMart's data communication. It is responsible for **all external HTTP interactions** — from fetching products via Shopify's GraphQL API to converting currencies via REST and generating AI content via Google Gemini. The layer is designed to be **protocol-oriented**, **modular**, and **highly testable** — every component has a protocol counterpart that can be swapped with a mock at test time.

---

## 🏗️ Core Components

### 1. `GraphQLClient` — Shopify API Gateway

The primary client for all Shopify Storefront API operations. Built as a wrapper around **Apollo iOS** with full Swift Concurrency support.

```
GraphQLClient
├── performQuery<Query>()     → Fetches data (products, collections, orders)
└── performMutation<Mutation>() → Modifies data (cart, checkout, customer)
```

**Key Implementation Details:**
- **Protocol:** `ShopifyGraphQLClientProtocol` — defines the contract with default cache policy (`returnCacheDataElseFetch`).
- **Cache:** Apollo's in-memory cache serves instant results while background-refreshing from network.
- **Concurrency:** Uses `withCheckedThrowingContinuation` to bridge Apollo's completion-handler API to `async/await`.
- **Error Mapping:** Apollo errors → `NetworkError.graphQLErrors([GraphQLError])` for consistent upstream handling.

### 2. `TokenInterceptor` — Authentication Middleware

An Apollo `ApolloInterceptor` that **automatically injects authentication headers** into every outgoing request:

```swift
// Headers injected on every request:
"X-Shopify-Storefront-Access-Token" → ShopifyConfig.storefrontToken  // Always present
"X-Shopify-Customer-Access-Token"   → SessionManager.getToken()      // When logged in
"Content-Type"                      → "application/json"
```

This interceptor is inserted at position `0` in the interceptor chain via `NetworkInterceptorProvider`, ensuring tokens are attached before any other processing.

### 3. `RestClient` — Generic REST Gateway

A lightweight, generic API client built on Swift's modern `URLSession` with `async/await`. Used for non-GraphQL endpoints.

```swift
protocol RestClientProtocol {
    func request<T: Decodable>(baseUrl: String, endpoint: String) async throws -> T
}
```

**Key Features:**
- **Generic Decoding:** Automatically decodes JSON responses into any `Decodable` type.
- **Status Validation:** Returns `NetworkError.requestFailed(statusCode:data:)` for non-2xx responses.
- **Error Classification:** Separates `DecodingError` → `NetworkError.decodingFailed` from transport errors.
- **Current Usage:** Powers the `CurrencyRemoteDataSource` for exchange rate fetching from CurrencyFreaks API.

### 4. `GeminiAPIClient` — AI Communication Layer

A specialized HTTP client for Google Gemini's generative AI API with built-in resilience features.

```
GeminiAPIClient
├── generate(prompt:imageData:model:maxTokens:)  → Main API
├── throttleIfNeeded()                            → Rate limiter
├── buildRequest()                                → Request constructor
├── executeWithRetry()                            → 429 retry handler
└── decodeResponse()                              → GeminiResponse decoder
```

**Resilience Features:**
| Feature                | Implementation                                              |
|------------------------|-------------------------------------------------------------|
| **Rate Limiting**      | Thread-safe throttling via `NSLock`, 4-second min interval  |
| **Retry on 429**       | Single retry after 10-second backoff                        |
| **Image Compression**  | 512px resize + 60% JPEG quality (2MB → ~30-50KB)           |
| **Token Optimization** | Per-feature `maxTokens` limits (30 for image search → 1024 for comparison) |

### 5. `SupabaseStorageService` — File Upload Layer

A dedicated service to handle uploading files (like user avatars) to Supabase Storage via its REST API.

```
SupabaseStorageService
└── uploadImage(imageData:) → Compresses and POSTs image to /storage/v1/object/avatars/
```

**Key Features:**
- **UUID Generation:** Automatically assigns a unique filename to every uploaded image.
- **Content-Type Handling:** Uploads as `image/jpeg` with appropriate compression.
- **Authorization:** Injects the `anonKey` directly as the `apikey` and `Authorization` bearer token.
- **URL Generation:** Constructs and returns the public, accessible URL for the uploaded file upon success.
- **Configuration:** Keys are loaded safely via `ShopifyConfig.SupabaseConfig`.

### 6. `ShopifyConfig` — Centralized Configuration

All API keys, URLs, and tokens are read from `Info.plist` (populated by `.xcconfig` files at build time):

| Key                    | Source                    | Purpose                    |
|------------------------|---------------------------|----------------------------|
| `STORE_URL`            | `Config.local.xcconfig`   | Shopify Storefront GraphQL endpoint |
| `ADMIN_STORE_URL`      | `Config.local.xcconfig`   | Shopify Admin API endpoint |
| `STOREFRONT_TOKEN`     | `Config.local.xcconfig`   | Public Storefront access token |
| `API_KEY`              | `Config.local.xcconfig`   | Shopify API key            |
| `API_SECRET_KEY`       | `Config.local.xcconfig`   | Shopify API secret         |
| `ADMIN_TOKEN`          | `Config.local.xcconfig`   | Admin API access token     |
| `GEMINI_API_KEY`       | `Config.local.xcconfig`   | Google Gemini API key      |
| `CURRENCY_API_KEY`     | `Config.local.xcconfig`   | CurrencyFreaks API key     |
| `CURRENCY_BASE_URL`    | `Config.local.xcconfig`   | CurrencyFreaks base URL    |
| `SUPABASE_PROJECT_URL` | `Config.local.xcconfig`   | Supabase project URL       |
| `SUPABASE_ANON_KEY`    | `Config.local.xcconfig`   | Supabase public anon key   |
| `SUPABASE_BUCKET_NAME` | `Config.local.xcconfig`   | Supabase storage bucket    |

> **Security:** `Config.local.xcconfig` is `.gitignore`'d — secrets never reach version control.

---

## 🚨 Error Handling (`NetworkError`)

A **unified `enum`** that centralizes all network-related errors across the entire app. This ensures the Presentation Layer (ViewModels) handles errors **consistently**, regardless of whether the error originated from a REST call, a GraphQL mutation, or a Shopify user validation error.

```swift
public enum NetworkError: LocalizedError {
    case invalidURL
    case encodingFailed(Error)
    case requestFailed(statusCode: Int, data: Data?)
    case decodingFailed(Error)
    case graphQLErrors([GraphQLError])    // Apollo-level query/mutation errors
    case userErrors([ShopifyUserError])   // Shopify business validation errors
    case noData
    case unauthorized
    case rateLimited
}
```

Every case maps to a **localized, user-friendly message** via `AppStrings.Network.*` — no raw error strings ever reach the UI.

### AI-Specific Errors (`AIError`)

The Gemini layer has its own `AIError` enum for AI-specific failure modes:

```swift
enum AIError: LocalizedError {
    case invalidURL        // Malformed Gemini endpoint
    case requestFailed     // Non-2xx HTTP status
    case emptyResponse     // Model returned no content
    case decodingFailed    // Response structure mismatch
    case rateLimited       // 429 persisted after retry
}
```

---

## 🔄 Data Flow

Here's the complete data flow for a typical network request (e.g., "Fetch Products on Home Screen"):

```
1. HomeView.onAppear()
       │
2. HomeViewModel.loadBanners()
       │
3. FetchBannersUseCase.execute()              ← Domain layer (pure Swift)
       │
4. HomeRepositoryProtocol.fetchBanners()      ← Domain protocol
       │
5. HomeRepositoryImpl.fetchBanners()          ← Data layer
       │
6. HomeRemoteDataSource.fetchBanners()
       │
7. GraphQLClient.performQuery(query:)
       │
8. TokenInterceptor → injects auth headers
       │
9. Apollo → HTTP → Shopify Storefront API
       │ (response)
10. GraphQL Data → DTO → mapped to Domain Entity
       │
11. Returned up: UseCase → ViewModel → @Published
       │
12. SwiftUI detects change → re-renders view
```

### Currency Conversion Flow

```
1. App Launch → QuickMartApp.task { currencyManager.loadRatesIfNeeded() }
       │
2. CurrencyManagerService checks: is selectedCurrency != "USD"?
       │ (yes)
3. GetCurrencyRatesUseCase.execute()
       │
4. CurrencyRepositoryImpl → CurrencyRemoteDataSource
       │
5. RestClient.request(baseUrl:endpoint:) → CurrencyFreaks API
       │ (response)
6. CurrencyResponseDTO → CurrencyRateEntity → stored in @Published rates
       │
7. Any view calls currencyManager.format(price) → localized formatted string
```

### AI Request Flow

```
1. User sends message in ChatView
       │
2. ChatViewModel.send(message:)
       │
3. SendChatMessageUseCase.execute(history:message:)
       │
4. AIRepositoryImpl.sendChat() → constructs prompt with catalog context
       │
5. GeminiAPIClient.generate(prompt:imageData:model:maxTokens:)
       │
6. throttleIfNeeded() → ensures 4s spacing
       │
7. buildRequest() → POST to Gemini REST API
       │
8. executeWithRetry() → handles 429 with 10s backoff
       │
9. decodeResponse() → extracts text from GeminiResponse
       │
10. String → ViewModel → @Published → SwiftUI renders bubble
```

---

## 📁 File Structure

```
Core/Network/
├── GraphQLClient.swift                 ← Apollo wrapper (query + mutation)
├── ShopifyGraphQLClientProtocol.swift  ← Protocol with default cache policy
├── RestClient.swift                    ← Generic REST client
├── RestClientProtocol.swift            ← REST protocol for DI
├── NetworkError.swift                  ← Unified error enum + GraphQLError + ShopifyUserError
├── Network.swift                       ← Network utilities
├── Apollo+NetworkError.swift           ← Apollo error mapping extension
├── ShopifyConfig.swift                 ← Centralized API configuration
└── ShopifyAPI/                         ← Auto-generated Apollo schema
    ├── Schema/                         ← GraphQL types, enums, objects
    ├── Operations/                     ← Query & Mutation definitions
    └── ShopifyAPI.graphql.swift        ← Entry point

Core/AI/
├── AIConfig.swift                      ← Gemini model names + API key
├── GeminiAPIClient.swift               ← HTTP client with throttling + retry
├── GeminiAPIClientProtocol.swift       ← Protocol + AIError enum
├── AIRepositoryProtocol.swift          ← Domain contract for AI features
├── AIRepositoryImpl.swift              ← Prompt engineering + image compression
├── Data/Models/                        ← GeminiResponse, AI result DTOs
├── Domain/                             ← UseCases + AIMessage model
└── Presentation/                       ← AI Views + ViewModels
```

---

## 🔐 Security Considerations

| Concern                    | Solution                                                   |
|----------------------------|------------------------------------------------------------|
| API Keys in source control | All keys live in `Config.local.xcconfig` (`.gitignore`'d)  |
| Token injection            | `TokenInterceptor` handles auth headers automatically      |
| Customer token storage     | Stored in `UserDefaults` (adequate for mobile session)      |
| Image data in AI requests  | Compressed + base64 encoded; sent via HTTPS                |
| Rate limit protection      | Client-side throttling + server 429 retry with backoff     |
