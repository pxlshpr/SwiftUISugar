import SwiftUI

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func readSafeAreaInsets(onChange: @escaping (EdgeInsets) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: InsetsPreferenceKey.self, value: geometryProxy.safeAreaInsets)
            }
        )
        .onPreferenceChange(InsetsPreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private struct InsetsPreferenceKey: PreferenceKey {
    static var defaultValue: EdgeInsets = .init()
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {}
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
