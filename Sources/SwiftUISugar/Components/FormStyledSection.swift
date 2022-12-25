#if canImport(UIKit)
import SwiftUI

let DefaultHorizontalPadding: CGFloat = 17
let DefaultVerticalPadding: CGFloat = 15

public struct FormStyledSection<Header: View, Footer: View, Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var header: Header?
    var footer: Footer?
    var content: () -> Content
    var verticalPadding: CGFloat?
    var horizontalPadding: CGFloat?

    public init(
        header: Header,
        footer: Footer,
        horizontalPadding: CGFloat? = nil,
        verticalPadding: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.footer = footer
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.content = content
    }

    public var body: some View {
        if let header {
            if let footer {
                withHeader(header, andFooter: footer)
            } else {
                withHeaderOnly(header)
            }
        } else {
            if let footer {
                withFooterOnly(footer)
            } else {
                withoutHeaderOrFooter
            }
        }
    }

    func withHeader(_ header: Header, andFooter footer: Footer) -> some View {
        VStack(spacing: 7) {
            headerView(for: header)
            contentView
            footerView(for: footer)
                .padding(.bottom, 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    func withFooterOnly(_ footer: Footer) -> some View {
        VStack(spacing: 7) {
            contentView
            footerView(for: footer)
                .padding(.bottom, 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    func withHeaderOnly(_ header: Header) -> some View {
        VStack(spacing: 7) {
            headerView(for: header)
            contentView
                .padding(.bottom, 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    var withoutHeaderOrFooter: some View {
        contentView
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
    
    //MARK: - Components
    
    func footerView(for footer: Footer) -> some View {
        footer
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(Color(.secondaryLabel))
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
    }
    
    func headerView(for header: Header) -> some View {
        header
            .foregroundColor(Color(.secondaryLabel))
            .font(.footnote)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
    }
    
//    var backgroundColor: Color {
//        Color(.secondarySystemGroupedBackground)
//        colorScheme == .light ? Color(.secondarySystemGroupedBackground) : Color(hex: "2C2C2E")
//    }
    
    var contentView: some View {
        content()
//            .background(.green)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, horizontalPadding ?? DefaultHorizontalPadding)
            .padding(.vertical, verticalPadding ?? DefaultVerticalPadding)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(formCellBackgroundColor(colorScheme: colorScheme))
//                    .foregroundStyle(FormCellBackgroundShapeStyle())
//                    .foregroundColor(backgroundColor)
            )
    }
}

/// Support optional header
extension FormStyledSection where Header == EmptyView {
    public init(
        footer: Footer,
        horizontalPadding: CGFloat? = nil,
        verticalPadding: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = nil
        self.footer = footer
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.content = content
    }
}

/// Support optional footer
extension FormStyledSection where Footer == EmptyView {
    public init(
        header: Header,
        horizontalPadding: CGFloat? = nil,
        verticalPadding: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.footer = nil
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.content = content
    }
}


/// Support optional header and footer
extension FormStyledSection where Header == EmptyView, Footer == EmptyView {
    public init(
        horizontalPadding: CGFloat? = nil,
        verticalPadding: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = nil
        self.footer = nil
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.content = content
    }
}

struct FormStyledSectionPreview: View {
    var footer: some View {
        Text("Provide a source if you want. Also this is now a very long footer lets see how this looks now shall we.")
    }
    
    
    var header: some View {
        Text("Header")
    }
    
    var body: some View {
        FormStyledScrollView {
            footerSection
            headerSection
            headerAndFooterSection
            noHeaderOrFooterSection
            headerSection
            footerSection
            noHeaderOrFooterSection
            headerAndFooterSection
        }
    }

    var headerSection: some View {
        FormStyledSection(header: header) {
            HStack {
                Text("Header only")
                Spacer()
            }
        }
    }

    var noHeaderOrFooterSection: some View {
        FormStyledSection {
            HStack {
                Text("No Header or Footer")
                Spacer()
            }
        }
    }
    var headerAndFooterSection: some View {
        FormStyledSection(header: header, footer: footer) {
            HStack {
                Text("Header and Footer")
                Spacer()
            }
        }
    }

    var footerSection: some View {
        FormStyledSection(footer: footer) {
            HStack {
                Text("Footer only")
                Spacer()
            }
        }
    }
}

struct FormStyledSection_Previews: PreviewProvider {
    static var previews: some View {
        FormStyledSectionPreview()
    }
}
#endif
