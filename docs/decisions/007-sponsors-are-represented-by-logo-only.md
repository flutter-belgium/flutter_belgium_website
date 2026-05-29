---
parent: Decisions
nav_order: 7
title: "ADR-007: Sponsors are represented by logo only"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Sponsors are represented by logo only

## Context and Problem Statement

The sponsor section displays sponsors as clean, centered logo cards. Every sponsor must have a visual identity to be shown. How should the `Sponsor` model be structured to reflect this constraint?

## Decision Drivers

- The UI shows only a logo (centered, 64px tall) — a sponsor without a logo cannot be displayed
- Contribution text adds visual noise that detracts from the clean card design
- The `name` field is still needed as `alt` text for accessibility
- The model should reflect what is actually rendered, not hypothetical future fields

## Considered Options

- `logoUrl` optional, `contribution` optional — render a text fallback when no logo
- `logoUrl` required, `contribution` optional — keep contribution for future use
- `logoUrl` required, `contribution` removed — model matches exactly what is displayed

## Decision Outcome

Chosen option: **`logoUrl` required, `contribution` removed**, because the model should enforce the actual display contract: a sponsor without a logo is not renderable. Removing `contribution` avoids dead fields.

```dart
class Sponsor {
  const Sponsor({
    required this.name,      // used as alt text on the logo image
    required this.logoUrl,   // 64px tall, centered in the card
    required this.websiteUrl, // card taps open this URL
  });
}
```

### Consequences

- Good, because the compiler enforces that every sponsor has a logo — no silent rendering failures
- Good, because the model is small and matches exactly what is displayed
- Bad, because adding contribution text in future requires adding the field back to the model
