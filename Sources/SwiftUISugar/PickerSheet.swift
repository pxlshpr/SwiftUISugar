import SwiftUI
import SwiftHaptics


public struct PickerSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    let title: String
    let items: [PickerItem]
    let pickedItem: PickerItem?
    let didPick: (PickerItem) -> ()

    public init(
        title: String,
        items: [PickerItem],
        pickedItem: PickerItem? = nil,
        didPick: @escaping (PickerItem) -> Void)
    {
        self.title = title
        self.items = items
        self.pickedItem = pickedItem
        self.didPick = didPick
    }
    
    public var body: some View {
        QuickForm(title: title) {
            List {
                ForEach(items) {
                    cell(for: $0)
                }
            }
        }
        .presentationDetents([.height(450), .large])
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func cell(for item: PickerItem) -> some View {
        
        var isSelected: Bool {
            pickedItem?.id == item.id
        }
        
        var label: some View {
            var titleColor: Color {
                isSelected ? .accentColor : .primary
            }
            
            var detailColor: Color {
                isSelected ? .accentColor : .primary
            }
            
            var checkmark: some View {
                Image(systemName: "checkmark")
                    .opacity(isSelected ? 1 : 0)
                    .foregroundColor(isSelected ? .accentColor : .clear)
            }
            
            var backgroundColor: Color {
                isSelected
                ? .accentColor.opacity(0.2)
                : Color(.tertiarySystemFill)
            }
            
            var linearGradient: LinearGradient? {
                switch item.colorStyle {
                case .plain:
                    return nil
                case .gradient(let topColor, let bottomColor):
                    return LinearGradient(
                        colors: [topColor, bottomColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
            
            var title: some View {
                var text: some View {
                    Text(item.title)
                        .font(.body)
                        .bold()
                        .padding(.vertical, 5)
                        .padding(.horizontal, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .foregroundColor(backgroundColor)
                                .opacity(item.hasAccessoryTexts ? 1 : 0)
                        )
                }
                
                return Group {
                    if let linearGradient, !isSelected {
                        text.foregroundStyle(linearGradient)
                    } else {
                        text.foregroundColor(titleColor)
                    }
                }
            }
            
            @ViewBuilder
            var detail: some View {
                if let detail = item.detail {
                    Text(detail)
                        .foregroundColor(detailColor)
                        .font(.caption)
                        .padding(.leading, 4)
                }
            }
            
            @ViewBuilder
            var secondaryDetail: some View {
                if let secondaryDetail = item.secondaryDetail {
                    Text(secondaryDetail)
                        .foregroundColor(detailColor)
                        .opacity(0.75)
                        .font(.footnote)
                        .padding(.leading, 4)
                }
            }

            @ViewBuilder
            var image: some View {
                if let image = item.systemImage {
                    if let linearGradient, !isSelected {
                        Image(systemName: image)
                            .foregroundStyle(linearGradient)
                    } else {
                        Image(systemName: image)
                            .foregroundColor(titleColor)
                    }
                }
            }
            
            return HStack(spacing: 17) {
                image
                VStack(alignment: .leading) {
                    title
                    detail
                    secondaryDetail
                }
                Spacer()
                checkmark
            }
        }
        
        func handleTap() {
            Haptics.feedback(style: .rigid)
            didPick(item)
            dismiss()
        }
        
        return Button {
            handleTap()
        } label: {
            label
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(
            Group {
                if isSelected {
                    SecondaryAccent()
                } else {
                    ListCellBackground()
                }
            }
        )
    }
}

public struct PickerItem: Identifiable {
    
    public var id: String
    public var title: String
    public var detail: String?
    public var secondaryDetail: String?
    public var systemImage: String?
    public var colorStyle: ColorStyle
    
    public enum ColorStyle {
        case plain
        case gradient(Color, Color)
    }
    
    public init(
        id: String? = nil,
        title: String,
        detail: String? = nil,
        secondaryDetail: String? = nil,
        systemImage: String? = nil,
        colorStyle: ColorStyle? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.detail = detail
        self.secondaryDetail = secondaryDetail
        self.systemImage = systemImage
        self.colorStyle = colorStyle ?? .plain
    }
    
    var hasAccessoryTexts: Bool {
        detail != nil || secondaryDetail != nil
    }
}

extension PickerItem: Equatable {
    public static func ==(lhs: PickerItem, rhs: PickerItem) -> Bool {
        lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.detail == rhs.detail
        && lhs.secondaryDetail == rhs.secondaryDetail
        && lhs.systemImage == rhs.systemImage
    }
}
