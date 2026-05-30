---
parent: Decisions
nav_order: 32
title: "ADR-032: useLogoInsteadOfTextTitle hides company name on detail page"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# useLogoInsteadOfTextTitle hides company name on detail page

## Context and Problem Statement

Some companies have a logo that already contains their name as part of the visual mark (e.g. a wordmark). Showing both the logo and the company name as a text heading next to it creates redundancy and looks visually cluttered.

## Decision Drivers

- Avoid redundant text next to a wordmark logo
- The `isAgency` badge should still be shown regardless of the logo style
- The flag already exists on the `MadeInCompany` model and is parsed from the data source

## Considered Options

- Always show the text name alongside the logo (status quo)
- Hide the text name when `useLogoInsteadOfTextTitle` is `true`, keep the Agency badge

## Decision Outcome

Chosen option: **Hide the `h1` name when `useLogoInsteadOfTextTitle` is `true`**, rendering only the Agency badge (if applicable) in the meta block. The logo itself serves as the visual title.

This is applied in `MadeInCompanyDetailPage` only. The companies list grid always uses logo-only cards regardless of this flag, since the grid layout doesn't show text titles.

### Consequences

- Good, because wordmark logos are not followed by redundant text
- Good, because the data-driven flag means no code changes are needed when new companies are added
- Neutral, because the Agency badge is still shown in both cases so type information is never lost
