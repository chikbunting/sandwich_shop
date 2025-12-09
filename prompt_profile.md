Goal

Add a simple Profile screen to the Sandwich Shop app and a navigation link from the Order screen. Keep it UI-only — no authentication or persistent storage.

Requirements

- Create `lib/views/profile_screen.dart` with a `ProfileScreen` widget.
- Fields: `Full name`, `Email`, `Phone` (TextFields).
- A `Save` button that validates `Full name` and `Email` are non-empty and shows a SnackBar "Profile saved" on success; show an error SnackBar on failure.
- Add a navigation control to `OrderScreen` (bottom area) that pushes `ProfileScreen`.
- Write widget tests at `test/views/profile_screen_test.dart`:
  - navigation opens the profile screen and shows fields and Save button.
  - saving with valid input shows a success SnackBar.

Notes for implementer

- Reuse `StyledButton` for consistent button styling.
- Use `Navigator.push` with a `MaterialPageRoute`.
- Keep changes small and test-driven.
