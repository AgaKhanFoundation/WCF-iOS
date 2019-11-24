//
//  JourneyDataSource.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/17/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

enum MilestoneRanges: Int {
  case milestone1
  case milestone2
  case milestone3
  case milestone4
  case milestone5
  case milestone6
  case milestone7
  case milestone8

  var range: Range<Int> {
    switch self {
    case .milestone1 : return 0 ..< 2580000
    case .milestone2 : return 2580000 ..< 5120000
    case .milestone3 : return 5120000 ..< 6070000
    case .milestone4 : return 6070000 ..< 7070000
    case .milestone5 : return 7070000 ..< 8030000
    case .milestone6 : return 8030000 ..< 8910000
    case .milestone7 : return 8910000 ..< 10200000
    case .milestone8 : return 10200000 ..< 11000000
    }
  }
}

enum MilestoneStatus {
  case current
  case notCompleted
  case completed
}

struct Milestone {
  var sequence = 0
  var distance = 0
  var name = ""
  var flagName = ""
  var journeyMap = ""
  var description = ""
  var title = ""
  var subTitle = ""
  var media = ""
  var content = ""
}

class JourneyDataSource: TableViewDataSource {
  var cells = [[CellContext]]()
  var completion: (() -> Void)?
  var totalDistance = 0
  var distanceToNextMilestone = 0
  var distanceCoveredToNextMilestone = 0
  var nameOfNextMilestone = ""
  var milestones = MilestoneDetails.milestones()

  func reload(completion: @escaping () -> Void) {
    self.completion = completion
    self.configure()
    completion()
  }

  func configure() {
    switch totalDistance {
    case MilestoneRanges.milestone1.range:
      configureCellsWithCurrentMilestone(at: 0)
    case MilestoneRanges.milestone2.range:
      configureCellsWithCurrentMilestone(at: 1)
    case MilestoneRanges.milestone3.range:
      configureCellsWithCurrentMilestone(at: 2)
    case MilestoneRanges.milestone4.range:
      configureCellsWithCurrentMilestone(at: 3)
    case MilestoneRanges.milestone5.range:
      configureCellsWithCurrentMilestone(at: 4)
    case MilestoneRanges.milestone6.range:
      configureCellsWithCurrentMilestone(at: 5)
    case MilestoneRanges.milestone7.range:
      configureCellsWithCurrentMilestone(at: 6)
    case MilestoneRanges.milestone8.range:
      configureCellsWithCurrentMilestone(at: 7)
    default:
      break
    }
  }

  func configureCellsWithCurrentMilestone(at milestone: Int) {
    cells.removeAll()
    var result = [CellContext]()
    var nextMilestoneIndex = 0
    for index in 0..<milestones.count {
      if index == milestone {
        let currentMilestone = newCurrentMilestone(for: index)
        result.append(currentMilestone)
        nextMilestoneIndex = index+1
      } else if index < milestone {
        let temp = newMilestone(for: index, status: .completed)
        result.append(temp)
      } else {
        if index == nextMilestoneIndex {
          guard var lastMilestone = result.removeLast() as? CurrentMilestoneContext else { break }
          let progress = calculateProgress(for: totalDistance, from: lastMilestone, to: milestones[index].distance)
          lastMilestone.progress = progress
          result.append(lastMilestone)
          nameOfNextMilestone = milestones[index].name
        }
        let temp = newMilestone(for: index, status: .notCompleted)
        result.append(temp)
      }
    }
    cells.append(result)
  }

  func newMilestone(for index: Int, status: MilestoneStatus) -> MilestoneContext {
    return MilestoneContext(sequence: milestones[index].sequence,
                            distance: milestones[index].distance,
                            name: milestones[index].name,
                            flagName: milestones[index].flagName,
                            journeyMap: milestones[index].journeyMap,
                            description: milestones[index].description,
                            title: milestones[index].title,
                            subTitle: milestones[index].subTitle,
                            media: milestones[index].media,
                            content: milestones[index].content,
                            status: status)
  }

  func newCurrentMilestone(for index: Int) -> CurrentMilestoneContext {
    return CurrentMilestoneContext(sequence: milestones[index].sequence,
                                   distance: milestones[index].distance,
                                   name: milestones[index].name,
                                   flagName: milestones[index].flagName,
                                   journeyMap: milestones[index].journeyMap,
                                   description: milestones[index].description,
                                   title: milestones[index].title,
                                   subTitle: milestones[index].subTitle,
                                   media: milestones[index].media,
                                   content: milestones[index].content,
                                   status: .current)
  }

  func calculateProgress(for totalDistance: Int, from last: CurrentMilestoneContext, to next: Int) -> CGFloat {
    distanceCoveredToNextMilestone = totalDistance - last.distance
    distanceToNextMilestone = next - last.distance
    return CGFloat(distanceCoveredToNextMilestone*100/distanceToNextMilestone)
  }
}
