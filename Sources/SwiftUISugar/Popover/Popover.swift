import SwiftUI

public struct Popover: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let style: Style
    let title: String
    let calloutString: String
    let primaryString: String
    
    let actions: [Action]
    
    public init(
        style: Style = .info,
        title: String,
        calloutString: String,
        primaryString: String,
        actions: [Action] = []
    ) {
        self.style = style
        self.title = title
        self.calloutString = calloutString
        self.primaryString = primaryString
        self.actions = actions
    }
    
    public var body: some View {
        VStack {
            texts
            buttons
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(width: 232)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    var texts: some View {
        
        var callout: some View {
            
            var icon: some View {
                Image(systemName: style.systemImage)
                    .imageScale(.large)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        style.iconForegroundColor(colorScheme),
                        style.iconBackgroundColor
                    )
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            
            return VStack(spacing: 3) {
                HStack {
                    icon
                    Text(title)
                        .font(.headline)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(calloutString)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 10)
            .padding(.top, 7)
            .padding(.bottom, 12)
            .background(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color(.tertiarySystemFill))
            )
        }
        
        var secondaryText: some View {
            Text(primaryString)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnote)
                .foregroundColor(Color(.secondaryLabel))
        }
        
        return VStack(spacing: 10) {
            callout
            secondaryText
        }
        .foregroundColor(.secondary)
        .font(.callout)
    }
    
    var buttons: some View {
        
        func button(_ action: Action) -> some View {
            Button {
                action.action()
            } label: {
                Text(action.title)
                    .foregroundColor(action.style.foregroundColor)
                    .bold(action.style.bold)
                    .padding(.vertical, 7)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(action.style.backgroundColor)
                    )
            }
        }
        
        return Group {
            if actions.count > 2 {
                VStack {
                    ForEach(actions, id: \.self.title) {
                        button($0)
                    }
                }
            } else {
                HStack {
                    ForEach(actions, id: \.self.title) {
                        button($0)
                    }
                }
            }
        }
    }
}

extension Popover {
    
    public struct Action {
        let title: String
        let style: Style
        let action: () -> ()

        public init(title: String, style: Style, action: @escaping () -> Void) {
            self.title = title
            self.style = style
            self.action = action
        }
        
        public enum Style {
            case destructive(isPrimary: Bool)
            case cancel(isPrimary: Bool)
            
            var foregroundColor: Color {
                switch self {
                case .cancel:
                    return .secondary
                case .destructive:
                    return .red
                }
            }
            
            var backgroundColor: Color {
                switch self {
                case .cancel:
                    return Color(.quaternarySystemFill).opacity(0.7)
                case .destructive:
                    if isPrimary {
                        return Color.red.opacity(0.1)
                    } else {
                        return Color.clear
                    }
                }
            }

            var bold: Bool {
                isPrimary
            }
            
            var isPrimary: Bool {
                switch self {
                case .cancel(let isPrimary):
                    return isPrimary
                case .destructive(let isPrimary):
                    return isPrimary
                }
            }
        }
    }
}

extension Popover {
    
    public enum Style {
        case info
        case warning
        
        var systemImage: String {
            switch self {
            case .info:
                return "info.circle.fill"
            case .warning:
                return "exclamationmark.triangle.fill"
            }
        }
        
        var iconBackgroundColor: Color {
            switch self {
            case .info:
                return .blue
            case .warning:
                return .yellow
            }
        }
        
        func iconForegroundColor(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
            ? .black
            : .white
        }
    }
}
