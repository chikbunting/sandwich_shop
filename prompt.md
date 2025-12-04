# Feature request: Editable Cart (prompt for LLM)

I have a Flutter sandwich shop app. I want you to help me implement an editable cart feature. Below is the context, user story, UI requirements, constraints, acceptance criteria, suggested code locations, and tests to add. Provide a concrete implementation plan and produce the code changes as a patch (file paths + diffs) for the repository.

---

## Context (what the repo contains today)
- Language: Dart + Flutter (no third-party packages allowed for this task).
- Models:
  - `Sandwich` (in `lib/models/sandwich.dart`) — has `id`, `name` (displayName), `isFootlong`, `breadType`, `image` getter, `fromJson` factory.
  - `Cart` (in `lib/models/cart.dart`) — holds `CartItem` entries and provides `add`, `remove`, `updateQuantity`, `totalQuantity`, and `totalPrice(PricingRepository)`.
- Repositories:
  - `PricingRepository` (in `lib/repositories/pricing_repository.dart`) — `unitPrice({isFootlong})` and `totalFor({quantity, isFootlong})`.
- UI:
  - Order screen: `lib/main.dart` (contains `OrderScreen`) — users can select sandwich type, size, bread, quantity and `Add to Cart`.
  - There is an existing `CartScreen` at `lib/views/cart_screen.dart` (already implemented) and an existing `View Cart` button that navigates (if not present, note it and add as part of the patch).
- Tests: Widget tests live in `test/views/widget_test.dart` and there are model/repo unit tests.

---

## User stories

1. As a customer, I want to see a small cart summary on the order screen so I always know how many items I have and the current total.
2. As a customer, I want to open the cart screen to see all items, change quantities for an item, and remove items from the cart.
3. As a developer/tester, I want the cart behaviour to be covered by unit and widget tests so changes are safe and predictable.

---

## Feature specification (exact behaviour)

A. Main screen cart summary (already partially implemented):
- Display a small persistent summary on the `OrderScreen` showing "Cart: {N} item(s) — £{TOTAL}".
- The summary updates immediately when items are added, removed, or quantities change.

B. Cart screen editing capabilities:
- For each `CartItem` shown on `CartScreen`:
  - Show the sandwich `name`, `breadType`, `size` (six-inch/footlong), `quantity`, and line total price.
  - Provide an increment `+` and decrement `−` button to change the quantity. When quantity is decremented to 0 the item should be removed from the cart.
  - Provide a remove (trash) button to remove the item immediately.
- Show the cart subtotal (sum of line totals) using `PricingRepository` for price calculation.
- Provide a "Continue Shopping" or back arrow (already provided by AppBar) and a "Checkout" button (non-functional for the exercise—just present it disabled or non-interactive).

C. Interaction & constraints:
- All pricing calculations must go through `PricingRepository` (single source of truth).
- No third-party packages—use only core Flutter/Dart.
- Update UI state with `setState` or simple state management in the existing widget hierarchy (do not introduce new frameworks).
- Keep API of `Cart` intact; use `Cart.add`, `Cart.updateQuantity`, `Cart.remove`, `Cart.totalPrice(...)`.

---

## Acceptance criteria (tests to pass)

1. Unit tests (existing) remain green. Add a unit test for `Cart.updateQuantity` removing item when set to 0 if not present.
2. Widget tests:
   - On `OrderScreen`:
     - Adding an item updates the cart summary count and total. (Already present; ensure it still passes.)
     - Tapping the "View Cart" button navigates to `CartScreen`.
   - On `CartScreen`:
     - Changing the quantity (tap +) increases total quantity and updates line and subtotal prices.
     - Tapping − decreases quantity, and when quantity reaches 0 the item is removed from the list and subtotal updates.
     - Tapping remove deletes the item and updates subtotal and summary when navigating back.

3. The app uses `PricingRepository` for every price calculation (unit and totals).

---

## Suggested implementation plan and file changes

1. Implement simple APIs in `lib/repositories/sandwich_repository.dart` if required to provide sandwich list to the order screen (optional).
2. Ensure `CartScreen` UI lists items and exposes + / − / remove controls. If `lib/views/cart_screen.dart` exists but lacks editing controls, update it.
3. Wire the "View Cart" button on `OrderScreen` if not present; it should navigate using `Navigator.push` to `CartScreen`.
4. Add logic in `CartScreen` to call `setState` after calling `Cart.updateQuantity(...)` or `Cart.remove(...)` and re-compute totals via `cart.totalPrice(pricingRepository)`.
5. Add widget tests in `test/views/cart_screen_test.dart` to cover interactions above.

---

## Code examples (how to call the Cart API)

- Add to cart (existing):
```dart
final sandwich = Sandwich(...);
_cart.add(sandwich, quantity: 2);
```

- Update quantity:
```dart
_cart.updateQuantity(sandwich, newQuantity);
setState(() {});
```

- Remove:
```dart
_cart.remove(sandwich);
setState(() {});
```

- Compute total price in UI:
```dart
final total = _cart.totalPrice(_pricingRepository);
``` 

---

## Tests to add (skeletons)

- `test/views/cart_screen_test.dart` (widget tests):
  - `testWidgets('CartScreen increments and updates subtotal', (tester) async { ... })`
  - `testWidgets('CartScreen decrement removes item at zero', (tester) async { ... })`
  - `testWidgets('CartScreen remove button deletes item', (tester) async { ... })`

- Optional unit test in `test/models/cart_update_test.dart`:
  - `test('updateQuantity removes item when <= 0', () { ... })`

---

## Deliverable (what I want you to return)
1. A clear step-by-step implementation plan.
2. A patch (file changes) implementing the cart editing UI and logic, plus tests. If the full patch is large, break it into bite-sized commits.
3. A small note about any decisions, trade-offs, and follow-up improvements.

---

## Constraints and preferences
- No third-party packages.
- Keep changes minimal and maintainable.
- Prefer explicit `setState` updates, no global mutable singletons unless they already exist.
- Provide unit & widget tests as part of the patch.


---

If you understand the request, produce the implementation plan and a proposed patch. If anything in the repo differs from what I described, mention what you need to inspect first and adapt the patch accordingly.
