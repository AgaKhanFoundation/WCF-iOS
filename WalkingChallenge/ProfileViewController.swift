
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

    name.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalToSuperview()
      ConstraintMaker.centerY.equalToSuperview()
    }

    donated.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalToSuperview()
      ConstraintMaker.bottom.equalTo(name.snp.centerY)
      ConstraintMaker.right.equalToSuperview()
      ConstraintMaker.left.equalTo(pledged.snp.left)
    }

    pledged.textColor = Style.Colors.grey
    pledged.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(name.snp.centerY)
      ConstraintMaker.bottom.equalToSuperview()
      ConstraintMaker.right.equalToSuperview()
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
  var supporters: Array<Supporter> =
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

    image.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.left.equalToSuperview()
      ConstraintMaker.height.width.equalTo(Style.Size.s56)
    }

    name.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(image.snp.right).offset(Style.Padding.p8)
      ConstraintMaker.top.equalTo(image.snp.top)
    }

    time.textColor = Style.Colors.grey
    time.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(image.snp.right).offset(Style.Padding.p8)
      ConstraintMaker.top.equalTo(name.snp.bottom)
    }

    team.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(image.snp.right).offset(Style.Padding.p8)
      ConstraintMaker.top.equalTo(time.snp.bottom)
    }

    raised.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(team.snp.bottom)
      ConstraintMaker.bottom.equalToSuperview()
      ConstraintMaker.left.equalTo(team.snp.left)
    }

    distance.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(team.snp.bottom)
      ConstraintMaker.bottom.equalToSuperview()
      ConstraintMaker.right.equalToSuperview()
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
  let events: Array<Event> = [
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

  var items: Array<String> = StatisticsRangeDataSource.ranges
  var selection: Int? = nil
}

class ProfileViewController: UIViewController {
  let dataSource = ProfileDataSource()

  // Views
  let profileImage = UIImageView()
  let nameLabel = UILabel(.header)
  let teamLabel = UILabel(.title)

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
        guard (url != nil) else { return }

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
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.profile

    let supporter0: SupporterView =
        SupporterView(supporter: supportersDataSource.supporters[0])
    let supporter1: SupporterView =
        SupporterView(supporter: supportersDataSource.supporters[1])

    let event0: EventView = EventView(event: eventsDataSource.events[0])
    let event1: EventView = EventView(event: eventsDataSource.events[1])

    view.addSubviews([profileImage, nameLabel, teamLabel, rangeButton,
                      supportersLabel, supporter0, supporter1, showSupportButton,
                      pastEventsLabel, event0, event1, showEventsButton])

    profileImage.contentMode = .scaleAspectFill
    // TODO(compnerd) figure out how to get this value properly
    profileImage.layer.cornerRadius = Style.Size.s128 / 2.0
    profileImage.layer.masksToBounds = true
    profileImage.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(topLayoutGuide.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.size.equalTo(Style.Size.s128)
      ConstraintMaker.centerX.equalToSuperview()
    }

    nameLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(profileImage.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.centerX.equalToSuperview()
    }

    teamLabel.textAlignment = .center
    teamLabel.textColor = Style.Colors.grey
    teamLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(nameLabel.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.centerX.equalToSuperview()
    }

    rangeButton.dataSource = statisticsRangeDataSource
    rangeButton.delegate = self
    rangeButton.selection = UserInfo.profileStatsRange
    rangeButton.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(teamLabel.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) localise this properly
    supportersLabel.text =
        "Current Supporters (\(supportersDataSource.supporters.count))"
    supportersLabel.snp.makeConstraints { (ConstraintMaker) in
      // FIXME(compenrd) this needs to be based off of the previous row of stats
      ConstraintMaker.top.equalTo(rangeButton.snp.bottom)
          .offset(Style.Padding.p8)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
    }

    supporter0.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(supportersLabel.snp.bottom)
        .offset(Style.Padding.p8)
      ConstraintMaker.left.right.equalToSuperview().inset(Style.Padding.p12)
    }

    supporter1.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(supporter0.snp.bottom)
      ConstraintMaker.left.right.equalToSuperview().inset(Style.Padding.p12)
    }

    showSupportButton.setTitle(Strings.Profile.seeMore, for: .normal)
    showSupportButton.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(supporter1.snp.bottom)
          .offset(Style.Padding.p8)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) localise this properly
    pastEventsLabel.text = "Past Events (\(eventsDataSource.events.count))"
    pastEventsLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(showSupportButton.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
    }

    event0.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(pastEventsLabel.snp.bottom)
          .offset(Style.Padding.p8)
      ConstraintMaker.left.right.equalToSuperview().inset(Style.Padding.p12)
    }

    event1.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(event0.snp.bottom)
      ConstraintMaker.left.right.equalToSuperview().inset(Style.Padding.p12)
    }

    showEventsButton.setTitle(Strings.Profile.seeMore, for: .normal)
    showEventsButton.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(event1.snp.bottom).offset(Style.Padding.p8)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
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
}

extension ProfileViewController: SelectionButtonDelegate {
}

