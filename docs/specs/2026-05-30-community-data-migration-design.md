# Community Data Migration — Design Spec

**Date:** 2026-05-30
**Status:** Approved

## Overview

Migrate the community data layer (meetups, talks, persons, companies, sponsors, team members, testimonials, community links) from local duplicate models and a mock repository into the `flutter_belgium_data` package (`feat/airtable-data` branch). The website switches from `MockFlutterBelgiumRepository` to `AirtableFlutterBelgiumRepository`, reading live data from AirTable at build time.

## pubspec.yaml

Add `ref: feat/airtable-data` to the existing git dependency:

```yaml
dependencies:
  flutter_belgium_data:
    git:
      url: https://github.com/flutter-belgium/flutter_belgium_data.git
      ref: feat/airtable-data
```

## Files deleted

These are now owned by the package and must be removed from the website:

- `lib/data/models/community_links.dart`
- `lib/data/models/company.dart`
- `lib/data/models/meetup.dart`
- `lib/data/models/person.dart`
- `lib/data/models/person_company.dart`
- `lib/data/models/person_social_links.dart`
- `lib/data/models/sponsor.dart`
- `lib/data/models/talk.dart`
- `lib/data/models/team_member.dart`
- `lib/data/models/testimonial.dart`
- `lib/data/repositories/flutter_belgium_repository.dart`
- `lib/util/string_utils.dart` (`toSlug` is now exported from the package barrel)

## main.server.dart

Read 6 env vars at startup. If any is missing, throw immediately with a message that names every missing variable. Build `AirTableConfig` from the values and construct `AirtableFlutterBelgiumRepository(config: config)` in place of the current `MockFlutterBelgiumRepository`.

| Env var | `AirTableConfig` field |
|---|---|
| `AIRTABLE_TOKEN` | `personalAccessToken` |
| `AIRTABLE_BASE` | `base` |
| `AIRTABLE_TABLE_MEETUPS` | `tableMeetups` |
| `AIRTABLE_TABLE_PEOPLE` | `tablePeople` |
| `AIRTABLE_TABLE_TALKS` | `tableTalks` |
| `AIRTABLE_TABLE_LOCATIONS` | `tableLocations` |

Remove the existing comment that described how to switch to the real API package — that transition is now complete.

## mock_flutter_belgium_repository.dart

Update all imports from local model/repository paths to `package:flutter_belgium_data/flutter_belgium_data.dart`. Drop redundant `isActive: true` from every `PersonCompany` constructor (it is now the default). Keep the file in the repo as a reference and for tests.

## Import updates (22 files)

Every file that imports `package:flutter_belgium_website/data/models/X.dart` must be updated:

- Files that **do not** already import `flutter_belgium_data`: replace the first local model import with `import 'package:flutter_belgium_data/flutter_belgium_data.dart';` and remove all remaining local model import lines.
- Files that **already** import `flutter_belgium_data`: remove all local model import lines, keeping the existing `flutter_belgium_data` import.

Affected components: `footer`, `hero_section`, `hosting_companies_section`, `join_section`, `meetup_list_card`, `nav_bar`, `next_meetup_section`, `past_meetups_section`, `sponsor_section`, `talk_card`, `talks_section`, `team_section`, `testimonials_section`.

Affected pages: `app_page`, `become_a_sponsor_page`, `branding_page`, `home_page`, `legal_page`, `meetup_detail_page`, `meetups_page`, `privacy_policy_page`, `scan_page`, `talks_page`, `terms_page`, `made_in_app_detail_page`, `made_in_apps_page`, `made_in_companies_page`, `made_in_company_detail_page`, `made_in_developer_detail_page`, `made_in_developers_page`.

## PersonCompany model change

`PersonCompany.isActive` now has a default of `true` and `jobTitle` is now `String?`. Existing mock constructors that pass `isActive: true` are redundant — remove that named argument.
