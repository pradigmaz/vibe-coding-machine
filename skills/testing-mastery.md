# Testing Mastery

Comprehensive strategy for automated quality assurance.

## 1. Testing Pyramid
1.  **Unit (70%):** Fast, isolated. Mock everything external.
2.  **Integration (20%):** Real DB, real API calls (in container). Test interactions.
3.  **E2E (10%):** Critical user flows (Login, Checkout) in browser environment.

## 2. Unit Testing Rules
*   **Isolation:** A unit test should NEVER fail because of network/DB issues.
*   **Mocking:** Use `jest.mock`, `unittest.mock` to simulate dependencies.
*   **Coverage:** Aim for high branch coverage, not just line coverage.

## 3. Integration Testing
*   Use a test database (Docker/SQLite).
*   Clean up state between tests.
*   Test happy paths AND error cases (404, 500, timeouts).

## 4. Fixing Broken Tests
*   **Analyze:** Read the assertion error carefully.
*   **Don't Cheat:** Never comment out a test or change expectation to match buggy behavior.
*   **Fix:** Fix the code if it's a bug. Update the test ONLY if requirements changed.

## 5. TDD (Test Driven Development)
*   **Red:** Write a failing test for new feature.
*   **Green:** Write minimal code to pass the test.
*   **Refactor:** Improve code quality while keeping test green.
