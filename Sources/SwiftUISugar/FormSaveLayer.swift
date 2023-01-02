import SwiftUI

public struct FormSaveInfo {
    let title: String
    let tapHandler: (() -> ())?
    let badge: Int?
    let systemImage: String?
    
    public init(title: String, badge: Int, tapHandler: (() -> ())? = nil) {
        self.title = title
        self.tapHandler = tapHandler
        self.badge = badge
        self.systemImage = nil
    }
    
    public init(title: String, systemImage: String, tapHandler: (() -> ())? = nil) {
        self.title = title
        self.tapHandler = tapHandler
        self.badge = nil
        self.systemImage = systemImage
    }

    public init(title: String, tapHandler: (() -> ())? = nil) {
        self.title = title
        self.tapHandler = tapHandler
        self.badge = nil
        self.systemImage = nil
    }
}

public struct FormConfirmableAction {
    let handler: () -> ()
    let shouldConfirm: Bool
    let message: String?
    let buttonTitle: String?
    
    public init(
        shouldConfirm: Bool = false,
        message: String? = nil,
        buttonTitle: String? = nil,
        handler: @escaping () -> ()
    ) {
        self.handler = handler
        self.shouldConfirm = shouldConfirm
        self.message = message
        self.buttonTitle = buttonTitle
    }
}

//MARK: - 2️⃣ FormDualSaveLayer
/// This has two actions, primary and secondary
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
            Button(saveAction.buttonTitle ?? "Save", role: .destructive) {
                saveAction.handler()
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(saveAction.message ?? "Are you sure?")
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
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        showingSaveConfirmation = true
                    }
                } else {
                    showingSaveConfirmation = true
                }
            } else {
                saveAction.handler()
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
            Button(saveSecondaryAction.buttonTitle ?? "Save", role: .destructive) {
                saveSecondaryAction.handler()
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(saveSecondaryAction.message ?? "Are you sure?")
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
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        showingSaveSecondaryConfirmation = true
                    }
                } else {
                    showingSaveSecondaryConfirmation = true
                }
            } else {
                saveSecondaryAction.handler()
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
            Button(cancelAction.buttonTitle ?? "Close without saving", role: .destructive) {
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(cancelAction.message ?? "Are you sure?")
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
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        showingCancelConfirmation = true
                    }
                } else {
                    showingCancelConfirmation = true
                }
            } else {
                cancelAction.handler()
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
            Button(action.buttonTitle ?? "Delete", role: .destructive) {
                action.handler()
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(action.message ?? "Are you sure?")
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
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        showingDeleteConfirmation = true
                    }
                } else {
                    showingDeleteConfirmation = true
                }
            } else {
                action.handler()
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

//MARK: - 1️⃣ FormSaveLayer

public struct FormSaveLayer: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var collapsedBinding: Bool
    @Binding var saveIsDisabledBinding: Bool
    @Binding var info: FormSaveInfo?

    @State var collapsed: Bool
    @State var saveIsDisabled: Bool
    
    let cancelAction: FormConfirmableAction
    let saveAction: FormConfirmableAction
    let deleteAction: FormConfirmableAction?
    @State var showingDeleteConfirmation = false
    @State var showingCancelConfirmation = false
    @State var showingSaveConfirmation = false
    
    let preconfirmationAction: (() -> ())?
    
    public init(
        collapsed: Binding<Bool>,
        saveIsDisabled: Binding<Bool>,
        info: Binding<FormSaveInfo?> = .constant(nil),
        preconfirmationAction: (() -> ())? = nil,
        cancelAction: FormConfirmableAction,
        saveAction: FormConfirmableAction,
        deleteAction: FormConfirmableAction? = nil
    ) {
        self.preconfirmationAction = preconfirmationAction
        
        _collapsedBinding = collapsed
        _saveIsDisabledBinding = saveIsDisabled
        _collapsed = State(initialValue: collapsed.wrappedValue)
        _saveIsDisabled = State(initialValue: saveIsDisabled.wrappedValue)
        
        _info = info

        self.cancelAction = cancelAction
        self.saveAction = saveAction
        self.deleteAction = deleteAction
    }
    
    public var body: some View {
        VStack {
            Spacer()
            buttonsLayer
        }
        .onChange(of: collapsedBinding, perform: collapsedChanged)
        .onChange(of: saveIsDisabledBinding, perform: saveIsDisabledChanged)
    }
    
    func collapsedChanged(_ newValue: Bool) {
        withAnimation(.interactiveSpring()) {
            self.collapsed = newValue
        }
    }
    
    func saveIsDisabledChanged(_ newValue: Bool) {
        withAnimation(.interactiveSpring()) {
            self.saveIsDisabled = newValue
        }
    }
    
    var horizontalPadding: CGFloat {
        20
//        30
    }
    
    var buttonHeight: CGFloat {
        collapsed ? 38 : 52
    }
    
    var buttonCornerRadius: CGFloat {
        collapsed ? 19 : 10
    }
    
    var height: CGFloat {
        collapsed ? 70 : 80
    }
    
    var shadowSize: CGFloat {
        //        3
        2
    }

    var buttonsLayer: some View {
        @ViewBuilder
        var background: some View {
            if !collapsed {
                Color.clear
                    .background(.thinMaterial)
            }
        }
        
        @ViewBuilder
        var divider: some View {
            if !collapsed {
                Divider()
            }
        }
        
        var buttons: some View {
            ZStack(alignment: .topLeading) {
                dismissButtonLayer
                infoButtonLayer
                saveButton
                deleteButtonLayer
            }
            .frame(height: height)
//            .background(.green)
        }
        
        return VStack(spacing: 0) {
            divider
            buttons
        }
        .background(background)
    }
    
    //MARK: Save
    
    var saveButton: some View {
        var confirmationActions: some View {
            Button(saveAction.buttonTitle ?? "Save", role: .destructive) {
                saveAction.handler()
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(saveAction.message ?? "Are you sure?")
        }

        var buttonWidth: CGFloat {
            collapsed ? 100 : UIScreen.main.bounds.width - (horizontalPadding * 2.0)
        }
        
        var xPosition: CGFloat {
            collapsed
            ? (100.0 / 2.0) + horizontalPadding + 38.0 + 10.0
            : UIScreen.main.bounds.width / 2.0
        }
        
        var yPosition: CGFloat {
            collapsed
            ? (38.0 / 2.0) + 16.0
            : (52.0/2.0) + 16.0
        }
        
        var shadowOpacity: CGFloat {
            collapsed ? 0.2 : 0
        }
        
        return Button {
            if saveAction.shouldConfirm {
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        showingSaveConfirmation = true
                    }
                } else {
                    showingSaveConfirmation = true
                }
            } else {
                saveAction.handler()
            }
        } label: {
            Text("Save")
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
    
    //MARK: Dismiss

    var dismissButton: some View {
        var confirmationActions: some View {
            Button(cancelAction.buttonTitle ?? "Close without saving", role: .destructive) {
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(cancelAction.message ?? "Are you sure?")
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
//                    .opacity(collapsed ? 1 : 0)
                    .opacity(1)
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
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        showingCancelConfirmation = true
                    }
                } else {
                    showingCancelConfirmation = true
                }
            } else {
                cancelAction.handler()
            }
        } label: {
            label
        }
    }
    
    @ViewBuilder
    var dismissButtonLayer: some View {
        HStack {
            dismissButton
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, horizontalPadding)
        .offset(y: collapsed ? (38/2.0) - 3 : -38 - 10)
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
    
    var infoButtonLayer: some View {
        var xPosition: CGFloat {
            horizontalPadding + 38.0 + 10.0
        }

        var maxWidth: CGFloat {
            UIScreen.main.bounds.width - xPosition - deleteButtonWidth - horizontalPadding
        }

        return HStack {
//            dismissButton
            if let info, !collapsed {
                infoButton(info)
                    .transition(.scale.combined(with: .move(edge: .bottom)).combined(with: .opacity))
            }
            Spacer()
        }
        .frame(maxWidth: maxWidth)
        .padding(.leading, xPosition)
        .offset(y: -38 - 10)
    }
    
    //MARK: Delete
    
    var deleteButtonWidth: CGFloat {
        105
    }
    
    func deleteButton(_ action: FormConfirmableAction) -> some View {
        var confirmationActions: some View {
            Button(action.buttonTitle ?? "Delete", role: .destructive) {
                action.handler()
                cancelAction.handler()
            }
        }

        var confirmationMessage: some View {
            Text(action.message ?? "Are you sure?")
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
            .frame(width: deleteButtonWidth, height: 38)
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
                if let preconfirmationAction {
                    preconfirmationAction()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        showingDeleteConfirmation = true
                    }
                } else {
                    showingDeleteConfirmation = true
                }
            } else {
                action.handler()
            }
        } label: {
            label
        }
    }
    
    @ViewBuilder
    var deleteButtonLayer: some View {
        if let deleteAction {
            HStack {
                Spacer()
                deleteButton(deleteAction)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, horizontalPadding)
            .offset(y: collapsed ? (38/2.0) - 3 : -38 - 10)
        }
    }
}


//MARK: - 👁‍🗨 Preview

struct FormSaveLayerPreview: View {

    @Environment(\.dismiss) var dismiss
    @State var collapsed: Bool = false
    @State var saveIsDisabled: Bool = true

    var infoBinding: Binding<FormSaveInfo?> {
        Binding<FormSaveInfo?>(
            get: {
                guard saveIsDisabled else {
                    return nil
                }
                return FormSaveInfo(
                    title: "No Quantity",
                    systemImage: "questionmark"
                )
            },
            set: { _ in }
        )
    }
    
    var cancelAction: FormConfirmableAction {
        FormConfirmableAction(
            shouldConfirm: true,
            message: "Are you sure you wanna cancel?",
            handler: {
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
                feedbackGenerator.impactOccurred()
                dismiss()
            }
        )
    }
    
    var saveAction: FormConfirmableAction {
        FormConfirmableAction(
            shouldConfirm: true,
            message: "Are you sure you wanna save?",
            handler: {
            }
        )
    }
    
    var deleteAction: FormConfirmableAction {
        FormConfirmableAction(
            shouldConfirm: true,
            message: "Are you sure you wanna delete?",
            handler: {
            }
        )
    }
    
    var body: some View {
        ZStack {
            VStack {
                Toggle(isOn: $collapsed) {
                    Text("Collapsed")
                }
                .toggleStyle(.button)
                Toggle(isOn: $saveIsDisabled) {
                    Text("Disable Save")
                }
                .toggleStyle(.button)
            }
            FormSaveLayer(
                collapsed: $collapsed,
                saveIsDisabled: $saveIsDisabled,
                info: infoBinding,
                cancelAction: cancelAction,
                saveAction: saveAction,
                deleteAction: deleteAction
            )
        }
    }
}

struct FormDualSaveLayerPreview: View {
    
    @Environment(\.dismiss) var dismiss

    @State var saveIsDisabled: Bool = false
    @State var saveSecondaryIsDisabled: Bool = false
    
    enum IncompleteState: CaseIterable {
        case none
        case multiple
        case forPrivate
        case forPublic
        case edit
        case editPublic

        var saveIsDisabled: Bool {
            switch self {
            case .none:         return false
            case .multiple:     return true
            case .forPrivate:   return true
            case .forPublic:    return true
            case .edit:         return false
            case .editPublic:   return false
            }
        }

        var saveSecondaryIsDisabled: Bool {
            switch self {
            case .none:         return false
            case .multiple:     return true
            case .forPrivate:   return true
            case .forPublic:    return false
            case .edit:            return false
            case .editPublic:   return false
            }
        }

        var description: String {
            switch self {
            case .none:         return "None"
            case .multiple:     return "Multiple"
            case .forPrivate:   return "Public"
            case .forPublic:    return "Private"
            case .edit:         return "Edit Private"
            case .editPublic:   return "Edit Public"
            }
        }
        
        var infoTitle: String? {
            switch self {
            case .none:         return nil
            case .multiple:     return "Missing Fields"
            case .forPrivate:   return "Missing Carb"
            case .forPublic:    return "No Source"
            case .edit:         return nil
            case .editPublic:   return nil
            }
        }

        var infoSystemImage: String? {
            switch self {
            case .none:         return nil
            case .multiple:     return nil
            case .forPrivate:   return "exclamationmark.triangle.fill"
            case .forPublic:    return "info.circle.fill"
            case .edit:         return nil
            case .editPublic:   return nil
            }
        }

        var infoBadge: Int? {
            switch self {
            case .none:         return nil
            case .multiple:     return 3
            case .forPrivate:   return nil
            case .forPublic:    return nil
            case .edit:         return nil
            case .editPublic:   return nil
            }
        }
        
        var tappedDelete: FormConfirmableAction? {
            switch self {
            case .edit, .editPublic:
                return FormConfirmableAction(
                    shouldConfirm: true,
                    message: "Are you sure you wanna delete?",
                    handler: {
                    }
                )
            default:
                return nil
            }
        }
        
        var saveTitle: String {
            var Conjunction: String {
                "to"
//                "for"
            }
            
            var Verb: String {
                switch self {
                case .editPublic:
                    return "Resubmit"
                default:
                    return "Submit"
                }
            }
            
            var Object: String {
//                "Public Database"
//                "Prep Database"
                "Public Foods"
//                "Prep Foods"
//                "Verification"
            }
            
            return "\(Verb) \(Conjunction) \(Object)"
//            switch self {
//            case .edit:
//                return "Submit for Verification"
//            case .editPublic:
//                return "Resubmit for Verification"
//            default:
//                return "Submit for Verification"
//            }
        }

        var saveSecondaryTitle: String {
            var Conjunction: String {
                switch self {
                case .edit:
                    return ""
                case .editPublic:
    //                return "in"
                    return "as "
                default:
    //                return "to"
                    return "as "
                }
            }
            
            var Verb: String {
                switch self {
                case .edit, .editPublic:
                    return "Save"
                default:
                    return "Add"
                }
            }
            
            var Object: String {
    //            "Private Database"
    //            "My Foods"
    //            "Private Foods"
                "Private Food"
            }
            
            return "\(Verb) \(Conjunction)\(Object)"
        }
    }
    
    @State var state: IncompleteState = .none
    
    var infoBinding: Binding<FormSaveInfo?> {
        Binding<FormSaveInfo?>(
            get: {
                guard let title = state.infoTitle else {
                    return nil
                }

                if let badge = state.infoBadge {
                    return FormSaveInfo(
                        title: title,
                        badge: badge
                    )
                } else if let systemImage = state.infoSystemImage {
                    return FormSaveInfo(
                        title: title,
                        systemImage: systemImage
                    )
                } else {
                    return FormSaveInfo(title: title)
                }
            },
            set: { _ in }
        )
    }

    var cancelAction: FormConfirmableAction {
        FormConfirmableAction(
            shouldConfirm: true,
            message: "Are you sure you wanna cancel?",
            handler: {
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
                feedbackGenerator.impactOccurred()
                dismiss()
            }
        )
    }
    
    var saveAction: FormConfirmableAction {
        FormConfirmableAction(
            shouldConfirm: true,
            message: "Are you sure you wanna save?",
            handler: {
            }
        )
    }
    
    var body: some View {
        ZStack {
            VStack {
                Picker("", selection: $state) {
                    ForEach(IncompleteState.allCases, id: \.self) {
                        Text($0.description).tag($0)
                    }
                }
                .pickerStyle(.wheel)
                .padding(.horizontal)
            }
            
            FormDualSaveLayer(
                saveIsDisabled: Binding<Bool>(get: { state.saveIsDisabled }, set: { _ in }),
                saveSecondaryIsDisabled: Binding<Bool>(get: { state.saveSecondaryIsDisabled }, set: { _ in }),
                saveTitle: state.saveTitle,
                saveSecondaryTitle: state.saveSecondaryTitle,
                info: infoBinding,
                cancelAction: cancelAction,
                saveAction: saveAction,
                saveSecondaryAction: saveAction,
                deleteAction: state.tappedDelete
            )
        }
    }
}

struct MainView: View {
    @State var showingSingle = false
    @State var showingDual = false

    var body: some View {
        VStack {
            Spacer()
            Button("Single") {
                showingSingle = true
            }
            Spacer().frame(height: 50)
            Button("Dual") {
                showingDual = true
            }
            Spacer()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
//            .green
            Color.teal
        )
        .fullScreenCover(isPresented: $showingSingle) { FormSaveLayerPreview() }
        .fullScreenCover(isPresented: $showingDual) { FormDualSaveLayerPreview() }
    }
}

struct FormSaveLayer_Previews: PreviewProvider {
    static var previews: some View {
        FormSaveLayerPreview()
    }
}

struct FormDualSaveLayer_Previews: PreviewProvider {
    static var previews: some View {
        FormDualSaveLayerPreview()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
