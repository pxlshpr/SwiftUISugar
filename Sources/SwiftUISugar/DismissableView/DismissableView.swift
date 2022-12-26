import SwiftUI

struct DismissableView: View {
    
    let onRightSide: Bool
    let didDismiss: () -> ()
    
    init(onRightSide: Bool = false, didDismiss: @escaping () -> ()) {
        self.onRightSide = onRightSide
        self.didDismiss = didDismiss
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if onRightSide {
                    Spacer()
                }
                Button {
                    didDismiss()
                } label: {
                    DismissButtonLabel()
                }
                if !onRightSide {
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
        }
        .background(.green)
    }
}

public struct DismissButtonLabel: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let forKeyboard: Bool
    init(forKeyboard: Bool = false) {
        self.forKeyboard = forKeyboard
    }
    
    var foregroundColor: Color {
    //    .white
//        colorScheme == .light ? .white : .black
        Color(.label)
    }

    var backgroundColor: Color {
    //    .accentColor
        Color(.quaternaryLabel)
    }


    var systemImage: String {
        if forKeyboard {
            return "keyboard.chevron.compact.down"
        } else {
            return "xmark"
//            return "chevron.compact.down"
        }
    }
    
    var imageScale: Image.Scale {
        forKeyboard ? .small : .medium
    }
    var fontWeight: Font.Weight {
        forKeyboard ? .regular : .medium
    }
    
    public var body: some View {
        Image(systemName: systemImage)
//            .imageScale(.medium)
            .imageScale(.medium)
            .fontWeight(.medium)
            .foregroundColor(foregroundColor)
            .frame(width: 37, height: 37)
            .background(
                Circle()
                    .foregroundStyle(.thinMaterial)
//                    .background(.thinMaterial)
//                    .foregroundColor(backgroundColor)
                    .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
            )
    }
}

struct DismissableViewPreview: View {
    var body: some View {
        DismissableView(onRightSide: true) {
            
        }
    }
}

struct DismissableView_Previews: PreviewProvider {
    static var previews: some View {
        DismissableViewPreview()
    }
}
