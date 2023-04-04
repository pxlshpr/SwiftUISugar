import SwiftUI
import SwiftHaptics

public struct BooleanPicker: View {

    let ButtonPadding: CGFloat = 40.0
    
    @StateObject var model: Model
    @Environment(\.colorScheme) var colorScheme
    @State var dragTranslationX: CGFloat?
    @Binding var selectionBinding: Bool
    
    public init(trueString: String, falseString: String, selectionBinding: Binding<Bool>) {
        let model = Model(
            trueString: trueString,
            falseString: falseString,
            selectedIndex: selectionBinding.wrappedValue ? 1 : 2
        )
        _model = StateObject(wrappedValue: model)
        _selectionBinding = selectionBinding
    }
    
    func selectColumn(_ index: Int) {
        selectionBinding = index == 1 ? true : false
        model.selectColumn(index)
    }
    
    class Model: ObservableObject {

        /// We're not using `@Published` for the index itself because otherwise we get a jerky
        /// jump of the button during a manual swipe of it. Instead, we use a separate `@Published` refresh toggle
        /// that we toggle along with index changes to show the change.
        var index: Int
        @Published var refresh = false

        let trueString: String
        let falseString: String
        
        init(trueString: String, falseString: String, selectedIndex: Int) {
            self.index = selectedIndex
            self.trueString = trueString
            self.falseString = falseString
        }
        
        func selectColumn(_ index: Int) {
            withAnimation {
                self.index = index
                refresh.toggle()
            }
        }
    }
}


extension BooleanPicker {
    public var body: some View {
        ZStack {
            background
            button
            texts
        }
        .frame(height: 50)
        .highPriorityGesture(dragGesture)
        .padding(.horizontal, ButtonPadding)
    }
    
    var r: CGFloat { 3 }
    
    var innerTopLeftShadowColor: Color {
        colorScheme == .light
        ? Color(red: 197/255, green: 197/255, blue: 197/255)
        : Color(hex: "232323")
    }
    
    var innerBottomRightShadowColor: Color {
        colorScheme == .light
        ? Color.white
        : Color(hex: "3D3E44")
    }
    
    var backgroundColor: Color {
        colorScheme == .light
        ? Color(red: 236/255, green: 234/255, blue: 235/255)
        : Color(hex: "303136")
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(
                .shadow(.inner(color: innerTopLeftShadowColor,radius: r, x: r, y: r))
                .shadow(.inner(color: innerBottomRightShadowColor, radius: r, x: -r, y: -r))
            )
            .foregroundColor(backgroundColor)
    }
    
    var selectedColumn: Int {
        //        model.extractedColumns.selectedColumnIndex
        model.index
    }
    
    var leftButton: some View {
        Button {
            Haptics.feedback(style: .soft)
            withAnimation(.interactiveSpring()) {
                selectColumn(1)
            }
        } label: {
            Text(model.trueString)
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundColor(selectedColumn == 1 ? .white : .secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
    }
    
    var rightButton: some View {
        Button {
            Haptics.feedback(style: .soft)
            withAnimation(.interactiveSpring()) {
                selectColumn(2)
            }
        } label: {
            Text(model.falseString)
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundColor(selectedColumn == 2 ? .white : .secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
    }
    
    func dragChanged(_ value: DragGesture.Value) {
        var translation = value.translation.width
        if selectedColumn == 1 {
            translation = max(0, translation)
            translation = min(translation, buttonWidth)
        } else {
            translation = max(-buttonWidth, translation)
            translation = min(0, translation)
        }
        self.dragTranslationX = translation
    }
    
    var buttonIsOnRight: Bool {
        buttonXPosition > buttonWidth
    }
    func dragEnded(_ value: DragGesture.Value) {
        var transitionAnimation: Animation {
            .interactiveSpring()
        }
        
        var cancelAnimation: Animation {
            .interactiveSpring()
        }
        let predictedTranslationX = value.predictedEndTranslation.width
        let predictedButtonX = (buttonWidth / 2.0) + (selectedColumn == 2 ? buttonWidth : 0) + predictedTranslationX
        let predictedButtonIsOnRight = predictedButtonX > buttonWidth
        
        if predictedButtonIsOnRight {
            if selectedColumn == 1 {
                Haptics.feedback(style: .soft)
                /// setting `dragTranslation` as `buttonWidth` with animation before resetting to `nil`
                withAnimation(transitionAnimation) {
                    dragTranslationX = buttonWidth
                }
                dragTranslationX = nil
                selectColumn(2)
            } else {
                withAnimation(cancelAnimation) {
                    dragTranslationX = nil
                }
            }
        } else {
            if selectedColumn == 2 {
                Haptics.feedback(style: .soft)
                /// setting `dragTranslation` as `-buttonWidth` with animation before resetting to `nil`
                withAnimation(transitionAnimation) {
                    dragTranslationX = -buttonWidth
                }
                dragTranslationX = nil
                selectColumn(1)
            } else {
                withAnimation(cancelAnimation) {
                    dragTranslationX = nil
                }
            }
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged(dragChanged)
            .onEnded(dragEnded)
    }
    
    var button: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(Color.accentColor.gradient)
            .shadow(color: innerTopLeftShadowColor, radius: 2, x: 0, y: 2)
            .padding(3)
            .frame(width: buttonWidth)
            .position(x: buttonXPosition, y: 25)
            .animation(
                .interactiveSpring(),
                value: model.index
            )
    }
    
    var texts: some View {
        HStack(spacing: 0) {
            VStack {
                leftButton
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            VStack {
                rightButton
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    var buttonWidth: CGFloat {
        (UIScreen.main.bounds.width - (ButtonPadding * 2.0)) / 2.0
    }
    
    var buttonXPosition: CGFloat {
        var x = (buttonWidth / 2.0) + (selectedColumn == 2 ? buttonWidth : 0)
        if let dragTranslationX {
            x += dragTranslationX
        }
        x = max(x, (buttonWidth / 2.0))
        x = min(x, (buttonWidth / 2.0) + buttonWidth)
        return x
    }
}

extension BooleanPicker {
    
    /// Unused button with same styling as picker
    var bigButton: some View {
        Button {
            /// Tap Handler goes here
        } label: {
            Text("Button")
                .font(.system(size: 22, weight: .semibold, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(Color.accentColor.gradient)
                        .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
                )
                .contentShape(Rectangle())
        }
    }
}

