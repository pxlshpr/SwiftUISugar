import SwiftUI

public struct FormStyledSection<Header: View, Content: View>: View {
    var header: Header?
    var content: () -> Content

    public init(header: Header, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.content = content
    }

    public var body: some View {
        if let header {
            withHeader(header)
        } else {
            withoutHeader
        }
    }

    func withHeader(_ header: Header) -> some View {
        VStack(spacing: 7) {
            header
                .foregroundColor(Color(.secondaryLabel))
                .font(.footnote)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            content()
                .padding(20)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)
                .padding(.bottom, 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    var withoutHeader: some View {
        content()
            .padding(20)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

/// Support optional header
extension FormStyledSection where Header == EmptyView {
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.header = nil
        self.content = content
    }
}
