# ShopEase

A full-stack e-commerce mobile application built with Flutter and a Node.js REST API backend.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter / Dart |
| State management | GetX (`get: ^4.6.6`) |
| Navigation | GetX named routes |
| Dependency injection | GetX `lazyPut` with `fenix: true` |
| Error handling | `dartz` — `Either<Failure, T>` |
| HTTP client | `http: ^1.2.1` |
| Image caching | `cached_network_image: ^3.4.1` |
| Local storage | `shared_preferences: ^2.2.3` |
| Payment | `flutter_stripe: ^10.2.0` (not yet wired) |
| Logging | `logger: ^2.4.0` |
| Backend | Node.js + Express.js |
| Auth | JWT (`jsonwebtoken`) + `bcryptjs` |

---

## Project Structure

```
e_commerce_app/
├── lib/
│   ├── main.dart                          ← App entry, GetMaterialApp, initDependencies()
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart            ← AppColors static constants
│   │   │   ├── app_theme.dart             ← AppTheme.lightTheme
│   │   │   ├── app_config.dart            ← AppConfig.baseUrl (backend URL)
│   │   │   └── app_endpoints.dart         ← AppEndpoints (all API path constants)
│   │   ├── errors/
│   │   │   └── failures.dart              ← Failure, ServerFailure, AuthFailure, NetworkFailure, PaymentFailure, NotFoundFailure
│   │   ├── routes/
│   │   │   ├── app_routes.dart            ← AppRoutes string constants
│   │   │   └── app_pages.dart             ← GetPage route list
│   │   └── utils/
│   │       └── app_logger.dart            ← appLogger (Logger instance, PrettyPrinter)
│   ├── domain/
│   │   ├── entities/                      ← Pure Dart, extend Equatable
│   │   │   ├── product_entity.dart
│   │   │   ├── category_entity.dart
│   │   │   ├── cart_item_entity.dart
│   │   │   └── user_entity.dart
│   │   ├── repositories/                  ← Abstract interfaces only
│   │   │   ├── product_repository.dart
│   │   │   ├── cart_repository.dart
│   │   │   ├── auth_repository.dart
│   │   │   └── payment_repository.dart
│   │   └── usecases/
│   │       ├── product_usecases.dart      ← GetAllProducts, GetFeatured, GetCategories, GetByCategory, Search, GetById
│   │       ├── cart_usecases.dart         ← GetCartItems, AddToCart, RemoveFromCart, UpdateQuantity, ClearCart
│   │       ├── auth_usecases.dart         ← Login, Register, Logout, ForgotPassword, ResetPassword
│   │       └── process_payment_usecase.dart
│   ├── data/
│   │   ├── models/                        ← Extend entities, add fromJson/toJson
│   │   │   ├── product_model.dart
│   │   │   ├── category_model.dart
│   │   │   └── user_model.dart
│   │   ├── datasources/
│   │   │   ├── product_datasource.dart    ← abstract ProductDataSource + ApiProductDataSource (HTTP)
│   │   │   └── auth_datasource.dart       ← abstract AuthDataSource + ApiAuthDataSource (HTTP + JWT)
│   │   └── repositories/
│   │       ├── product_repository_impl.dart
│   │       ├── cart_repository_impl.dart  ← In-memory cart state
│   │       ├── auth_repository_impl.dart  ← Holds _currentUser, clears token on logout
│   │       └── payment_repository_impl.dart ← Mock payment (Stripe not yet wired)
│   ├── di/
│   │   └── injection_container.dart       ← initDependencies() — all Get.lazyPut registrations
│   └── presentation/
│       ├── bindings/
│       │   ├── initial_binding.dart       ← AuthController + CartController (permanent)
│       │   ├── home_binding.dart          ← MainController + HomeController
│       │   ├── checkout_binding.dart      ← CheckoutController
│       │   ├── product_detail_binding.dart
│       │   └── forgot_password_binding.dart
│       ├── controllers/
│       │   ├── auth_controller.dart
│       │   ├── home_controller.dart
│       │   ├── cart_controller.dart
│       │   ├── checkout_controller.dart
│       │   ├── main_controller.dart
│       │   ├── product_detail_controller.dart
│       │   └── forgot_password_controller.dart
│       ├── pages/
│       │   ├── splash/splash_page.dart
│       │   ├── auth/
│       │   │   ├── login_page.dart
│       │   │   ├── register_page.dart
│       │   │   ├── forgot_password_page.dart
│       │   │   └── reset_password_page.dart
│       │   ├── main/main_page.dart        ← IndexedStack with bottom NavigationBar (4 tabs)
│       │   ├── home/home_page.dart
│       │   ├── search/search_page.dart
│       │   ├── products/product_detail_page.dart
│       │   ├── cart/cart_page.dart
│       │   ├── checkout/checkout_page.dart
│       │   └── profile/profile_page.dart
│       └── widgets/
│           ├── product_card_widget.dart
│           ├── category_chip_widget.dart
│           ├── banner_carousel_widget.dart
│           └── cart_item_widget.dart
├── backend/                               ← Node.js (local dev only)
├── android/
    └── app/src/main/AndroidManifest.xml  ← INTERNET permission + usesCleartextTraffic

```

---

## Architecture

ShopEase follows **Clean Architecture** with three layers:

```
Presentation  →  Domain  ←  Data
```

- **Domain** — pure Dart entities, abstract repository interfaces, and use cases. No Flutter or HTTP dependencies.
- **Data** — implements the domain interfaces. Models extend entities and add `fromJson`/`toJson`. Repository impls catch all exceptions and convert them to typed `Either<Failure, T>` values.
- **Presentation** — GetX controllers hold `Rx` observable state. Pages are `StatelessWidget`s that read from controllers via `Obx`.

The layers are wired together by `injection_container.dart` using GetX `lazyPut`.

---
## Routes

| Constant | Path | Page | Binding |
|---|---|---|---|
| `AppRoutes.splash` | `/` | `SplashPage` | `InitialBinding` |
| `AppRoutes.login` | `/login` | `LoginPage` | — |
| `AppRoutes.register` | `/register` | `RegisterPage` | — |
| `AppRoutes.forgotPassword` | `/forgot-password` | `ForgotPasswordPage` | `ForgotPasswordBinding` |
| `AppRoutes.resetPassword` | `/reset-password` | `ResetPasswordPage` | `ForgotPasswordBinding` |
| `AppRoutes.main` | `/main` | `MainPage` | `HomeBinding` |
| `AppRoutes.productDetail` | `/product-detail` | `ProductDetailPage` | `ProductDetailBinding` |
| `AppRoutes.checkout` | `/checkout` | `CheckoutPage` | `CheckoutBinding` |

`ProductDetailPage` receives its product via `Get.arguments as ProductEntity`.

---

## Backend

Located at `backend/` inside the project root. Committed to the repo — `node_modules/` and `.env` are gitignored.

### Running

```bash
cd backend
npm start        # production
npm run dev      # with nodemon (auto-restart)
```

Runs on **port 3000**.

### Endpoints

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/` | — | Health check |
| GET | `/api/products` | — | All 12 products |
| GET | `/api/products/featured` | — | Featured products |
| GET | `/api/products/search?q=` | — | Search by name/description |
| GET | `/api/products/category/:id` | — | Filter by category |
| GET | `/api/products/:id` | — | Single product |
| GET | `/api/categories` | — | All 6 categories |
| POST | `/api/auth/login` | — | `{email, password}` → `{token, user}` |
| POST | `/api/auth/register` | — | `{name, email, password}` → `{token, user}` |
| POST | `/api/orders` | Bearer JWT | Place order |
| GET | `/api/orders` | Bearer JWT | User's order history |

### Demo credentials

```
email:    john@example.com
password: password123
```

### Backend file structure

```
backend/
├── server.js
├── .env                   ← PORT=3000, JWT_SECRET, JWT_EXPIRES_IN=7d
├── data/
│   ├── products.js        ← 12 products (in-memory)
│   ├── categories.js      ← 6 categories (in-memory)
│   └── users.js           ← users (in-memory, pre-hashed passwords)
├── middleware/
│   └── auth.js            ← JWT Bearer verification
└── routes/
    ├── products.js
    ├── categories.js
    ├── auth.js
    └── orders.js
```

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.11.4`
- Node.js `>=18`
- Android emulator or physical device

### 1. Install Flutter dependencies

```bash
flutter pub get
```

### 2. Start the backend

```bash
cd backend
npm install
npm run dev
```

### 3. Connect the emulator to the backend

The app calls `http://localhost:3000`. Android emulators need ADB port forwarding to reach the host machine:

```bash
adb reverse tcp:3000 tcp:3000
```

> Run this once per emulator session. ADB is at `C:\Users\<you>\AppData\Local\Android\Sdk\platform-tools\adb.exe`.
>
> For a real device on WiFi, change `AppConfig.baseUrl` in `lib/core/constants/app_config.dart` to your machine's local IP, e.g. `http://192.168.1.5:3000`.

### 4. Run the app

```bash
flutter run
```

---

## Color Scheme

| Name | Hex | Constant |
|---|---|---|
| Primary blue | `#2563EB` | `AppColors.primary` |
| Purple accent | `#7C3AED` | `AppColors.secondary` |
| Background | `#F8FAFC` | `AppColors.background` |
| Error / destructive | `#EF4444` | `AppColors.error` |
| Success | `#10B981` | `AppColors.success` |

---
## Not Yet Implemented

- Auth token persistence (lost on app restart — `shared_preferences` is installed but unused)
- Real Stripe payment (mock only — 2-second delay, always succeeds)
- Google / Facebook social login
- Wishlist page
- Order history page
- Notifications, Addresses, Payment Methods pages
- Real database (all backend data is in-memory and resets on server restart)
- Profile stats (Orders, Wishlist, Reviews) are hardcoded
