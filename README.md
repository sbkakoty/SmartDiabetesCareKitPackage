# SmartDiabetesCareKit

**SmartDiabetesCareKit** is a Kotlin Multiplatform (KMP) shared library for the **AI Diabetic Care Assistant** application.

It is designed to keep common business and AI-related logic in Kotlin while allowing Android and iOS applications to retain their native UI and platform-specific integrations.

---

## Overview

```text
                    SmartDiabetesCareKit
                              KMP
                               |
             +-----------------+-----------------+
             |                                   |
          Android                              iOS
       Jetpack Compose                         SwiftUI
             |                                   |
             +---------------+-------------------+
                             |
                    Shared Business Logic
                             |
              +--------------+--------------+
              |              |              |
           Domain           Data            AI
              |              |              |
       Shared Models   Data Sources   Intent / Prompt
                                      / Conversation
```

### Main goals

- Share business logic between Android and iOS.
- Keep UI implementation native to each platform.
- Centralize AI intent, prompt, and conversation logic.
- Provide an XCFramework for iOS.
- Distribute the iOS framework through Swift Package Manager.

---

## Features

- Kotlin Multiplatform shared module
- Android and iOS support
- iOS XCFramework generation
- Remote Swift Package Manager distribution
- Shared domain models
- Patient-related data abstractions
- Health-record data abstractions
- Diet-plan data abstractions
- AI intent detection
- AI prompt construction
- AI conversation management
- Native Android and iOS UI integration

---

# Architecture

The shared module follows a layered architecture:

```text
SmartDiabetesCareKit
│
├── Domain
│   ├── Models
│   └── Repository/DataSource abstractions
│
├── Data
│   ├── Patient
│   ├── Health Records
│   └── Diet Plans
│
└── AI
    ├── IntentDetector
    ├── PromptBuilder
    └── AIConversationManager
```

The platform applications provide platform-specific implementations where required.

## iOS architecture

A recommended iOS integration is:

```text
SwiftUI
   |
   v
ViewModel
   |
   v
Repository
   |
   v
SmartDiabetesCareKit
   |
   +---- IntentDetector
   |
   +---- PromptBuilder
   |
   +---- AIConversationManager
   |
   v
Native platform services
```

This keeps KMP business logic independent from SwiftUI/UIKit.

---

# Project Structure

A typical KMP project structure is:

```text
SmartDiabetesCareKit/
│
├── app/
│   └── shared/
│       ├── src/
│       │   ├── commonMain/
│       │   ├── androidMain/
│       │   └── iosMain/
│       │
│       └── build/
│           └── XCFrameworks/
│               └── release/
│                   └── SmartDiabetesCareKit.xcframework
│
├── gradle/
├── gradlew
├── gradlew.bat
├── settings.gradle.kts
└── README.md
```

The exact Kotlin package structure may differ depending on the project's Gradle configuration.

---

# Building the KMP Module

From the project root:

```bash
./gradlew :app:shared:build
```

To inspect available XCFramework tasks:

```bash
./gradlew :app:shared:tasks --all | grep XCFramework
```

---

# Creating the iOS XCFramework

Generate the release XCFramework with:

```bash
./gradlew :app:shared:assembleSmartDiabetesCareKitReleaseXCFramework
```

The generated framework will be available at:

```text
app/shared/build/XCFrameworks/release/
```

Expected output:

```text
SmartDiabetesCareKit.xcframework
```

---

# iOS Swift Package

The iOS distribution uses Swift Package Manager with a remote binary target.

The package manifest contains a binary target similar to:

```swift
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SmartDiabetesCareKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SmartDiabetesCareKit",
            targets: [
                "SmartDiabetesCareKit"
            ]
        )
    ],
    targets: [
        .binaryTarget(
            name: "SmartDiabetesCareKit",
            url: "https://github.com/sbkakoty/SmartDiabetesCareKit/releases/download/1.0.1/SmartDiabetesCareKit.xcframework.zip",
            checksum: "YOUR_SHA256_CHECKSUM"
        )
    ]
)
```

> Replace `YOUR_SHA256_CHECKSUM` with the checksum generated for the exact XCFramework ZIP.

---

# Creating the XCFramework ZIP

After generating the release XCFramework:

```bash
cd app/shared/build/XCFrameworks/release
```

Create the archive:

```bash
ditto -c -k --sequesterRsrc --keepParent SmartDiabetesCareKit.xcframework SmartDiabetesCareKit.xcframework.zip
```

Calculate the Swift Package checksum:

```bash
swift package compute-checksum SmartDiabetesCareKit.xcframework.zip
```

Copy the resulting SHA-256 checksum into `Package.swift`.

---

# GitHub Release

The recommended remote distribution structure is:

```text
GitHub Repository
│
├── Package.swift
├── README.md
│
└── GitHub Release
    │
    └── 1.0.1
        └── SmartDiabetesCareKit.xcframework.zip
```

The release page URL and binary download URL are intentionally different.

### Release page

```text
https://github.com/sbkakoty/SmartDiabetesCareKit/releases/tag/1.0.1
```

### Binary download URL

```text
https://github.com/sbkakoty/SmartDiabetesCareKit/releases/download/1.0.1/SmartDiabetesCareKit.xcframework.zip
```

`Package.swift` must use the **download URL**, not the release page URL.

---

# Semantic Versioning

Use semantic versioning for releases:

```text
MAJOR.MINOR.PATCH
```

Examples:

```text
1.0.0
1.0.1
1.1.0
2.0.0
```

A typical release process is:

```text
KMP source change
       |
       v
Build XCFramework
       |
       v
Create ZIP
       |
       v
Calculate checksum
       |
       v
Update Package.swift
       |
       v
Commit changes
       |
       v
Create Git tag
       |
       v
Create GitHub Release
       |
       v
Upload XCFramework ZIP
       |
       v
Xcode resolves package version
```

**Important:** the `Package.swift` contained in the Git tag must reference the corresponding release version.

For example, tag `1.0.1` should contain a manifest referencing:

```text
/releases/download/1.0.1/SmartDiabetesCareKit.xcframework.zip
```

---

# Adding the Package to Xcode

In your iOS project:

1. Open the Xcode project.
2. Select **File → Add Package Dependencies...**
3. Enter:

```text
https://github.com/sbkakoty/SmartDiabetesCareKit.git
```

4. Select the desired version.
5. Add the product:

```text
SmartDiabetesCareKit
```

to the iOS application target.

Then import the package:

```swift
import SmartDiabetesCareKit
```

---

# Example iOS Usage

For example, shared prompt-building logic can be consumed from Swift:

```swift
import SmartDiabetesCareKit

func generatePrompt() {
    let prompt = PromptBuilder.shared.diabetesAssistantPrompt(
        patient: patient,
        healthRecord: healthRecord,
        question: "What should I eat for dinner?"
    )

    print(prompt)
}
```

The exact generated Swift API can vary depending on the Kotlin declarations and exported types. Xcode autocomplete or the generated framework interface can be used to verify the exact Swift names.

---

# Recommended AI Chat Integration

For an AI chat feature, the shared module can be integrated below the ViewModel/Repository layer:

```text
User
 |
 v
AIChatView
 |
 v
AIChatViewModel
 |
 v
AIChatRepository
 |
 +------------------------------+
 |                              |
 v                              v
KMP IntentDetector        KMP PromptBuilder
 |                              |
 +--------------+---------------+
                |
                v
       KMP AIConversationManager
                |
                v
          Native AI Service
                |
                v
            AI Response
```

This allows the AI business rules to remain shared while the UI and platform-specific networking remain native.

---

# Data Source Architecture

The KMP module can define common data-source abstractions:

```text
                Shared KMP
                    |
       +------------+------------+
       |            |            |
       v            v            v
 PatientData   HealthRecord   DietPlan
   Source       DataSource    DataSource
       |            |            |
       v            v            v
     iOS          iOS          iOS
 implementation implementation implementation
```

Android can provide separate implementations of the same abstractions.

This keeps the shared business logic independent of the underlying platform database or SDK.

---

# Requirements

## iOS

- iOS 16.0 or later
- Xcode compatible with the generated XCFramework
- Swift Package Manager

## Android

- Android Studio
- Kotlin Multiplatform-compatible Kotlin/Gradle toolchain
- Android SDK

---

# Troubleshooting

## `The package does not contain a buildable target`

A binary-only iOS Swift package may not be suitable for a normal:

```bash
swift build
```

workflow on macOS.

Validate the package manifest with:

```bash
swift package describe
```

or:

```bash
swift package dump-package
```

The intended consumer for the iOS XCFramework is Xcode.

---

## `Invalid manifest`

Run:

```bash
swift package describe
```

and:

```bash
swift package dump-package
```

Also verify the manifest contained by the Git tag:

```bash
git show 1.0.1:Package.swift
```

The tagged manifest must contain a valid `.binaryTarget`.

---

## XCFramework download failure

Verify that the GitHub Release contains:

```text
SmartDiabetesCareKit.xcframework.zip
```

and that `Package.swift` references:

```text
/releases/download/<version>/SmartDiabetesCareKit.xcframework.zip
```

Do not use:

```text
/releases/tag/<version>
```

as the binary target URL.

---

## Checksum mismatch

Calculate the checksum again:

```bash
swift package compute-checksum SmartDiabetesCareKit.xcframework.zip
```

Make sure the checksum exactly matches the value in `Package.swift`.

The checksum must be calculated from the **same ZIP file uploaded to the GitHub Release**.

---

## Xcode package cache issues

If Xcode continues resolving an old package version, try:

**File → Packages → Reset Package Caches**

You can also remove SwiftPM caches from Terminal:

```bash
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/Developer/Xcode/SourcePackages
```

Then reopen Xcode and resolve package dependencies again.

---

# Design Principles

This project follows these principles:

### Shared where it makes sense

Business rules, models, AI intent detection, prompt construction, and conversation logic are shared.

### Native where it matters

UI, platform lifecycle, platform-specific APIs, and platform-specific integrations remain native.

### Dependency inversion

Shared business logic depends on abstractions rather than directly depending on iOS or Android implementations.

### Single source of truth

AI-related business rules should not be duplicated between Swift and Kotlin.

---

# Repository

GitHub:

https://github.com/sbkakoty/SmartDiabetesCareKit

---

# License

SmartDiabetesCareKit is licensed under the MIT License.

Copyright (c) 2026 Sonjoy Borkakoty

---

# Author

**Sonjoy Borkakoty**

SmartDiabetesCareKit is developed and maintained by Sonjoy Borkakoty.

GitHub: https://github.com/sbkakoty