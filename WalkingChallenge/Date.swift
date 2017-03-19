
import Foundation

extension Date {
    private var components: DateComponents { return Calendar.current.dateComponents([.year, .month, .day, .hour, .second], from: self) }
    
    private static func from(components: DateComponents) -> Date {
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var startOfDay: Date {
        var components = self.components
        components.hour = 0
        components.minute = 0
        components.second = 0
        return .from(components: components)
    }
    
    var endOfDay: Date {
        var components = self.components
        components.hour = 23
        components.minute = 59
        components.second = 59
        return .from(components: components)
    }
}
