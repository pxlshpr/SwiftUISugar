import SwiftUI

public struct FormSaveLayer: View {
    
    @Binding var collapsedBinding: Bool
    @State var collapsed: Bool
    @Binding var saveIsDisabledBinding: Bool
    @State var saveIsDisabled: Bool
    
    let tappedCancel: () -> ()
    let tappedSave: () -> ()
    let tappedDelete: (() -> ())?
    
    public init(
        collapsed: Binding<Bool>,
        saveIsDisabled: Binding<Bool>,
        tappedCancel: @escaping () -> (),
        tappedSave: @escaping () -> (),
        tappedDelete: (() -> ())? = nil
    ) {
        _collapsedBinding = collapsed
        _saveIsDisabledBinding = saveIsDisabled
        _collapsed = State(initialValue: collapsed.wrappedValue)
        _saveIsDisabled = State(initialValue: saveIsDisabled.wrappedValue)
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

    var buttonHeight: CGFloat {
        collapsed ? 38 : 52
    }
    
    var buttonCornerRadius: CGFloat {
        collapsed ? 19 : 10
    }
    
    var height: CGFloat {
        collapsed ? 70 : 128
    }

    var saveButton: some View {
        var buttonWidth: CGFloat {
            collapsed ? 100 : UIScreen.main.bounds.width - 60
        }
        
        var xPosition: CGFloat {
            collapsed
            ? (100.0 / 2.0) + 20.0 + 38.0 + 10.0
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
            .foregroundColor(.white)
            .frame(width: buttonWidth, height: buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: buttonCornerRadius)
                    .foregroundStyle(Color.accentColor.gradient)
//                    .foregroundColor(.accentColor)
                    .shadow(color: Color(.black).opacity(shadowOpacity), radius: 3, x: 0, y: 3)
            )
        }
        .buttonStyle(.borderless)
        .position(x: xPosition, y: yPosition)
        .disabled(saveIsDisabled)
        .opacity(saveIsDisabled ? 0.2 : 1)
    }
    
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
            collapsed ? 38 : UIScreen.main.bounds.width - 60
        }
        
        var xPosition: CGFloat {
            collapsed
            ? (38.0 / 2.0) + 20.0
            : UIScreen.main.bounds.width / 2.0
        }

        var yPosition: CGFloat {
            collapsed
            ? (38.0 / 2.0) + 16.0
            : (52.0/2.0) + 16.0 + 52 + 8
        }

        var label: some View {
            HStack {
                if collapsed {
                    image
                }
                if !collapsed {
                    text
                }
            }
            .frame(width: buttonWidth, height: buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: buttonCornerRadius)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
                    .opacity(collapsed ? 1 : 0)
            )
        }
        
        return Button {
            tappedCancel()
        } label: {
            label
        }
        .position(x: xPosition, y: yPosition)
    }
    
    func deleteButton(_ action: @escaping () -> ()) -> some View {
        var xPosition: CGFloat {
            collapsed
            ? (38.0 / 2.0) + 20.0
            : UIScreen.main.bounds.width / 2.0
        }

        var yPosition: CGFloat {
            collapsed
            ? (38.0 / 2.0) + 16.0
            : (52.0/2.0) + 16.0 + 52 + 8
        }

        var label: some View {
            HStack {
                Image(systemName: "trash")
                    .imageScale(.medium)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                Text("Delete")
                    .foregroundColor(.red)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 5)
            }
            .frame(width: 100, height: 38)
            .background(
                RoundedRectangle(cornerRadius: 19)
                    .foregroundStyle(.ultraThinMaterial)
                    .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
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
            .padding(.horizontal, 20)
            .offset(y: collapsed ? (38/2.0) - 3 : -38 - 10)
        }
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
                dismissButton
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
}


struct FormSaveLayerPreview: View {
    
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
                saveIsDisabled: $saveIsDisabled
            ) {
                print("cancel")
            } tappedSave: {
                print("save")
            } tappedDelete: {
                print("delete")
            }
        }
    }
}

struct FormSaveLayer_Previews: PreviewProvider {
    static var previews: some View {
        FormSaveLayerPreview()
    }
}
