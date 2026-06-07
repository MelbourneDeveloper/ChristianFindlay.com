---
name: Christian Findlay Blog
colors:
  surface: '#11131b'
  surface-dim: '#11131b'
  surface-bright: '#373942'
  surface-container-lowest: '#0c0e16'
  surface-container-low: '#191b23'
  surface-container: '#1d1f27'
  surface-container-high: '#282a32'
  surface-container-highest: '#32343d'
  on-surface: '#e1e2ed'
  on-surface-variant: '#c3c6d7'
  inverse-surface: '#e1e2ed'
  inverse-on-surface: '#2e3039'
  outline: '#8d90a0'
  outline-variant: '#434655'
  surface-tint: '#b4c5ff'
  primary: '#b4c5ff'
  on-primary: '#002a78'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#0053db'
  secondary: '#4edea3'
  on-secondary: '#003824'
  secondary-container: '#00a572'
  on-secondary-container: '#00311f'
  tertiary: '#ffb596'
  on-tertiary: '#581e00'
  tertiary-container: '#bc4800'
  on-tertiary-container: '#ffede6'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffdbcd'
  tertiary-fixed-dim: '#ffb596'
  on-tertiary-fixed: '#360f00'
  on-tertiary-fixed-variant: '#7d2d00'
  background: '#11131b'
  on-background: '#e1e2ed'
  surface-variant: '#32343d'
  bg-deepest: '#020617'
  bg-surface: '#0f172a'
  bg-component: '#1e293b'
  text-heading: '#f1f5f9'
  text-body: '#cbd5e1'
  text-secondary: '#94a3b8'
  text-muted: '#64748b'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  code-sm:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  margin-sm: 1rem
  margin-md: 2rem
  gutter: 2rem
  card-padding: 1.5rem
  section-gap: 2.5rem
---

# Design System: Christian Findlay Blog

## Visual Style
A modern, high-fidelity tech aesthetic featuring a deep dark theme, clean typography, and vibrant accent colors. The design uses "glassmorphism" effects with subtle borders and shadows to create depth.

## Colors

### Brand
- **Primary:** `#2563eb` (Blue) - Used for primary CTAs, links, and highlights.
- **Secondary:** `#10b981` (Emerald) - Used for accents and success states.

### Backgrounds
- **Darker:** `#020617` (Deepest Navy) - Main page background.
- **Dark:** `#0f172a` (Navy) - Section backgrounds and card surfaces.
- **Light:** `#1e293b` (Slate) - Component backgrounds.

### Grays
- **Gray-100:** `#f1f5f9` - Heading text.
- **Gray-300:** `#cbd5e1` - Primary body text.
- **Gray-400:** `#94a3b8` - Secondary text and icons.
- **Gray-500:** `#64748b` - Muted text.

## Typography
- **Headings:** `Plus Jakarta Sans`, sans-serif. Bold weights with tight letter-spacing.
- **Body:** `Inter`, sans-serif. Balanced line heights for readability.
- **Mono:** `JetBrains Mono`, monospace. Used for code and technical metadata.

## Components

### Cards
- **Background:** `#0f172a`
- **Border:** `1px solid rgba(255, 255, 255, 0.05)`
- **Radius:** `0.75rem` (12px)
- **Shadow:** `0 12px 24px rgba(0, 0, 0, 0.15)`
- **Hover:** `translateY(-5px)` with increased shadow and primary-light glow.

### Badges/Chips
- **Categories:** Solid primary background, white text, uppercase.
- **Tags:** Low-opacity primary background, primary-light text, capitalized.

## Spacing
- **Gaps:** 32px to 40px for grid layouts.
- **Padding:** 24px (var(--spacing-6)) for standard card internal padding.
