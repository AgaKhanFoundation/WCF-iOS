
import Foundation

// Some helpers for doing async with UI

// Use seconds because its easier to reason with in animations than nanoseconds
typealias Seconds = Double

extension Seconds {
  var timeAfterNow: DispatchTime {
    return DispatchTime.now() + Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
  }
}

func onMain(delay: Seconds = 0, _ block: @escaping GenericBlock) {
  DispatchQueue.main.asyncAfter(deadline: delay.timeAfterNow, execute: block)
}

func onBackground(delay: Seconds = 0, _ block: @escaping GenericBlock) {
  DispatchQueue.global(qos: .background).asyncAfter(deadline: delay.timeAfterNow, execute: block)
}
