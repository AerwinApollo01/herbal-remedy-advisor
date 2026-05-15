# 🌿 Herbal Remedy Advisor

A multicultural health companion iOS app that matches symptoms to natural herbal remedies drawn from 7 global healing traditions.

## Overview

Herbal Remedy Advisor bridges a gap in US health culture by surfacing ancient healing knowledge from cultures that have long practiced preventive cleansing protocols. Every remedy is culturally attributed, historically sourced, and educationally framed.

**Platform:** iOS 16+ · iPhone · Portrait  
**Status:** v1.0 — Scope frozen

---

## Features

| Screen | Description |
|---|---|
| Symptom Selection | 10 symptom chips, multi-select, triggers remedy matching |
| Results | Filterable remedy cards by healing tradition |
| Remedy Detail | Full protocol: ingredients, steps, cultural quote, journal CTA |
| Tradition Filter | Gallery of 7 healing traditions with cultural descriptions |
| Cleanse Journal | Monthly calendar, progress bar, daily tasks, achievements |
| Day Complete Overlay | Streak celebration with next-day quote preview |
| Protocol Complete Overlay | Full-screen congratulations with stats and closing wisdom |

## Healing Traditions

| Tradition | Region | Color |
|---|---|---|
| Ayurveda | 🇮🇳 India · South Asia | `#B03020` |
| Traditional Chinese Medicine | 🇨🇳 China · East Asia | `#C03030` |
| Persian Medicine | 🇮🇷 Iran · Middle East | `#7B35A0` |
| African Herbalism | 🌍 Sub-Saharan Africa | `#D05010` |
| Curanderismo | 🌿 Latin America · Mexico | `#1A7A40` |
| European Herbalism | 🏛️ Europe · Mediterranean | `#1A60A0` |
| Southeast Asian Folk | 🇹🇭 Thailand · Vietnam · Indonesia | `#C08010` |

## Remedy Database

11 remedies across 10 symptoms, including:

- Triphala & Ginger Decoction (Ayurveda, 21 days)
- Ashwagandha Golden Milk (Ayurveda, 30 days)
- Wormwood & Clove Tonic (TCM, 14 days)
- Saffron & Rhodiola Adaptogen Blend (Persian, 21 days)
- Papaya Seed & Honey Protocol (SE Asian Folk, 7 days)
- Valerian & Passionflower Evening Tonic (European, 14 days)
- and 5 more...

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 5.9+ |
| UI Framework | SwiftUI |
| Minimum iOS | iOS 16.0 |
| Architecture | MVVM |
| State Management | `@StateObject`, `@EnvironmentObject` |
| Persistence | UserDefaults (SwiftData-ready for v2) |
| Navigation | `TabView` + `NavigationStack` |
| Fonts | Noto Serif + Noto Sans (variable, bundled) |
| Project Generation | XcodeGen |

## Project Structure

```
HerbalRemedyAdvisor/
├── App/
│   └── HerbalRemedyAdvisorApp.swift
├── Models/
│   ├── Remedy.swift
│   ├── Tradition.swift
│   ├── Quote.swift
│   └── JournalState.swift
├── Data/
│   ├── RemedyDatabase.swift      # 11 remedies + symptom map
│   ├── TraditionDatabase.swift   # 7 traditions
│   └── QuoteDatabase.swift       # 147 quotes (21 per tradition)
├── ViewModels/
│   ├── SymptomViewModel.swift
│   ├── JournalViewModel.swift
│   └── TraditionViewModel.swift
├── Views/
│   ├── Symptoms/
│   ├── Results/
│   ├── Detail/
│   ├── Traditions/
│   ├── Journal/
│   └── Shared/                   # Colors, fonts, reusable components
└── Resources/
    └── Fonts/                    # Noto Serif + Noto Sans
```

## Design System

**Palette**

| Token | Hex | Usage |
|---|---|---|
| `forest` | `#1A2E1A` | Headers, nav bar, key buttons |
| `moss` | `#2D4A2D` | Gradients |
| `sage` | `#5C7A4E` | Subheadings, secondary labels |
| `fern` | `#8AAB6E` | Accent labels on dark |
| `mist` | `#C8DDB8` | Borders, chip backgrounds |
| `cream` | `#F5F0E8` | App background, cards |
| `gold` | `#C8A050` | Progress, streak, CTAs |
| `copper` | `#A0704A` | Secondary highlights, disclaimers |
| `subtext` | `#4A5A3A` | Body text, labels |

**Typography:** Noto Serif (headings, quotes, CTAs) + Noto Sans (body, labels)

---

## Getting Started

### Requirements

- Xcode 15+
- iOS 16.0+ Simulator or device
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)

### Setup

```bash
git clone https://github.com/AerwinApollo01/herbal-remedy-advisor.git
cd herbal-remedy-advisor
xcodegen generate
open HerbalRemedyAdvisor.xcodeproj
```

Then select an iPhone simulator and press **Run**.

### Build from CLI

```bash
xcodebuild \
  -project HerbalRemedyAdvisor.xcodeproj \
  -scheme HerbalRemedyAdvisor \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug \
  build
```

---

## Out of Scope (v1.0)

- User accounts / authentication
- Cloud sync
- Push notifications
- AI-powered remedy generation (Claude API — planned v2)
- Social sharing, Apple HealthKit, iPad, Android, IAP

---

## Health Disclaimer

> These remedies are based on traditional practices from various healing cultures. They are not intended to diagnose, treat, cure, or prevent any medical condition. Always consult a qualified, licensed healthcare provider before beginning any herbal cleanse or protocol.
