import SwiftUI

public struct SVDatePicker: View {
    private let title: String
    @Binding private var selection: Date
    private let displayedComponents: DatePickerComponents

    public init(
        _ title: String,
        selection: Binding<Date>,
        displayedComponents: DatePickerComponents = .date
    ) {
        self.title = title
        self._selection = selection
        self.displayedComponents = displayedComponents
    }

    public var body: some View {
        DatePicker(
            title,
            selection: $selection,
            displayedComponents: displayedComponents
        )
    }
}
