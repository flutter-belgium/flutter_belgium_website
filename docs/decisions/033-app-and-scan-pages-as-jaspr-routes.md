---
parent: Decisions
nav_order: 33
title: "ADR-033: /app and /scan implemented as Jaspr routes with inline script"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# /app and /scan implemented as Jaspr routes with inline script

## Context and Problem Statement

The old Flutter Belgium website had two utility pages:
- `app.html` — detects the visitor's platform and redirects to the correct app store (Play Store for Android, App Store for iOS)
- `scan.html` — immediately redirects to `app.html`, used as a short URL for QR codes shown at meetups

These pages needed to be preserved in the new Jaspr site. The question was how to implement client-side JavaScript redirects in a statically generated Jaspr site.

## Decision Drivers

- The redirect logic must execute client-side (platform detection requires `navigator.userAgent`)
- The pages should feel part of the site (NavBar, Footer) rather than bare HTML files
- Routes should be managed through Jaspr's router, not as ad-hoc static files in `web/`
- The implementation should be consistent with how the rest of the site is built

## Considered Options

- Static HTML files in `web/` (`app.html`, `scan.html`) with inline `<script>` tags
- Jaspr routes using external JS files in `web/scripts/` referenced via `script(src: '...')`
- Jaspr routes using `script(content: '...')` for inline JavaScript

## Decision Outcome

Chosen option: **Jaspr routes with `script(content: '...')`**, because it keeps the pages inside the Jaspr routing system, shares NavBar and Footer with the rest of the site, and avoids external file dependencies.

In Jaspr 0.23.x, the `script` component is a class with named parameters. Inline script content is passed via the `content` parameter (not as children). `src` is available for external scripts.

- `/app` — shows a brief page with App Store and Play Store buttons as a visible fallback, then immediately redirects based on `navigator.userAgent`
- `/scan` — redirects to `/app` via `window.location.replace('/app')`, used as the QR code target URL at meetups

### Consequences

- Good, because both pages are proper Jaspr routes, consistent with the rest of the site
- Good, because visitors without JavaScript see the fallback download buttons on `/app`
- Good, because the QR code URL (`/scan`) is short and decoupled from the app store URLs
- Neutral, because the platform detection script runs after the page renders — users briefly see the page before being redirected
