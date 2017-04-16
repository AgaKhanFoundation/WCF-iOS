
import UIKit
import SnapKit

struct LeaderBoardEntry {
  let imageURL: URL?
  let name: String
  let standing: Int
  let distance: Float
  let raised: Float
}

class LeaderBoardCell: UITableViewCell, IdentifiedUITableViewCell {
  static var identifier: String = "LeaderBoardCell"

  internal var standing: UILabel = UILabel(.header)
  internal var picture: UIImageView = UIImageView()
  internal var name: UILabel = UILabel(.body)
  internal var distance: UILabel = UILabel(.body)
  internal var raised: UILabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([standing, picture, name, distance, raised])

    standing.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
      // TODO(compnerd) figure out the right way to get this value
      ConstraintMaker.width.height.equalTo(Style.Size.s32)
      ConstraintMaker.centerY.equalToSuperview()
    }

    picture.layer.backgroundColor = Style.Colors.grey.cgColor
    // TODO(compnerd) figure out the right way to get this value
    picture.layer.cornerRadius = Style.Size.s32 / 2.0
    picture.layer.masksToBounds = true
    picture.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(standing.snp.right)
          .offset(Style.Padding.p8)
      // TODO(compnerd) figure out the right way to get this value
      ConstraintMaker.height.width.equalTo(Style.Size.s32)
      ConstraintMaker.centerY.equalToSuperview()
    }

    name.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(picture.snp.right)
          .offset(Style.Padding.p12)
      ConstraintMaker.centerY.equalToSuperview()
    }

    distance.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.bottom.equalTo(name.snp.centerY)
      ConstraintMaker.width.equalTo(raised.snp.width)
    }

    raised.textColor = Style.Colors.grey
    raised.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.top.equalTo(name.snp.centerY)
    }
  }
}

extension LeaderBoardCell: ConfigurableUITableViewCell {
  func configure(_ data: Any) {
    guard let info = data as? LeaderBoardEntry else { return }

    standing.text = "\(info.standing)."
    name.text = info.name

    // TODO(compnerd) localise this properly
    distance.text = "\(info.distance) miles"

    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    raised.text = currencyFormatter.string(from: NSNumber(value: info.raised))
  }
}

protocol LeaderBoardDataSource {
  var leaders: Array<LeaderBoardEntry> { get }
}

class LeaderBoard: UITableView {
  var data: LeaderBoardDataSource?

  convenience init() {
    self.init(frame: CGRect.zero)
    self.allowsSelection = false
    self.dataSource = self
    self.register(LeaderBoardCell.self,
                  forCellReuseIdentifier: LeaderBoardCell.identifier)
  }
}

extension LeaderBoard: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    guard (data != nil) else { return 0 }
    return data!.leaders.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let entry = data?.leaders[safe: indexPath.row],
      let cell =
          tableView.dequeueReusableCell(withIdentifier: LeaderBoardCell.identifier,
                                        for: indexPath) as? ConfigurableUITableViewCell
    else { return UITableViewCell() }

    cell.configure(entry)
    return cell as! UITableViewCell
  }
}

