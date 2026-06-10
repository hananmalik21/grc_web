# Typography Reference

Quick guide to the app's `TextTheme` styles. All sizes use **ScreenUtil** (`.sp`) so they scale with screen width.

**Source:** `lib/core/theme/app_text_styles.dart`  
**Applied in:** `lib/core/theme/app_theme.dart`

**Font family:** `SF Pro` (fallback: SF Pro Display → SF Pro Text → Inter → Roboto)

---

## TextTheme styles

| Style | Size | Line height | Weight | Letter spacing | Default color | Typical use |
|---|---:|---:|---|---:|---|---|
| `displaySmall` | **24** | 32 | w600 (Semibold) | 0.072 | `#101828` textPrimary | Page titles (e.g. Library) |
| `headlineSmall` | **24** | 32 | w600 (Semibold) | 0.072 | `#101828` textPrimary | Stat card values, large numbers |
| `titleLarge` | **20** | 28 | w600 (Semibold) | -0.46 | `#101828` textPrimary | Dialog / panel headers |
| `titleMedium` | **18** | 28 | w600 (Semibold) | -0.45 | `#101828` textPrimary | Section titles, chart card titles |
| `titleSmall` | **16** | 24 | w500 (Medium) | -0.32 | `#101828` textPrimary | Question titles, action buttons |
| `bodyLarge` | **14** | 20 | w500 (Medium) | -0.154 | `#101828` textPrimary | Table headers, emphasized body text |
| `bodyMedium` | **14** | 20 | w400 (Regular) | -0.154 | `#4A5565` textBody | Default body / paragraph text |
| `bodySmall` | **12** | 16 | w500 (Medium) | — | `#6A7282` textSecondary | Labels, captions, badges |
| `labelSmall` | **12** | 16 | w500 (Medium) | — | *(theme default)* | Form labels, small tags |

> Styles not listed above (`headlineLarge`, `bodySmall` variants, etc.) use Flutter/Material defaults and are **not** customized in this project.

---

## How to use

```dart
final textTheme = Theme.of(context).textTheme;

// Preferred — use theme styles
Text('Risk Exposure Trend', style: textTheme.titleMedium);

// Override only what you need (color, weight, etc.)
Text(
  'View all',
  style: textTheme.bodyMedium?.copyWith(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.w500,
  ),
);
```

Access via extension:

```dart
Theme.of(context).textTheme.titleMedium
// or
DefaultTextStyle.of(context).style
```

---

## Figma → Flutter weight mapping

| Figma (SF Pro) | Flutter `FontWeight` |
|---|---|
| Regular (400) | `FontWeight.w400` |
| Medium (510) | `FontWeight.w500` |
| Semibold (590) | `FontWeight.w600` |

---

## Common color overrides

These colors are **not** part of `TextTheme` but are often applied with `copyWith`:

| Token | Hex | Use |
|---|---|---|
| `AppColors.textPrimary` | `#101828` | Headings, primary text |
| `AppColors.textBody` | `#4A5565` | Body copy |
| `AppColors.textSecondary` | `#6A7282` | Muted / helper text |
| `AppColors.textLabel` | `#364153` | Form section labels |
| `AppColors.axisLabel` | `#6B7280` | Chart axis labels |
| `colorScheme.primary` | `#155DFC` | Links, interactive text |

---

## Pixel-perfect text (dialogs / tight layouts)

For layouts that must match Figma line-heights exactly (e.g. stat cards, dialogs), pair styles with `AppTextMetrics`:

```dart
Text(
  'Customer Database',
  style: textTheme.titleLarge,
  strutStyle: AppTextMetrics.strut(fontSize: 20, lineHeight: 28),
  textHeightBehavior: AppTextMetrics.textHeight,
)
```

| Helper | Purpose |
|---|---|
| `AppTextMetrics.strut(fontSize, lineHeight)` | Forces exact line height |
| `AppTextMetrics.textHeight` | Prevents ascent/descent overflow on web |

---

## One-line cheat sheet

```
displaySmall  → 24 / 32  w600   page titles
headlineSmall → 24 / 32  w600   big numbers
titleLarge    → 20 / 28  w600   dialog headers
titleMedium   → 18 / 28  w600   section titles
titleSmall    → 16 / 24  w500   buttons, question titles
bodyLarge     → 14 / 20  w500   table headers
bodyMedium    → 14 / 20  w400   body text
bodySmall     → 12 / 16  w500   labels, captions
labelSmall    → 12 / 16  w500   form labels
```
