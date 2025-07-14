E-Commerce Store with BLoC
This is a mini e-commerce application built with Flutter, demonstrating a clean architecture (MVVM), BLoC for state management, and interaction with the FakeStoreAPI.

Table of Contents
Features

Architecture

State Management

API Used

How to Run the App

Known Limitations & Future Improvements

Features
The application includes the following functionalities:

Login Functionality:

Authenticates users using the /auth/login endpoint of FakeStoreAPI.

Securely handles and stores authentication tokens.

Redirects to the main product listing screen upon successful login.

Product Listing:

Fetches and displays a list of products from the /products endpoint.

Each product is displayed as a card with an image, title, and price.

Filtering by Category: Allows users to filter products by category using /products/category/:category.

Search Bar: Implemented for searching products by title or description.

Pull-to-Refresh: Users can pull down on the product list to refresh the data.

Product Details:

Tapping on a product card navigates to a detailed view of the product.

Displays full description, larger image, price, and rating.

Includes an "Add to Cart" button.

Cart Management:

Allows users to view items in their cart via /carts/user/:userId.

Displays item quantity and provides options to remove items or update quantities.

Shows the total price of items in the cart.

Cart Item Count Badge: The shopping cart icon in the AppBar displays the number of items currently in the cart.

User Profile:

Fetches and displays basic user information from /users/:id.

Shows details like name, email, and address.

Custom App Drawer:

Accessible from the product list screen.

Includes options for:

User Profile navigation.

Dark Mode Toggle: Switches the app's theme between light and dark modes.

Logout functionality.

Architecture
The project follows the MVVM (Model-View-ViewModel) architecture pattern, adapted for Flutter with BLoC:

Models (data/models): Plain Dart objects representing data structures (e.g., ProductModel, AuthResponseModel).

Views (ui): The UI layer, consisting of Flutter widgets responsible for rendering the user interface. They dispatch events to BLoCs and rebuild based on BLoC states.

Repositories (data/repositories): Abstract the data sources (e.g., API calls, local storage). They provide data to BLoCs without the BLoCs needing to know the data's origin.

BLoCs (Business Logic Components - bloc): Act as ViewModels. They contain the business logic, process incoming events, interact with repositories to fetch/manipulate data, and emit new states to update the UI.

State Management
BLoC (Business Logic Component) is used for state management throughout the application. Each major feature (Authentication, Products, Cart, User Profile, and Product Detail) has its own dedicated BLoC to manage its specific state and logic, ensuring clear separation of concerns and testability.

AuthBloc: Manages user login and authentication status.

ProductBloc: Manages the list of products, including fetching, filtering, and searching.

ProductDetailBloc: Manages the state for a single product's details.

CartBloc: Manages the user's shopping cart items and total.

UserBloc: Manages fetching and displaying user profile information.

API Used
The application utilizes the FakeStoreAPI (https://fakestoreapi.com/) as its backend. This is a public REST API providing mock data for:

Products (/products, /products/category/:category, /products/:id)

Carts (/carts/user/:userId)

User Accounts (/users/:id)

Authentication (/auth/login)

Dio is used as the HTTP client for making network requests to the FakeStoreAPI.

How to Run the App
Follow these steps to get the application running on your local machine:

Clone the Repository:

git clone <your_repository_url> e_commerce_store-with_BLOC
cd e_commerce_store-with_BLOC

(Replace <your_repository_url> with the actual URL if this were a real repository.)

Install Dependencies:
Make sure you have Flutter installed. Then, fetch the project dependencies:

flutter pub get

Add Android Internet Permission:
Open android/app/src/main/AndroidManifest.xml and ensure the following line is present inside the <manifest> tag (before <application>):

<uses-permission android:name="android.permission.INTERNET"/>

Run the App:
You can run the app on an emulator, simulator, or a physical device.

flutter run

To build a release version (e.g., for APK or IPA):

flutter build apk --release # For Android
flutter build ios --release # For iOS

Known Limitations & Future Improvements
Cart Management: The "Add to Cart" functionality currently simulates adding items to a local cart. The FakeStoreAPI does not provide a direct endpoint to persist cart changes server-side. For a production app, this would require a real backend integration.

User ID for Cart/Profile: The app currently assumes a fixed userId (1) after login for fetching cart and profile data, as FakeStoreAPI's login endpoint does not return the user ID. In a real application, the authenticated user's ID would be returned by the login API and used dynamically.

Checkout Process: The "Proceed to Checkout" button in the cart screen is a placeholder and does not implement any actual checkout logic.

Error UI: While errors are shown via SnackBar, more sophisticated error screens or inline error messages could be implemented for a better user experience.

Pagination/Lazy Loading: For very large product lists, implementing pagination or lazy loading would improve performance.

Testing: Unit, widget, and integration tests are not included in this basic setup but are crucial for a production-ready application.

Animations: More subtle UI animations and transitions could be added to enhance the user experience.

Localization: The app currently supports only English.
