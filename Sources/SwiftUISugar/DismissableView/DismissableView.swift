import SwiftUI

struct DismissableView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    
                } label: {
                    DismissButtonLabel()
                }
                Spacer()
                Button {
                    
                } label: {
                    DismissButtonLabel(forKeyboard: true)
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
        DismissableView()
    }
}

struct DismissableView_Previews: PreviewProvider {
    static var previews: some View {
        DismissableViewPreview()
    }
}
