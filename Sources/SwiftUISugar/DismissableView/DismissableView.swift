import SwiftUI
import SwiftHaptics

public struct DismissableView<Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    
    var content: () -> Content
    let onRightSide: Bool
    let isInTabView: Bool
    let didTapDismiss: (() -> ())?

    let didPageBack: (() -> ())?
    let didTapToday: (() -> ())?
    @Binding var shouldShowToday: Bool
    let didPageForward: (() -> ())?

    public init(
        onRightSide: Bool = false,
        isInTabView: Bool = false,
        didTapDismiss: (() -> ())? = nil,
        didPageBack: (() -> ())? = nil,
        didTapToday: (() -> ())? = nil,
        shouldShowToday: Binding<Bool> = .constant(false),
        didPageForward: (() -> ())? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _shouldShowToday = shouldShowToday
        self.onRightSide = onRightSide
        self.isInTabView = isInTabView
        self.content = content
        self.didTapDismiss = didTapDismiss
        self.didPageBack = didPageBack
        self.didTapToday = didTapToday
        self.didPageForward = didPageForward
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
                    optionalPagingButtons
                    Spacer()
                }
                Button {
                    if let didTapDismiss {
                        didTapDismiss()
                    } else {
                        Haptics.feedback(style: .soft)
                        dismiss()
                    }
                } label: {
                    DismissButtonLabel()
                }
                if !onRightSide {
                    Spacer()
                    optionalPagingButtons
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, isInTabView ? 5 : 0)
        }
    }

    
    var optionalPagingButtons: some View {
        HStack {
            if let didPageBack {
                Button {
                    didPageBack()
                } label: {
                    bottomAccessoryButtonLabel("chevron.left")
                }
            }
            if let didTapToday, shouldShowToday {
                Button {
                    didTapToday()
                } label: {
//                    bottomAccessoryButtonLabel("circle.circle.fill")
                    bottomAccessoryButtonLabel(text: "Today")
                }
                .transition(.scale)
            }
            if let didPageForward {
                Button {
                    didPageForward()
                } label: {
                    bottomAccessoryButtonLabel("chevron.right")
                }
            }
        }
    }
    
    var safeAreaBottomInset: some View {
        Spacer().frame(height: 38.0 + 5.0 + 20.0)
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
            .frame(width: 38, height: 38)
            .background(
                Circle()
                    .foregroundColor(.accentColor)
                    .foregroundStyle(.thinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
            )
    }
    
    var keyboardButton: some View {
        bottomAccessoryButtonLabel("keyboard.chevron.compact.down")
    }
}

func bottomAccessoryButtonLabel(_ systemImage: String) -> some View {
    Image(systemName: systemImage)
        .imageScale(.medium)
        .fontWeight(.medium)
        .foregroundColor(Color(.secondaryLabel))
        .frame(width: 38, height: 38)
        .background(
            Circle()
                .foregroundStyle(.thinMaterial)
                .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
        )
}

func bottomAccessoryButtonLabel(text: String) -> some View {
    Text(text)
        .textCase(.uppercase)
        .font(.system(size: 14, weight: .semibold, design: .rounded))
        .foregroundColor(Color(.secondaryLabel))
        .frame(height: 38)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 19, style: .continuous)
                .foregroundStyle(.thinMaterial)
                .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
        )
}

struct DismissableViewPreview: View {
    var body: some View {
        DismissableView(isInTabView: true) {
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
        TabView {
            DismissableViewPreview()
        }
    }
}

