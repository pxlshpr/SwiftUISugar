import SwiftUI
import SwiftHaptics

extension Field {

    @ViewBuilder
    func menuButton(for option: SelectionOption) -> some View {
        Button(action: {
            selectedUnit?.wrappedValue = option
            onUnitChanged?(option)
        }) {
            if let systemImage = contentProvider?.systemImage(for: option) {
                Label(unitString(for: option), systemImage: systemImage)
            } else {
                Text(unitString(for: option))
            }
        }
    }

    @ViewBuilder
    func menu(for options: Binding<[SelectionOption]>) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options.wrappedValue[index]
                if let provider = contentProvider, provider.shouldPlaceDividerBefore(option, within: options.wrappedValue)
                {
                    Divider()
                }
                if option.isGroup, let subOptions = option.subOptions {
                    secondaryMenu(for: subOptions, option: option)
                } else {
                    menuButton(for: option)
                }
            }
        } label: {
            HStack {
                if value == nil {
                    Spacer()
                }
                selectedOptionText()
            }
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
                if let provider = contentProvider, provider.shouldPlaceDividerBefore(option, within: options)
                {
                    Divider()
                }
                if option.isGroup, let subOptions = option.subOptions {
                    tertiaryMenu(for: subOptions, option: option)
                } else {
                    menuButton(for: option)
                }
            }
        } label: {
            if let systemImage = contentProvider?.systemImage(for: option) {
                Label(title(for: option), systemImage: systemImage)
            } else {
                Text(title(for: option))
            }
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
                if let provider = contentProvider, provider.shouldPlaceDividerBefore(option, within: options)
                {
                    Divider()
                }
                menuButton(for: option)
            }
        } label: {
            if let systemImage = contentProvider?.systemImage(for: option) {
                Label(title(for: option), systemImage: systemImage)
            } else {
                Text(title(for: option))
            }
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }
}
