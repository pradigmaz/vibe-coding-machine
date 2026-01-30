# Security Masterclass (Vulnerability Hunter)

A mindset and checklist for identifying and fixing critical security vulnerabilities (OWASP Top 10).

## 1. Broken Access Control (IDOR)
*   **Vulnerability:** Accessing resources by ID without ownership check.
    *   `GET /api/docs/123` -> returns doc even if I don't own it.
*   **Fix:** Always query with `userId`.
    *   `db.docs.findOne({ id: 123, userId: currentUser.id })`

## 2. Cryptographic Failures
*   **Vulnerability:** Using MD5/SHA1 or hardcoded secrets.
*   **Fix:**
    *   Use `bcrypt` or `argon2` for passwords.
    *   Secrets in `process.env` ONLY.
    *   Rotate keys.

## 3. Injection Attacks (SQLi, NoSQLi, Command)
*   **Vulnerability:** Concatenating strings into queries/commands.
    *   `db.query("SELECT * FROM users WHERE name = '" + name + "'")`
*   **Fix:**
    *   **SQL:** Use Parameterized Queries (`?` or `$1`).
    *   **NoSQL:** Validate input types (Zod). Ensure `{ $ne: null }` attacks are impossible.
    *   **Command:** Use `execFile` instead of `exec`. Whitelist arguments.

## 4. Insecure Design (Rate Limiting)
*   **Vulnerability:** Unlimited attempts on Login/OTP endpoints.
*   **Fix:** Implement Rate Limiting (Redis, Token Bucket) + Account Lockout after N failed attempts.

## 5. Security Misconfiguration
*   **Vulnerability:** Verbose error messages (stack traces) in production.
*   **Fix:** Generic error messages ("Internal Server Error") for clients. Log details securely.
*   **Headers:** Use Helmet (CSP, HSTS, X-Content-Type-Options).

## 6. Vulnerable Components
*   **Action:** Run `npm audit` / `trivy` regularly. Update dependencies.

## 7. SSRF (Server-Side Request Forgery)
*   **Vulnerability:** Server fetching URLs provided by user.
*   **Fix:** Whitelist allowed domains/protocols. Disable redirects. Validate IP (block internal/private ranges).
