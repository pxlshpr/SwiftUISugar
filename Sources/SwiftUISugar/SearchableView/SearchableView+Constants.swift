import SwiftUI

let colorHexKeyboardLight = "CDD0D6"
let colorHexKeyboardDark = "303030"
let colorHexSearchTextFieldDark = "535355"
let colorHexSearchTextFieldLight = "FFFFFF"

public typealias SearchSubmitHandler = (() -> ())

struct SearchableViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
