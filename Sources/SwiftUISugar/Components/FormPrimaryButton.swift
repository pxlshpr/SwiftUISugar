import SwiftUI

public struct FormPrimaryButton: View {
    
    var title: String
    var color: Color = .accentColor
    var action: () -> ()
    
    public init(title: String, color: Color = .accentColor, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold()
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(color.gradient)
                )
                .padding(.horizontal)
                .padding(.horizontal)
        }
        .buttonStyle(.borderless)
    }
}
