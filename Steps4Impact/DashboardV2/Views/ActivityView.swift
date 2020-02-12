/**
* Copyright © 2019 Aga Khan Foundation
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice,
*    this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
*    this list of conditions and the following disclaimer in the documentation
*    and/or other materials provided with the distribution.
*
* 3. The name of the author may not be used to endorse or promote products
*    derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
* EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
* OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
* WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
* OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

import UIKit

class ActivityState {
  var time: ActivityTime = .day
  var unit: ActivityUnit = .miles
  var dateLeftButtonDisabled: Bool = true
  var dateRightButtonDisabled: Bool = true
  var dateLabel: String?
  var commitment: Int = 0
  var eventLengthInDays: Int = 1
  var currentPedometerData: [PedometerData] = []
}

struct ActivityData {
  let milesData: [PedometerData]
  let stepsData: [PedometerData]
  let commitment: Int
  let eventLengthInDays: Int
}

enum ActivityTime {
  case day
  case week
}

enum ActivityUnit {
  case miles
  case steps
}

class ActivityView: View {
  // Views
  private let stackView = UIStackView(axis: .vertical,
                                      spacing: Style.Padding.p8,
                                      alignment: .fill)
  private let timeView = ActivityTimeView()
  private let dateview = ActivityDateView()
  private let progressView = ActivityProgressView()
  private let graphView = ActivityGraphView()
  private let unitView = ActivityUnitView()
  
  // State
  private var state = ActivityState()
  private var milesData: [PedometerData] = []
  private var stepsData: [PedometerData] = []
  private var currentIndex: Int = 0
  
  // Helpers
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  
  override func commonInit() {
    super.commonInit()
    
    timeView.delegate = self
    dateview.delegate = self
    graphView.isHidden = true
    unitView.delegate = self
    
    stackView.addArrangedSubviews(timeView, dateview, progressView, graphView, unitView)
    
    addSubview(stackView) {
      $0.edges.equalToSuperview()
    }
    
    update()
  }
  
  func configure(data: ActivityData) {
    milesData = data.milesData
    stepsData = data.stepsData
    state.commitment = data.commitment
    state.eventLengthInDays = data.eventLengthInDays
    
//    injectDummyData()
    
    update(currentIndex: milesData.indexOfToday ?? (milesData.count - 1))
    update()
  }
  
  func update() {
    update(currentIndex: currentIndex)
    timeView.configure(state: state)
    dateview.configure(state: state)
    progressView.configure(state: state)
    graphView.configure(state: state)
    unitView.configure(state: state)
  }
  
  private func update(currentIndex: Int) {
    guard
      milesData.count != 0,
      stepsData.count != 0,
      currentIndex >= 0,
      currentIndex < milesData.count,
      currentIndex < stepsData.count
    else { return }
    
    // Get current data
    
    let currentData: PedometerData
    
    switch state.unit {
    case .miles:
      currentData = milesData[currentIndex]
    case .steps:
      currentData = stepsData[currentIndex]
    }
    
    // Set the state.dateLabel
    
    switch state.time {
    case .day:
      state.dateLabel = dateFormatter.string(from: currentData.date)
    case .week:
      state.dateLabel = "Week of \(dateFormatter.string(from: currentData.date))"
    }
    
    // Set state.currentPedometerData for progress bar or graph
    
    switch (state.time, state.unit) {
    case (.day, _):
      state.currentPedometerData = [currentData]
    case (.week, .miles):
      state.currentPedometerData = getWeekData(data: milesData, currentIndex: currentIndex)
    case (.week, .steps):
      state.currentPedometerData = getWeekData(data: stepsData, currentIndex: currentIndex)
    }
    
    // Set disabled state for date view buttons
    state.dateLeftButtonDisabled = currentIndex == 0
    
    switch state.unit {
    case .miles:
      state.dateRightButtonDisabled = milesData.count == currentIndex + 1
    case .steps:
       state.dateRightButtonDisabled = stepsData.count == currentIndex + 1
    }
    
    self.currentIndex = currentIndex
  }
  
  private func getWeekData(data: [PedometerData], currentIndex: Int) -> [PedometerData] {
    let anchorData = data[currentIndex]
    
    return [
      data[safe: currentIndex - 3] ?? PedometerData(date: anchorData.date.addingTimeInterval(86400 * -3), count: 0),
      data[safe: currentIndex - 2] ?? PedometerData(date: anchorData.date.addingTimeInterval(86400 * -2), count: 0),
      data[safe: currentIndex - 1] ?? PedometerData(date: anchorData.date.addingTimeInterval(86400 * -1), count: 0),
      anchorData,
      data[safe: currentIndex + 1] ?? PedometerData(date: anchorData.date.addingTimeInterval(86400 * 1), count: 0),
      data[safe: currentIndex + 2] ?? PedometerData(date: anchorData.date.addingTimeInterval(86400 * 2), count: 0),
      data[safe: currentIndex + 3] ?? PedometerData(date: anchorData.date.addingTimeInterval(86400 * 3), count: 0)
    ]
  }
}

extension ActivityView: ActivityTimeViewDelegate {
  func activityTimeViewTapped(time: ActivityTime) {
    state.time = time
    
    switch time {
    case .day:
      progressView.isHidden = false
      graphView.isHidden = true
    case .week:
      progressView.isHidden = true
      graphView.isHidden = false
    }
    
    update()
  }
}

extension ActivityView: ActivityDateViewDelegate {
  func activityDateViewLeftTapped() {
    update(currentIndex: currentIndex - 1)
    update()
  }
  
  func activityDateViewRightTapped() {
    update(currentIndex: currentIndex + 1)
    update()
  }
}

extension ActivityView: ActivityUnitViewDelegate {
  func activityUnitViewTapped(unit: ActivityUnit) {
    state.unit = unit
    update()
  }
}

extension ActivityView {
  func injectDummyData() {
    // This is useful for testing in the simulator where healthkit data is sparse
    let now = Date()
    
    milesData = [
      PedometerData(date: Date(timeInterval: 86400 * 4, since: now), count: 1),
      PedometerData(date: Date(timeInterval: 86400 * 3, since: now), count: 3),
      PedometerData(date: Date(timeInterval: 86400 * 2, since: now), count: 2),
      PedometerData(date: Date(timeInterval: 86400, since: now), count: 2),
      PedometerData(date: now, count: 1),
      PedometerData(date: Date(timeInterval: -86400, since: now), count: 2),
      PedometerData(date: Date(timeInterval: -86400 * 2, since: now), count: 3),
      PedometerData(date: Date(timeInterval: -86400 * 3, since: now), count: 2),
      PedometerData(date: Date(timeInterval: -86400 * 4, since: now), count: 3)
      ].reversed()
    
    stepsData = milesData.map {
      PedometerData(date: $0.date, count: $0.count * 2000)
    }
    
    state.commitment = 500
    state.eventLengthInDays = 100
  }
}
