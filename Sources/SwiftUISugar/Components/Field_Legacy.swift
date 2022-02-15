import SwiftUI

public struct Field_Legacy: View {
    
    let Padding: CGFloat = 10.0
    
    @Binding var label: String
    @Binding var value: String
    @State var placeholder: String? = nil
    @State var isDecimal: Bool = false
    @State var units: String? = nil
    @State var hideAutocorrectionBar: Bool = true
    @State var autocapitalization: UITextAutocapitalizationType = .sentences

    public init(
        label: String,
        value: Binding<String>,
        placeholder: String? = nil,
        isDecimal: Bool = false,
        units: String? = nil,
        hideAutocorrectionBar: Bool = true,
        autocapitalization: UITextAutocapitalizationType = .sentences
    ) {
        self._label = .constant(label)
        self.placeholder = placeholder
        self.isDecimal = isDecimal
        self.units = units
        self.hideAutocorrectionBar = hideAutocorrectionBar
        self.autocapitalization = autocapitalization
        self._value = value
    }

    public init(
        label: Binding<String>,
        value: Binding<String>,
        placeholder: String? = nil,
        isDecimal: Bool = false,
        units: String? = nil,
        hideAutocorrectionBar: Bool = true,
        autocapitalization: UITextAutocapitalizationType = .sentences
    ) {
        self._label = label
        self.placeholder = placeholder
        self.isDecimal = isDecimal
        self.units = units
        self.hideAutocorrectionBar = hideAutocorrectionBar
        self.autocapitalization = autocapitalization
        self._value = value
    }

    public var body: some View {
        ZStack {
            labelsLayer
            textFieldLayer
        }
    }
    
    @ViewBuilder
    var textField: some View {
        TextField(placeholder ?? "", text: $value)
            .keyboardType(isDecimal ? .decimalPad : .alphabet)
            .disableAutocorrection(hideAutocorrectionBar)
            .autocapitalization(autocapitalization)
            .multilineTextAlignment(.trailing)
            .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder
    var textFieldLayer: some View {
        HStack {
            Spacer()
                .frame(width: labelWidth(for: label) + Padding)
            textField
            if let units = units {
                Text(units)
                    .foregroundColor(Color(.clear))
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    @ViewBuilder
    var labelsLayer: some View {
        HStack {
            Text(label)
                .foregroundColor($value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel))
            Spacer()
            if let units = units {
                Text(units)
                    .foregroundColor($value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel))
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    func labelWidth(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        let size = font.fontSize(for: text)
        return size.width
    }
}
