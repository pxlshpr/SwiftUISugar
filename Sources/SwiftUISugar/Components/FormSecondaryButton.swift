import SwiftUI

public struct FormSecondaryButton: View {
    
    var title: String
    var action: () -> ()
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold()
                .foregroundColor(.accentColor)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.clear)
                )
                .padding(.horizontal)
                .padding(.horizontal)
                .contentShape(Rectangle())
        }
    }
}
