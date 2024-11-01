import Foundation

extension Double {
    var isDecimal: Bool {
        self != trunc(self)
    }
}
