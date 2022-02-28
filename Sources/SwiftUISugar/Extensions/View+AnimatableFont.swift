import SwiftUI

extension View {
    func animatableFont(size: Double,
                        weight: Font.Weight,
                        design: Font.Design = .default) -> some View {
        self.modifier(AnimatableFontModifier(size: size,
                                             weight: weight,
                                             design: design))
    }
    
    func animatableFont(style: Font.TextStyle,
                        weight: Font.Weight) -> some View {
        self.modifier(AnimatableFontWeightModifier(style: style,
                                                   weight: weight))
    }

}
