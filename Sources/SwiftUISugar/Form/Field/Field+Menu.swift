//import SwiftUI
//import SwiftHaptics
//
//extension Field {
//    @ViewBuilder
//    func menu(for options: Binding<[SelectionOption]>) -> some View {
//        fieldMenu(
//            for: options.wrappedValue,
//            label: selectedOptionText,
//            value: value,
//            contentProvider: contentProvider) { option in
//                selectedUnit?.wrappedValue = option
//                onUnitChanged?(option)
//            }
//    }
//}
//
////MARK: - Global Functions
//@ViewBuilder
//public func fieldMenu<LabelContent: View>(
//    for options: [SelectionOption],
//    label: LabelContent,
//    value: Binding<String>?,
//    contentProvider: FieldContentProvider? = nil,
//    onOptionSelection: @escaping ((SelectionOption) -> Void)
//) -> some View {
//    Menu {
//        ForEach(options.indices, id: \.self) { index in
//            let option = options[index]
//            if let _ = option as? SelectionDivider {
//                Divider()
//            } else if option.isGroup, let subOptions = option.subOptions {
//                fieldSecondaryMenu(
//                    for: subOptions,
//                    label: fieldMenuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection),
//                    value: value,
//                    contentProvider: contentProvider,
//                    onOptionSelection: onOptionSelection
//                )
//            } else {
//                fieldMenuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection)
//            }
//        }
//    } label: {
//        label
//    }
//    .onTapGesture {
//        Haptics.feedback(style: .soft)
//    }
//}
//
//@ViewBuilder
//func fieldSecondaryMenu<LabelContent: View>(for options: [SelectionOption], label: LabelContent, value: Binding<String>?, contentProvider: FieldContentProvider?, onOptionSelection: @escaping ((SelectionOption) -> Void)) -> some View {
//    Menu {
//        ForEach(options.indices, id: \.self) { index in
//            let option = options[index]
//            if let _ = option as? SelectionDivider {
//                Divider()
//            } else if option.isGroup, let subOptions = option.subOptions {
//                fieldTertiaryMenu(
//                    for: subOptions,
//                    label: fieldMenuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection),
//                    value: value,
//                    contentProvider: contentProvider,
//                    onOptionSelection: onOptionSelection
//                )
//            } else {
//                fieldMenuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection)
//            }
//        }
//    } label: {
//        label
//    }
//    .onTapGesture {
//        Haptics.feedback(style: .soft)
//    }
//}
//
//@ViewBuilder
//func fieldTertiaryMenu<LabelContent: View>(for options: [SelectionOption], label: LabelContent, value: Binding<String>?, contentProvider: FieldContentProvider?, onOptionSelection: @escaping ((SelectionOption) -> Void)) -> some View {
//    Menu {
//        ForEach(options.indices, id: \.self) { index in
//            let option = options[index]
//            if let _ = option as? SelectionDivider {
//                Divider()
//            } else {
//                fieldMenuButton(for: option, value: value, contentProvider: contentProvider, onOptionSelected: onOptionSelection)
//            }
//        }
//    } label: {
//        label
//    }
//    .onTapGesture {
//        Haptics.feedback(style: .soft)
//    }
//}
//
//func fieldMenuTitle(for option: SelectionOption?, forMenu: Bool = false, value: Binding<String>?, contentProvider: FieldContentProvider?) -> String {
//    guard let option = option else { return "Unsupported" }
//    var isPlural = true
//    if let value = value, let doubleValue = Double(value.wrappedValue) {
//        isPlural = doubleValue > 1
//    }
//    if forMenu {
//        return contentProvider?.menuTitle(for: option, isPlural: isPlural)
//        ?? option.menuTitle(isPlural: isPlural)
//        ?? contentProvider?.title(for: option, isPlural: isPlural)
//        ?? option.title(isPlural: isPlural) ?? "Unsupported"
//    } else {
//        return contentProvider?.title(for: option, isPlural: isPlural) ?? option.title(isPlural: isPlural) ?? "Unsupported"
//    }
//}
//@ViewBuilder
//func fieldMenuButtonLabel(for option: SelectionOption, value: Binding<String>?, contentProvider: FieldContentProvider?) -> some View {
//    let title = fieldMenuTitle(for: option, forMenu: true, value: value, contentProvider: contentProvider)
//    if let accessorySystemImage = contentProvider?.accessorySystemImage(for: option) {
//        Label(title, systemImage: accessorySystemImage)
//    } else if let accessorySystemImage = option.accessorySystemImage {
//        Label(title, systemImage: accessorySystemImage)
//    } else {
//        Text(title)
//    }
//}
//
//@ViewBuilder
//func fieldMenuButton(for option: SelectionOption, value: Binding<String>?, contentProvider: FieldContentProvider?, onOptionSelected: @escaping ((SelectionOption) -> Void)) -> some View {
//    Button(role: option.role) {
//        onOptionSelected(option)
//        NotificationCenter.default.post(name: .selectionOptionChanged, object: nil)
//    } label: {
//        fieldMenuButtonLabel(for: option, value: value, contentProvider: contentProvider)
//    }
////        Button(action: {
////            onOptionSelected(option)
////            NotificationCenter.default.post(name: .selectionOptionChanged, object: nil)
////        }) {
////            menuButtonLabel(for: option, value: value, contentProvider: contentProvider)
////        }
//}
