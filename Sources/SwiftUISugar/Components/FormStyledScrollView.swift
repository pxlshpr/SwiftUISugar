import SwiftUI

public struct FormStyledScrollView<Content: View>: View {
    
    var content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            content()
        }
        .background(Color(.systemGroupedBackground))
    }
}
