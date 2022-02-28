import SwiftUI
import SwiftHaptics

extension Field {

    @ViewBuilder
    func menuButtonLabel(for option: SelectionOption) -> some View {
        let title = title(for: option, forMenu: true)
        if let systemImage = contentProvider?.systemImage(for: option) {
            Label(title, systemImage: systemImage)
        } else if let systemImage = option.systemImage {
            Label(title, systemImage: systemImage)
        } else {
            Text(title)
        }
    }
    
    @ViewBuilder
    func menuButton(for option: SelectionOption) -> some View {
        Button(action: {
            selectedUnit?.wrappedValue = option
            onUnitChanged?(option)
        }) {
            menuButtonLabel(for: option)
        }
    }

    //MARK: - Menus
    
    @ViewBuilder
    func menu(for options: Binding<[SelectionOption]>) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options.wrappedValue[index]
                if let _ = option as? SelectionDivider {
                    Divider()
                } else if option.isGroup, let subOptions = option.subOptions {
                    secondaryMenu(for: subOptions, option: option)
                } else {
                    menuButton(for: option)
                }
            }
        } label: {
            selectedOptionText
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }

    @ViewBuilder
    func secondaryMenu(for options: [SelectionOption], option: SelectionOption) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                if let _ = option as? SelectionDivider {
                    Divider()
                } else if option.isGroup, let subOptions = option.subOptions {
                    tertiaryMenu(for: subOptions, option: option)
                } else {
                    menuButton(for: option)
                }
            }
        } label: {
            menuButtonLabel(for: option)
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }

    @ViewBuilder
    func tertiaryMenu(for options: [SelectionOption], option: SelectionOption) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                if let _ = option as? SelectionDivider {
                    Divider()
                } else {
                    menuButton(for: option)
                }
            }
        } label: {
            menuButtonLabel(for: option)
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }
}
