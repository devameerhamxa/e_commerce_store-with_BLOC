# 🛍️ E-Commerce Store with BLoC

A mini e-commerce Flutter application built with a clean architecture (MVVM), leveraging BLoC for state management and integrating with [FakeStoreAPI](https://fakestoreapi.com/).

---

## 📋 Features

* **User Authentication**

  * Login via `/auth/login`
  * Secure token handling and redirect to product screen

* **Product Listing & Filtering**

  * Fetch products from `/products`
  * Filter by category and search by title/description
  * Pull-to-refresh support

* **Product Details**

  * View product info, image, rating, and price
  * Add to cart functionality

* **Cart Management**

  * Fetch cart via `/carts/user/:userId`
  * View, update, and remove items
  * Cart item badge in AppBar

* **User Profile**

  * Fetch user info via `/users/:id`

* **Custom App Drawer**

  * Profile navigation, theme toggle, logout

---

## 🏗️ Architecture

Implements **MVVM with BLoC**:

* `models/` – Data classes (e.g., `ProductModel`, `UserModel`)
* `repositories/` – Abstract API/data logic
* `bloc/` – Business logic and state management
* `ui/` – Flutter widgets and screens

Each feature (auth, products, cart, profile) has its own BLoC for modularity and maintainability.

---

## 🔄 State Management

Uses the [BLoC](https://bloclibrary.dev/#/) library to manage UI state:

* `AuthBloc`, `ProductBloc`, `CartBloc`, `UserBloc`, `ProductDetailBloc`

---

## 🌐 API Integration

* **FakeStoreAPI** endpoints:

  * `/products`, `/products/category/:category`, `/products/:id`
  * `/carts/user/:userId`
  * `/users/:id`
  * `/auth/login`

* **Dio** used as HTTP client.

---

## 🚀 Getting Started

### 1. Clone & Navigate

```bash
git clone <your_repository_url> e_commerce_store-with_BLOC
cd e_commerce_store-with_BLOC
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Android Permissions

In `android/app/src/main/AndroidManifest.xml`, add:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### 4. Run the App

```bash
flutter run
```

### 5. Build Release

```bash
flutter build apk --release
```

---

## ⚠️ Limitations & Future Enhancements

* Static userId for cart/profile (due to API limitation)
* Local-only cart simulation
* No checkout integration
* Basic error handling
* No pagination/lazy loading
* Lacks unit & integration testing
* No animations or localization

---
Here`s the APK--release link & video:
APK: https://drive.google.com/file/d/1G5JCwdkFxL5XlOxCHhbZ49ce8VfK3iFz/view?usp=sharing
Screen Recording Video: https://drive.google.com/file/d/17rhJnwANQhZuqSjMIpD__cD4OrluP_kQ/view?usp=sharing
