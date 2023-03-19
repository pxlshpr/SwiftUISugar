#if canImport(UIKit)
import SwiftUI
import SwiftHaptics

public struct QuickForm<Content: View>: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let titleFontStyle: Font.TextStyle
    let lighterBackground: Bool
    @Binding var info: FormSaveInfo?
    @Binding var saveAction: FormConfirmableAction?
    @Binding var deleteAction: FormConfirmableAction?
    var content: () -> Content

    @State var showingDeleteConfirmation = false

    public init(
        title: String,
        titleFontStyle: Font.TextStyle = .title2,
        lighterBackground: Bool = false,
        info: Binding<FormSaveInfo?> = .constant(nil),
        saveAction: Binding<FormConfirmableAction?> = .constant(nil),
        deleteAction: Binding<FormConfirmableAction?> = .constant(nil),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.titleFontStyle = titleFontStyle
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
            optionalTopTrailingSaveButton
            dismissButton
        }
        .frame(height: 30)
        .padding(.leading, 20)
        .padding(.trailing, 14)
        .padding(.top, 12)
        .padding(.bottom, 18)
    }
    
    @ViewBuilder
    var optionalTopTrailingSaveButton: some View {
        if let saveAction, saveAction.position == .topTrailing {
            saveAndDismissButton(saveAction)
        }
    }

    @ViewBuilder
    var saveRow: some View {
        if let saveAction, saveAction.shouldPlaceAtBottom {
            saveRow(with: saveAction)
        }
    }
    
    func saveRow(with saveAction: FormConfirmableAction) -> some View {
        @ViewBuilder
        var saveButton: some View {
            if saveAction.position == .bottomTrailing {
                bottomTrailingSaveButton(saveAction)
            } else {
                bottomFilledSaveButton(saveAction)
            }
        }

        return HStack {
            if saveAction.position == .bottomTrailing {
                Spacer()
            }
            saveButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    func bottomFilledSaveButton(_ saveAction: FormConfirmableAction) -> some View {
        var buttonHeight: CGFloat { 52 }
        var buttonCornerRadius: CGFloat { 10 }
        var shadowSize: CGFloat { 2 }
        var saveIsDisabled: Bool { saveAction.isDisabled }

        return Button {
            tappedSave(saveAction)
        } label: {
            Text(saveAction.confirmationButtonTitle ?? "Save")
                .bold()
                .foregroundColor((colorScheme == .light && saveIsDisabled) ? .black : .white)
                .frame(height: buttonHeight)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                        .foregroundStyle(Color.accentColor.gradient)
                        .shadow(color: Color(.black), radius: shadowSize, x: 0, y: shadowSize)
                )
        }
        .buttonStyle(.borderless)
        .disabled(saveIsDisabled)
        .opacity(saveIsDisabled ? (colorScheme == .light ? 0.2 : 0.2) : 1)
    }
    
    func tappedSave(_ saveAction: FormConfirmableAction) {
        Haptics.successFeedback()
        saveAction.handler()
        dismiss()
    }
    
    func bottomTrailingSaveButton(_ saveAction: FormConfirmableAction) -> some View {
        var foregroundColor: Color {
            (colorScheme == .light && saveAction.isDisabled)
            ? .black
            : .white
        }

        return Button {
            tappedSave(saveAction)
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

    func saveAndDismissButton(_ saveAction: FormConfirmableAction) -> some View {
        Button {
            tappedSave(saveAction)
        } label: {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 30))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.white, Color.accentColor.gradient)
        }
        .disabled(saveAction.isDisabled)
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
