//
//  BadgeCollectionDataSource.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/4/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import UIKit

class BadgesCollectionDataSource: CollectionViewDataSource {

  var completion: (() -> Void)?
  var refresh: Bool = true
  var records: [Record]? {
    didSet {
      self.records = self.records?.sorted(by: { (r1, r2) -> Bool in             // swiftlint:disable:this variable_name
        if let d1 = r1.date, let d2 = r2.date {                                 // swiftlint:disable:this variable_name
          if d1 > d2 {
            return true
          }
        }
        return false
      })
    }
  }

  var event: Event?
  var team: Team?
  var stepsBadges = [Badge]()
  var achievementBadges = [Badge]()
  var streakBadge: Badge?
  var teamProgressBadge: Badge?
  var personalProgressBadge: Badge?
  var finalMedalBadge: Badge?
  var isChallengeCompleted: Bool = false
  var cells: [[CellContext]] = []

  func configure() {
    guard let event = event else {
      return
    }
    let now = Date()
    isChallengeCompleted = event.challengePhase.end < now
    /// Removing all earlier cells during refereh()
    stepsBadges.removeAll()
    achievementBadges.removeAll()
    cells.removeAll()
    /// Configure DailySteps , Streak  and Personal Prpgress badges
    configureBadges()
    /// Configure Team Progress badge
    configureTeamProgressBadge()
    if let badge = streakBadge {
      achievementBadges.append(badge)
    }
    if let badge = personalProgressBadge {
      achievementBadges.append(badge)
    }
    if let badge = teamProgressBadge {
      achievementBadges.append(badge)
    }
    if let badge = finalMedalBadge {
      cells.append([badge])
    } else {
      cells.append(stepsBadges)
    }
    cells.append(achievementBadges)
  }

  func configureBadges() {                                  // swiftlint:disable:this cyclomatic_complexity function_body_length line_length
    var badgesCount = 0
    var totalSteps = 0
    guard let records = records else { return }

    for record in records {
      if let distance = record.distance {

        /// Check for Daily Steps Badges
        switch distance {
        case EligibiltyRange.completed_daily_10000_Steps.range:
          badgesCount += 1
          createStepBadge(for: 10000, date: record.date)
        case EligibiltyRange.completed_daily_15000_Steps.range:
          badgesCount += 1
          createStepBadge(for: 15000, date: record.date)
        case EligibiltyRange.completed_daily_20000_Steps.range:
          badgesCount += 1
          createStepBadge(for: 20000, date: record.date)
        case EligibiltyRange.completed_daily_25000_Steps.range:
          badgesCount += 1
          createStepBadge(for: 25000, date: record.date)
        default:
          break
        }
        /// Check for Streak Badge
        switch badgesCount {

          /*  swiftlint:disable:next line_length
           Using the guard statement to avoid same badge creation again inorder to hold the first date value when the user crossed the respective range
           */
        case 10:
          guard let badge = personalProgressBadge, badge.streak == 10 else {
            createStreakBadge(for: 10, date: record.date)
            break
          }
        case 20:
          guard let badge = personalProgressBadge, badge.streak == 20 else {
            createStreakBadge(for: 20, date: record.date)
            break
          }
        case 30:
          guard let badge = personalProgressBadge, badge.streak == 30 else {
            createStreakBadge(for: 30, date: record.date)
            break
          }
        case 40:
          guard let badge = personalProgressBadge, badge.streak == 40 else {
            createStreakBadge(for: 40, date: record.date)
            break
          }
        case 50:
          guard let badge = personalProgressBadge, badge.streak == 50 else {
            createStreakBadge(for: 50, date: record.date)
            break
          }
        case 60:
          guard let badge = personalProgressBadge, badge.streak == 60 else {
            createStreakBadge(for: 60, date: record.date)
            break
          }
        case 70:
          guard let badge = personalProgressBadge, badge.streak == 70 else {
            createStreakBadge(for: 70, date: record.date)
            break
          }
        case 80:
          guard let badge = personalProgressBadge, badge.streak == 80 else {
            createStreakBadge(for: 80, date: record.date)
            break
          }
        case 90:
          guard let badge = personalProgressBadge, badge.streak == 90 else {
            createStreakBadge(for: 90, date: record.date)
            break
          }
        default:
          break
        }
        /// Check for Personal Progress Badge
        totalSteps += distance
        switch totalSteps {
          /*  swiftlint:disable:next line_length
           Using the guard statement to avoid same badge creation again inorder to hold the first date value when the user crossed the respective range
           */
        case EligibiltyRange.completed_50_miles.range:
          guard let badge = personalProgressBadge, badge.personalProgress == 50 else {
            createPersonalProgressBadge(for: 50, date: record.date)
            break
          }
        case EligibiltyRange.completed_100_Miles.range:
          guard let badge = personalProgressBadge, badge.personalProgress == 100 else {
            createPersonalProgressBadge(for: 100, date: record.date)
            break
          }
        case EligibiltyRange.completed_250_Miles.range:
          guard let badge = personalProgressBadge, badge.personalProgress == 250 else {
            createPersonalProgressBadge(for: 250, date: record.date)
            break
          }
        case EligibiltyRange.completed_500_miles.range:
          guard let badge = personalProgressBadge, badge.personalProgress == 500 else {
            createPersonalProgressBadge(for: 500, date: record.date)
            break
          }
        default:
          break
        }
      }
    }
    /// Check for Final Medal Badge
    if isChallengeCompleted {
      switch badgesCount {
      case 25..<50:
        createFinalMedalBadge(for: FinalMedalType.silver)
      case 50..<75:
        createFinalMedalBadge(for: FinalMedalType.gold)
      case 75..<99:
        createFinalMedalBadge(for: FinalMedalType.platinum)
      case 100:
        createFinalMedalBadge(for: FinalMedalType.champion)
      default:
        break
      }
    }
  }
  /// Calculating Team Progress Badge
  func configureTeamProgressBadge() {
    guard let team = team else { return }
    var teamTotalSteps = 0
    for participant in team.members {
      guard let records = participant.records else { return }
      teamTotalSteps += records.reduce(0) { $0 + ($1.distance ?? 0) }
    }
    switch teamTotalSteps {
    case EligibiltyRange.completed_25percent_journey.range:
      createTeamProgressBadge(for: 25)
    case EligibiltyRange.completed_50percent_journey.range:
      createTeamProgressBadge(for: 50)
    case EligibiltyRange.completed_75percent_journey.range:
      createTeamProgressBadge(for: 75)
    default:
      break
    }
  }
  func createFinalMedalBadge(for medal: FinalMedalType) {
    finalMedalBadge = Badge(finalMedalAchieved: medal, badgeType: .finalMedal)
  }
  func createStepBadge(for steps: Int, date recordDate: Date?) {
    let newBadge = Badge(stepsCompleted: steps, date: recordDate, badgeType: .steps)
    stepsBadges.append(newBadge)
  }
  func createTeamProgressBadge(for percentage: Int) {
    teamProgressBadge = Badge(teamProgress: percentage, badgeType: .teamProgress)
  }
  func createPersonalProgressBadge(for miles: Int, date recordDate: Date?) {
    personalProgressBadge = Badge(personalProgress: miles, date: recordDate, badgeType: .personalProgress)
  }
  func createStreakBadge(for streak: Int, date recordDate: Date?) {
    stepsBadges.removeAll()
    streakBadge = Badge(streak: streak, date: recordDate, badgeType: .streak)
  }
  func reload(completion: @escaping () -> Void) {
    self.completion = completion
    AKFCausesService.getParticipant(fbid: FacebookService.shared.id) { (result) in
      if let participant = Participant(json: result.response), let records = participant.records {
        self.records = records
        self.event = participant.events?.first
        self.configure()
        completion()
      }
    }
  }
}
// MARK: - Badges Types and Categpory Ranges
enum BadgeType {
  case steps
  case streak
  case teamProgress
  case personalProgress
  case finalMedal
  case unknown
}

enum FinalMedalType: String {
  case silver = "Silver"
  case gold = "Gold"
  case platinum = "Platinum"
  case champion = "Champion"
  case unknown = ""
}

enum EligibiltyRange: Int {

  case completed_daily_10000_Steps                      // swiftlint:disable:this variable_name
  case completed_daily_15000_Steps                      // swiftlint:disable:this variable_name
  case completed_daily_20000_Steps                      // swiftlint:disable:this variable_name
  case completed_daily_25000_Steps                      // swiftlint:disable:this variable_name
  case completed_50_miles                               // swiftlint:disable:this variable_name
  case completed_100_Miles                              // swiftlint:disable:this variable_name
  case completed_250_Miles                              // swiftlint:disable:this variable_name
  case completed_500_miles                              // swiftlint:disable:this variable_name
  case completed_25percent_journey                      // swiftlint:disable:this variable_name
  case completed_50percent_journey                      // swiftlint:disable:this variable_name
  case completed_75percent_journey                      // swiftlint:disable:this variable_name

  var range: Range<Int> {
    switch self {
    case .completed_daily_10000_Steps : return 10000..<15000
    case .completed_daily_15000_Steps : return 15000..<20000
    case .completed_daily_20000_Steps : return 20000..<25000
    case .completed_daily_25000_Steps : return 25000 ..< 100000
    case .completed_50_miles : return (2000*50) ..< (2000*100)
    case .completed_100_Miles : return (2000*100) ..< (2000*250)
    case .completed_250_Miles : return (2000*250) ..< (2000*500)
    case .completed_500_miles : return (2000*500) ..< (2000*1000)
    case .completed_25percent_journey: return 1375..<2750
    case .completed_50percent_journey: return 2750..<4125
    case .completed_75percent_journey: return 41255..<5500
    }
  }
}
