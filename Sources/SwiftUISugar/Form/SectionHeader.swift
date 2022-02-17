import SwiftUI

public struct SectionHeader: View {
    
    var isEditing: Binding<Bool>?
    var imageName: Binding<String>?
    @Binding var title: String
    
    public init(_ title: Binding<String>, imageName: Binding<String>? = nil, isEditing: Binding<Bool>? = nil) {
        self._title = title
        self.imageName = imageName
        self.isEditing = isEditing
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
    var titleView: some View {
        HStack {
            if let imageName = imageName?.wrappedValue {
                Image(systemName: imageName)
                    .foregroundColor(Color.gray)
            }
            Text(title)
                .textCase(.none)
                .foregroundColor(Color.gray)
        }
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
