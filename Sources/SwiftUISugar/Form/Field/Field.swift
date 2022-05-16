import SwiftUI
import SwiftHaptics

public typealias UnitChangedHandler = (SelectionOption) -> Void

public enum SelectorFieldStyle {
    case plain
    case prominent
}

public struct Field: View {

    var label: Binding<String>?
    var value: Binding<String>?
    var systemImage: Binding<String>?
    @State var keyboardType: UIKeyboardType = .default
    @State var selectorStyle: SelectorFieldStyle
    var contentProvider: FieldContentProvider?

    @State var placeholder: String? = nil
    @State var unit: String? = nil /// Single (optional) unit

    /// Multiple units
    var units: Binding<[SelectionOption]>? =     nil
    var selectedUnit: Binding<SelectionOption>? = nil
    var onUnitChanged: UnitChangedHandler? = nil

    @FocusState var isFocused: Bool
    @Environment(\.colorScheme) var colorScheme

    @State var refreshMenuBool: Bool = false
    
    /// Constants
    let Padding: CGFloat = 10.0
    let FontSize = 13.0
    let FontWeight: Font.Weight = .semibold
    let UIFontWeight: UIFont.Weight = .semibold
    static var PaddingTapTargetHorizontal: CGFloat = 10.0
    static var PaddingTapTargetVertical: CGFloat = 7.0

    let selectionOptionChanged = NotificationCenter.default.publisher(for: .selectionOptionChanged)

    //MARK: - Initializers
    public init(
        label: Binding<String>? = nil,
        value: Binding<String>? = nil,
        systemImage: Binding<String>? = nil,
        placeholder: String? = nil,
        unit: String? = nil,
        units: Binding<[SelectionOption]>? = nil,
        selectedUnit: Binding<SelectionOption>? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        selectorStyle: SelectorFieldStyle = .plain,
        contentProvider: FieldContentProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self.label = label
        self.value = value
        self.systemImage = systemImage
        self._placeholder = State(initialValue: placeholder)
        self._unit = State(initialValue: unit)
        self.units = units
        self.selectedUnit = selectedUnit
        self._keyboardType = State(initialValue: keyboardType)
        self._selectorStyle = State(initialValue: selectorStyle)
        self.onUnitChanged = onUnitChanged
        self.contentProvider = contentProvider
    }

    //MARK: Convenience Initializers
    public init(
        label: String,
        value: Binding<String>? = nil,
        systemImage: Binding<String>? = nil,
        placeholder: String? = nil,
        unit: String? = nil,
        units: Binding<[SelectionOption]>? = nil,
        selectedUnit: Binding<SelectionOption>? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        selectorStyle: SelectorFieldStyle = .plain,
        contentProvider: FieldContentProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self.init(
            label: .constant(label),
            value: value,
            systemImage: systemImage,
            placeholder: placeholder,
            unit: unit,
            units: units,
            selectedUnit: selectedUnit,
            keyboardType: keyboardType,
            selectorStyle: selectorStyle,
            contentProvider: contentProvider,
            onUnitChanged: onUnitChanged)
    }
    
//    public init(
//        units: Binding<[SelectionOption]>? = nil,
//        selectedUnit: Binding<SelectionOption>? = nil,
//        selectorStyle: SelectorFieldStyle = .plain,
//        contentProvider: FieldContentProvider? = nil,
//        onUnitChanged: UnitChangedHandler? = nil
//    ) {
//        self.init(
//            value: value,
//            placeholder: placeholder,
//            unit: unit,
//            units: units,
//            selectedUnit: selectedUnit,
//            keyboardType: keyboardType,
//            selectorStyle: selectorStyle,
//            contentProvider: contentProvider,
//            onUnitChanged: onUnitChanged)
//    }

    
    //MARK: - Legacy
//    public init(
//        label: Binding<String>,
//        value: Binding<String>,
//        placeholder: String? = nil,
//        units: Binding<[SelectionOption]>,
//        selectedUnit: Binding<SelectionOption>,
//        keyboardType: UIKeyboardType = .alphabet,
//        contentProvider: FieldContentProvider? = nil,
//        onUnitChanged: UnitChangedHandler? = nil
//    ) {
//        self._label = label
//        self.value = value
//        self._keyboardType = State(initialValue: keyboardType)
//        self._placeholder = State(initialValue: placeholder)
//        self.units = units
//        self.selectedUnit = selectedUnit
//        self.onUnitChanged = onUnitChanged
//        self.contentProvider = contentProvider
//    }
}
