import SwiftUI

public struct FormSecondaryButton: View {
    
    var title: String
    var action: () -> ()
    
    let foregroundColor: Color
    
    public init(title: String, foregroundColor: Color = .accentColor, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.foregroundColor = foregroundColor
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold()
                .foregroundColor(foregroundColor)
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
