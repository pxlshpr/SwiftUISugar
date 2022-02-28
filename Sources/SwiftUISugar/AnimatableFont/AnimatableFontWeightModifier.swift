import SwiftUI

struct AnimatableFontWeightModifier: AnimatableModifier {
    var style: Font.TextStyle = .body
    var weight: Font.Weight = .regular

    var animatableData: Font.Weight {
        get { weight }
        set { weight = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(style).weight(weight))
    }
}
