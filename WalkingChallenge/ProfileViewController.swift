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

fileprivate class StatisticsRangeDataSource: SelectionButtonDataSource {
  static let ranges = [Strings.Profile.thisWeek, Strings.Profile.thisMonth,
                       Strings.Profile.thisEvent, Strings.Profile.overall]

  var items: [String] = StatisticsRangeDataSource.ranges
  var selection: Int?
}

class Badge: UIView {
  var lblTitle: UILabel = UILabel()

  init(withTitle title: String) {
    super.init(frame: CGRect.zero)

    lblTitle.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
    lblTitle.text = title
    lblTitle.textAlignment = .center
    lblTitle.textColor = Style.Colors.grey

    addSubview(lblTitle)
    lblTitle.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview()
      make.top.equalToSuperview()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class AmountRaisedBadge: Badge {
  let lblIcon: UILabel = UILabel()
  let lblAmount: UILabel = UILabel()

  var value: Float = 0.0 {
    didSet { lblAmount.text = DataFormatters.formatCurrency(value: value) }
  }

  init() {
    super.init(withTitle: "Funds Raised")
    initialize()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialize() {
    lblIcon.font = UIFont.boldSystemFont(ofSize: 48.0)
    lblIcon.text = Locale.current.currencySymbol
    lblIcon.textAlignment = .center
    lblIcon.textColor = Style.Colors.green
    addSubview(lblIcon)
    lblIcon.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(lblTitle.snp.bottom).offset(Style.Padding.p12)
    }

    lblAmount.font = UIFont.preferredFont(forTextStyle: .headline)
    lblAmount.text = DataFormatters.formatCurrency(value: value)
    lblAmount.textAlignment = .center
    lblAmount.textColor = Style.Colors.grey
    addSubview(lblAmount)
    lblAmount.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(lblIcon.snp.bottom)
    }
  }
}

class MilesWalkedBadge: Badge {
  let prgProgress: ProgressRing = ProgressRing(radius: 38.0, width: 8.0)

  var value: Float = 0.0 {
    didSet { prgProgress.setProgress(value, animated: true) }
  }

  init() {
    super.init(withTitle: "Miles Walked")
    initialize()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialize() {
    prgProgress.summary =
        ProgressRingSummaryDistance(value: 0, max: 0, units: "miles")
    addSubview(prgProgress)
    prgProgress.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(lblTitle.snp.bottom).offset(Style.Padding.p12)
      make.size.equalTo(76.0)
    }
  }
}

class StreakBadge: Badge {
  let lblIcon: UILabel = UILabel()
  let lblStreak: UILabel = UILabel()

  var value: Int = 0 {
    didSet { lblStreak.text = String(describing: value) }
  }

  init() {
    super.init(withTitle: "Streak")
    initialize()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialize() {
    lblIcon.font = UIFont.boldSystemFont(ofSize: 48.0)
    lblIcon.text = "\u{1f525}" // :fire:
    lblIcon.textAlignment = .center
    addSubview(lblIcon)
    lblIcon.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(lblTitle.snp.bottom).offset(Style.Padding.p12)
    }

    lblStreak.font = UIFont.preferredFont(forTextStyle: .headline)
    lblStreak.text = String(describing: 0)
    lblStreak.textAlignment = .center
    lblStreak.textColor = Style.Colors.grey
    addSubview(lblStreak)
    lblStreak.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(lblIcon.snp.bottom)
    }
  }
}

class ProfileViewController: UIViewController {
  fileprivate let statisticsRangeDataSource: StatisticsRangeDataSource =
      StatisticsRangeDataSource()

  let imgProfile: UIImageView = UIImageView()
  let lblRealName: UILabel = UILabel()
  let lblTeamName: UILabel = UILabel()

  let lblDashboard: UILabel = UILabel()
  let cboRange: SelectionButton = SelectionButton(type: .system)
  let stkStatistics: UIStackView = UIStackView()

  let lblSponsors: UILabel = UILabel()
  let stkSupporters: UIStackView = UIStackView()

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
        guard let url = url else { return }
        if let data = try? Data(contentsOf: url) {
          onMain { self?.imgProfile.image = UIImage(data: data) }
        }
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
    imgProfile.contentMode = .scaleAspectFill
    // TODO(compnerd) figure out how to get this value properly
    imgProfile.layer.cornerRadius = Style.Size.s128 / 2.0
    imgProfile.layer.masksToBounds = true

    view.addSubview(imgProfile)
    imgProfile.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.size.equalTo(Style.Size.s128)
      make.centerX.equalToSuperview()
    }
    top = imgProfile.snp.bottom

    lblRealName.font = UIFont.preferredFont(forTextStyle: .headline)
    lblRealName.textColor = Style.Colors.grey
    view.addSubview(lblRealName)
    lblRealName.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }
    top = lblRealName.snp.bottom

    lblTeamName.font = UIFont.preferredFont(forTextStyle: .callout)
    lblTeamName.textColor = Style.Colors.grey
    view.addSubview(lblTeamName)
    lblTeamName.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }
    top = lblTeamName.snp.bottom
  }

  private func configureStatisticsView(_ top: inout ConstraintRelatableTarget) {
    lblDashboard.font = UIFont.preferredFont(forTextStyle: .headline)
    lblDashboard.text = Strings.Profile.dashboard
    lblDashboard.textColor = Style.Colors.grey
    view.addSubview(lblDashboard)
    lblDashboard.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblDashboard.snp.bottom

    cboRange.dataSource = statisticsRangeDataSource
    cboRange.delegate = self
    cboRange.selection = UserInfo.profileStatsRange
    view.addSubview(cboRange)
    cboRange.snp.makeConstraints { (make) in
      make.top.equalTo(lblDashboard.snp.top)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblDashboard.snp.bottom

    stkStatistics.alignment = .lastBaseline
    stkStatistics.axis = .horizontal
    stkStatistics.spacing = Style.Padding.p12
    view.addSubview(stkStatistics)
    stkStatistics.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(top).offset(Style.Padding.p12)
    }
    top = stkStatistics.snp.bottom

    // TODO(compnerd) hold references to the badges to update the values
    stkStatistics.addArrangedSubview(AmountRaisedBadge())
    stkStatistics.addArrangedSubview(MilesWalkedBadge())
    stkStatistics.addArrangedSubview(StreakBadge())
  }

  private func configureSponsorsView(_ top: inout ConstraintRelatableTarget) {
    lblSponsors.font = UIFont.preferredFont(forTextStyle: .headline)
    lblSponsors.text = Strings.Profile.sponsors
    lblSponsors.textColor = Style.Colors.grey
    view.addSubview(lblSponsors)
    lblSponsors.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblSponsors.snp.bottom

    let scrollView: UIScrollView = UIScrollView()
    scrollView.addSubview(stkSupporters)
    stkSupporters.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview()
    }
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(top)
      make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-Style.Padding.p12)
      make.height.equalTo(stkStatistics.snp.height)
    }
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureHeaderView(&top)
    configureStatisticsView(&top)
    configureSponsorsView(&top)
  }

  private func updateProfile() {
    Facebook.getRealName(for: "me") { [weak self] (name) in
      if let name = name {
        self?.lblRealName.text = name
      }
    }

    AKFCausesService.getParticipant(fbid: Facebook.id) { [weak self] (result) in
      switch result {
      case .success(_, let response):
        guard let response = response else { return }
        guard let participant = Participant(json: response) else { return }

        self?.lblTeamName.text = participant.team?.name

        break
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
    let configurationView = SettingsViewController()//ConfigurationViewController()
    navigationController?.pushViewController(configurationView, animated: true)
  }
}

extension ProfileViewController: SelectionButtonDelegate {
}
