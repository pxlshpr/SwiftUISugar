import SwiftUI

struct FormStyledScrollView<Content: View>: View {
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            content()
        }
        .background(Color(.systemGroupedBackground))
    }
}
