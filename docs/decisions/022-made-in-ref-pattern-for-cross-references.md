---
parent: Decisions
nav_order: 22
title: "ADR-022: Made in Flutter Belgium uses Ref models for cross-references"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Made in Flutter Belgium uses Ref models for cross-references

## Context and Problem Statement

Apps, companies, and developers reference each other: an app has a list of developers who built it and companies involved; a company has a list of apps and developers; a developer has a list of apps. The API returns lightweight reference objects within these lists, not the full nested models.

## Decision Drivers

- Avoid deep nesting and circular model dependencies
- Keep deserialization simple — each detail page route already has the full model for its primary entity
- Refs are sufficient for rendering linked cards (icon + name + href)

## Considered Options

- Embed full models recursively (circular dependency risk, large payload)
- Use string IDs and look up the full model client-side at runtime
- Separate lightweight `*Ref` models that contain only what is needed to render a card and a link

## Decision Outcome

Chosen option: **Separate `*Ref` models** (`MadeInAppRef`, `MadeInCompanyRef`, `MadeInDeveloperRef`), each containing only the fields needed to render a linked card:
- `name` (or `githubUserName` for developers)
- `localIconPath` / `localLogoPath` / `localAvatarPath` — the pre-mapped local asset path
- `useLogoInsteadOfTextTitle` for companies

Refs are embedded directly in the full models (e.g. `MadeInApp.developers` is `List<MadeInDeveloperRef>`). The detail page routes for the linked entity already exist — the ref provides the slug needed to construct the link.

### Consequences

- Good, because there are no circular model dependencies
- Good, because each ref carries exactly the data needed to render its card — no over-fetching
- Good, because adding a new field to a ref does not require changing the full model
- Neutral, because refs and full models may drift if the API schema changes — both must be kept in sync
