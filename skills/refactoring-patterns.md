# Refactoring Patterns

Techniques to improve code structure without changing behavior.

## 1. Code Smells (When to refactor)
*   **Bloaters:** Long Method, Large Class, Long Parameter List.
*   **Couplers:** Feature Envy (method uses another class more than its own), Inappropriate Intimacy.
*   **Dispensables:** Duplicate Code, Dead Code, Comments (that explain "what" instead of "why").

## 2. Core Techniques

### Extract Method
*   **Problem:** Method is too long or does too many things.
*   **Solution:** Group code fragments into separate methods with descriptive names.

### Extract Class
*   **Problem:** One class does work of two.
*   **Solution:** Create a new class and move relevant fields/methods.

### Replace Conditional with Polymorphism
*   **Problem:** Complex `switch` or `if/else` based on type.
*   **Solution:** Use subclasses/interfaces and overridden methods.

### Guard Clauses
*   **Problem:** Deeply nested `if` statements.
*   **Solution:** Return early. `if (invalid) return;` instead of `if (valid) { ... }`.

### Parameter Object
*   **Problem:** Method takes 4+ parameters.
*   **Solution:** Group them into a single object/interface.

### Remove Duplication
*   **Problem:** Same code structure in two places.
*   **Solution:** Extract to shared method, base class, or utility.

## 3. Workflow
1.  **Tests:** Ensure tests exist and pass.
2.  **Small Steps:** Apply one pattern at a time.
3.  **Verify:** Run tests after EVERY change.
4.  **Commit:** Atomic commits for each refactoring step.
