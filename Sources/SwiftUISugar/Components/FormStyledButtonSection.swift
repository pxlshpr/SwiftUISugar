import SwiftUI

public struct FormStyledButtonSection<Header: View, Footer: View, Content: View>: View {
    var header: Header?
    var footer: Footer?
    var content: () -> Content
    
    public init(header: Header, footer: Footer, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.footer = footer
        self.content = content
    }
    
    public var body: some View {
        FormStyledSection(
            header: header,
            footer: footer,
            horizontalPadding: 0,
            verticalPadding: 0,
            content: content
        )
    }
}

/// Support optional header
extension FormStyledButtonSection where Header == EmptyView {
    public init(
        footer: Footer,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = nil
        self.footer = footer
        self.content = content
    }
}

/// Support optional footer
extension FormStyledButtonSection where Footer == EmptyView {
    public init(
        header: Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.footer = nil
        self.content = content
    }
}


/// Support optional header and footer
extension FormStyledButtonSection where Header == EmptyView, Footer == EmptyView {
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = nil
        self.footer = nil
        self.content = content
    }
}
