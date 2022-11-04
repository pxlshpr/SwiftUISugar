import SwiftUI

public extension View {
    func bottomMenu(isPresented: Binding<Bool>, menu: BottomMenu) -> some View {
        self.modifier(BottomMenuModifier(isPresented: isPresented, menu: menu))
    }
    
//    func bottomMenu(item: Binding<Identifiable?>, menu: BottomMenu) -> some View {
//        self.modifier(BottomMenuModifier(isPresented: isPresented, menu: menu))
//    }

}

