import SwiftUI
import SwiftHaptics

extension Field {
    
    static func title(for option: SelectionOption?, forMenu: Bool = false, value: Binding<String>?, contentProvider: FieldContentProvider?) -> String {
        guard let option = option else { return "Unsupported" }
        var isPlural = true
        if let value = value, let doubleValue = Double(value.wrappedValue) {
            isPlural = doubleValue > 1
        }
        if forMenu {
            return contentProvider?.menuTitle(for: option, isPlural: isPlural)
            ?? option.menuTitle(isPlural: isPlural)
            ?? contentProvider?.title(for: option, isPlural: isPlural)
            ?? option.title(isPlural: isPlural) ?? "Unsupported"
        } else {
            return contentProvider?.title(for: option, isPlural: isPlural) ?? option.title(isPlural: isPlural) ?? "Unsupported"
        }
    }

    @ViewBuilder
    static func menuButtonLabel(for option: SelectionOption, value: Binding<String>?, contentProvider: FieldContentProvider?) -> some View {
        let title = title(for: option, forMenu: true, value: value, contentProvider: contentProvider)
        if let systemImage = contentProvider?.systemImage(for: option) {
            Label(title, systemImage: systemImage)
        } else if let systemImage = option.systemImage {
            Label(title, systemImage: systemImage)
        } else {
            Text(title)
        }
    }
    
    @ViewBuilder
    static func menuButton(for option: SelectionOption, value: Binding<String>?, contentProvider: FieldContentProvider?, onOptionSelected: @escaping ((SelectionOption) -> Void)) -> some View {
        Button(action: {
            onOptionSelected(option)
            NotificationCenter.default.post(name: .selectionOptionChanged, object: nil)
        }) {
            menuButtonLabel(for: option, value: value, contentProvider: contentProvider)
        }
    }
    
    @ViewBuilder
    public static func menu<LabelContent: View>(for options: [SelectionOption], label: LabelContent, value: Binding<String>?, contentProvider: FieldContentProvider? = nil, onOptionSelection: @escaping ((SelectionOption) -> Void)) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                if let _ = option as? SelectionDivider {
                    Divider()
                } else if option.isGroup, let subOptions = option.subOptions {
                    secondaryMenu(
                        for: subOptions,
                        label: menuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection),
                        value: value,
                        contentProvider: contentProvider,
                        onOptionSelection: onOptionSelection
                    )
                } else {
                    menuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection)
                }
            }
        } label: {
            label
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }
    
    @ViewBuilder
    static func secondaryMenu<LabelContent: View>(for options: [SelectionOption], label: LabelContent, value: Binding<String>?, contentProvider: FieldContentProvider?, onOptionSelection: @escaping ((SelectionOption) -> Void)) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                if let _ = option as? SelectionDivider {
                    Divider()
                } else if option.isGroup, let subOptions = option.subOptions {
                    tertiaryMenu(
                        for: subOptions,
                        label: menuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection),
                        value: value,
                        contentProvider: contentProvider,
                        onOptionSelection: onOptionSelection
                    )
                } else {
                    menuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection)
                }
            }
        } label: {
            label
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }

    @ViewBuilder
    static func tertiaryMenu<LabelContent: View>(for options: [SelectionOption], label: LabelContent, value: Binding<String>?, contentProvider: FieldContentProvider?, onOptionSelection: @escaping ((SelectionOption) -> Void)) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                if let _ = option as? SelectionDivider {
                    Divider()
                } else {
                    menuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection)
                }
            }
        } label: {
            label
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }
}

extension Field {
    @ViewBuilder
    func menu(for options: Binding<[SelectionOption]>) -> some View {
        Self.menu(
            for: options.wrappedValue,
            label: selectedOptionText,
            value: value,
            contentProvider: contentProvider) { option in
                selectedUnit?.wrappedValue = option
                onUnitChanged?(option)
            }
    }
}

//extension Field {
//
//    @ViewBuilder
//    func menu(for options: Binding<[SelectionOption]>) -> some View {
//        Menu {
//            ForEach(options.indices, id: \.self) { index in
//                let option = options.wrappedValue[index]
//                if let _ = option as? SelectionDivider {
//                    Divider()
//                } else if option.isGroup, let subOptions = option.subOptions {
//                    secondaryMenu(for: subOptions, option: option)
//                } else {
//                    menuButton(for: option)
//                }
//            }
//        } label: {
//            selectedOptionText
//        }
//        .onTapGesture {
//            Haptics.feedback(style: .soft)
//        }
//    }
//
//    @ViewBuilder
//    func secondaryMenu(for options: [SelectionOption], option: SelectionOption) -> some View {
//        Menu {
//            ForEach(options.indices, id: \.self) { index in
//                let option = options[index]
//                if let _ = option as? SelectionDivider {
//                    Divider()
//                } else if option.isGroup, let subOptions = option.subOptions {
//                    tertiaryMenu(for: subOptions, option: option)
//                } else {
//                    menuButton(for: option)
//                }
//            }
//        } label: {
//            menuButtonLabel(for: option)
//        }
//        .onTapGesture {
//            Haptics.feedback(style: .soft)
//        }
//    }
//
//    @ViewBuilder
//    func tertiaryMenu(for options: [SelectionOption], option: SelectionOption) -> some View {
//        Menu {
//            ForEach(options.indices, id: \.self) { index in
//                let option = options[index]
//                if let _ = option as? SelectionDivider {
//                    Divider()
//                } else {
//                    menuButton(for: option)
//                }
//            }
//        } label: {
//            menuButtonLabel(for: option)
//        }
//        .onTapGesture {
//            Haptics.feedback(style: .soft)
//        }
//    }
//
//    //MARK: - Helpers
//
//    @ViewBuilder
//    func menuButtonLabel(for option: SelectionOption) -> some View {
//        let title = title(for: option, forMenu: true)
//        if let systemImage = contentProvider?.systemImage(for: option) {
//            Label(title, systemImage: systemImage)
//        } else if let systemImage = option.systemImage {
//            Label(title, systemImage: systemImage)
//        } else {
//            Text(title)
//        }
//    }
//
//    @ViewBuilder
//    func menuButton(for option: SelectionOption) -> some View {
//        Button(action: {
//            selectedUnit?.wrappedValue = option
//            onUnitChanged?(option)
//        }) {
//            menuButtonLabel(for: option)
//        }
//    }
//}
