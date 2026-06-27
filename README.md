# Digify HR (grc_web)

Flutter web application for the Digify HR enterprise suite, including time tracking, attendance, leave management, payroll, and GRC modules.

## Prerequisites

- [FVM](https://fvm.app/) (Flutter Version Management)
- Flutter stable (configured via `.fvmrc`)

## Setup

```bash
fvm install
fvm flutter pub get
```

## Run

```bash
fvm flutter run -d chrome
```

## Build

```bash
fvm flutter build web
```

Output is written to `build/web/`.

## Dependencies

This project depends on `digify_grc_suite` from [hananmalik21/grc_suite](https://github.com/hananmalik21/grc_suite.git).
