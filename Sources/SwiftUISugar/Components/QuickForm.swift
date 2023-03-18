#if canImport(UIKit)
import SwiftUI
import SwiftHaptics

public struct QuickForm<Content: View>: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let titleFontStyle: Font.TextStyle
    let saveInPlaceOfDismiss: Bool
    let lighterBackground: Bool
    @Binding var info: FormSaveInfo?
    @Binding var saveAction: FormConfirmableAction?
    @Binding var deleteAction: FormConfirmableAction?
    var content: () -> Content

    @State var showingDeleteConfirmation = false

    public init(
        title: String,
        titleFontStyle: Font.TextStyle = .title2,
        saveInPlaceOfDismiss: Bool = false,
        lighterBackground: Bool = false,
        info: Binding<FormSaveInfo?> = .constant(nil),
        saveAction: Binding<FormConfirmableAction?> = .constant(nil),
        deleteAction: Binding<FormConfirmableAction?> = .constant(nil),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.titleFontStyle = titleFontStyle
        self.saveInPlaceOfDismiss = saveInPlaceOfDismiss
        self.lighterBackground = lighterBackground
        _info = info
        _saveAction = saveAction
        _deleteAction = deleteAction
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                topRow
                content()
                    .frame(maxWidth: .infinity)
//                    .frame(maxHeight: .infinity)
                saveRow
                Spacer()
            }
            .background(
                background
                    .edgesIgnoringSafeArea(.all) /// requireds to cover the area that would be covered by the keyboard during its dismissal animation
            )
            /// This ensures that the it takes up the entire height and aligns to the top, which
            /// - ensures the contents stick to the top while dismissing (it otherwise centers vertically)
            .frame(height: proxy.size.height, alignment: .top)
        }
    }
    
    @ViewBuilder
    var background: some View {
        if lighterBackground {
            FormCellBackground()
        } else {
            FormBackground()
        }
    }

    var topRow: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(.top, 5)
            Spacer()
            deleteButton
            trailingButton
        }
        .frame(height: 30)
        .padding(.leading, 20)
        .padding(.trailing, 14)
        .padding(.top, 12)
        .padding(.bottom, 18)
    }

    var saveRow: some View {
        HStack {
            Spacer()
            saveButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    //MARK: - Buttons

    @ViewBuilder
    var saveButton: some View {
        if let saveAction, !saveInPlaceOfDismiss {
            saveButton(saveAction)
        }
    }
    
    func saveButton(_ saveAction: FormConfirmableAction) -> some View {
        var foregroundColor: Color {
            (colorScheme == .light && saveAction.isDisabled)
            ? .black
            : .white
        }

        return Button {
            Haptics.successFeedback()
            saveAction.handler()
            dismiss()
        } label: {
            Group {
                if let buttonImage = saveAction.buttonImage {
                    Image(systemName: buttonImage)
                        .bold()
                        .foregroundColor(foregroundColor)
                        .frame(width: 38, height: 38)
                } else {
                    Text(saveAction.confirmationButtonTitle ?? "Save")
                        .bold()
                        .foregroundColor(foregroundColor)
                        .frame(height: 38)
                        .padding(.horizontal, 20)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 19)
                    .foregroundStyle(Color.accentColor.gradient)
                    .shadow(color: Color(.black).opacity(0.2), radius: 2, x: 0, y: 2)
            )
        }
        .disabled(saveAction.isDisabled)
        .opacity(saveAction.isDisabled ? 0.2 : 1)
    }

    var saveAndDismissButton: some View {
        
        var isDisabled: Bool {
            guard let saveAction else {
                return false
            }
            return saveAction.isDisabled
        }
        
        return Button {
            Haptics.feedback(style: .soft)
            dismiss()
            if let saveAction {
                saveAction.handler()
            }
        } label: {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 30))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.white, Color.accentColor.gradient)
                .disabled(isDisabled)
        }
    }
    
    var dismissButton: some View {
        Button {
            Haptics.feedback(style: .soft)
            dismiss()
        } label: {
            CloseButtonLabel()
        }
    }

    @ViewBuilder
    var trailingButton: some View {
        if saveInPlaceOfDismiss {
            saveAndDismissButton
        } else {
            dismissButton
        }
    }

    @ViewBuilder
    var deleteButton: some View {
        if let deleteAction {
            deleteButton(deleteAction)
        }
    }

    func deleteButton(_ action: FormConfirmableAction) -> some View {
        var shadowSize: CGFloat { 2 }

        var confirmationActions: some View {
            Button(action.confirmationButtonTitle ?? "Delete", role: .destructive) {
                action.handler()
                dismiss()
            }
        }

        var confirmationMessage: some View {
            Text(action.confirmationMessage ?? "Are you sure?")
        }

        func textLabel(_ string: String) -> some View {
            HStack {
                Image(systemName: "trash.fill")
                    .symbolRenderingMode(.multicolor)
                    .imageScale(.medium)
                    .fontWeight(.medium)
                    .padding(.leading, 5)
                Text(string)
                    .foregroundColor(.red)
                    .padding(.trailing, 7)
            }
            .frame(width: 105, height: 38)
            .background(
                RoundedRectangle(cornerRadius: 19)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: shadowSize, x: 0, y: shadowSize)
            )
        }

        func imageLabel(_ imageName: String) -> some View {
            HStack {
                Image(systemName: "trash.circle.fill")
                    .font(.system(size: 30))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        Color.red.opacity(0.75),
                        Color(.quaternaryLabel).opacity(0.5)
                    )
            }
        }

        var label: some View {
            Group {
                if let imageName = action.buttonImage {
                    imageLabel(imageName)
                } else {
                    textLabel(action.confirmationButtonTitle ?? "Delete")
                }
            }
            .confirmationDialog(
                "",
                isPresented: $showingDeleteConfirmation,
                actions: { confirmationActions },
                message: { confirmationMessage }
            )
        }

        return Button {
            if action.shouldConfirm {
                Haptics.warningFeedback()
                showingDeleteConfirmation = true
            } else {
                action.handler()
            }
        } label: {
            label
        }
    }
}
#endif
