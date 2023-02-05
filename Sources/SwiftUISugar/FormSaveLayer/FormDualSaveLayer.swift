import SwiftUI
import SwiftHaptics

public struct FormDualSaveLayer: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var saveIsDisabledBinding: Bool
    @Binding var saveSecondaryIsDisabledBinding: Bool
    @Binding var info: FormSaveInfo?
    
    @State var saveIsDisabled: Bool
    @State var saveSecondaryIsDisabled: Bool

    let saveTitle: String
    let saveSecondaryTitle: String

//    let tappedCancel: () -> ()
//    let tappedSave: () -> ()
//    let tappedSaveSecondary: () -> ()
//    let tappedDelete: (() -> ())?

    let cancelAction: FormConfirmableAction
    let saveSecondaryAction: FormConfirmableAction
    let saveAction: FormConfirmableAction
    let deleteAction: FormConfirmableAction?
    @State var showingDeleteConfirmation = false
    @State var showingCancelConfirmation = false
    @State var showingSaveConfirmation = false
    @State var showingSaveSecondaryConfirmation = false

    let preconfirmationAction: (() -> ())?
    
    public init(
        saveIsDisabled: Binding<Bool>,
        saveSecondaryIsDisabled: Binding<Bool>,
        saveTitle: String,
        saveSecondaryTitle: String,
        info: Binding<FormSaveInfo?> = .constant(nil),
        preconfirmationAction: (() -> ())? = nil,
        cancelAction: FormConfirmableAction,
        saveAction: FormConfirmableAction,
        saveSecondaryAction: FormConfirmableAction,
        deleteAction: FormConfirmableAction? = nil
    ) {
        self.preconfirmationAction = preconfirmationAction
        
        _saveIsDisabledBinding = saveIsDisabled
        _saveIsDisabled = State(initialValue: saveIsDisabled.wrappedValue)

        _saveSecondaryIsDisabledBinding = saveSecondaryIsDisabled
        _saveSecondaryIsDisabled = State(initialValue: saveSecondaryIsDisabled.wrappedValue)

        self.saveTitle = saveTitle
        self.saveSecondaryTitle = saveSecondaryTitle
        
        _info = info
        
        
        self.cancelAction = cancelAction
        self.saveAction = saveAction
        self.saveSecondaryAction = saveSecondaryAction
        self.deleteAction = deleteAction
    }
    
    public var body: some View {
        VStack {
            Spacer()
            buttonsLayer
        }
        .onChange(of: saveIsDisabledBinding, perform: saveIsDisabledChanged)
        .onChange(of: saveSecondaryIsDisabledBinding, perform: saveSecondaryIsDisabledChanged)
    }
    
    func saveIsDisabledChanged(_ newValue: Bool) {
        withAnimation(.interactiveSpring()) {
            self.saveIsDisabled = newValue
        }
    }

    func saveSecondaryIsDisabledChanged(_ newValue: Bool) {
        withAnimation(.interactiveSpring()) {
            self.saveSecondaryIsDisabled = newValue
        }
    }

    var horizontalPadding: CGFloat {
//        20
        20
    }
    
    var buttonHeight: CGFloat { 52 }
    var buttonCornerRadius: CGFloat { 10 }
    var height: CGFloat { 128 }
    var shadowSize: CGFloat { 2 }
    
    var buttonsLayer: some View {
        var background: some View {
            Color.clear
                .background(.thinMaterial)
        }
        
        var divider: some View {
            Divider()
        }
        
        var buttons: some View {
            ZStack(alignment: .topLeading) {
//                dismissButtonLayer
                saveSecondaryButton
                saveButton
                topButtonsLayer
            }
            .frame(height: height)
        }
        
        return VStack(spacing: 0) {
            divider
            buttons
        }
        .background(background)
    }
    
    //MARK: Info
    func infoButton(_ info: FormSaveInfo) -> some View {
        var xPosition: CGFloat {
            UIScreen.main.bounds.width / 2.0
        }
        
        var yPosition: CGFloat {
            (52.0/2.0) + 16.0 + 52 + 8
        }
        
        var shadowOpacity: CGFloat {
            0.2
//            info.tapHandler == nil ? 0 : 0.2
        }
        
        var titleColor: Color {
            info.tapHandler == nil ? Color(.tertiaryLabel) : .secondary
        }
        
        var label: some View {
            HStack {
                if let systemImage = info.systemImage {
                    Image(systemName: systemImage)
                        .symbolRenderingMode(.multicolor)
                        .imageScale(.medium)
                        .fontWeight(.medium)
                }
                if let badge = info.badge {
                    Text("\(badge)")
                        .foregroundColor(Color(.secondaryLabel))
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .frame(width: 25, height: 25)
                        .background(
                            Circle()
                                .foregroundColor(Color(.secondarySystemFill))
                        )
                }
                Text(info.title)
                    .foregroundColor(titleColor)
                    .padding(.trailing, 3)
            }
            .padding(.horizontal, 12)
            .frame(height: 38)
            .background(
                RoundedRectangle(cornerRadius: 19)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(shadowOpacity), radius: shadowSize, x: 0, y: shadowSize)
            )
        }
        
        func button(_ tapHandler: @escaping () -> ()) -> some View {
            Button {
                tapHandler()
            } label: {
                label
            }
        }
        
        return Group {
            if let tapHandler = info.tapHandler {
                button(tapHandler)
            } else {
                label
            }
        }
    }
    
    //MARK: Save
    var saveButton: some View {
        var confirmationActions: some View {
            Button(saveAction.confirmationButtonTitle ?? "Save", role: .destructive) {
                saveAction.handler()
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(saveAction.confirmationMessage ?? "Are you sure?")
        }

        var buttonWidth: CGFloat {
            UIScreen.main.bounds.width - (horizontalPadding * 2)
        }
        
        var xPosition: CGFloat {
            UIScreen.main.bounds.width / 2.0
        }
        
        var yPosition: CGFloat {
            (52.0/2.0) + 16.0
        }
        
        var shadowOpacity: CGFloat {
            0
        }
        
        return Button {
            if saveAction.shouldConfirm {
                Haptics.warningFeedback()
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: FormSaveLayerPreConfirmationDelay) {
                        showingSaveConfirmation = true
                    }
                } else {
                    showingSaveConfirmation = true
                }
            } else {
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: FormSaveLayerPreConfirmationDelay) {
                        saveAction.handler()
                    }
                } else {
                    saveAction.handler()
                }
            }
        } label: {
            Text(saveTitle)
                .bold()
                .foregroundColor((colorScheme == .light && saveIsDisabled) ? .black : .white)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(
                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                        .foregroundStyle(Color.accentColor.gradient)
                    //                    .foregroundColor(.accentColor)
                        .shadow(color: Color(.black).opacity(shadowOpacity), radius: shadowSize, x: 0, y: shadowSize)
                )
        }
        .buttonStyle(.borderless)
        .position(x: xPosition, y: yPosition)
        .disabled(saveIsDisabled)
        .opacity(saveIsDisabled ? (colorScheme == .light ? 0.2 : 0.2) : 1)
        .confirmationDialog(
            "",
            isPresented: $showingSaveConfirmation,
            actions: { confirmationActions },
            message: { confirmationMessage }
        )
    }
    
    //MARK: Save (Secondary)
    
    var saveSecondaryButton: some View {
        var confirmationActions: some View {
            Button(saveSecondaryAction.confirmationButtonTitle ?? "Save", role: .destructive) {
                saveSecondaryAction.handler()
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(saveSecondaryAction.confirmationMessage ?? "Are you sure?")
        }

        var image: some View {
            Image(systemName: "chevron.down")
                .imageScale(.medium)
                .fontWeight(.medium)
                .foregroundColor(Color(.secondaryLabel))
        }
        
        var text: some View {
            Text(saveSecondaryTitle)
                .foregroundColor(.accentColor)
                .fontWeight(.medium)
        }
        
        var buttonWidth: CGFloat {
            UIScreen.main.bounds.width - (horizontalPadding * 2)
        }
        
        var xPosition: CGFloat {
            UIScreen.main.bounds.width / 2.0
        }
        
        var yPosition: CGFloat {
            (52.0/2.0) + 16.0 + 52 + 8
        }
        
        var label: some View {
            HStack {
                text
            }
            .frame(width: buttonWidth, height: buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: buttonCornerRadius)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: shadowSize, x: 0, y: shadowSize)
                    .opacity(0)
            )
        }
        
        return Button {
            if saveSecondaryAction.shouldConfirm {
                Haptics.warningFeedback()
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: FormSaveLayerPreConfirmationDelay) {
                        showingSaveSecondaryConfirmation = true
                    }
                } else {
                    showingSaveSecondaryConfirmation = true
                }
            } else {
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: FormSaveLayerPreConfirmationDelay) {
                        saveAction.handler()
                    }
                } else {
                    saveSecondaryAction.handler()
                }
            }
        } label: {
            label
        }
        .disabled(saveSecondaryIsDisabled)
        .opacity(saveSecondaryIsDisabled ? (colorScheme == .light ? 0.2 : 0.2) : 1)
        .position(x: xPosition, y: yPosition)
        .confirmationDialog(
            "",
            isPresented: $showingSaveSecondaryConfirmation,
            actions: { confirmationActions },
            message: { confirmationMessage }
        )
    }
    
    //MARK: Dismiss

    var dismissButton: some View {
        var confirmationActions: some View {
            Button(cancelAction.confirmationButtonTitle ?? "Close without saving", role: .destructive) {
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(cancelAction.confirmationMessage ?? "Are you sure?")
        }

        var image: some View {
            Image(systemName: "chevron.down")
                .imageScale(.medium)
                .fontWeight(.medium)
                .foregroundColor(Color(.secondaryLabel))
        }
        
        var buttonWidth: CGFloat {
            38
        }
        
        var label: some View {
            image
            .frame(width: buttonWidth, height: 38)
            .background(
                RoundedRectangle(cornerRadius: 19)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: shadowSize, x: 0, y: shadowSize)
            )
            .confirmationDialog(
                "",
                isPresented: $showingCancelConfirmation,
                actions: { confirmationActions },
                message: { confirmationMessage }
            )
        }
        
        return Button {
            if cancelAction.shouldConfirm {
                Haptics.warningFeedback()
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: FormSaveLayerPreConfirmationDelay) {
                        showingCancelConfirmation = true
                    }
                } else {
                    showingCancelConfirmation = true
                }
            } else {
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: FormSaveLayerPreConfirmationDelay) {
                        cancelAction.handler()
                    }
                } else {
                    cancelAction.handler()
                }
            }
        } label: {
            label
        }
    }
    
//    @ViewBuilder
//    var dismissButtonLayer: some View {
//        HStack {
//            dismissButton
//            Spacer()
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal, horizontalPadding)
//        .offset(y: -38 - 10)
//    }
//
    //MARK: Delete
    func deleteButton(_ action: FormConfirmableAction) -> some View {
        var confirmationActions: some View {
            Button(action.confirmationButtonTitle ?? "Delete", role: .destructive) {
                action.handler()
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(action.confirmationMessage ?? "Are you sure?")
        }
        
        var label: some View {
            HStack {
//                Image(systemName: "trash")
                Image(systemName: "trash.fill")
                    .symbolRenderingMode(.multicolor)
                    .imageScale(.medium)
                    .fontWeight(.medium)
                    .padding(.leading, 5)
                Text("Delete")
                    .foregroundColor(.red)
                    .padding(.trailing, 7)
            }
            .frame(width: 105, height: 38)
            .background(
                RoundedRectangle(cornerRadius: 19)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: shadowSize, x: 0, y: shadowSize)
            )
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
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: FormSaveLayerPreConfirmationDelay) {
                        showingDeleteConfirmation = true
                    }
                } else {
                    showingDeleteConfirmation = true
                }
            } else {
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: FormSaveLayerPreConfirmationDelay) {
                        action.handler()
                    }
                } else {
                    action.handler()
                }
            }
        } label: {
            label
        }
    }
    
    @ViewBuilder
    var topButtonsLayer: some View {
        HStack {
            dismissButton
            if let info {
                infoButton(info)
            }
            Spacer()
            if let deleteAction {
                deleteButton(deleteAction)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, horizontalPadding)
        .offset(y: -38 - 10)
    }
}
