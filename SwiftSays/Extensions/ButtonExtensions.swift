import SwiftUI

extension Button {
    init(action: @escaping () async throws -> Void, label: () -> Label) {
        self.init(action: { Task { try await action() }}, label: label)
    }
}
