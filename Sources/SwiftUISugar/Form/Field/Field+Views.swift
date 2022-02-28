import SwiftUI

extension Field {

    @ViewBuilder
    public var body: some View {
        if let units = units {
            menuField(for: units)
        } else {
            field
        }
    }

    @ViewBuilder
    var field: some View {
        ZStack {
            labelsLayer
            textFieldLayer
        }
        .onTapGesture {
            isFocused = true
        }
    }

    @ViewBuilder
    func menuField(for units: Binding<[SelectionOption]>) -> some View {
        HStack {
            if value != nil {
                field
            } else {
                labelsLayer
                Spacer()
            }
            if units.count > 1 {
                menu(for: units)
            } else {
                selectedOptionText
            }
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
                    .foregroundColor(.white)
            }
            .if(selectorStyle == .plain) { view in
                view.font(.subheadline)
                    .foregroundColor(.accentColor)
            }
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
                secondaryText
            }
            chevron
        }
        .transition(.scale)
        .animation(.interactiveSpring(), value: title)
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
        .padding(.vertical, Self.PaddingTapTargetVertical)
        .contentShape(Rectangle())
        .grayscale(!haveMultipleOptions ? 1.0 : 0.0)
        .disabled(!haveMultipleOptions)
    }
    
//    @ViewBuilder
//    func selectedOptionText_legacy(singleOption: Bool = false) -> some View {
//        HStack(spacing: 0) {
//            VStack (alignment: value == nil ? .trailing : .leading) {
//                Text(selectedUnitString)
//                    .font(.headline)
//                    .multilineTextAlignment(.leading)
//                if let subtitle = subtitle {
//                    Text(subtitle)
//                        .font(.subheadline)
//                        .multilineTextAlignment(.leading)
//                }
//            }
//            if !singleOption {
//                Spacer().frame(width: 5)
//                Image(systemName: "chevron.down")
//                    .font(.system(size: 12, weight: .semibold))
//            }
//        }
//        .transition(.scale)
//        .animation(.interactiveSpring(), value: selectedUnitString)
//        .foregroundColor(foregroundColor)
//        .padding(.leading, 10)
//        .padding(.trailing, 10)
//        .padding(.vertical, 3)
//        .background(backgroundView)
//        .padding(.vertical, Self.PaddingTapTargetVertical)
//        .contentShape(Rectangle())
//        .grayscale(singleOption ? 1.0 : 0.0)
//        .disabled(singleOption)
//    }

    @ViewBuilder
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(pillBackgroundColor)
//            .overlay(RoundedRectangle(cornerRadius: 6))
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
    var textFieldLayer: some View {
        HStack {
            Spacer()
                .frame(width: label.widthForLabelFont + Padding)
            textField
//            if let units = unit {
//                Text(units)
//                    .foregroundColor(Color(.clear))
//                    .multilineTextAlignment(.trailing)
//            }
        }
    }

    @ViewBuilder
    var labelsLayer: some View {
        if let value = value {
            HStack {
                Text(label)
                    .foregroundColor(value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel))
                Spacer()
//                if let units = unit {
//                    Text(units)
//                        .foregroundColor(value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel))
//                        .multilineTextAlignment(.trailing)
//                }
            }
        } else {
            Text(label)
                .foregroundColor(Color(.label))
        }
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
