import SwiftUI

public struct SVDatePicker<Style: DatePickerStyle>: View {
    private let title: String
    @Binding private var selection: Date
    private let displayedComponents: DatePickerComponents
    private let style: Style

    public init(
        _ title: String,
        selection: Binding<Date>,
        displayedComponents: DatePickerComponents = .date,
        style: Style = .automatic
    ) {
        self.title = title
        self._selection = selection
        self.displayedComponents = displayedComponents
        self.style = style
    }

    public var body: some View {
        DatePicker(
            title,
            selection: $selection,
            displayedComponents: displayedComponents,
        )
        .datePickerStyle(style)
    }
}
