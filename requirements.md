# Requirements: Editable Cart Feature

This document summarizes the requirements for the "Editable Cart" feature for the Sandwich Shop app. It is written in a form suitable for feeding to an LLM or for direct implementation by a developer.

## 1. Feature description

Provide customers the ability to view and edit items in their shopping cart. The feature has two main surface areas:

- A persistent cart summary on the `OrderScreen` showing the current number of items and the total price.
- A dedicated `CartScreen` where customers can modify cart contents: increment/decrement quantities, remove items, and see per-line and subtotal prices.

All price calculations must use the existing `PricingRepository` (single source of truth). No third-party packages should be added for this task.


## 2. User stories

- As a customer, I want to see how many items are currently in my cart and the total price while I'm building my order so I can make informed decisions.

- As a customer, I want to open the cart and adjust quantities for items already added so I can correct mistakes without re-adding items.

- As a customer, I want to remove an item from my cart if I no longer want it.

- As a developer/tester, I want unit and widget tests that verify the behaviour so the feature remains stable when modified.


## 3. Acceptance criteria

Functional criteria

1. Cart summary on `OrderScreen` must show: `Cart: {N} item(s) — £{TOTAL}` where `{N}` is the total quantity of all items and `{TOTAL}` is the total price computed with `PricingRepository`.

2. When the "Add to Cart" button is pressed, the cart summary updates immediately to reflect the new state.

3. `CartScreen` shows a list of cart items. Each item shows:
   - Sandwich name (displayName or fallback), bread type, and size (six-inch or footlong),
   - Quantity and line total price (quantity × unit price), and
   - Controls: `+` (increment quantity), `−` (decrement quantity), and a remove/trash button.

4. Incrementing quantity updates the line total and cart subtotal immediately.

5. Decrementing quantity by pressing `−` decreases the quantity by 1; when the quantity reaches 0 the item is removed from the cart (and the UI updates accordingly).

6. Pressing the remove button deletes the item immediately and updates the subtotal and the `OrderScreen` summary if the user navigates back.

7. All price calculations call `PricingRepository` (use `unitPrice` and `totalFor` as appropriate). The cart code must not duplicate pricing rules.

8. The checkout button on `CartScreen` is present but non-functional for this exercise (disabled or a no-op). The back/continue navigation should work as normal.

Non-functional criteria

- No new third-party packages are introduced. Use only the Flutter SDK and Dart standard libraries.

- Changes should be covered by unit and widget tests as specified below.


## 4. Tests (acceptance tests)

Add or update tests to validate behaviour.

Unit tests

- `test/models/cart_update_test.dart`: verify that `Cart.updateQuantity(item, 0)` removes the item and that `totalQuantity` / `totalPrice()` reflect the change.

Widget tests

- `test/views/widget_test.dart` (OrderScreen tests): already present tests should still pass (adding an item updates the summary).

- `test/views/cart_screen_test.dart` (new):
  - `testWidgets('CartScreen increments and updates subtotal', ...)` — Add a known item to the cart, open `CartScreen`, tap `+`, assert that the item's quantity and the subtotal change accordingly.
  - `testWidgets('CartScreen decrement removes item at zero', ...)` — Decrement until quantity is zero and assert removal and subtotal change.
  - `testWidgets('CartScreen remove button deletes item', ...)` — Use remove button and assert the item disappears and subtotal changes.


## 5. Implementation subtasks (developer checklist)

1. Ensure `Cart` API has methods required by UI: `add(Sandwich, quantity)`, `updateQuantity(Sandwich, newQuantity)`, `remove(Sandwich)`, `totalPrice(PricingRepository)`, `totalQuantity`, `items` (read-only list). If missing, add or adapt accordingly.

2. Add or update `lib/views/cart_screen.dart` to show editable cart rows including quantity controls and remove button. Each control should call the `Cart` API and `setState` to re-render.

3. Wire navigation from `OrderScreen` to `CartScreen` via a `View Cart` button (if not present). The button should use `Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen(cart: _cart, pricing: _pricingRepository)))` or equivalent.

4. Ensure the `OrderScreen` cart summary updates when the `Cart` is mutated. Use `setState` right after calling `Cart` methods or pass callbacks to `CartScreen` that call `setState` on return.

5. Add the widget tests specified above.

6. Run `flutter analyze` and `flutter test` to confirm no analyzer errors and all tests pass.


## 6. Edge cases and notes

- If multiple `CartItem` entries could represent the same sandwich (due to differing bread or size), `Cart` merging rules must be clear. The current `Cart` implementation merges by type/size/bread — keep that behaviour.

- Persistence is out of scope for this exercise; the cart lives in memory only.

- UI performance: keep the cart list simple; there will typically be few items.

- If the `CartScreen` already exists in the repo, first inspect it and modify it rather than creating a new file.


## 7. Deliverables

- Implementation patch modifying `lib/views/cart_screen.dart` (or creating it), `lib/main.dart` (navigation wiring if needed), and tests at `test/views/cart_screen_test.dart` and `test/models/cart_update_test.dart`.

- Short notes describing any deviations or design trade-offs.

## 8. Profile screen (new exercise)

This file documents the requirements for a lightweight Profile screen used for the next worksheet exercise. The screen is intentionally simple — no authentication or persistence is required; it only demonstrates navigation, forms, and widget testing.

Feature description

- Provide a `ProfileScreen` where users can view and enter simple details: full name, email, and phone number. The screen includes a Save button that validates input minimally and shows a confirmation `SnackBar` when pressed.

User stories

- As a user, I want to open my profile screen from the `OrderScreen` so I can view or edit my contact details.
- As a tester, I want widget tests that verify navigation to the profile screen and the presence of form fields and the save confirmation.

Acceptance criteria

1. The app includes a `ProfileScreen` at `lib/views/profile_screen.dart`.
2. `OrderScreen` contains a link or button at the bottom that navigates to `ProfileScreen` via `Navigator.push`.
3. `ProfileScreen` shows three `TextField` widgets with labels/placeholders: `Full name`, `Email`, and `Phone`.
4. `ProfileScreen` shows a `Save` button. When pressed with non-empty `Full name` and a non-empty `Email`, the screen shows a `SnackBar` with text containing `Profile saved` and does not crash.
5. No persistence is required; entered values can be discarded when navigating back.

Tests

- `test/views/profile_screen_test.dart`:
  - `testWidgets('navigates to profile and shows fields', ...)` — pump the app, tap the profile navigation control, assert that `Full name`, `Email`, and `Phone` fields and the `Save` button are present.
  - `testWidgets('saves profile and shows snackbar', ...)` — navigate to profile, enter valid values for required fields, tap `Save`, and assert that a `SnackBar` with `Profile saved` is shown.

Notes

- Keep implementations simple and UI-focused. Use existing `StyledButton` where convenient for visual consistency.
- Add minimal validation: require non-empty name and email. If validation fails, show a red `SnackBar` with an error message.

