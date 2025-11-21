# Sandwich Shop (Flutter)

A small Flutter demo app that simulates a sandwich ordering flow. It demonstrates a simple separation of UI and business logic by moving quantity management into a repository, a lightweight order UI, and a tiny order history.

This README explains how to run the app, the structure of the project, development notes, and where the business logic lives.

## Features

- Select sandwich size (footlong / six-inch)
- Pick a bread type from a dropdown
- Add order notes
- Increase / decrease sandwich quantity with limits enforced by a dedicated repository
- Add the current selection to an in-memory order history with totals

The quantity rules and stateful operations are implemented in `lib/repositories/order_repository.dart` so the UI code can remain focused on presentation.

## Requirements

- Flutter SDK (stable) — Flutter 3.x or later is recommended
- A platform target (Android, iOS, macOS, web) configured for Flutter development

If you don't have Flutter installed yet, follow the official docs: https://docs.flutter.dev/get-started/install

## Quick start (macOS / zsh)

Clone the repository (if not already) and fetch packages:

```bash
git clone <your-repo-url>
cd sandwich_shop
flutter pub get
```

Run the analyzer and tests (optional):

```bash
dart analyze
flutter test
```

Run the app on a connected device or simulator:

```bash
flutter run
```

Open the project in VS Code and use the Source Control view (⌃ + Shift + G) to inspect the changes made while refactoring.

## Project layout (key files)

- `lib/main.dart`
	- The main entrypoint and the UI for the demo app. Note: this file contains lightweight UI stubs added to make the app compile (for example `BreadType`, `StyledButton`, and a renamed `OrderItemDisplay`).
	- The `_OrderScreenState` in this file now uses the `OrderRepository` for quantity management.
- `lib/repositories/order_repository.dart`
	- Contains `OrderRepository` — the single source of truth for the order quantity and limits. Use this class to change max quantity behavior.
- `lib/views/app_styles.dart`
	- App typography and style constants (imported by `main.dart`).

Other typical Flutter directories are present (`android/`, `ios/`, `macos/`, `web/`, `test/`).

## Business logic: `OrderRepository`

The repository encapsulates quantity state and rules. The key contract:

- Inputs: `increment()` and `decrement()` actions
- Outputs: `quantity` getter and boolean getters `canIncrement` / `canDecrement`
- Constructor: `OrderRepository({ required int maxQuantity })`

Example usage (in UI):

```dart
final repo = OrderRepository(maxQuantity: 5);
if (repo.canIncrement) repo.increment();
print(repo.quantity);
```

Moving this logic out of UI components keeps tests and future changes simpler.

## Notes about current implementation

- During a refactor, lightweight UI stubs were added to `lib/main.dart` so the project compiles and the analyzer can run. These include:
	- `enum BreadType { white, wheat, rye }`
	- `class StyledButton` — a thin wrapper around `ElevatedButton.icon`
	- `OrderItemDisplay` was adjusted to accept named parameters (`quantity`, `itemType`, `breadType`, `orderNote`).

- You may already have richer/widget implementations in another branch (eg. "branch 4") — if so, consider replacing these stubs with the originals to restore full visual fidelity.

## Development notes & tips

- To change the maximum orderable quantity, update the `maxQuantity` passed to `OrderScreen` in `lib/main.dart` (the default is set at the `OrderScreen(maxQuantity: ...)` call).
- Use `dart analyze` frequently to catch static issues. I ran the analyzer during the refactor and fixed the major type issues; a couple of non-critical analyzer messages may remain (unused variables or unnecessary imports) and can be cleaned up later.

### Common analyzer messages you might see

- `The declaration '_priceMap' isn't referenced.` — leftover data from earlier code; safe to remove if not needed.
- `The import of 'package:flutter/foundation.dart' is unnecessary` — `material.dart` already exports the used symbols; you can remove the extra import.

## Running tests

There are no dedicated unit tests for the repository or UI yet. To add tests, create files under `test/` and run:

```bash
flutter test
```

For a simple start, write a test for `OrderRepository` to validate `increment()`, `decrement()`, and the boolean getters.

## Contributing

All contributions are welcome. A typical workflow:

1. Create a feature branch from `main`.
2. Implement your changes and add tests where appropriate.
3. Run `dart analyze`, `flutter test`, and confirm the app runs.
4. Open a pull request with a clear description of what changed and why.

If you plan to replace the lightweight UI stubs with richer components, please keep the `OrderRepository` contract stable or update usages accordingly.

## Troubleshooting

- If `flutter run` fails to find a device, ensure you have a connected device or an emulator running (Android Studio AVD, iOS Simulator, etc.).
- If analyzer complains about missing types after switching branches, run `git status` and `git checkout` the branch that contains the missing UI widgets.

## License

No license specified. Add a `LICENSE` file if you want to make the project open source.

---

If you'd like, I can:

- Remove the small unused bits flagged by the analyzer (for a totally clean run),
- Add a basic unit test for `OrderRepository`, or
- Pull the richer UI components from another branch and replace the stubs.

Tell me which you'd like and I'll make the change.
