# **Journal Trend Analysis Mobile Application - Implementation Task List**

This document details the step-by-step incremental development tasks required to build the Flutter-based **Journal Trend Analysis Mobile Application**. Follow this list sequentially to build the application from scratch to final deployment.

---

## **Phase 1 — Project Foundation**

- [x] **T1.1: Flutter Project Initialization & Pubspec Configuration**
  - **Description**: Initialize a clean Flutter application targetting Android. Add dependencies defined in `design.md` to `pubspec.yaml` (including flutter_bloc, get_it, go_router, dio, hive, shared_preferences, fl_chart, dartz, graphview, easy_localization). Run flutter pub get.
  - **Dependencies**: None
  - **Acceptance Criteria**: Flutter project runs successfully on the emulator, and `pubspec.yaml` contains all specified packages without any conflicts.
  - **Estimated Complexity**: Low

- [x] **T1.2: Directory Structure Configuration**
  - **Description**: Configure the main folder structure in `lib/` to implement Clean Architecture, separating `core/` and `features/` (personalization, home, journal, keywords, profile, author, institution). Create all directories and stub files.
  - **Dependencies**: T1.1
  - **Acceptance Criteria**: Workspace directories are structured exactly as defined in Section 3 of `design.md`.
  - **Estimated Complexity**: Low

- [x] **T1.3: Core Theme and Color Palette Setup**
  - **Description**: Create `app_colors.dart` and `app_theme.dart` under `lib/core/theme/`. Define dark and light theme palettes. Specifically configure the premium Slate Dark theme (#0B0F19 background, #1E293B card background, #6366F1 indigo primary) using Google Fonts `Outfit` and `Inter`.
  - **Dependencies**: T1.2
  - **Acceptance Criteria**: AppTheme classes compiled cleanly. MaterialTheme utilizes the dark slate colors and Google Fonts on running test widgets.
  - **Estimated Complexity**: Low

- [x] **T1.4: Localization & Assets Setup**
  - **Description**: Set up translations folders `assets/translations/en.json` and `assets/translations/vi.json` and configure `easy_localization`. Add keys for setup screens, dashboard tabs, charts, details, and errors. Update `main.dart` to initialize localization.
  - **Dependencies**: T1.2
  - **Acceptance Criteria**: App launches with localization support. Changing languages dynamically replaces localized string values in widgets.
  - **Estimated Complexity**: Low

---

## **Phase 2 — Core Architecture**

- [x] **T2.1: Custom Errors, Exceptions & Failures Setup**
  - **Description**: Create `exceptions.dart` and `failures.dart` under `lib/core/error/`. Implement `Failure` base class and custom subclasses: `ServerFailure`, `CacheFailure`, `NetworkFailure`. Ensure that all failures override `props` using `equatable` for easy testing.
  - **Dependencies**: T1.2
  - **Acceptance Criteria**: Code compiles. Failure classes are fully defined with localized user-friendly message mappings.
  - **Estimated Complexity**: Low

- [x] **T2.2: Dependency Injection Config**
  - **Description**: Setup `get_it` service locator configuration in `lib/injection_container.dart` utilizing `injectable`. Add base setups for external classes (Dio, SharedPreferences, Hive).
  - **Dependencies**: T1.2
  - **Acceptance Criteria**: `injection_container.dart` is present and successfully auto-generates dependency maps upon running `flutter pub run build_runner build`.
  - **Estimated Complexity**: Low

- [x] **T2.3: Network Client Integration**
  - **Description**: Create `api_client.dart` under `lib/core/network/` enclosing `Dio` configurations. Write an interceptor attaching the custom polite User-Agent (`JournalTrendAnalyzer/1.0 (mailto:academic-analytics@fptu.edu.vn)`) and loggers. Include connection timeout constraints.
  - **Dependencies**: T2.2
  - **Acceptance Criteria**: ApiClient behaves as a singleton in GetIt. Network requests are sent with custom headers and verified via console outputs.
  - **Estimated Complexity**: Medium

- [x] **T2.4: Local Storage Box Setup**
  - **Description**: Register and open Hive boxes (`analytics_cache` and `search_history`) and configure standard primitive SharedPreferences file instances. Initialize this on application setup in `main.dart`.
  - **Dependencies**: T2.2
  - **Acceptance Criteria**: Hive and SharedPreferences are initialized asynchronously at app start before `runApp()` executes.
  - **Estimated Complexity**: Medium

- [x] **T2.5: Navigation Shell Routing Config**
  - **Description**: Configure `go_router` in `lib/core/navigation/app_router.dart`. Implement a ShellRoute setup enclosing a bottom navigation layout (Home, Journal, Keywords, Profile). Write the route guard checking local preferences for first-time launch.
  - **Dependencies**: T2.4
  - **Acceptance Criteria**: App redirects to `/setup` if preferences are empty, otherwise boots directly into the bottom-tabbed interface.
  - **Estimated Complexity**: High

---

## **Phase 3 — Personalization Setup**

- [x] **T3.1: UserPreferences Entity & Local Data Source**
  - **Description**: Create the domain `UserPreferences` entity and data model `UserPreferencesModel` supporting JSON serialization. Implement `PersonalizationLocalDataSource` to read/write preferences to SharedPreferences.
  - **Dependencies**: T2.4
  - **Acceptance Criteria**: Data source methods can read, write, and clear preference states reliably in local tests.
  - **Estimated Complexity**: Low

- [x] **T3.2: UserPreferences Repository & Use Cases**
  - **Description**: Define the `UserRepository` interface in the domain layer. Write the data implementation `UserRepositoryImpl` linking the local data source. Implement use cases: `GetUserPreferences`, `SaveUserPreferences`, and `GenerateRandomName`.
  - **Dependencies**: T3.1
  - **Acceptance Criteria**: Use cases compile cleanly, returning either a `Failure` or the specified data object using `Either` logic.
  - **Estimated Complexity**: Medium

- [x] **T3.3: Random Researcher Name Generator Utility**
  - **Description**: Implement a name generator logic under `lib/core/utils/name_generator.dart`. Combine academic titles (`Dr.`, `Prof.`), academic surnames, and modern/tech terms randomly.
  - **Dependencies**: T1.2
  - **Acceptance Criteria**: Calling `generateRandomName()` returns a random, realistic researcher name (e.g., `Dr. Sophia Vector`). No duplicates are generated consecutively.
  - **Estimated Complexity**: Low

- [x] **T3.4: Personalization BLoc**
  - **Description**: Implement `PersonalizationBloc` under `features/personalization/presentation/`. Handle events: `LoadPreferences`, `SubmitPreferences`, `GenerateNamePressed`. Manage states: `Initial`, `Loading`, `Loaded`, `SubmitSuccess`, `Error`.
  - **Dependencies**: T3.2, T3.3
  - **Acceptance Criteria**: Bloc triggers events, updates local storage asynchronously on save, and transitions states correctly.
  - **Estimated Complexity**: Medium

- [x] **T3.5: Personalization Setup Screen**
  - **Description**: Build `setup_screen.dart`. Create a sleek dark-mode UI with input fields for "Full Name" and an autocomplete dropdown list for "Research Interest" (fetching dynamically via API). Add the "Generate Random Researcher Name" button to populate the name field.
  - **Dependencies**: T3.4
  - **Acceptance Criteria**: User can type their name, click the random generator button to automatically fill the name, search and select an interest from the API dropdown, and submit to save.
  - **Estimated Complexity**: High

- [x] **T3.6: Router Personalization Route Guard Integration**
  - **Description**: Update the app router to verify setup completion. Set up a listener on `PersonalizationBloc` state to trigger navigation updates on initialization.
  - **Dependencies**: T2.5, T3.5
  - **Acceptance Criteria**: Once personalization is submitted, the setup screen redirects automatically to `/home` without user delay.
  - **Estimated Complexity**: Medium

---

## **Phase 4 — Dashboard**

- [x] **T4.1: Dashboard Domain Layer**
  - **Description**: Add the entity models: `PublicationTrend`, `CitationTrend`, `Paper`. Set up repositories, use cases, and interfaces to access overview details from the OpenAlex data model.
  - **Dependencies**: T2.1
  - **Acceptance Criteria**: Domain models compile and implement value equatability overrides.
  - **Estimated Complexity**: Low

- [x] **T4.2: Dashboard Remote Data Source**
  - **Description**: Write `DashboardRemoteDataSource` to execute queries to OpenAlex `/works` endpoint. Retrieve metadata (publication count, cited count) grouped by concept.
  - **Dependencies**: T2.3
  - **Acceptance Criteria**: API responses are parsed successfully into DTO models, handles empty parameters and error payloads.
  - **Estimated Complexity**: Medium

- [x] **T4.3: Dashboard Repository Implementation**
  - **Description**: Implement `OpenAlexRepository` interface in `DashboardRepositoryImpl`. Coordinate Remote API lookup with local database `Hive` cache persistence. Implement the logic checking sync timestamp dates.
  - **Dependencies**: T4.2, T2.4
  - **Acceptance Criteria**: Data is pulled from Hive cache if accessed on the same calendar day. Otherwise, remote fetch is executed, updated in cache, and then returned.
  - **Estimated Complexity**: High

- [x] **T4.4: Dashboard Bloc Integration**
  - **Description**: Create `DashboardBloc` managing the load events. Integrate it with `GetDashboardData` usecase. Yield states: `DashboardLoading`, `DashboardLoaded`, `DashboardFailure`.
  - **Dependencies**: T4.3
  - **Acceptance Criteria**: Bloc emits proper loading state, fetches data using saved user preferences, and updates UI on completion.
  - **Estimated Complexity**: Medium

- [x] **T4.5: Dashboard UI Page & Bento Cards Layout**
  - **Description**: Create `home_screen.dart` containing the Dashboard. Implement a sleek Bento Grid Layout displaying cards for: Welcome message (personalization info), total publication count, average citation count, most active year, top journal, top author.
  - **Dependencies**: T4.4, T1.3
  - **Acceptance Criteria**: UI layout matches color palette, scales correctly on various mobile display aspect ratios, and handles loading skeleton shimmers.
  - **Estimated Complexity**: High

- [x] **T4.6: Synchronization Status Display & Manual Sync Trigger UI**
  - **Description**: Add a sync indicator widget at the top of the dashboard showing the date/time of the last update. Add a manual refresh button that clears the cache and triggers a remote fetch.
  - **Dependencies**: T4.5
  - **Acceptance Criteria**: Clicking the refresh button triggers a reload, displays active loading animations, fetches remote data, updates the sync indicator timestamp, and refreshes all metrics.
  - **Estimated Complexity**: Medium

---

## **Phase 5 — Trend Analytics**

- [x] **T5.1: Publication Trend API and Local Data Cache**
  - **Description**: Write usecase `GetPublicationTrend`. Query OpenAlex `works` endpoint filtering by concept, grouped by `publication_year`. Cache output list in Hive box.
  - **Dependencies**: T4.3
  - **Acceptance Criteria**: JSON groupings are serialized to local DB boxes and returned as list entities.
  - **Estimated Complexity**: Medium

- [x] **T5.2: Publication Trend Line Chart UI Component**
  - **Description**: Implement the `PublicationTrendLineChart` widget using `fl_chart`. Display a Line Chart mapping paper counts against publication years. Customise line gradient fill, grid lines, and interactive tooltips.
  - **Dependencies**: T5.1, T1.3
  - **Acceptance Criteria**: Line chart displays data curves clearly with clean axis labeling. Tapping on coordinates highlights values with an animation overlay.
  - **Estimated Complexity**: High

- [x] **T5.3: Top Keywords Analysis API and UI Horizontal Bar Chart**
  - **Description**: Define the `Keyword` entity. Fetch keyword counts from OpenAlex works. Build `TopKeywordsBarChart` displaying the top 10 keywords in a Horizontal Bar Chart.
  - **Dependencies**: T4.3, T1.3
  - **Acceptance Criteria**: Keywords are ordered from highest count to lowest count and plotted on a neat horizontal bar chart.
  - **Estimated Complexity**: High

- [x] **T5.4: Author Productivity vs Impact Scatter Plot Widget**
  - **Description**: Retrieve top author profiles for the topic. Render a Scatter Plot using `fl_chart` plotting total papers (productivity - X-axis) vs total citations (impact - Y-axis) for each author.
  - **Dependencies**: T4.3, T1.3
  - **Acceptance Criteria**: Authors are plotted as distinct dots on the scatter plot. Tapping a dot reveals the author's name and metrics in a tooltip.
  - **Estimated Complexity**: High

- [x] **T5.5: Journal Ranking Horizontal Bar Chart UI**
  - **Description**: Query `/works` to aggregate source counts, calculating the contribution count for each journal. Build `JournalRankingBarChart` displaying journals in a ranked horizontal bar chart.
  - **Dependencies**: T4.3, T1.3
  - **Acceptance Criteria**: The chart ranks journals by publication volume, conforming to the "Journal Trend Analysis" branding.
  - **Estimated Complexity**: Medium

- [x] **T5.6: Author Collaboration Network Graph Widget**
  - **Description**: Retrieve authorship details for the top publications. Map co-authorships into a network model. Build `AuthorCollaborationNetworkGraph` using the `graphview` package to draw visual connection nodes.
  - **Dependencies**: T4.3
  - **Acceptance Criteria**: Authors are represented as nodes. Shared publications are rendered as lines linking nodes together, allowing zoom/pan navigation.
  - **Estimated Complexity**: High

- [x] **T5.7: Emerging Keywords Grid and Topic Evolution Views**
  - **Description**: Calculate keyword growth rate percentages. Render the bento card grid for emerging trends, alongside list representations indicating sub-topic changes.
  - **Dependencies**: T5.3
  - **Acceptance Criteria**: Displays growing keywords sorted by percentage growth, formatted as colorful metric cards.
  - **Estimated Complexity**: Medium

---

## **Phase 6 — Search**

- [ ] **T6.1: Search Concepts API Interface**
  - **Description**: Write `SearchConcepts` usecase. Direct HTTP request to `/concepts?search={query}` on OpenAlex to lookup matches dynamically.
  - **Dependencies**: T2.3
  - **Acceptance Criteria**: Returns list of concepts matching the search term, containing name, level, and OpenAlex ID.
  - **Estimated Complexity**: Medium

- [ ] **T6.2: Recent Searches Local Cache Storage**
  - **Description**: Create the local data source manager for recent queries using Hive. Build local saving and clearing methods. Limit storage to the last 10 unique entries.
  - **Dependencies**: T2.4
  - **Acceptance Criteria**: Query items are pushed to cache when searched. Clearing query history works instantly in tests.
  - **Estimated Complexity**: Low

- [ ] **T6.3: Search Autocomplete UI Dropdown and Input**
  - **Description**: Build search page controls. Integrate keyboard listener to fetch data with debounce (300ms delay). Populate results inside an autocomplete dropdown list.
  - **Dependencies**: T6.1, T6.2
  - **Acceptance Criteria**: Typing in the search input updates lookup suggestions after the debounce delay. Displays local search history when the search bar is focused but empty.
  - **Estimated Complexity**: High

- [ ] **T6.4: Search Result Page Layout and List Builder**
  - **Description**: Clicking a concept loads the matching papers. Build `SearchResultList` utilizing custom publication cards displaying title, year, citations, and journal names.
  - **Dependencies**: T6.3, T4.1
  - **Acceptance Criteria**: Shows search results list in infinite scroll pagination mode. Tapping on a card navigates to the detailed publication view.
  - **Estimated Complexity**: Medium

---

## **Phase 7 — Detail Pages**

- [ ] **T7.1: Publication Detail Screen UI & Abstract Rendering**
  - **Description**: Create `publication_detail_screen.dart` showing title, authors list, year, citation count, DOI (clickable link), abstract text, and open-access status metadata.
  - **Dependencies**: T2.5, T4.1
  - **Acceptance Criteria**: Displays full metadata details. Clicking the DOI opens the device browser. Automatically extracts and formats inverted abstracts from OpenAlex.
  - **Estimated Complexity**: Medium

- [ ] **T7.2: Journal Detail Screen UI**
  - **Description**: Create `journal_detail_screen.dart`. Show total publications count, estimated ranking, publisher, h-index estimation, and homepage URL.
  - **Dependencies**: T2.5, T5.5
  - **Acceptance Criteria**: Details are displayed beautifully. Links are launchable via `url_launcher`.
  - **Estimated Complexity**: Medium

- [ ] **T7.3: Author Detail Screen UI**
  - **Description**: Create `author_detail_screen.dart`. Fetch author stats (total works, citation index, last known institution, homepage profile). Display list of recent papers published by this author.
  - **Dependencies**: T2.5, T5.4
  - **Acceptance Criteria**: Displays author profile information, their citation metrics, and list of works. Tapping a work navigates back to the Publication Detail Screen.
  - **Estimated Complexity**: High

---

## **Phase 8 — User Features**

- [ ] **T8.1: Profile & Settings Page Layout**
  - **Description**: Create `profile_screen.dart`. Render user name and active research focus info. Include settings widgets: Change Language (English/Vietnamese), Toggle Dark/Light Mode, Clear Local Cache database.
  - **Dependencies**: T2.5, T3.4
  - **Acceptance Criteria**: UI layout matches design system rules. Updates local configuration parameters instantly on changes.
  - **Estimated Complexity**: Medium

- [ ] **T8.2: Daily Automatic Refresh Sync Engine**
  - **Description**: Implement logic checks in `main.dart` or initialization BLoc. Read cached sync timestamp. Compare with system clock. Run sync if calendar day has changed.
  - **Dependencies**: T4.3, T4.6
  - **Acceptance Criteria**: On app boot, if date changed since last log, calls `refreshAllData()` in background and updates dashboard UI metrics quietly.
  - **Estimated Complexity**: Medium

- [ ] **T8.3: Local Storage Wipe & Settings adjustments**
  - **Description**: Write handlers for deleting cached datasets inside Hive. Include confirmation dialog alerts before execution.
  - **Dependencies**: T8.1, T2.4
  - **Acceptance Criteria**: Triggering "Clear Cache" drops Hive tables, resets personalization state, and redirects the app back to the Personalization Setup screen.
  - **Estimated Complexity**: Low

---

## **Phase 9 — Testing**

- [ ] **T9.1: Unit Testing for Domain Use Cases**
  - **Description**: Write unit tests verifying logic paths for use cases: `GetUserPreferences`, `SaveUserPreferences`, `GetPublicationTrend`, `SearchTopics`. Mock repository layers.
  - **Dependencies**: T3.2, T4.1, T5.1
  - **Acceptance Criteria**: All use case unit tests pass successfully. Code coverage target: >80% for use cases.
  - **Estimated Complexity**: Medium

- [ ] **T9.2: Unit Testing for Repository Cache Coordination**
  - **Description**: Write unit tests for `OpenAlexRepositoryImpl`. Verify that cached data is returned first when valid, and remote API is queried when the cache has expired.
  - **Dependencies**: T4.3
  - **Acceptance Criteria**: Mocks simulate cache hits, cache misses, and api failures correctly, passing all validation tests.
  - **Estimated Complexity**: Medium

- [ ] **T9.3: Widget Testing for Setup Screen & Bento Card Widgets**
  - **Description**: Write widget tests checking input text fields, validation errors, and list expansions. Test that Bento Cards render content and call callback triggers.
  - **Dependencies**: T3.5, T4.5
  - **Acceptance Criteria**: Widget tests verify layout elements and simulate tap events without errors.
  - **Estimated Complexity**: Medium

- [ ] **T9.4: Widget Testing for Interactive Charts**
  - **Description**: Test that custom widgets (`PublicationTrendLineChart`, `TopKeywordsBarChart`, `AuthorProductivityScatterPlot`) render data curves without throwing layout overflow errors.
  - **Dependencies**: T5.2, T5.3, T5.4
  - **Acceptance Criteria**: Test data lists are rendered correctly within the chart coordinates during tests.
  - **Estimated Complexity**: Medium

- [ ] **T9.5: Integration Testing for Full Onboarding Flow**
  - **Description**: Write integration tests using `integration_test` package. Programmatically open application, fill personalization inputs, tap name generator, select topic, transition to dashboard, view charts, and trigger sync.
  - **Dependencies**: T8.3, T3.6
  - **Acceptance Criteria**: End-to-end integration tests execute successfully on emulator target and verify app flow without human intervention.
  - **Estimated Complexity**: High

---

## **Phase 10 — Deployment & Performance Tuning**

- [ ] **T10.1: App Shimmer Loading States & Performance Tuning**
  - **Description**: Audit app performance. Implement optimization techniques: const constructors, list view item caching, list item recycling, image pre-fetching, and lazy-loading of inactive tabs.
  - **Dependencies**: T8.3
  - **Acceptance Criteria**: App renders at 60fps/120fps with no frame drops during scrolling lists. Memory usage stays low.
  - **Estimated Complexity**: Medium

- [ ] **T10.2: ProGuard & Android Release Configuration**
  - **Description**: Set up optimization configs in `android/app/build.gradle`. Set up ProGuard rules file `proguard-rules.pro` to minify release code. Configure digital keys and properties.
  - **Dependencies**: T1.1
  - **Acceptance Criteria**: Release configurations are set up and successfully verified.
  - **Estimated Complexity**: Medium

- [ ] **T10.3: Final Build Execution**
  - **Description**: Execute CLI build commands: `flutter build apk --release` and `flutter build appbundle`. Verify bundle output sizes.
  - **Dependencies**: T10.2, T9.5
  - **Acceptance Criteria**: Generates optimized production-ready release APK and AAB binaries under `build/app/outputs/` directory.
  - **Estimated Complexity**: Low
