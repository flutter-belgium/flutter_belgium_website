# Made in Flutter Belgium — Design Spec

**Date:** 2026-05-29  
**Status:** Approved

## Overview

Add a "Made in Flutter Belgium" section to the existing Jaspr-based Flutter Belgium website (`flutterbelgium.be`). It replaces the standalone `madein.flutterbelgium.be` Next.js site with an integrated, SEO-friendly set of pages inside the main site. Data is sourced from the existing `api.madein.flutterbelgium.be` API (backed by the `made_in_flutter_belgium_data` repo). Images are downloaded at CI time to avoid any external image dependency.

---

## Routes

| Route                                        | Description                                  |
| -------------------------------------------- | -------------------------------------------- |
| `/made-in-flutter-belgium`                   | Redirects to `/made-in-flutter-belgium/apps` |
| `/made-in-flutter-belgium/apps`              | Apps list page                               |
| `/made-in-flutter-belgium/companies`         | Companies list page                          |
| `/made-in-flutter-belgium/developers`        | Developers list page                         |
| `/made-in-flutter-belgium/apps/{slug}`       | App detail page                              |
| `/made-in-flutter-belgium/companies/{slug}`  | Company detail page                          |
| `/made-in-flutter-belgium/developers/{slug}` | Developer detail page                        |

**Slug format:** lowercase name, spaces replaced with hyphens, special characters stripped. Example: `"Covid Safe"` → `covid-safe`, `"ACA Group"` → `aca-group`.

Since Jaspr generates static HTML at build time, the router creates one `Route` per known item — no runtime slug resolution needed.

---

## Data Architecture

### API Endpoints Used

All fetched at `jaspr build` time (server-side static generation):

```
GET https://api.madein.flutterbelgium.be/projects/minimized_all.json
GET https://api.madein.flutterbelgium.be/projects/{name}/info.json
GET https://api.madein.flutterbelgium.be/companies/minimized_all.json
GET https://api.madein.flutterbelgium.be/companies/{name}/info.json
GET https://api.madein.flutterbelgium.be/developers/minimized_all.json
GET https://api.madein.flutterbelgium.be/developers/{githubUserName}/info.json
```

Names with spaces must be URL-encoded in HTTP requests (`"Covid Safe"` → `"Covid%20Safe"`).

### Models (`lib/data/models/made_in_flutter_belgium/`)

**`MadeInApp`**

```
name            String
localIconPath   String         // local asset path
description     String
publisher       String?
releaseDate     DateTime
isSunsetted     bool
sunsetReason    String?
links           MadeInAppLinks // appstore, playstore, webApp, marketingWebsite, youTube, demoYouTubeVideo, openSourceCode
localBannerPath String?
screenshotPaths List<String>   // local asset paths
developers      List<MadeInDeveloperRef>
involvedCompanies List<MadeInCompanyRef>
```

**`MadeInCompany`**

```
name                      String
localLogoPath             String
useLogoInsteadOfTextTitle bool
description               String?
links                     MadeInCompanyLinks? // website, jobWebsite
isAgency                  bool
developers                List<MadeInDeveloperRef>
projects                  List<MadeInAppRef>
involvedProjects          List<MadeInAppRef>
```

**`MadeInDeveloper`**

```
githubUserName    String
name              String?
localAvatarPath   String
description       String?
links             MadeInDeveloperLinks? // linkedin, personalWebsite, freelanceWebsite
projects          List<MadeInAppRef>
```

Ref types (`MadeInAppRef`, `MadeInCompanyRef`, `MadeInDeveloperRef`) are lightweight: enough fields to render a card (name + local image path).

### Repository (`lib/data/repositories/`)

**`MadeInFlutterBelgiumRepository`** (abstract interface):

```dart
Future<List<MadeInApp>>       getApps();                  // minimized — name + icon only
Future<MadeInApp>             getApp(String name);        // full detail
Future<List<MadeInApp>>       getLatestApps(int count);   // full detail, sorted by releaseDate desc
Future<List<MadeInCompany>>   getCompanies();             // minimized — name + logo only
Future<MadeInCompany>         getCompany(String name);    // full detail
Future<List<MadeInDeveloper>> getDevelopers();            // minimized — name + avatar only
Future<MadeInDeveloper>       getDeveloper(String githubUserName); // full detail
```

**`HttpMadeInFlutterBelgiumRepository`** data fetching strategy:

- `getApps()` / `getCompanies()` / `getDevelopers()` — single request to `minimized_all.json`; returns partial models (name + local image path only)
- `getApp(name)` / `getCompany(name)` / `getDeveloper(username)` — single request to `info.json`; returns full model
- `getLatestApps(count)` — fetches all projects' `info.json` in parallel (needed for `releaseDate` to sort); returns top N sorted descending. `minimized_all.json` does not include `releaseDate`.

**`MockMadeInFlutterBelgiumRepository`** — 3–5 hardcoded entries for local development.

### Image URL → Local Path Transformation

**API images** — strip base URL, remove `/images/` segment:

```
https://api.madein.flutterbelgium.be/projects/Bevoy/images/app_icon.webp
→ assets/made_in/projects/Bevoy/app_icon.webp

https://api.madein.flutterbelgium.be/companies/ACA Group/images/logo.svg
→ assets/made_in/companies/ACA Group/logo.svg   (extension preserved)

https://api.madein.flutterbelgium.be/projects/Covid Safe/images/screenshot_1.webp
→ assets/made_in/projects/Covid Safe/screenshot_1.webp
```

**GitHub avatars** — map to known local path:

```
https://avatars.githubusercontent.com/vanlooverenkoen
→ assets/made_in/developers/vanlooverenkoen/avatar.jpg
```

Local folder names preserve the original name including spaces (e.g. `"ACA Group"` → folder `ACA Group/`). Jaspr handles URL-encoding when rendering `src` attributes.

---

## Pages & Components

### List Pages

All three list pages share `MadeInPageShell`:

- Hero header: title **"Made in Flutter Belgium"**, subtitle
- Pill tab bar: `apps` | `companies` | `developers` (active tab highlighted in brand yellow `#FFD648`; each tab is a route link, lowercase labels)
- Responsive card grid below

**`MadeInCard`** — icon/logo/avatar image (rounded corners, app-store style) + name below. Taps navigate to the detail page.

### Detail Pages

**App detail (`MadeInAppDetailPage`)**

- App icon + name + publisher + release date
- Description
- Store/link buttons (App Store, Play Store, web, open source, YouTube)
- Screenshots row
- Involved companies section (company logo cards)
- Developers section (developer avatar cards)
- Sunset banner if `isSunsetted == true`

**Company detail (`MadeInCompanyDetailPage`)**

- Logo + name + agency badge if `isAgency`
- Description
- Website + jobs links
- Own projects grid
- Involved projects grid
- Team developers list

**Developer detail (`MadeInDeveloperDetailPage`)**

- Avatar + name + GitHub username
- Bio
- Links (LinkedIn, personal website, freelance)
- Projects grid

All detail pages use the existing `NavBar` and `Footer`.

### Home Page Showcase (`MadeInShowcaseSection`)

- Inserted into the home page after the About section, before the Meetups section
- Displays the **5 latest apps** sorted by `releaseDate` descending
- Horizontal row of 5 `MadeInCard` components (icon + name)
- CTA button below: **"Explore what Belgians built with Flutter"** → links to `/made-in-flutter-belgium/apps`

---

## Navigation

- **Footer link** — existing `madeInUrl` link in the footer is updated to point to `/made-in-flutter-belgium/apps` (internal link instead of the old external URL)
- **Navbar** — no change
- **Home page** — showcase section with CTA (see above)

---

## CI Changes

### New step in `.github/workflows/deploy.yml`

Added before `jaspr build`, in the build-and-deploy job:

```yaml
- name: Download Made in Flutter Belgium images
  run: python3 .github/workflows/scripts/download_made_in_images.py
```

### Script: `.github/workflows/scripts/download_made_in_images.py`

1. Fetches `minimized_all.json` for projects, companies, developers
2. For each **project** — fetches `info.json` to get full image list; downloads app icon, banner, and all screenshots to `web/assets/made_in/projects/{name}/`
3. For each **company** — fetches `info.json`; downloads logo (preserving `.svg` or `.webp` extension) to `web/assets/made_in/companies/{name}/`
4. For each **developer** — fetches `info.json`; downloads GitHub avatar to `web/assets/made_in/developers/{githubUserName}/avatar.jpg`

Names with spaces are URL-encoded for HTTP requests but used as-is for local paths.

### `.gitignore`

`web/assets/made_in/` is added to `.gitignore` — images only live inside the CI/GitHub Pages artifact, never committed.

---

## File Structure

```
lib/
  data/
    models/
      made_in_flutter_belgium/
        made_in_app.dart
        made_in_app_links.dart
        made_in_company.dart
        made_in_company_links.dart
        made_in_developer.dart
        made_in_developer_links.dart
        made_in_app_ref.dart
        made_in_company_ref.dart
        made_in_developer_ref.dart
    repositories/
      made_in_flutter_belgium_repository.dart
      http_made_in_flutter_belgium_repository.dart
      mock_made_in_flutter_belgium_repository.dart
  pages/
    made_in_flutter_belgium/
      made_in_apps_page.dart
      made_in_companies_page.dart
      made_in_developers_page.dart
      made_in_app_detail_page.dart
      made_in_company_detail_page.dart
      made_in_developer_detail_page.dart
  components/
    made_in_flutter_belgium/
      made_in_page_shell.dart
      made_in_card.dart
      made_in_showcase_section.dart   # used on home page

.github/
  workflows/
    scripts/
      download_made_in_images.py
    deploy.yml                        # modified

web/
  assets/
    made_in/                          # gitignored, populated by CI
```
