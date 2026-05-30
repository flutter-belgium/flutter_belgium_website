---
parent: Decisions
nav_order: 28
title: "ADR-028: Become a sponsor — dedicated page supersedes direct Slack link"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Become a sponsor — dedicated page supersedes direct Slack link

## Context and Problem Statement

ADR-012 established a "Become a sponsor" dashed tile linking directly to the Slack invite URL. This gave potential sponsors no information about what they would get or how sponsorship works before committing to joining Slack.

## Decision Drivers

- Potential sponsors need context: what they get, what it covers, and how to reach out
- The contact subject line should be specific so organisers can filter incoming messages
- The page should feel consistent with the rest of the site

## Considered Options

- Keep direct Slack link (status quo from ADR-012)
- Open a mailto: link with a pre-filled subject
- Dedicated `/become-a-sponsor` page using the existing `LegalPage` layout

## Decision Outcome

Chosen option: **Dedicated `/become-a-sponsor` page**, using the `LegalPage` component for layout consistency with Privacy Policy and Terms pages.

The tile in the sponsors grid now links to `/become-a-sponsor` instead of the Slack invite. The page explains why to sponsor, what sponsors receive (dedicated slide at the start of each meetup with optional job openings + logo on the website), what the money covers, and how to get in touch via `administration@impaktfull.com` with subject `Sponsorship Flutter Belgium`.

### Consequences

- Good, because potential sponsors are informed before reaching out
- Good, because the specific email subject makes it easy to filter sponsorship enquiries
- Good, because the `LegalPage` component is reused with no new UI needed
- Neutral, because the page content must be kept up to date as sponsorship terms evolve
