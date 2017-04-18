
import Foundation

protocol PedometerDataProvider {
  typealias PedometerCallback = (_ steps: Int) -> Void
  func retrieveStepCountForDateRange(_ interval: DateInterval,
                                     _ completion: @escaping PedometerCallback)
}
