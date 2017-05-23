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
import FacebookCore

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
    // TODO(compnerd) fetch and model this
    donated.text = DataFormatters.formatCurrency(value: 0)
    // TODO(compnerd) localise this properly
    pledged.text =
        "Pledged \(DataFormatters.formatCurrency(value: supporter.pledged))"
  }
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

    // TODO(compnerd) use a placeholder instead of the filled bordered area
    image.layer.borderWidth = 1
    image.layer.backgroundColor = Style.Colors.grey.cgColor

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
      // TODO(compnerd) asynchronously load and display the image
      _ = url
    }

    name.text = event.name
    // TODO(compnerd) format this
    time.text = event.time
    // TODO(compnerd) properly localise this
    team.text = "Team: \(event.team)"
    raised.text = DataFormatters.formatCurrency(value: event.raised)
    distance.text = DataFormatters.formatDistance(value: event.distance)
  }
}

fileprivate class StatisticsRangeDataSource: SelectionButtonDataSource {
  static let ranges = [Strings.Profile.thisWeek, Strings.Profile.thisMonth,
                       Strings.Profile.thisEvent, Strings.Profile.overall]

  var items: [String] = StatisticsRangeDataSource.ranges
  var selection: Int?
}

class ProfileViewController: UIViewController {
  fileprivate let statisticsRangeDataSource: StatisticsRangeDataSource =
      StatisticsRangeDataSource()

  // Views
  let profileImage = UIImageView()
  let scrollView = BaseScrollView()
  let nameLabel = UILabel(.header)
  let teamLabel = UILabel(.title)

  var rangeButton = SelectionButton(type: .system)
  let lblRaisedSymbol: UILabel = UILabel()
  let lblRaisedAmount: UILabel = UILabel(.header)
  let prgProgress: ProgressRing = ProgressRing(radius: 64.0)
  let lblStreakSymbol: UILabel = UILabel()
  let lblStreak: UILabel = UILabel(.header)
  let lblStreakUnits: UILabel = UILabel(.caption)

  let sponsorshipDataSource: SponsorshipDataSource = SponsorshipDataSource()
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
    title = Strings.NavBarTitles.profile

    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: getGearButton()!)
    navigationController?.navigationBar.barTintColor = Style.Colors.darkGreen
    navigationController?.navigationBar.tintColor = Style.Colors.white
    navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: Style.Colors.white]
  }

  private func configureHeaderView(_ top: inout ConstraintRelatableTarget) {
    scrollView.addSubview(profileImage)
    profileImage.contentMode = .scaleAspectFill
    // TODO(compnerd) figure out how to get this value properly
    profileImage.layer.cornerRadius = Style.Size.s128 / 2.0
    profileImage.layer.masksToBounds = true
    profileImage.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.size.equalTo(Style.Size.s128)
      make.centerX.equalToSuperview()
    }
    top = profileImage.snp.bottom

    scrollView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }
    top = nameLabel.snp.bottom

    scrollView.addSubview(teamLabel)
    teamLabel.textAlignment = .center
    teamLabel.textColor = Style.Colors.grey
    teamLabel.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }
    top = teamLabel.snp.bottom
  }

  private func configureStatisticsView(_ top: inout ConstraintRelatableTarget) {
    scrollView.addSubview(rangeButton)
    rangeButton.dataSource = statisticsRangeDataSource
    rangeButton.delegate = self
    rangeButton.selection = UserInfo.profileStatsRange
    rangeButton.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }

    scrollView.addSubviews([lblRaisedSymbol, lblRaisedAmount])

    lblRaisedSymbol.text =
        "\(String(describing: Locale.current.currencySymbol!))"
    lblRaisedSymbol.textColor = Style.Colors.green
    lblRaisedSymbol.font = UIFont.boldSystemFont(ofSize: 32.0)
    lblRaisedSymbol.snp.makeConstraints { (make) in
      make.centerY.equalTo(lblRaisedAmount.snp.centerY)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) calculate this properly
    lblRaisedAmount.text = "423.50"
    lblRaisedAmount.snp.makeConstraints { (make) in
      make.centerY.equalTo(lblRaisedSymbol.snp.centerY)
      make.left.equalTo(lblRaisedSymbol.snp.right).offset(Style.Padding.p8)
    }

    scrollView.addSubview(prgProgress)
    prgProgress.summary = ProgressRingSummaryDistance(value: 375.0, max: 500.0)
    prgProgress.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalTo(lblRaisedAmount.snp.centerY)
      make.top.equalTo(rangeButton.snp.bottom).offset(Style.Padding.p8)
      make.size.equalTo(Style.Size.s128)
    }

    scrollView.addSubviews([lblStreakSymbol, lblStreak, lblStreakUnits])

    lblStreakSymbol.text = "\u{1f525}" // :fire:
    lblStreakSymbol.font = UIFont.systemFont(ofSize: 32.0)
    lblStreakSymbol.snp.makeConstraints { (make) in
      make.centerY.equalTo(prgProgress.snp.centerY)
      make.right.equalTo(lblStreak.snp.left).offset(-Style.Padding.p8)
    }
    // TODO(compnerd) calculate this properly
    lblStreak.text = "34"
    lblStreak.snp.makeConstraints { (make) in
      make.top.equalTo(lblStreakSymbol.snp.top)
      make.bottom.equalTo(lblStreakUnits.snp.top)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalTo(lblStreakUnits.snp.left)
    }
    // FIXME(compnerd) localise this properly
    lblStreakUnits.text = "days"
    lblStreakUnits.snp.makeConstraints { (make) in
      make.bottom.equalTo(lblStreakSymbol.snp.bottom)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }

    top = prgProgress.snp.bottom
  }

  private func configureSupportersView(_ top: inout ConstraintRelatableTarget) {
    let kMaxDisplayedSupporters: Int = 2

    scrollView.addSubview(supportersLabel)
    // TODO(compnerd) localise this properly
    supportersLabel.text =
        "Current Supporters (\(sponsorshipDataSource.supporters.count))"
    supportersLabel.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    top = supportersLabel.snp.bottom

    for supporter in 0..<min(sponsorshipDataSource.supporters.count,
                             kMaxDisplayedSupporters) {
      let supporterView: SupporterView =
          SupporterView(supporter: sponsorshipDataSource.supporters[supporter])

      scrollView.addSubview(supporterView)
      supporterView.snp.makeConstraints { (make) in
        make.top.equalTo(top).offset(Style.Padding.p8)
        make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      }
      top = supporterView.snp.bottom
    }

    if sponsorshipDataSource.supporters.count > kMaxDisplayedSupporters {
      scrollView.addSubview(showSupportButton)
      showSupportButton.setTitle(Strings.Profile.seeMore, for: .normal)
      showSupportButton.addTarget(self, action: #selector(showSupporters),
                                  for: .touchUpInside)
      showSupportButton.snp.makeConstraints { (make) in
        make.top.equalTo(top).offset(Style.Padding.p8)
        make.right.equalToSuperview().inset(Style.Padding.p12)
      }
      top = showSupportButton.snp.bottom
    }
  }

  private func configureEventsView(_ top: inout ConstraintRelatableTarget) {
    let kMaxDisplayedEvents: Int = 2

    scrollView.addSubview(pastEventsLabel)
    // TODO(compnerd) localise this properly
    pastEventsLabel.text = "Past Events (\(eventsDataSource.events.count))"
    pastEventsLabel.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    top = pastEventsLabel.snp.bottom

    for event in 0..<min(eventsDataSource.events.count, kMaxDisplayedEvents) {
      let eventView: EventView =
          EventView(event: eventsDataSource.events[event])

      scrollView.addSubview(eventView)
      eventView.snp.makeConstraints { (make) in
        make.top.equalTo(top).offset(Style.Padding.p8)
        make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      }
      top = eventView.snp.bottom
    }

    if eventsDataSource.events.count > kMaxDisplayedEvents {
      scrollView.addSubview(showEventsButton)
      showEventsButton.setTitle(Strings.Profile.seeMore, for: .normal)
      showEventsButton.addTarget(self, action: #selector(showEvents),
                                 for: .touchUpInside)
      showEventsButton.snp.makeConstraints { (make) in
        make.top.equalTo(top).offset(Style.Padding.p8)
        make.right.equalToSuperview().inset(Style.Padding.p12)
        make.bottom.equalTo(scrollView.contentView)
      }
      top = showEventsButton.snp.bottom
    }
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    super.view.addSubview(scrollView)
    scrollView.snp.makeConstraints { (make) in
      make.edges.equalTo(view)
    }

    var top: ConstraintRelatableTarget = scrollView.snp.top
    configureHeaderView(&top)
    configureStatisticsView(&top)
    configureSupportersView(&top)
    configureEventsView(&top)
  }

  private func updateProfile() {
    Facebook.getRealName(for: "me") { [weak self] (name) in
      if let name = name {
        self?.nameLabel.text = name
      }
    }

    guard let fbid = AccessToken.current?.userId else { return }
    AKFCausesService.getParticipant(fbid: fbid) { [weak self] (result) in
      switch result {
      case .success(_, let response):
        guard let response = response else { return }
        if let participant = Participant(json: response) {
          self?.teamLabel.text = participant.team?.name
        }
      case .failed(let error):
        print("unable to get participant: \(String(describing: error?.localizedDescription))")
        break
      }
    }
  }

  private func getGearButton() -> UIButton? {
    if let image = UIImage(named: Strings.Assets.gearIcon) {
      let button: UIButton =
        UIButton(frame: CGRect(x: 0, y: 0, width: image.size.width,
                               height: image.size.height))
      button.setBackgroundImage(image, for: .normal)
      button.addTarget(self, action: #selector(configureApp), for: .touchUpInside)
      return button
    }
    return nil
  }

  func configureApp() {
    let configurationView = ConfigurationViewController()
    navigationController?.pushViewController(configurationView, animated: true)
  }

  func showSupporters() {
    let supportersView = SupportersViewController()
    navigationController?.pushViewController(supportersView, animated: true)
  }

  func showEvents() {
    let eventsView = EventsViewController()
    navigationController?.pushViewController(eventsView, animated: true)
  }
}

extension ProfileViewController: SelectionButtonDelegate {
}
