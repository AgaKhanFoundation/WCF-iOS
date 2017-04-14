
import SnapKit
import FBSDKLoginKit

struct Supporter {
  let name: String
  let pledged: Int

  init(name: String, pledged: Int) {
    self.name = name
    self.pledged = pledged
  }
}

class SupporterCell: UITableViewCell {
  static let identifier = "SupporterCell"

  var nameLabel = UILabel(.body)
  var donatedLabel = UILabel(.body)
  var pledgedLabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([nameLabel, donatedLabel, pledgedLabel])

    nameLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.centerY.equalToSuperview()
    }

    donatedLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.left.equalTo(pledgedLabel.snp.left)
      ConstraintMaker.bottom.equalTo(nameLabel.snp.centerY)
    }

    pledgedLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.top.equalTo(nameLabel.snp.centerY)
    }
  }
}

class SupporterDataSource: NSObject, UITableViewDataSource {
  let supportersExpanded = false

  // TODO(compnerd) pull this from the backend
  let supporters = [Supporter(name: "Alpha", pledged: 32),
                    Supporter(name: "Beta", pledged: 64),
                    Supporter(name: "Gamma", pledged: 128),
                    Supporter(name: "Delta", pledged: 256)]

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    // FIXME(compnerd) how many supporters should we be showing?
    return supportersExpanded ? supporters.count : 2
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let supporter = supporters[safe: indexPath.row],
      let cell =
      tableView.dequeueReusableCell(withIdentifier: SupporterCell.identifier,
                                    for: indexPath)
        as? SupporterCell
      else { return UITableViewCell() }

    if (indexPath.row >= (supportersExpanded ? supporters.count : 2) - 1) {
      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
    }

    cell.nameLabel.text = supporter.name
    // TODO(compnerd) calculate this properly
    cell.donatedLabel.text = "$0"
    // TODO(compnerd) localise this
    cell.pledgedLabel.text = "Pledged $\(supporter.pledged)"
    return cell
  }
}

class Event {
  let name: String
  let time: String
  let team: String
  let amountRaised: Int
  let distance: Int

  init(name: String, time: String, team: String, amountRaised: Int,
       distance: Int) {
    self.name = name
    self.time = time
    self.team = team
    self.amountRaised = amountRaised
    self.distance = distance
  }
}

class EventCell: UITableViewCell {
  static let identifier = "EventCell"

  let eventImage = UIImageView()
  let nameLabel = UILabel(.header)
  let timeLabel = UILabel(.body)
  let teamLabel = UILabel(.body)
  let amountRaisedLabel = UILabel(.body)
  let distanceLabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([eventImage, nameLabel, timeLabel, teamLabel, amountRaisedLabel,
                 distanceLabel])

    eventImage.layer.borderWidth = 1
    eventImage.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.top.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.height.width.equalTo(Style.Size.s56)
    }

    nameLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(eventImage.snp.right).offset(Style.Padding.p8)
      ConstraintMaker.top.equalTo(eventImage.snp.top)
    }

    timeLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(eventImage.snp.right).offset(Style.Padding.p8)
      ConstraintMaker.top.equalTo(nameLabel.snp.bottom)
    }

    teamLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(eventImage.snp.right).offset(Style.Padding.p8)
      ConstraintMaker.top.equalTo(timeLabel.snp.bottom)
    }

    amountRaisedLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(eventImage.snp.right).offset(Style.Padding.p8)
      ConstraintMaker.top.equalTo(teamLabel.snp.bottom)
    }

    distanceLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.top.equalTo(teamLabel.snp.bottom)
    }
  }
}

class EventsDelegate: NSObject, UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    // FIXME(compnerd) properly calculate this
    return 96.0
  }
}

class EventsDataSource: NSObject, UITableViewDataSource {
  let eventsExpanded = false

  // TODO(compnerd) pull this from the backend
  let events = [Event(name: "Alpha", time: "January 2017", team: "Team",
                      amountRaised: 32, distance: 1),
                Event(name: "Beta", time: "February 2017", team: "Team",
                      amountRaised: 64, distance: 2),
                Event(name: "Gamma", time: "March 2017", team: "Team",
                      amountRaised: 128, distance: 3)]

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    // FIXME(compnerd) how many events should we be showing?
    return eventsExpanded ? events.count : 2
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let event = events[safe: indexPath.row],
      let cell =
      tableView.dequeueReusableCell(withIdentifier: EventCell.identifier,
                                    for: indexPath)
        as? EventCell
      else { return UITableViewCell() }

    if (indexPath.row >= (eventsExpanded ? events.count : 2) - 1) {
      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
    }

    cell.nameLabel.text = event.name
    cell.timeLabel.text = event.time
    cell.teamLabel.text = "Team: \(event.team)"
    // TODO(compnerd) properly localise this
    cell.amountRaisedLabel.text = "$\(event.amountRaised)"
    // TODO(compnerd) properly localise this
    cell.distanceLabel.text = "\(event.distance) miles"

    return cell
  }
}

class ProfileViewController: UIViewController {
  let dataSource = ProfileDataSource()

  // Views
  let profileImage = UIImageView()
  let nameLabel = UILabel(.header)
  let teamLabel = UILabel(.title)

  static let ranges = [Strings.Profile.thisWeek, Strings.Profile.thisMonth,
                       Strings.Profile.thisEvent, Strings.Profile.overall]
  let rangePicker = DropDownPickerView(data: ranges)

  let supportersDataSource = SupporterDataSource()
  let supportersLabel = UILabel(.header)
  let supportersTable = UITableView()
  let supportersExpandButton = UIButton(type: .system)

  let eventsDelegate = EventsDelegate()
  let eventsDataSource = EventsDataSource()
  let pastEventsLabel = UILabel(.header)
  let pastEventsTable = UITableView()
  let pastEventsExpandButton = UIButton(type: .system)

  let logoutButton = FBSDKLoginButton()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

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

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.profile
    logoutButton.delegate = self

    view.addSubviews([profileImage, nameLabel, teamLabel, rangePicker,
                      supportersLabel, supportersTable, supportersExpandButton,
                      pastEventsLabel, pastEventsTable, pastEventsExpandButton])

    profileImage.contentMode = .scaleAspectFill
    profileImage.layer.cornerRadius = Style.Size.s128 / 2
    profileImage.layer.masksToBounds = true
    profileImage.layer.borderColor = Style.Colors.grey.cgColor
    profileImage.layer.borderWidth = 1
    profileImage.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(topLayoutGuide.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.size.equalTo(Style.Size.s128)
      ConstraintMaker.centerX.equalToSuperview()
    }

    nameLabel.textAlignment = .center
    nameLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(profileImage.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.leading.trailing.equalToSuperview()
          .inset(Style.Padding.p12)
    }

    teamLabel.textAlignment = .center
    teamLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(nameLabel.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.leading.trailing.equalToSuperview()
          .inset(Style.Padding.p12)
    }

    // TODO(compnerd) make this look better ...
    rangePicker.layer.borderColor = Style.Colors.grey.cgColor
    rangePicker.layer.borderWidth = 1
    rangePicker.inset = UIEdgeInsetsMake(Style.Padding.p8, Style.Padding.p8,
                                         Style.Padding.p8, Style.Padding.p8)
    rangePicker.selection = UserInfo.profileStatsRange
    rangePicker.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(teamLabel.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    supportersLabel.text = Strings.Profile.supporters
    supportersLabel.snp.makeConstraints { (ConstraintMaker) in
      // FIXME(compenrd) this needs to be based off of the previous row of stats
      ConstraintMaker.top.equalTo(rangePicker.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
    }

    supportersTable.allowsSelection = false
    supportersTable.dataSource = supportersDataSource
    supportersTable.register(SupporterCell.self,
                             forCellReuseIdentifier: SupporterCell.identifier)
    supportersTable.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(supportersLabel.snp.bottom)
          .offset(Style.Padding.p8)
      ConstraintMaker.left.right.equalToSuperview().inset(Style.Padding.p12)
      // FIXME(compnerd) how do we generate something reasonable here?
      ConstraintMaker.height.greaterThanOrEqualTo(40.0 * 2.25)
    }

    supportersExpandButton.setTitle(Strings.Profile.showMore, for: .normal)
    supportersExpandButton.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(supportersTable.snp.bottom)
          .offset(Style.Padding.p8)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
    }

    pastEventsLabel.text = Strings.Profile.pastEvents
    pastEventsLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(supportersExpandButton.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
    }

    pastEventsTable.allowsSelection = false
    pastEventsTable.dataSource = eventsDataSource
    pastEventsTable.delegate = eventsDelegate
    pastEventsTable.register(EventCell.self,
                             forCellReuseIdentifier: EventCell.identifier)
    pastEventsTable.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(pastEventsLabel.snp.bottom)
          .offset(Style.Padding.p8)
      ConstraintMaker.left.right.equalToSuperview().inset(Style.Padding.p12)
      // FIXME(compnerd) how do we generate something reasonable here?
      ConstraintMaker.height.greaterThanOrEqualTo(40.0 * 2.25)
    }

    pastEventsExpandButton.setTitle(Strings.Profile.showMore, for: .normal)
    pastEventsExpandButton.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(pastEventsTable.snp.bottom)
          .offset(Style.Padding.p8)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) move this to settings view
    view.addSubview(logoutButton)
    logoutButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-Style.Padding.p12)
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
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    AppController.shared.logout()
  }

  func loginButton(_ loginButton: FBSDKLoginButton!,
                   didCompleteWith result: FBSDKLoginManagerLoginResult!,
                   error: Error!) {
    // Left blank because the user should be logged in when reaching this point
  }
}

