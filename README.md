# MotionBank

MotionBank is a modern iOS banking application showcase designed to demonstrate advanced UI/UX concepts, modern Swift/SwiftUI features, global state management, and various native iOS frameworks.

## Features Included

- **Global State Management**: Centralized `GlobalState` using `ObservableObject` and `@EnvironmentObject` to manage account balances, live transaction history, and app-wide notifications.
- **Advanced Send Money Flow**: A highly polished UI featuring dynamic currency formatting, mock contact selection, live balance validation, and a custom keypad embedded in a sleek glassmorphic container.
- **Activity Insights Dashboard**: A fully native, scrollable analytics view displaying total monthly spend, custom category ring charts, and embedded transaction history.
- **Custom In-App Notifications**: A global toast banner system with haptic feedback to confirm actions (e.g., sending money, copying account details, logging out).
- **CoreImage QR Generation**: Real-time generation of custom QR codes using Apple's `CoreImage` (`CIFilter.qrCodeGenerator()`).
- **Profile & Security Settings**: A premium user dashboard featuring copy-to-clipboard functionality, notification preferences, privacy controls, and a custom animated logout overlay.
- **Wallet Card Expansion**: Interactive card stacking and viewing with detailed breakdown views and limit controls.
- **Hero Transitions & Animations**: Smooth, spring-based scale and opacity animations for popups and transitions.
- **Finance Dashboard**: A highly polished, data-rich overview with custom styling and seamless navigation.
- **Shimmer Loading**: Custom modifier simulating network request loading states.
- **Glassmorphism & Dark Mode**: Custom ultra-thin materials optimized for a premium dark aesthetic.
- **AVFoundation**: Real-time camera scanner using `AVCaptureSession` bridged to SwiftUI via `UIViewControllerRepresentable`.

## Architecture
The app follows a modernized MVVM architecture tailored for SwiftUI. State is managed globally via environment injection, allowing complex views to seamlessly read from and mutate a central source of truth without extensive binding chains.

## How to Run
This project is configured as an Xcode Project using XcodeGen. 

1. Ensure you have the `project.yml` file and run `xcodegen generate` if the `.xcodeproj` is missing.
2. Open `MotionBank.xcodeproj` in Xcode.
3. Select a Development Team in the Signing & Capabilities editor.
4. Select the `MotionBank` executable target and run it on an iOS Simulator (iOS 16+ required).

Enjoy the modern banking experience!
