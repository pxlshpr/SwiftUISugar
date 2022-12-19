import SwiftUI

public struct FormSecondaryButton: View {
    
    var title: String
    var action: () -> ()
    
    let foregroundColor: Color
    let bold: Bool
    
    public init(title: String, bold: Bool = true, foregroundColor: Color = .accentColor, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.bold = bold
        self.foregroundColor = foregroundColor
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold(bold)
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
