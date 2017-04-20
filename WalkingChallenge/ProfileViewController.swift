/**
 * Copyright © 2017 Aga Khan Foundation
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

import SnapKit

struct Supporter {
  let name: String
  let pledged: Int
}

class SupporterView: UIView {
  internal var name: UILabel = UILabel(.body)
  internal var donated: UILabel = UILabel(.body)
  internal var pledged: UILabel = UILabel(.caption)

  convenience init(supporter: Supporter) {
    self.init(frame: CGRect.zero)
    self.configure()
    self.updateForSupporter(supporter)
  }

  convenience init() {
    self.init(frame: CGRect.zero)
    self.configure()
  }

  private func configure() {
    // FIXME(compnerd) this should inset eeverything by the desired amount, but
    // doesnt seem to?
    layoutMargins =
        UIEdgeInsets(top: Style.Padding.p12, left: Style.Padding.p12,
                     bottom: Style.Padding.p12, right: Style.Padding.p12)

    addSubviews([name, donated, pledged])

    name.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.centerY.equalToSuperview()
    }

    donated.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.bottom.equalTo(name.snp.centerY)
      make.right.equalToSuperview()
      make.left.equalTo(pledged.snp.left)
    }

    pledged.textColor = Style.Colors.grey
    pledged.snp.makeConstraints { (make) in
      make.top.equalTo(name.snp.centerY)
      make.bottom.equalToSuperview()
      make.right.equalToSuperview()
    }
  }

  func updateForSupporter(_ supporter: Supporter) {
    name.text = supporter.name

    let formatter: NumberFormatter = NumberFormatter()
    formatter.numberStyle = .currency

    donated.text = formatter.string(from: NSNumber(value: 0))
    // TODO(compnerd) localise this properly
    pledged.text =
        "Pledged " + formatter.string(from: NSNumber(value: supporter.pledged))!
  }
}

class SupporterDataSource {
  // TODO(compnerd) pull this from the backend
  var supporters: [Supporter] =
      [Supporter(name: "Alpha", pledged: 32),
       Supporter(name: "Beta", pledged: 64),
       Supporter(name: "Gamma", pledged: 128),
       Supporter(name: "Delta", pledged: 256)]
}

struct Event {
  let image: URL?
  let name: String
  let time: String
  let team: String
  let raised: Float
  let distance: Float
}

class EventView: UIView {
  internal var image: UIImageView = UIImageView()
  internal var name: UILabel = UILabel(.title)
  internal var time: UILabel = UILabel(.caption)
  internal var team: UILabel = UILabel(.caption)
  internal var raised: UILabel = UILabel(.caption)
  internal var distance: UILabel = UILabel(.caption)

  convenience init(event: Event) {
    self.init(frame: CGRect.zero)
    self.configure()
    self.updateForEvent(event)
  }

  private func configure() {
    // FIXME(compnerd) this should inset eeverything by the desired amount, but
    // doesnt seem to?
    layoutMargins =
      UIEdgeInsets(top: Style.Padding.p12, left: Style.Padding.p12,
                   bottom: Style.Padding.p12, right: Style.Padding.p12)

    addSubviews([image, name, time, team, raised, distance])

    image.snp.makeConstraints { (make) in
      make.top.left.equalToSuperview()
      make.height.width.equalTo(Style.Size.s56)
    }

    name.snp.makeConstraints { (make) in
      make.left.equalTo(image.snp.right).offset(Style.Padding.p8)
      make.top.equalTo(image.snp.top)
    }

    time.textColor = Style.Colors.grey
    time.snp.makeConstraints { (make) in
      make.left.equalTo(image.snp.right).offset(Style.Padding.p8)
      make.top.equalTo(name.snp.bottom)
    }

    team.snp.makeConstraints { (make) in
      make.left.equalTo(image.snp.right).offset(Style.Padding.p8)
      make.top.equalTo(time.snp.bottom)
    }

    raised.snp.makeConstraints { (make) in
      make.top.equalTo(team.snp.bottom)
      make.bottom.equalToSuperview()
      make.left.equalTo(team.snp.left)
    }

    distance.snp.makeConstraints { (make) in
      make.top.equalTo(team.snp.bottom)
      make.bottom.equalToSuperview()
      make.right.equalToSuperview()
    }
  }

  func updateForEvent(_ event: Event) {
    if let url = event.image {
    }

    name.text = event.name
    // TODO(compnerd) format this
    time.text = event.time
    // TODO(compnerd) properly localise this
    team.text = "Team: \(event.team)"

    let formatter: NumberFormatter = NumberFormatter()
    formatter.numberStyle = .currency
    raised.text = formatter.string(from: NSNumber(value: event.raised))

    // TODO(compnerd) properly localise this
    distance.text = "\(event.distance) miles"
  }
}

class EventsDataSource {
  // TODO(compnerd) pull this from the backend
  let events: [Event] = [
      Event(image: nil, name: "Alpha", time: "January 2017", team: "Team",
            raised: 32.0, distance: 1.0),
      Event(image: nil, name: "Beta", time: "February 2017", team: "Team",
            raised: 64.0, distance: 2.0),
      Event(image: nil, name: "Gamma", time: "March 2017", team: "Team",
            raised: 128, distance: 3.0)
  ]
}

class StatisticsRangeDataSource: SelectionButtonDataSource {
  static let ranges = [Strings.Profile.thisWeek, Strings.Profile.thisMonth,
                       Strings.Profile.thisEvent, Strings.Profile.overall]

  var items: [String] = StatisticsRangeDataSource.ranges
  var selection: Int?
}

class ProfileViewController: UIViewController {
  let dataSource = ProfileDataSource()

  // Views
  let profileImage = UIImageView()
  let nameLabel = UILabel(.header)
  let teamLabel = UILabel(.title)
  let scrollView = BaseScrollView()

  let statisticsRangeDataSource: StatisticsRangeDataSource =
      StatisticsRangeDataSource()
  var rangeButton = SelectionButton(type: .system)

  let supportersDataSource = SupporterDataSource()
  let supportersLabel = UILabel(.section)
  let showSupportButton = UIButton(type: .system)

  let eventsDataSource = EventsDataSource()
  let pastEventsLabel = UILabel(.section)
  let showEventsButton = UIButton(type: .system)

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    configureView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    updateProfile()
    onBackground {
      Facebook.profileImage(for: "me") { [weak self] (url) in
        guard url != nil else { return }

        let data = try? Data(contentsOf: url!)
        onMain { self?.profileImage.image = UIImage(data: data!) }
      }
    }
  }
  
  // MARK: - Configure

  private func configureNavigation() {
    // TODO(compnerd) use the gear icon instead
    navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .compose, target: self,
                        action: #selector(configureApp))

    navigationController?.navigationBar.barTintColor = Style.Colors.darkGreen
    navigationController?.navigationBar.tintColor = Style.Colors.white
    navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: Style.Colors.white]
  }

  private func configureView() {
    super.view.addSubview(scrollView)
    scrollView.snp.makeConstraints { (make) in
      make.edges.equalTo(view)
    }
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.profile

    let supporter0: SupporterView =
        SupporterView(supporter: supportersDataSource.supporters[0])
    let supporter1: SupporterView =
        SupporterView(supporter: supportersDataSource.supporters[1])

    let event0: EventView = EventView(event: eventsDataSource.events[0])
    let event1: EventView = EventView(event: eventsDataSource.events[1])

    scrollView.contentView.addSubviews([profileImage, nameLabel, teamLabel, rangeButton,
                      supportersLabel, supporter0, supporter1, showSupportButton,
                      pastEventsLabel, event0, event1, showEventsButton])

    profileImage.contentMode = .scaleAspectFill
    // TODO(compnerd) figure out how to get this value properly
    profileImage.layer.cornerRadius = Style.Size.s128 / 2.0
    profileImage.layer.masksToBounds = true
    profileImage.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
          .offset(Style.Padding.p12)
      make.size.equalTo(Style.Size.s128)
      make.centerX.equalToSuperview()
    }

    nameLabel.snp.makeConstraints { (make) in
      make.top.equalTo(profileImage.snp.bottom)
          .offset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }

    teamLabel.textAlignment = .center
    teamLabel.textColor = Style.Colors.grey
    teamLabel.snp.makeConstraints { (make) in
      make.top.equalTo(nameLabel.snp.bottom)
          .offset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }

    rangeButton.dataSource = statisticsRangeDataSource
    rangeButton.delegate = self
    rangeButton.selection = UserInfo.profileStatsRange
    rangeButton.snp.makeConstraints { (make) in
      make.top.equalTo(teamLabel.snp.bottom)
          .offset(Style.Padding.p12)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) localise this properly
    supportersLabel.text = "Current Supporters (\(supportersDataSource.supporters.count))"
    supportersLabel.snp.makeConstraints { (make) in
      // FIXME(compenrd) this needs to be based off of the previous row of stats
      make.top.equalTo(rangeButton.snp.bottom)
          .offset(Style.Padding.p8)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }

    supporter0.snp.makeConstraints { (make) in
      make.top.equalTo(supportersLabel.snp.bottom)
        .offset(Style.Padding.p8)
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
    }

    supporter1.snp.makeConstraints { (make) in
      make.top.equalTo(supporter0.snp.bottom)
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
    }

    showSupportButton.setTitle(Strings.Profile.seeMore, for: .normal)
    showSupportButton.addTarget(self, action: #selector(showSupporters),
                                for: .touchUpInside)

    showSupportButton.snp.makeConstraints { (make) in
      make.top.equalTo(supporter1.snp.bottom)
          .offset(Style.Padding.p8)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) localise this properly
    pastEventsLabel.text = "Past Events (\(eventsDataSource.events.count))"
    pastEventsLabel.snp.makeConstraints { (make) in
      make.top.equalTo(showSupportButton.snp.bottom)
          .offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }

    event0.snp.makeConstraints { (make) in
      make.top.equalTo(pastEventsLabel.snp.bottom)
          .offset(Style.Padding.p8)
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
    }

    event1.snp.makeConstraints { (make) in
      make.top.equalTo(event0.snp.bottom)
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
    }

    showEventsButton.setTitle(Strings.Profile.seeMore, for: .normal)
    showEventsButton.snp.makeConstraints { (make) in
      make.top.equalTo(event1.snp.bottom).offset(Style.Padding.p8)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.bottom.equalTo(scrollView.contentView)
    }
  }

  private func updateProfile() {
    dataSource.updateProfile { [weak self] (success: Bool) in
      guard success else {
        self?.alert(message: "Error loading profile")
        return
      }

      self?.nameLabel.text = self?.dataSource.realName
      self?.teamLabel.text = Team.name
    }
  }

  func configureApp() {
    let configurationView = ConfigurationViewController()
    navigationController?.pushViewController(configurationView, animated: true)
  }

  func showSupporters() {
    let supportersView = SupportersViewController()
    navigationController?.pushViewController(supportersView, animated: true)
  }
}

extension ProfileViewController: SelectionButtonDelegate {
}
