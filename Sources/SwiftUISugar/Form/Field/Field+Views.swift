import SwiftUI
import AVFAudio

let AccessoryImageWidth: CGFloat = 20

extension Field {

    @ViewBuilder
    public var body: some View {
        Group {
            if let units = units {
                menuField(for: units)
            } else {
                field
            }
        }
        .listRowBackground(isFocused ? Color.accentColor : Color(.secondarySystemGroupedBackground))
    }

    @ViewBuilder
    var field: some View {
        ZStack {
            labelsLayer
            textFieldLayer
        }
        .onTapGesture {
//            isFocused = true
        }
    }

    @ViewBuilder
    var singleOptionText: some View {
        if let option = unit {
            if selectorStyle == .plain {
                Text(option)
                    .foregroundColor(haveValue ? Color(.secondaryLabel) : Color(.tertiaryLabel))
                    .multilineTextAlignment(.trailing)
            } else {
                Text(option)
                    .multilineTextAlignment(.trailing)
                    .font(.headline)
                    .foregroundColor(foregroundColor)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.vertical, 3)
                    .background(backgroundView)
                    .padding(.vertical, PaddingTapTargetVertical)
                    .grayscale(1.0)
                    .opacity(haveValue ? 1.0 : 0.5)
            }
        }
    }
    
    @ViewBuilder
    var labelView: some View {
        if let label = label {
            HStack {
                Text(label.wrappedValue)
                
                    .if(isFocused, transform: { text in
                            text
                            .bold()
                    })
                if let accessoryMenuContents = accessoryMenuContents,
                   let accessorySystemImage = accessorySystemImage?.wrappedValue {
                    Menu {
                        accessoryMenuContents
                    } label: {
                        Image(systemName: accessorySystemImage)
                            .frame(width: AccessoryImageWidth)
                    }
                } else if let accessorySystemImage = accessorySystemImage?.wrappedValue {
                    Image(systemName: accessorySystemImage)
                }
            }
        }
    }

    @ViewBuilder
    var labelsLayer: some View {
        if value != nil {
            HStack {
                labelView
                    .foregroundColor(labelColor)
                Spacer()
                singleOptionText
            }
        } else {
            labelView
                .foregroundColor(labelColor)
        }
    }
    
    var labelColor: Color {
        guard let value = value else {
            return Color(.label)
        }
        guard !isFocused else {
            return Color(.label)
        }
        return value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel)
    }
    
    var labelWidth: CGFloat {
        guard let label = label else { return 0 }
        let baseWidth = label.wrappedValue.widthForLabelFont + Padding
        if isShowingAccessoryImage {
            return baseWidth + AccessoryImageWidth
        } else {
            return baseWidth
        }
    }
    
    var isShowingAccessoryImage: Bool {
        accessorySystemImage != nil
    }
    
    @ViewBuilder
    var textFieldLayer: some View {
        HStack {
            Spacer()
                .frame(width: labelWidth)
            textField
            /// placeholder that simulates the unit being placed on the `labelsLayer` to pad out the space needed
            singleOptionText
                .opacity(0)
        }
    }
    
    @ViewBuilder
    var textField: some View {
        if let value = value {
            TextField(placeholder ?? "", text: value)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
                .frame(maxHeight: .infinity)
        }
    }

    
    @ViewBuilder
    func menuField(for units: Binding<[SelectionOption]>) -> some View {
        HStack {
            if label != nil {
                if value != nil {
                    field
                } else {
                    labelsLayer
                    Spacer()
                }
            }
            if units.count > 1 {
                menu(for: units)
                    .id(refreshMenuBool)
            } else {
                selectedOptionText
            }
        }
        .onReceive(selectionOptionChanged) { notification in
            refreshMenuBool.toggle()
        }
    }

    var textAlignment: HorizontalAlignment {
        value == nil ? .trailing : .leading
    }
    
    var textVerticalSpacing: CGFloat {
        3
    }
    
    @ViewBuilder
    var primaryText: some View {
        Text(title)
            .multilineTextAlignment(.leading)
            .if(selectorStyle == .prominent) { view in
                view.font(.headline)
            }
            .if(selectorStyle == .plain) { view in
                view.font(.subheadline)
            }
            .minimumScaleFactor(0.1)
    }
    
    @ViewBuilder
    var secondaryText: some View {
        if let subtitle = subtitle {
            Text(subtitle)
                .fontWeight(selectorStyle == .prominent ? .regular : .light)
                .multilineTextAlignment(.leading)
                .if(selectorStyle == .prominent) { view in
                    view.font(.subheadline)
                }
                .if(selectorStyle == .plain) { view in
                    view.font(.footnote)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.vertical, 3)
                        .padding(.horizontal, 7)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(
                            RoundedRectangle(cornerRadius: 7.0)
                                .fill(Color(.secondarySystemFill))
                        )
                }
                .minimumScaleFactor(0.1)
        }
    }
    
    var haveMultipleOptions: Bool {
        (units?.wrappedValue.count ?? 1) > 1
    }
    
    @ViewBuilder
    var chevron: some View {
        if haveMultipleOptions {
            Spacer().frame(width: 5)
            Image(systemName: "chevron.down")
                .font(.system(size: 12, weight: .semibold))
                .if(selectorStyle == .plain) { view in
                    view.foregroundColor(Color(.tertiaryLabel))
                }
        }
    }
    
    @ViewBuilder
    var selectedOptionText: some View {
        HStack(spacing: 0) {
            VStack(alignment: textAlignment, spacing: textVerticalSpacing) {
                primaryText
                    .animation(.interactiveSpring(), value: title)
                secondaryText
                    .animation(.interactiveSpring(), value: title)
            }
            chevron
        }
        .foregroundColor(foregroundColor)
        .padding(.leading, 10)
        .if(selectorStyle == .prominent, transform: { view in
            view
                .padding(.trailing, 10)
        })
        .padding(.vertical, 3)
        .if(selectorStyle == .prominent, transform: { view in
            view
                .background(backgroundView)
        })
        .padding(.vertical, PaddingTapTargetVertical)
        .contentShape(Rectangle())
        .grayscale(isFocused ? 0.0 : 1.0)
//        .grayscale(!haveMultipleOptions ? 1.0 : 0.0)
        .disabled(!haveMultipleOptions)
//        .opacity(haveValue ? 1.0 : 0.5)
    }
    
    var haveValue: Bool {
        guard let value = value else {
            return true
        }
        return !value.wrappedValue.isEmpty
    }
    
    @ViewBuilder
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(pillBackgroundColor)
//            .overlay(RoundedRectangle(cornerRadius: 6))
    }
    
    //MARK: - Legacy
    @ViewBuilder
    var unitText: some View {
        if let subtitle = subtitle {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(unitTextColor)
                    .animation(.interactiveSpring(), value: title)
                Text(subtitle)
                    .foregroundColor(unitTextColor)
                    .font(.caption2)
                    .animation(.interactiveSpring(), value: subtitle)
            }
            .foregroundColor(unitTextColor)
        } else {
            Text(title)
                .foregroundColor(unitTextColor)
                .animation(.interactiveSpring(), value: title)
        }
    }
}
