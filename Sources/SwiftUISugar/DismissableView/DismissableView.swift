import SwiftUI
import SwiftHaptics

public struct DismissableView<Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    
    var content: () -> Content
    let onRightSide: Bool
    
    public init(
        onRightSide: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.onRightSide = onRightSide
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            content()
//                .safeAreaInset(edge: .bottom) { safeAreaBottomInset }
//                .edgesIgnoringSafeArea(.bottom)
            buttonLayer
        }
    }
    
    var buttonLayer: some View {
        VStack {
            Spacer()
            HStack {
                if onRightSide {
                    Spacer()
                }
                Button {
                    Haptics.feedback(style: .soft)
                    dismiss()
                } label: {
                    DismissButtonLabel()
                }
                if !onRightSide {
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    var safeAreaBottomInset: some View {
        Spacer().frame(height: 37.0 + 5.0 + 20.0)
    }

}

public struct DismissButtonLabel: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let forKeyboard: Bool
    init(forKeyboard: Bool = false) {
        self.forKeyboard = forKeyboard
    }
    
    @ViewBuilder
    public var body: some View {
        if forKeyboard {
            keyboardButton
        } else {
            dismissButton
        }
    }
    
    var dismissButton: some View {
        Image(systemName: "chevron.down")
            .imageScale(.medium)
            .fontWeight(.medium)
//            .foregroundStyle(.thinMaterial)
            .foregroundColor(.white)
            .frame(width: 37, height: 37)
            .background(
                Circle()
                    .foregroundColor(.accentColor)
                    .foregroundStyle(.thinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
            )
    }
    
    var keyboardButton: some View {
        Image(systemName: "keyboard.chevron.compact.down")
            .imageScale(.medium)
            .fontWeight(.medium)
            .foregroundColor(Color(.label))
            .frame(width: 37, height: 37)
            .background(
                Circle()
                    .foregroundStyle(.thinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
            )
    }
}

struct DismissableViewPreview: View {
    var body: some View {
        DismissableView(onRightSide: true) {
            List {
                ForEach(0...40, id: \.self) {
                    Text("\($0)")
                }
            }
        }
    }
}

struct DismissableView_Previews: PreviewProvider {
    static var previews: some View {
        DismissableViewPreview()
    }
}
