import SwiftUI

//MARK: - 2️⃣ FormDualSaveLayer
/// This has two actions, primary and secondary
public struct FormDualSaveLayer: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var saveIsDisabledBinding: Bool
    @State var saveIsDisabled: Bool
    @Binding var saveSecondaryIsDisabledBinding: Bool
    @State var saveSecondaryIsDisabled: Bool

    let saveTitle: String
    let saveSecondaryTitle: String

    let infoTitle: String?
    let infoBadge: Int?
    let infoSystemImage: String?

    let tappedCancel: () -> ()
    let tappedSave: () -> ()
    let tappedSaveSecondary: () -> ()
    let tappedDelete: (() -> ())?
    
    public init(
        saveIsDisabled: Binding<Bool>,
        saveSecondaryIsDisabled: Binding<Bool>,
        saveTitle: String,
        saveSecondaryTitle: String,
        infoTitle: String? = nil,
        infoBadge: Int? = nil,
        infoSystemImage: String? = nil,
        tappedCancel: @escaping () -> (),
        tappedSave: @escaping () -> (),
        tappedSaveSecondary: @escaping () -> (),
        tappedDelete: (() -> ())? = nil
    ) {
        _saveIsDisabledBinding = saveIsDisabled
        _saveIsDisabled = State(initialValue: saveIsDisabled.wrappedValue)

        _saveSecondaryIsDisabledBinding = saveSecondaryIsDisabled
        _saveSecondaryIsDisabled = State(initialValue: saveSecondaryIsDisabled.wrappedValue)

        self.saveTitle = saveTitle
        self.saveSecondaryTitle = saveSecondaryTitle
        
        self.infoTitle = infoTitle
        self.infoBadge = infoBadge
        self.infoSystemImage = infoSystemImage
        
        self.tappedSave = tappedSave
        self.tappedSaveSecondary = tappedSaveSecondary
        
        self.tappedCancel = tappedCancel
        self.tappedDelete = tappedDelete
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
    func infoButton(_ infoTitle: String) -> some View {
        var xPosition: CGFloat {
            UIScreen.main.bounds.width / 2.0
        }
        
        var yPosition: CGFloat {
            (52.0/2.0) + 16.0 + 52 + 8
        }
        
        var label: some View {
            HStack {
                if let infoSystemImage {
                    Image(systemName: infoSystemImage)
                        .symbolRenderingMode(.multicolor)
                        .imageScale(.medium)
                        .fontWeight(.medium)
                }
                if let infoBadge {
                    Text("\(infoBadge)")
                        .foregroundColor(Color(.secondaryLabel))
                        .font(.system(size: 14, weight: .bold, design: .rounded))
//                        .padding(7)
                        .frame(width: 25, height: 25)
                        .background(
                            Circle()
                                .foregroundColor(Color(.secondarySystemFill))
                        )
                }
                Text(infoTitle)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 3)
            }
            .padding(.horizontal, 12)
            .frame(height: 38)
            .background(
                RoundedRectangle(cornerRadius: 19)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: shadowSize, x: 0, y: shadowSize)
            )
        }
        
        return Button {
//            action()
        } label: {
            label
        }
    }
    
    //MARK: Save
    var saveButton: some View {
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
            tappedSave()
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
    }
    
    //MARK: Save (Secondary)
    
    var saveSecondaryButton: some View {
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
            tappedSaveSecondary()
        } label: {
            label
        }
        .disabled(saveSecondaryIsDisabled)
        .opacity(saveSecondaryIsDisabled ? (colorScheme == .light ? 0.2 : 0.2) : 1)
        .position(x: xPosition, y: yPosition)
    }
    
    //MARK: Dismiss

    var dismissButton: some View {
        var image: some View {
            Image(systemName: "chevron.down")
                .imageScale(.medium)
                .fontWeight(.medium)
                .foregroundColor(Color(.secondaryLabel))
        }
        
        var text: some View {
            Text("Cancel")
                .foregroundColor(.secondary)
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
        }
        
        return Button {
            tappedCancel()
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
    func deleteButton(_ action: @escaping () -> ()) -> some View {
        var xPosition: CGFloat {
            UIScreen.main.bounds.width / 2.0
        }
        
        var yPosition: CGFloat {
            (52.0/2.0) + 16.0 + 52 + 8
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
        }
        
        return Button {
            action()
        } label: {
            label
        }
    }
    
    @ViewBuilder
    var topButtonsLayer: some View {
        HStack {
            dismissButton
            if let infoTitle {
                infoButton(infoTitle)
            }
            Spacer()
            if let tappedDelete {
                deleteButton(tappedDelete)
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
    @State var collapsed: Bool
    @Binding var saveIsDisabledBinding: Bool
    @State var saveIsDisabled: Bool
    
    let infoTitle: String?
    let infoBadge: Int?
    let infoSystemImage: String?

    let tappedCancel: () -> ()
    let tappedSave: () -> ()
    let tappedDelete: (() -> ())?
    
    public init(
        collapsed: Binding<Bool>,
        saveIsDisabled: Binding<Bool>,
        infoTitle: String? = nil,
        infoBadge: Int? = nil,
        infoSystemImage: String? = nil,
        tappedCancel: @escaping () -> (),
        tappedSave: @escaping () -> (),
        tappedDelete: (() -> ())? = nil
    ) {
        _collapsedBinding = collapsed
        _saveIsDisabledBinding = saveIsDisabled
        _collapsed = State(initialValue: collapsed.wrappedValue)
        _saveIsDisabled = State(initialValue: saveIsDisabled.wrappedValue)
        
        self.infoTitle = infoTitle
        self.infoBadge = infoBadge
        self.infoSystemImage = infoSystemImage

        self.tappedSave = tappedSave
        self.tappedCancel = tappedCancel
        self.tappedDelete = tappedDelete
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
            tappedSave()
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
    }
    
    //MARK: Dismiss

    var dismissButton: some View {
        var image: some View {
            Image(systemName: "chevron.down")
                .imageScale(.medium)
                .fontWeight(.medium)
                .foregroundColor(Color(.secondaryLabel))
        }
        
        var text: some View {
            Text("Cancel")
                .foregroundColor(.secondary)
        }
        
        var buttonWidth: CGFloat {
//            collapsed ? 38 : UIScreen.main.bounds.width - 60
            38
        }
        
        var xPosition: CGFloat {
//            collapsed
//            ? (38.0 / 2.0) + 20.0
//            : UIScreen.main.bounds.width / 2.0
            (38.0 / 2.0) + 20.0
        }
        
        var yPosition: CGFloat {
//            collapsed
//            ? (38.0 / 2.0) + 16.0
//            : (52.0/2.0) + 16.0 + 52 + 8
            (38.0 / 2.0) + 16.0
//            -(52.0/2.0) + 16.0 + 52 + 8
        }
        
        var label: some View {
            HStack {
//                if collapsed {
                    image
//                }
//                if !collapsed {
//                    text
//                }
            }
            .frame(width: buttonWidth, height: 38)
            .background(
                RoundedRectangle(cornerRadius: 19)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: shadowSize, x: 0, y: shadowSize)
//                    .opacity(collapsed ? 1 : 0)
                    .opacity(1)
            )
        }
        
        return Button {
            tappedCancel()
        } label: {
            label
        }
//        .position(x: xPosition, y: yPosition)
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
    func infoButton(_ infoTitle: String) -> some View {
        var xPosition: CGFloat {
            UIScreen.main.bounds.width / 2.0
        }
        
        var yPosition: CGFloat {
            (52.0/2.0) + 16.0 + 52 + 8
        }
        
        var label: some View {
            HStack {
                if let infoSystemImage {
                    Image(systemName: infoSystemImage)
                        .symbolRenderingMode(.multicolor)
                        .imageScale(.medium)
                        .fontWeight(.medium)
                }
                if let infoBadge {
                    Text("\(infoBadge)")
                        .foregroundColor(Color(.secondaryLabel))
                        .font(.system(size: 14, weight: .bold, design: .rounded))
//                        .padding(7)
                        .frame(width: 25, height: 25)
                        .background(
                            Circle()
                                .foregroundColor(Color(.secondarySystemFill))
                        )
                }
                Text(infoTitle)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 3)
            }
            .padding(.horizontal, 12)
            .frame(height: 38)
            .background(
                RoundedRectangle(cornerRadius: 19)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: shadowSize, x: 0, y: shadowSize)
            )
        }
        
        return Button {
//            action()
        } label: {
            label
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
            if let infoTitle, !collapsed {
                infoButton(infoTitle)
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
    
    func deleteButton(_ action: @escaping () -> ()) -> some View {
//        var xPosition: CGFloat {
//            collapsed
//            ? (38.0 / 2.0) + 20.0
//            : UIScreen.main.bounds.width / 2.0
//        }
//
//        var yPosition: CGFloat {
//            collapsed
//            ? (38.0 / 2.0) + 16.0
//            : (52.0/2.0) + 16.0 + 52 + 8
//        }
        
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
        }
        
        return Button {
            action()
        } label: {
            label
        }
    }
    
    @ViewBuilder
    var deleteButtonLayer: some View {
        if let tappedDelete {
            HStack {
                Spacer()
                deleteButton(tappedDelete)
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
    @State var saveIsDisabled: Bool = false

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
                infoTitle: saveIsDisabled ? "Quantity Required" : nil,
                infoBadge: nil,
                infoSystemImage: saveIsDisabled ? "exclamationmark.triangle.fill" : nil
            ) {
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
                feedbackGenerator.impactOccurred()
                dismiss()
            } tappedSave: {
                print("save")
            } tappedDelete: {
                print("delete")
            }
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
        
        var tappedDelete: (() -> ())? {
            switch self {
            case .edit, .editPublic:
                return { }
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
    
    var body: some View {
        ZStack {
            VStack {
//                Toggle(isOn: $saveIsDisabled) {
//                    Text("Disable Save")
//                }
//                .toggleStyle(.button)
//                Toggle(isOn: $saveSecondaryIsDisabled) {
//                    Text("Disable Save Secondary")
//                }
//                .toggleStyle(.button)
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
                infoTitle: state.infoTitle,
                infoBadge: state.infoBadge,
                infoSystemImage: state.infoSystemImage,
                tappedCancel: {
                    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
                    feedbackGenerator.impactOccurred()
                    dismiss()
                },
                tappedSave: {},
                tappedSaveSecondary: {},
                tappedDelete: state.tappedDelete
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
