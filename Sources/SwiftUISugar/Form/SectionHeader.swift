import SwiftUI

public struct SectionHeader: View {
    
    var isEditing: Binding<Bool>?
    var imageName: Binding<String>?
    @Binding var title: String
    var titlePrefix: Binding<String>?
    var onPrefixTapped: (() -> Void)?

    public init(_ title: String,
                prefix: String? = nil,
                imageName: String? = nil,
                isEditing: Binding<Bool>? = nil,
                onPrefixTapped: (() -> Void)? = nil
    ) {
        self.init(.constant(title),
                  prefix: prefix != nil ? .constant(prefix!) : nil,
                  imageName: imageName != nil ? .constant(imageName!) : nil,
                  isEditing: isEditing,
                  onPrefixTapped: onPrefixTapped)
    }

    public init(_ title: Binding<String>,
                prefix: Binding<String>? = nil,
                imageName: String? = nil,
                isEditing: Binding<Bool>? = nil,
                onPrefixTapped: (() -> Void)? = nil
    ) {
        self.init(title,
                  prefix: prefix,
                  imageName: imageName != nil ? .constant(imageName!) : nil,
                  isEditing: isEditing,
                  onPrefixTapped: onPrefixTapped)
    }

    public init(_ title: Binding<String>,
                prefix: Binding<String>? = nil,
                imageName: Binding<String>? = nil,
                isEditing: Binding<Bool>? = nil,
                onPrefixTapped: (() -> Void)? = nil
    ) {
        self._title = title
        self.titlePrefix = prefix
        self.imageName = imageName
        self.isEditing = isEditing
        self.onPrefixTapped = onPrefixTapped
    }
    
    @ViewBuilder
    public var body: some View {
        if let isEditing = isEditing {
            EditButton(isEditing: isEditing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .overlay(titleView, alignment: .leading)
        } else {
            titleView
        }
    }
    
    @ViewBuilder
    var image: some View {
        if let imageName = imageName?.wrappedValue {
            Image(systemName: imageName)
        }
    }
    
    @ViewBuilder
    var titleView: some View {
        HStack {
            if let titlePrefix = titlePrefix {
                if let onPrefixTapped = onPrefixTapped {
                    Button {
                        onPrefixTapped()
                    } label: {
                        image
                        Text(titlePrefix.wrappedValue)
                    }
                    .font(.headline)
                    .foregroundColor(.accentColor)
                } else {
                    image
                        .foregroundColor(Color(.tertiaryLabel))
                    Text(titlePrefix.wrappedValue)
                        .foregroundColor(Color(.tertiaryLabel))
                }
            }
            Text(title)
                .foregroundColor(Color(.secondaryLabel))
        }
        .textCase(.none)
        .font(.subheadline)
        .lineLimit(1)
        .minimumScaleFactor(0.2)
//        .multilineTextAlignment(.leading)
    }
    
    struct EditButton: View {
        @Binding var isEditing: Bool

        var body: some View {
            Button(isEditing ? "DONE" : "EDIT") {
                withAnimation {
                    isEditing.toggle()
                }
            }
            .foregroundColor(.accentColor)
        }
    }
}
