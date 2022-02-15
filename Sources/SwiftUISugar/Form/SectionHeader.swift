import SwiftUI

public struct SectionHeader: View {
    
    var isEditing: Binding<Bool>?
    @State var imageName: String?
    @State var title: String
    
    init(_ title: String, imageName: String? = nil, isEditing: Binding<Bool>? = nil) {
        self._title = State(initialValue: title)
        self._imageName = State(initialValue: imageName)
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
            if let imageName = imageName {
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
