# Flutter Belgium Website — Redesign Spec

**Date:** 2026-05-29
**Status:** Approved

---

## Overview

Redesign of the Flutter Belgium website from the current functional-but-generic layout to a Clean & Minimal aesthetic. Inspired by fronteers.nl (structure), uxbelgium.be (whitespace and warmth), and aanmelder.nl (energy). Includes two new animated sections: Hosting Companies and Testimonials. Changes span CSS, existing components, two new components, and two new data models.

---

## Design Direction: Clean & Minimal

White-first, generous whitespace, soft shadows. Community-warm without being heavy. Typography does the heavy lifting. Brand colours used as accents, not wallpaper.

---

## Section Layout

| # | Section | Background | Notes |
|---|---------|-----------|-------|
| 1 | NavBar | White `#FFFFFF`, sticky | Logo left, nav links + primary pill CTA right |
| 2 | Hero | White `#FFFFFF` | Two-column: text left, large logomark right |
| 3 | About | Grey `#E6EDFF` | |
| 4 | Next Meetup | Navy `#021F40` | Yellow `#FFD648` section label |
| 5 | **Hosting Companies** | White `#FFFFFF` | Two auto-scrolling logo rows (new) |
| 6 | Past Meetups | Grey `#E6EDFF` | |
| 7 | Talks | White `#FFFFFF` | |
| 8 | **Testimonials** | Grey `#E6EDFF` | Three auto-scrolling card columns (new) |
| 9 | Join | Sky `#027DFD` | |
| 10 | Footer | Navy `#021F40` | |

---

## Component-Level Changes

### NavBar
- Add a primary pill CTA button "Join Slack" in the nav (links to `communityLinks.slackInviteUrl`)
- Nav links remain: About · Meetups · Talks · Join
- Border bottom: `1px solid #E6EDFF`

### Hero
- **Two-column layout:** text column left (flex ~1.2), logomark column right (flex ~0.8)
- Left column: section label, large headline, subtitle, two pill CTAs
- Right column: `logo-default.svg` displayed large (~200px tall), vertically centred
- Background: white
- Headline: `clamp(2.5rem, 5vw, 4rem)`, font-weight 800
- Responsive: stack to single column on mobile (logomark moves above text or hidden)

### Buttons / CTAs
- All buttons switch from `border-radius: 8px` to `border-radius: 999px` (pill shape)
- Primary: sky blue background, white text
- Secondary/ghost: transparent, navy border+text
- Outline-white (on dark bg): transparent, white border+text

### Section padding
- Increase from `5rem 1.5rem` to `7rem 1.5rem` for all content sections
- Hero stays at `6rem 1.5rem` (two-col layout already gives it visual weight)

### Typography
- Hero headline: `clamp(2.5rem, 5vw, 4rem)`, weight 800
- Section titles: `clamp(1.75rem, 3vw, 2.5rem)`, weight 700 (unchanged)
- All other text: unchanged

### Cards (Meetup & Talk)
- **Remove** `border: 1.5px solid var(--color-grey)` from talk cards
- **Add** `box-shadow: 0 2px 16px rgba(2, 31, 64, 0.08)` to both meetup and talk cards
- Hover: `box-shadow: 0 8px 32px rgba(2, 31, 64, 0.13)`, `translateY(-3px)`
- Border radius: keep `12px`
- No top accent bar

### Section label
- Keep sky `#027DFD` on all light sections (About, Meetups, Talks)
- Next Meetup section label: yellow `#FFD648` (already correct, no change)

---

## CSS Changes Summary

Files changed: `web/styles.css`, `lib/components/nav_bar.dart`, `lib/components/hero_section.dart`, `lib/app.dart`, `lib/main.server.dart`, `lib/main.client.dart`. Two new component files and two new model files are created.

### Variables to update
```css
--section-padding: 7rem 1.5rem;  /* was 5rem */
```

### Selector changes
| Selector | Change |
|---|---|
| `.btn` | `border-radius: 999px` |
| `.hero` | `background: #fff` (was `#E6EDFF`) |
| `.hero-inner` | add `flex-direction: row`, `align-items: center` |
| `.hero-logo` | new class `.hero-logomark`, `height: 200px` |
| `.hero-tagline` | `font-size: clamp(2.5rem, 5vw, 4rem)`, `font-weight: 800` |
| `.meetup-card` | `box-shadow: 0 2px 16px rgba(2,31,64,.08)` |
| `.talk-card` | remove border, add same shadow as meetup-card |
| `.talk-card:hover` | `box-shadow: 0 8px 32px rgba(2,31,64,.13)` |
| `.navbar-inner` | add `.navbar-cta` pill button styles |

### New CSS
```css
/* Hero two-column */
.hero-inner { flex-direction: row; align-items: center; }
.hero-content { flex: 1.2; }
.hero-logomark { flex: 0.8; display: flex; justify-content: center; }
.hero-logomark img { height: 200px; }

/* Nav CTA */
.navbar-cta {
  padding: 0.5rem 1.25rem;
  border-radius: 999px;
  background: var(--color-sky);
  color: var(--color-white);
  font-weight: 600;
  font-size: 0.9rem;
  transition: opacity 0.2s;
}
.navbar-cta:hover { opacity: 0.85; }

/* Responsive: stack hero on mobile */
@media (max-width: 768px) {
  .hero-inner { flex-direction: column; }
  .hero-logomark { display: none; }
}
```

---

## New Data Models

### `Company` (`lib/data/models/company.dart`)
```dart
class Company {
  const Company({required this.name, required this.logoUrl, required this.websiteUrl});
  final String name;       // used as alt text — logo image contains the visual name
  final String logoUrl;    // URL to company logo image
  final String websiteUrl; // link to company website
}
```

### `Testimonial` (`lib/data/models/testimonial.dart`)
```dart
class Testimonial {
  const Testimonial({required this.text, required this.authorName, required this.authorRole, required this.authorAvatarUrl});
  final String text;
  final String authorName;
  final String authorRole;
  final String authorAvatarUrl;
}
```

### Repository additions (`lib/data/repositories/flutter_belgium_repository.dart`)
```dart
Future<List<Company>> getHostingCompanies();
Future<List<Testimonial>> getTestimonials();
```

Mock data for `getHostingCompanies()`: iO (Ghent), Zimmo (Antwerp), Cegeka (Hasselt), Cronos (Leuven) — with placeholder logo URLs and company website URLs.

Mock data for `getTestimonials()`: 9 testimonials from community members split across three display columns (3 each).

---

## New Components

### HostingCompaniesSection (`lib/components/hosting_companies_section.dart`)

**Layout:** Section label "Hosted at" + title "Companies that trust Flutter". Two rows of logo circles (64×64px, `border-radius: 50%`, white background, soft shadow) that auto-scroll horizontally using CSS `@keyframes`. Row 1 scrolls left, row 2 scrolls right. Both rows duplicate their logo list to create a seamless infinite loop. Fade gradient overlays (`24px`) on both sides via `::before`/`::after` pseudo-elements or wrapping divs.

**Data:** `List<Company>` — logos split roughly 50/50 across the two rows. With mock data (4 companies) duplicate to fill: `[...companies, ...companies, ...companies, ...companies]`.

**CSS animations:**
```css
@keyframes scroll-left  { from { transform: translateX(0); }    to { transform: translateX(-50%); } }
@keyframes scroll-right { from { transform: translateX(-50%); } to { transform: translateX(0); } }
.companies-track-left  { animation: scroll-left  30s linear infinite; }
.companies-track-right { animation: scroll-right 30s linear infinite; }
```

### TestimonialsSection (`lib/components/testimonials_section.dart`)

**Layout:** Section label "Community" + title "What Flutter Belgium members say". Three columns side-by-side, each scrolling upward at a different speed (15s, 19s, 17s). Each column duplicates its testimonial list (`[...col, ...col]`) to create seamless infinite loop. Fade gradient top/bottom via a wrapping div with `mask-image: linear-gradient(to bottom, transparent, black 15%, black 85%, transparent)`. Max height `740px`, `overflow: hidden`. Columns 2 and 3 hidden on small screens.

**CSS animation:**
```css
@keyframes scroll-up { from { transform: translateY(0); } to { transform: translateY(-50%); } }
.testimonial-track { animation: scroll-up var(--duration, 15s) linear infinite; }
```

**Testimonial card:** White background, soft shadow (`0 2px 16px rgba(2,31,64,.08)`), `border-radius: 16px`, padding `1.5rem`. Quote text, then avatar (40×40px circle) + name + role row at the bottom. Max width `280px`.

**Data split:** 9 mock testimonials → column 1: indices 0–2, column 2: 3–5, column 3: 6–8.

---

## Dart Component Changes

### NavBar (`lib/components/nav_bar.dart`)
Add a `communityLinks` parameter and render a pill CTA "Join Slack" in the nav bar.

```dart
class NavBar extends StatelessComponent {
  const NavBar({required this.communityLinks, super.key});
  final CommunityLinks communityLinks;
  // ...yields the Slack CTA link
}
```

Update `App` to pass `communityLinks` to `NavBar`.

### HeroSection (`lib/components/hero_section.dart`)
Restructure the hero layout to two columns:
- Wrap existing text content in a `div(classes: 'hero-content', [...])`
- Add a `div(classes: 'hero-logomark', [img(src: '/assets/logo-default.svg', ...)])`
- Outer `hero-inner` div gets children `[HeroContent, HeroLogomark]`

---

## App wiring (`lib/app.dart` and `lib/main.server.dart`)

`App` receives two new props: `List<Company> companies` and `List<Testimonial> testimonials`. `main.server.dart` fetches them from the repository and passes them through.

---

## Out of Scope
- Dark mode
- Mobile hamburger menu (navbar links still hidden on mobile as before)
- Pause-on-hover for animations
