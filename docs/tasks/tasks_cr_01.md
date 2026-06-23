# **Journal Trend Analysis - Lab 3 Implementation Task List (tasks_cr_01.md)**

This document details the step-by-step incremental development tasks required to integrate **Firebase Services** and **Patrol E2E testing** into the Journal Trend Analysis application. It covers only the new and modified requirements specified in `requirements_change_request_01.md` and does not duplicate completed Lab 2 baseline tasks.

---

## **Phase 11 — Firebase Services Infrastructure**

- [x] **T11.1: Firebase Core Setup and Platform Provisioning**
  - **Description**: Add packages `firebase_core` to `pubspec.yaml`. Configure Firebase project on the console for Android. Generate and register debug SHA-1 keys. Place `google-services.json` in `android/app/`. Initialize Firebase in `main.dart` asynchronously.
  - **Dependencies**: None (starts after Lab 2 baseline is functional)
  - **Acceptance Criteria**: App compiles and boots on Android emulator with `Firebase.initializeApp()` successfully executed.
  - **Estimated Complexity**: Medium

- [x] **T11.2: Firebase Authentication & Google Sign-In**
  - **Description**: Add `firebase_auth` and `google_sign_in` to `pubspec.yaml`. Create `FirebaseAuthService` wrapper. Implement `AuthBloc` (events: `SignInRequested`, `SignOutRequested`, `CheckAuthStatus`). Update router redirects to secure all app views behind `/login`.
  - **Dependencies**: T11.1
  - **Acceptance Criteria**: Attempting to access app routes without being signed in redirects to `/login`. Triggering Google Sign-In launches account picker, authenticates, and routes to `/home`.
  - **Estimated Complexity**: High

- [x] **T11.3: Login Screen Implementation**
  - **Description**: Create `login_screen.dart`. Design a clean, Slate-dark themed interface with a "Sign in with Google" button, loading progress indicator, and error snackbars.
  - **Dependencies**: T11.2
  - **Acceptance Criteria**: Google Sign-In button renders, displays loading spinner during authentication, and shows clear errors on network failure.
  - **Estimated Complexity**: Medium

- [x] **T11.4: Firebase Storage & PDF Report Generation**
  - **Description**: Add `firebase_storage`, `pdf`, and `printing` packages. Implement `PDFReportService` generating a multi-page document layout containing the 6 dashboard metrics. Implement `ReportRepository` to handle temporary file writes and upload streams to Firebase Storage. Wire up `ReportCubit`.
  - **Dependencies**: T11.1
  - **Acceptance Criteria**: Tapping the "Export PDF" button generates the report, uploads it, returns a valid public URL, and displays it in the UI.
  - **Estimated Complexity**: High

- [x] **T11.5: Firebase Cloud Messaging & Notification Center**
  - **Description**: Add `firebase_messaging` to `pubspec.yaml`. Set up FCM background/foreground message event streams. Log FCM token to console for testing. Create `NotificationCubit` to hold runtime notification arrays. Rework Profile Screen to display a scrollable Notifications list.
  - **Dependencies**: T11.1
  - **Acceptance Criteria**: App registers for push notifications. Sending an FCM payload from the console is received by the app and populates the notification list.
  - **Estimated Complexity**: High

- [x] **T11.6: Remote Config & Crashlytics Integration**
  - **Description**: Add `firebase_remote_config` and `firebase_crashlytics` to `pubspec.yaml`. Implement `RemoteConfigService` with defaults (e.g. `max_journals_limit: 10`, `max_keywords_limit: 10`). Wire unhandled error streams to Crashlytics.
  - **Dependencies**: T11.1
  - **Acceptance Criteria**: App fetches Remote Config settings on boot. Crashing the app manually via button click uploads crash trace reports to the Firebase console.
  - **Estimated Complexity**: Medium

- [x] **T11.7: Firebase Analytics Events Tracking**
  - **Description**: Add `firebase_analytics`. Implement tracking invocations across matching files:
    - `login` on auth success.
    - `search_topic` on search query trigger.
    - `view_publication` in publication details screen.
    - `view_journal` in journal details screen.
    - `view_keyword` in keyword details screen.
    - `export_pdf` when report finishes uploading.
    - `logout` when signing out.
  - **Dependencies**: T11.2, T11.4
  - **Acceptance Criteria**: Events log to system console during debugging and trace accurately in Firebase Analytics DebugView.
  - **Estimated Complexity**: Medium

---

## **Phase 12 — Screen Restructuring & Adaptations**

- [ ] **T12.1: Home Dashboard Metrics Expansion**
  - **Description**: Modify `home_screen.dart`. Reorganize the bento grid from showing 2 metrics to showing all 6 required dashboard cards (Total publications, Avg citations, Most active year, Top journal, Top author, and Most influential publication). Connect the details widgets to the `DashboardBloc` state payload.
  - **Dependencies**: T11.7
  - **Acceptance Criteria**: All 6 cards render correctly on various screen aspect ratios with accurate metrics retrieved from the OpenAlex client.
  - **Estimated Complexity**: Medium

- [ ] **T12.2: Journals Screen Redesign**
  - **Description**: Restructure `journal_screen.dart` to show journal rankings instead of publication cards. Renders a ranked list of top journals, publication count statistics, and a horizontal bar chart of journal contributions. Connect tapping items to navigate to `JournalDetailScreen`.
  - **Dependencies**: T11.7
  - **Acceptance Criteria**: Journals screen lists journals by contribution rank, renders bar charts dynamically, and correctly forwards user selections.
  - **Estimated Complexity**: High

- [ ] **T12.3: Keywords Screen Rework & Keyword Detail Screen**
  - **Description**: Update `keywords_screen.dart` to focus on keyword analytics and navigate to a new `KeywordDetailScreen`. Create the new detail view showing keyword publication trends chart, related journals list, top authors, and related papers feed.
  - **Dependencies**: T11.7
  - **Acceptance Criteria**: Keywords screen behaves as a search index. Selecting a keyword opens the detail screen loading all 4 analytical feeds properly.
  - **Estimated Complexity**: High

---

## **Phase 13 — Patrol Automated Testing**

- [ ] **T13.1: Patrol Framework Configuration**
  - **Description**: Install `patrol_cli`. Add `patrol` dev dependency. Configure `android/app/build.gradle` (test runner class and dependencies setup).
  - **Acceptance Criteria**: Running `patrol doctor` completes successfully on the workstation.
  - **Estimated Complexity**: Medium

- [ ] **T13.2: E2E Patrol Test Suite Implementation**
  - **Description**: Build automated tests inside `patrol_tests/` matching all 11 required scenarios:
    - `authentication_test.dart` (Google sign-in login verification, redirection, sign out).
    - `publication_test.dart` (Topic search, list rendering, opening publication details).
    - `journal_test.dart` (Journals navigation, list rendering, journal details verification).
    - `keyword_test.dart` (Keywords navigation, detail screens checking).
    - `profile_test.dart` (Profile user info checks, notifications display).
    - `export_test.dart` (PDF generation, storage upload validations).
    - `remote_config_test.dart` (Verification of config parameters updates in the UI).
  - **Dependencies**: T13.1, Phase 11, Phase 12
  - **Acceptance Criteria**: Executing `patrol test` runs all integration scripts on target emulator and returns all pass indicators.
  - **Estimated Complexity**: High
