# Permission System — Developer Guide

## What is this?

Every action in the app (view a screen, click a button, run a query) is protected by a **permission key** — a dot-separated string like:

```
employees.manage_employees.view
employees.manage_employees.*
employees.*
```

When a user logs in, the backend returns a list of keys they are allowed to do. The frontend checks these keys before rendering any button, sidebar item, or route.

---

## File Map

```
lib/core/permissions/
├── perm_action.dart       — The 4 actions: create, view, update, delete
├── perm_module.dart       — Data classes: PermModule, PermSubModule
├── perm_catalog.dart      — Every module/submodule in the app (single source of truth)
├── perm_keys.dart         — Typed constants for every key (no raw strings in UI code)
├── permission_guard.dart  — Matching logic (exact + wildcard). Only place it lives.
├── permission_service.dart— Singleton that the rest of the app calls. + Riverpod bootstrap.
└── permission_gate.dart   — Widget wrapper: show child only if permission held.
```

---

## Key Concepts

### 1. Key Format

```
{module}.{submodule}.{action}

employees.manage_employees.create
employees.manage_employees.view
employees.manage_employees.*       ← wildcard covers all actions under manage_employees
employees.*                        ← wildcard covers every submodule under employees
```

Keys are always **lowercase**. The backend returns them lowercase; the bootstrap normalises them on init.

---

### 2. Wildcard Matching

`PermissionGuard` resolves a key by checking from most-specific to least-specific:

```
User asks: can I do "employees.manage_employees.create"?

1. Is "employees.manage_employees.create" in the set?     → exact match
2. Is "employees.manage_employees.*" in the set?          → submodule wildcard
3. Is "employees.*" in the set?                           → module wildcard

First match wins. If nothing matches → denied.
```

Wildcards are **never expanded upfront**. Every check is lazy.

---

### 3. The Catalog (`perm_catalog.dart`)

This is the **only place** modules and submodules are defined. Everything else is derived from it.

```dart
const kEmployeesModule = PermModule(
  label: 'Employees',
  baseKey: 'employees',
  subModules: [
    PermSubModule(
      label: 'Manage Employees',
      baseKey: 'employees.manage_employees',
      route: AppRoutes.employees,
    ),
    // more submodules...
  ],
);
```

`kAllModules` is the master list at the bottom of the file. The sidebar and seed utility both loop this list — nothing is hardcoded elsewhere.

---

### 4. Typed Keys (`perm_keys.dart`)

Never write raw strings in UI code. Use `PermKeys`:

```dart
// ✅ Correct
PermissionService().can(PermKeys.manageEmployeesCreate)

// ❌ Wrong — raw string, typos won't be caught
PermissionService().can('employees.manage_employees.create')
```

Every submodule gets 5 constants (`All`, `Create`, `View`, `Update`, `Delete`):

```dart
PermKeys.manageEmployeesAll     // employees.manage_employees.*
PermKeys.manageEmployeesCreate  // employees.manage_employees.create
PermKeys.manageEmployeesView    // employees.manage_employees.view
PermKeys.manageEmployeesUpdate  // employees.manage_employees.update
PermKeys.manageEmployeesDelete  // employees.manage_employees.delete
```

Fields are `static final`, not `static const`, because they are computed at runtime from catalog objects.

---

## How to Use It

### Check a single permission (imperative)

```dart
if (PermissionService().can(PermKeys.manageEmployeesCreate)) {
  // show create button
}
```

### Hide/show a widget (declarative)

```dart
PermissionGate(
  permKey: PermKeys.manageEmployeesCreate,
  child: ElevatedButton(onPressed: onCreate, child: Text('Add Employee')),
  // fallback: Text('No access') — optional, defaults to SizedBox.shrink()
)
```

### Protect a GoRouter route

```dart
GoRoute(
  path: AppRoutes.employees,
  redirect: (context, state) {
    if (!PermissionService().can(PermKeys.manageEmployeesView)) {
      return '/unauthorized';
    }
    return null;
  },
  builder: (context, state) => const EmployeeManagementScreen(),
)
```

### Check module/submodule visibility (sidebar logic)

```dart
// Is the whole module visible at all?
PermissionService().canSeeModule(kEmployeesModule)

// Is a specific submodule visible?
PermissionService().canSeeSubModule(kEmployeesModule.subModules[0])
```

---

## Lifecycle

```
User logs in
    ↓
currentUserProvider fetches /api/security/users/{guid}
    ↓
Response includes "permission_keys": [{ "permission_key": "employees.manage_employees.*" }]
    ↓
permissionsBootstrapProvider (watched in AppLayout) fires
    ↓
PermissionService().init(permissionKeys)   ← guard is now live
    ↓
All can() / canSeeModule() calls work correctly

User logs out
    ↓
currentUserProvider returns null
    ↓
permissionsBootstrapProvider fires
    ↓
PermissionService().clear()               ← guard reset, all can() return false
```

The bootstrap provider is watched once in `AppLayout.build`:

```dart
ref.watch(permissionsBootstrapProvider);
```

You do not call `init()` or `clear()` manually anywhere else.

---

## Adding a New Module

**Step 1** — Add it to `perm_catalog.dart`:

```dart
const kMyNewModule = PermModule(
  label: 'My New Module',
  baseKey: 'my_new_module',
  subModules: [
    PermSubModule(
      label: 'Manage Things',
      baseKey: 'my_new_module.manage_things',
      route: AppRoutes.myNewModule,
    ),
  ],
);

// Add to kAllModules list at the bottom:
const kAllModules = <PermModule>[
  // ...existing modules...
  kMyNewModule,
];
```

**Step 2** — Add keys to `perm_keys.dart`:

```dart
// my_new_module
static final manageThingsAll    = kMyNewModule.subModules[0].wildcard;
static final manageThingsCreate = kMyNewModule.subModules[0].action(PermAction.create);
static final manageThingsView   = kMyNewModule.subModules[0].action(PermAction.view);
static final manageThingsUpdate = kMyNewModule.subModules[0].action(PermAction.update);
static final manageThingsDelete = kMyNewModule.subModules[0].action(PermAction.delete);
```

**Step 3** — Use the keys in your screen:

```dart
PermissionGate(
  permKey: PermKeys.manageThingsCreate,
  child: CreateThingButton(),
)
```

**Step 4** — Seed the new permissions to the backend (run once from Developer Tools):

```dart
await seedAllPermissions(); // iterates kAllModules automatically
```

That's it. The sidebar will automatically show/hide the new module based on the user's permissions.

---

## Rules (short version)

| Rule | Why |
|------|-----|
| No raw permission strings outside `perm_catalog.dart` and `perm_keys.dart` | Typos compile silently |
| Only `PermissionGuard` contains matching logic | One place to audit/fix |
| Only `PermissionService` is called from UI | Clean abstraction layer |
| `PermKeys` fields are `static final`, not `static const` | Computed from catalog at runtime |
| Always lowercase + trim permissions from API response | Backend casing is unreliable |
| Never call `init()` with an empty list | Empty list = no permissions = silent lockout |
| Sidebar loops `kAllModules`, never a hardcoded list | Adding to catalog is enough |

---

## Edge Cases

| Case | Behaviour |
|------|-----------|
| Backend returns empty `permission_keys` | `PermissionService().clear()` — all `can()` return false |
| User has both wildcard and specific key for same action | Guard matches on first hit — no conflict |
| Key casing mismatch (backend vs catalog) | Bootstrap lowercases all keys on init |
| Module has no visible submodules | `canSeeModule()` returns false — module hidden from sidebar |
| `PermissionService().can()` called before `init()` | Returns false — safe default |
