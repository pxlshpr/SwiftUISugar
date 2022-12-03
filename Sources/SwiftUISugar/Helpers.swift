import SwiftUI
import SwiftHaptics

/// Use this to ensure that a sheet is shown upon setting it to true.
///
/// This is to mitigate cases where the user might invoke an action to present a sheet while a `Menu` is presented,
/// which results in being stuck with the bound `Bool` having being set without actually presenting the sheet.
///
/// This is what the check for whether it is already true is for—and we set it to false and set it back to true
/// after a delay in that case to ensure that it actually gets presented.
public func showSheetWithBinding(_ binding: Binding<Bool>, includeHaptics: Bool = true) {
    if binding.wrappedValue {
        binding.wrappedValue = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if includeHaptics {
                Haptics.feedback(style: .soft)
            }
            binding.wrappedValue = true
        }
    } else {
        if includeHaptics {
            Haptics.feedback(style: .soft)
        }
        binding.wrappedValue = true
    }
}
