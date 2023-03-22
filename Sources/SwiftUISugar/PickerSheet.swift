import SwiftUI
import SwiftHaptics

public protocol PickableItem: Equatable {
    var pickerTitle: String { get }
    var pickerSystemImage: String? { get }
    var pickerDetail: String? { get }
}

public extension PickableItem {
    var pickerSystemImage: String? { nil }
    var pickerDetail: String? { nil }
    
    var pickerItem: PickerItem {
        PickerItem(
            id: self.pickerTitle,
            title: self.pickerTitle,
            detail: self.pickerDetail,
            systemImage: self.pickerSystemImage
        )
    }
}

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
            
            var title: some View {
                Text(item.title)
                    .font(.body)
                    .bold()
//                    .bold(isSelected)
                    .foregroundColor(titleColor)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .foregroundColor(backgroundColor)
                    )
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
                    Image(systemName: image)
                        .foregroundColor(titleColor)
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

public struct PickerItem: Identifiable, Equatable {
    
    public var id: String
    public var title: String
    public var detail: String?
    public var secondaryDetail: String?
    public var systemImage: String?
    
    public init(
        id: String? = nil,
        title: String,
        detail: String? = nil,
        secondaryDetail: String? = nil,
        systemImage: String? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.detail = detail
        self.secondaryDetail = secondaryDetail
        self.systemImage = systemImage
    }
}
