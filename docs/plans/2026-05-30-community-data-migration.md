# Community Data Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove all duplicate community data models and repository interface from the website, switch to `AirtableFlutterBelgiumRepository` from `flutter_belgium_data`, and fail-fast at startup if any required env var is missing.

**Architecture:** The `flutter_belgium_data` package (`feat/airtable-data` branch) now owns all community models and the `FlutterBelgiumRepository` interface. The website deletes its local copies, updates all imports to the package barrel, and wires `AirtableFlutterBelgiumRepository` into `main.server.dart` using six env vars read at startup.

**Tech Stack:** Dart, Jaspr (static site), `flutter_belgium_data` git dependency, AirTable HTTP API

---

### Task 1: Update pubspec.yaml and refresh dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add `ref` to the git dependency**

Replace the existing `flutter_belgium_data` block in `pubspec.yaml`:

```yaml
  flutter_belgium_data:
    git:
      url: https://github.com/flutter-belgium/flutter_belgium_data.git
      ref: feat/airtable-data
```

- [ ] **Step 2: Run pub get**

```bash
fvm dart pub get
```

Expected: resolves dependencies with no errors. The `flutter_belgium_data` entry in `.dart_tool/package_config.json` should now point to the `feat/airtable-data` revision.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: point flutter_belgium_data to feat/airtable-data branch"
```

---

### Task 2: Update mock_flutter_belgium_repository.dart

**Files:**
- Modify: `lib/data/repositories/mock_flutter_belgium_repository.dart`

- [ ] **Step 1: Replace the file content**

The only changes are: (a) swap all 11 local imports for a single package import, (b) drop `isActive: true` from every `PersonCompany` constructor (it is now the default). Replace the entire import block at the top of the file:

```dart
import 'package:flutter_belgium_data/flutter_belgium_data.dart';
```

Remove these lines (they are replaced by the single import above):
```
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';
import 'package:flutter_belgium_website/data/models/sponsor.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/data/models/team_member.dart';
import 'package:flutter_belgium_website/data/models/testimonial.dart';
import 'package:flutter_belgium_website/data/repositories/flutter_belgium_repository.dart';
```

- [ ] **Step 2: Fix PersonCompany constructors**

Find every `PersonCompany(` call that passes `isActive: true` and remove that named argument. There are three such calls (one per person). Example — before:

```dart
PersonCompany(
    name: 'impaktfull',
    jobTitle: 'Founder & Flutter Developer',
    isActive: true),
```

After:

```dart
PersonCompany(
    name: 'impaktfull',
    jobTitle: 'Founder & Flutter Developer'),
```

Apply the same to the `_jens` and `_kris` constants.

- [ ] **Step 3: Verify no analyzer errors**

```bash
fvm dart analyze lib/data/repositories/mock_flutter_belgium_repository.dart
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/data/repositories/mock_flutter_belgium_repository.dart
git commit -m "refactor: use flutter_belgium_data types in MockFlutterBelgiumRepository"
```

---

### Task 3: Update main.server.dart to use AirtableFlutterBelgiumRepository

**Files:**
- Modify: `lib/main.server.dart`

- [ ] **Step 1: Add `dart:io` import**

Add at the top of the import block (keep alphabetical order with the other dart: imports — there are none currently, so add it first):

```dart
import 'dart:io';
```

- [ ] **Step 2: Add the env-var loader function**

Add this private function directly above `void main()`:

```dart
AirTableConfig _loadAirTableConfig() {
  const required = {
    'AIRTABLE_TOKEN',
    'AIRTABLE_BASE',
    'AIRTABLE_TABLE_MEETUPS',
    'AIRTABLE_TABLE_PEOPLE',
    'AIRTABLE_TABLE_TALKS',
    'AIRTABLE_TABLE_LOCATIONS',
  };
  final missing =
      required.where((k) => Platform.environment[k] == null).toList();
  if (missing.isNotEmpty) {
    throw StateError(
        'Missing required environment variables: ${missing.join(', ')}');
  }
  return AirTableConfig(
    personalAccessToken: Platform.environment['AIRTABLE_TOKEN']!,
    base: Platform.environment['AIRTABLE_BASE']!,
    tableMeetups: Platform.environment['AIRTABLE_TABLE_MEETUPS']!,
    tablePeople: Platform.environment['AIRTABLE_TABLE_PEOPLE']!,
    tableTalks: Platform.environment['AIRTABLE_TABLE_TALKS']!,
    tableLocations: Platform.environment['AIRTABLE_TABLE_LOCATIONS']!,
  );
}
```

- [ ] **Step 3: Replace MockFlutterBelgiumRepository with AirtableFlutterBelgiumRepository**

Remove the import:
```dart
import 'package:flutter_belgium_website/data/repositories/mock_flutter_belgium_repository.dart';
```

Replace the repository instantiation line:
```dart
// before
final repository = MockFlutterBelgiumRepository();

// after
final repository = AirtableFlutterBelgiumRepository(config: _loadAirTableConfig());
```

- [ ] **Step 4: Remove the stale comment**

Delete these lines (the migration is now complete):
```dart
// To switch to the real API package, replace MockFlutterBelgiumRepository
// with ApiFlutterBelgiumRepository from the published Dart package,
// then delete lib/data/models/ and lib/data/repositories/mock_*.dart.
```

- [ ] **Step 5: Verify no analyzer errors**

```bash
fvm dart analyze lib/main.server.dart
```

Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/main.server.dart
git commit -m "feat: switch to AirtableFlutterBelgiumRepository with env-var config"
```

---

### Task 4: Bulk-update component and page imports

**Files:**
- Modify: all 24 files listed below

24 files still import local data models. The rule:
- If the file **already** has `import 'package:flutter_belgium_data/flutter_belgium_data.dart';` → remove every local model import line.
- If the file **does not** have that import → replace the first local model import line with `import 'package:flutter_belgium_data/flutter_belgium_data.dart';` and remove all remaining local model import lines.

Files that already have the `flutter_belgium_data` import (remove local lines only):
- `lib/pages/home_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_app_detail_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_apps_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_companies_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_company_detail_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_developer_detail_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_developers_page.dart`

Files that do not yet have the `flutter_belgium_data` import (replace first, remove rest):
- `lib/components/footer.dart`
- `lib/components/hero_section.dart`
- `lib/components/hosting_companies_section.dart`
- `lib/components/join_section.dart`
- `lib/components/meetups/meetup_list_card.dart`
- `lib/components/nav_bar.dart`
- `lib/components/next_meetup_section.dart`
- `lib/components/past_meetups_section.dart`
- `lib/components/sponsor_section.dart`
- `lib/components/talk_card.dart`
- `lib/components/talks_section.dart`
- `lib/components/team_section.dart`
- `lib/components/testimonials_section.dart`
- `lib/pages/app_page.dart`
- `lib/pages/become_a_sponsor_page.dart`
- `lib/pages/branding_page.dart`
- `lib/pages/legal_page.dart`
- `lib/pages/meetups/meetup_detail_page.dart`
- `lib/pages/meetups/meetups_page.dart`
- `lib/pages/privacy_policy_page.dart`
- `lib/pages/scan_page.dart`
- `lib/pages/talks/talks_page.dart`
- `lib/pages/terms_page.dart`

- [ ] **Step 1: Run the import-rewrite script**

```bash
python3 - << 'EOF'
import re, os

FBD = "import 'package:flutter_belgium_data/flutter_belgium_data.dart';"
LOCAL = re.compile(
    r"^import 'package:flutter_belgium_website/data/models/\w+\.dart';\n?",
    re.MULTILINE,
)

files = [
    "lib/pages/home_page.dart",
    "lib/pages/made_in_flutter_belgium/made_in_app_detail_page.dart",
    "lib/pages/made_in_flutter_belgium/made_in_apps_page.dart",
    "lib/pages/made_in_flutter_belgium/made_in_companies_page.dart",
    "lib/pages/made_in_flutter_belgium/made_in_company_detail_page.dart",
    "lib/pages/made_in_flutter_belgium/made_in_developer_detail_page.dart",
    "lib/pages/made_in_flutter_belgium/made_in_developers_page.dart",
    "lib/components/footer.dart",
    "lib/components/hero_section.dart",
    "lib/components/hosting_companies_section.dart",
    "lib/components/join_section.dart",
    "lib/components/meetups/meetup_list_card.dart",
    "lib/components/nav_bar.dart",
    "lib/components/next_meetup_section.dart",
    "lib/components/past_meetups_section.dart",
    "lib/components/sponsor_section.dart",
    "lib/components/talk_card.dart",
    "lib/components/talks_section.dart",
    "lib/components/team_section.dart",
    "lib/components/testimonials_section.dart",
    "lib/pages/app_page.dart",
    "lib/pages/become_a_sponsor_page.dart",
    "lib/pages/branding_page.dart",
    "lib/pages/legal_page.dart",
    "lib/pages/meetups/meetup_detail_page.dart",
    "lib/pages/meetups/meetups_page.dart",
    "lib/pages/privacy_policy_page.dart",
    "lib/pages/scan_page.dart",
    "lib/pages/talks/talks_page.dart",
    "lib/pages/terms_page.dart",
]

for path in files:
    with open(path) as f:
        src = f.read()
    has_fbd = FBD in src
    if has_fbd:
        out = LOCAL.sub("", src)
    else:
        seen = [False]
        def repl(m):
            if not seen[0]:
                seen[0] = True
                return FBD + "\n"
            return ""
        out = LOCAL.sub(repl, src)
    out = re.sub(r'\n{3,}', '\n\n', out)
    with open(path, "w") as f:
        f.write(out)
    print(f"updated {path}")
EOF
```

Expected: 30 lines of `updated lib/...` with no Python errors.

- [ ] **Step 2: Verify no remaining local model imports in lib/**

```bash
grep -r "flutter_belgium_website/data/models" lib/ --include="*.dart"
```

Expected: no output (zero matches).

- [ ] **Step 3: Verify no analyzer errors across all updated files**

```bash
fvm dart analyze lib/components lib/pages
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/components lib/pages
git commit -m "refactor: replace local data model imports with flutter_belgium_data package"
```

---

### Task 5: Delete obsolete local files

**Files:**
- Delete: `lib/data/models/community_links.dart`
- Delete: `lib/data/models/company.dart`
- Delete: `lib/data/models/meetup.dart`
- Delete: `lib/data/models/person.dart`
- Delete: `lib/data/models/person_company.dart`
- Delete: `lib/data/models/person_social_links.dart`
- Delete: `lib/data/models/sponsor.dart`
- Delete: `lib/data/models/talk.dart`
- Delete: `lib/data/models/team_member.dart`
- Delete: `lib/data/models/testimonial.dart`
- Delete: `lib/data/repositories/flutter_belgium_repository.dart`
- Delete: `lib/util/string_utils.dart`

- [ ] **Step 1: Delete all obsolete files**

```bash
rm lib/data/models/community_links.dart \
   lib/data/models/company.dart \
   lib/data/models/meetup.dart \
   lib/data/models/person.dart \
   lib/data/models/person_company.dart \
   lib/data/models/person_social_links.dart \
   lib/data/models/sponsor.dart \
   lib/data/models/talk.dart \
   lib/data/models/team_member.dart \
   lib/data/models/testimonial.dart \
   lib/data/repositories/flutter_belgium_repository.dart \
   lib/util/string_utils.dart
```

- [ ] **Step 2: Check lib/data/models is now empty**

```bash
ls lib/data/models/
```

Expected: empty directory listing (no files).

- [ ] **Step 3: Full analyzer pass**

```bash
fvm dart analyze lib/
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "chore: delete local data models, repository interface, and string_utils"
```

---

### Task 6: Verify the full build

**Files:** none

- [ ] **Step 1: Run the Jaspr build**

```bash
fvm dart run jaspr build
```

Expected: build completes with no errors. A `build/` directory is produced.

- [ ] **Step 2: Confirm no stale local data references remain**

```bash
grep -r "flutter_belgium_website/data" lib/ --include="*.dart"
grep -r "flutter_belgium_website/util/string_utils" lib/ --include="*.dart"
```

Expected: no output for either command.
