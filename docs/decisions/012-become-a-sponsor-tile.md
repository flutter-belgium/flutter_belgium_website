---
parent: Decisions
nav_order: 12
title: "ADR-012: Become a sponsor tile in the sponsors grid"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# "Become a sponsor" tile in the sponsors grid

## Context and Problem Statement

The sponsors section shows current sponsors but gives no clear path for new sponsors to get in touch. Potential sponsors visiting the site have no obvious call to action.

## Decision Drivers

- Make it easy for potential sponsors to reach out
- Should feel part of the sponsor grid, not a separate section
- Contact mechanism should not require a dedicated contact page or form

## Considered Options

- Add a paragraph below the sponsors grid with a contact email or link
- Add a dedicated "Become a sponsor" section between sponsors and footer
- Add a dashed tile at the end of the sponsor grid linking to the Slack invite

## Decision Outcome

Chosen option: **Dashed tile at the end of the sponsor grid**, because it sits naturally alongside existing sponsor cards and communicates that the slot is open. Linking to Slack makes it easy to reach the organisers without needing a dedicated contact form.

### Consequences

- Good, because potential sponsors immediately see where to apply when viewing existing sponsors
- Good, because no backend or contact form is required — Slack handles the conversation
- Neutral, because the Slack invite URL is used as the contact mechanism; this can be changed to an email or dedicated URL later via `SponsorSection.contactUrl`
- Bad, because the "Become a sponsor" tile always appears even if all sponsorship slots are filled
