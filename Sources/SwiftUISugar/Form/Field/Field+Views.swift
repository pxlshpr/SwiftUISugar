import SwiftUI

extension Field {

    @ViewBuilder
    public var body: some View {
        if let units = units {
            fieldWithMenu(for: units)
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
    func fieldWithMenu(for units: Binding<[SelectionOption]>) -> some View {
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
                selectedOptionText(singleOption: true)
            }
        }
    }

    @ViewBuilder
    func selectedOptionText(singleOption: Bool = false) -> some View {
        HStack(spacing: 0) {
            VStack (alignment: value == nil ? .trailing : .leading) {
                Text(selectedUnitString)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(.label))
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            if !singleOption {
                Spacer().frame(width: 5)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
            }
        }
        .transition(.scale)
        .animation(.interactiveSpring(), value: selectedUnitString)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.vertical, 3)
//        .background(backgroundView)
        .padding(.vertical, Self.PaddingTapTargetVertical)
        .contentShape(Rectangle())
        .grayscale(singleOption ? 1.0 : 0.0)
        .disabled(singleOption)
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
                Text(selectedUnitString)
                    .foregroundColor(unitTextColor)
                    .animation(.interactiveSpring(), value: selectedUnitString)
                Text(subtitle)
                    .foregroundColor(unitTextColor)
                    .font(.caption2)
                    .animation(.interactiveSpring(), value: subtitle)
            }
            .foregroundColor(unitTextColor)
        } else {
            Text(selectedUnitString)
                .foregroundColor(unitTextColor)
                .animation(.interactiveSpring(), value: selectedUnitString)
        }
    }
}
