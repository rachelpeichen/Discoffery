//
//  CustomCheckRow&Cell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/19.
//

import Foundation
import Eureka

// MARK: CustomCheckRow
final class CustomCheckRow<T: Equatable>: Row<CustomCheckCell<T>>, SelectableRowType, RowType {

  public var selectableValue: T?

  required public init(tag: String?) {

    super.init(tag: tag)

    displayValueFor = nil
  }
}

// MARK: CustomCheckCell
class CustomCheckCell<T: Equatable>: Cell<T>, CellType {

  required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  required public init?(coder aDecoder: NSCoder) {

    fatalError("init(coder:) has not been implemented")
  }

  // Image for selected state
  lazy public var trueImage: UIImage = {
    return UIImage(named: "selected")!
  }()

  // Image for unselected state
  lazy public var falseImage: UIImage = {
    return UIImage(named: "unselected")!
  }()

  public override func update() {

    super.update()

    checkImageView?.image = row.value != nil ? trueImage : falseImage

    checkImageView?.sizeToFit()
  }

  /// Image view to render images. If `accessoryType` is set to `checkmark`
  /// will create a new `UIImageView` and set it as `accessoryView`.
  /// Otherwise returns `self.imageView`.
  open var checkImageView: UIImageView? {

    guard accessoryType == .checkmark else { return self.imageView }

    guard let accessoryView = accessoryView else {

      let imageView = UIImageView()

      self.accessoryView = imageView

      return imageView
    }

    return accessoryView as? UIImageView
  }

  public override func setup() {

    super.setup()

    accessoryType = .none
  }

  public override func didSelect() {

    row.reload()

    row.select()

    row.deselect()
  }
}

// MARK: WeekDayRow
final class WeekDayRow: Row<WeekDayCell>, RowType {

  required public init(tag: String?) {
    super.init(tag: tag)
    displayValueFor = nil
    cellProvider = CellProvider<WeekDayCell>(nibName: "WeekDaysCell")
  }
}

// MARK: WeeklyDayCell
public enum WeekDay {
  case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

public class WeekDayCell : Cell<Set<WeekDay>>, CellType {

  @IBOutlet var sundayButton: UIButton!
  @IBOutlet var mondayButton: UIButton!
  @IBOutlet var tuesdayButton: UIButton!
  @IBOutlet var wednesdayButton: UIButton!
  @IBOutlet var thursdayButton: UIButton!
  @IBOutlet var fridayButton: UIButton!
  @IBOutlet var saturdayButton: UIButton!

  open override func setup() {
    height = { 60 }
    row.title = nil
    super.setup()
    selectionStyle = .none
    for subview in contentView.subviews {
      if let button = subview as? UIButton {
        button.setImage(UIImage(named: "checkedDay"), for: .selected)
        button.setImage(UIImage(named: "uncheckedDay"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        imageTopTitleBottom(button)
      }
    }
  }

  open override func update() {
    row.title = nil
    super.update()
    let value = row.value
    mondayButton.isSelected = value?.contains(.monday) ?? false
    tuesdayButton.isSelected = value?.contains(.tuesday) ?? false
    wednesdayButton.isSelected = value?.contains(.wednesday) ?? false
    thursdayButton.isSelected = value?.contains(.thursday) ?? false
    fridayButton.isSelected = value?.contains(.friday) ?? false
    saturdayButton.isSelected = value?.contains(.saturday) ?? false
    sundayButton.isSelected = value?.contains(.sunday) ?? false

    mondayButton.alpha = row.isDisabled ? 0.6 : 1.0
    tuesdayButton.alpha = mondayButton.alpha
    wednesdayButton.alpha = mondayButton.alpha
    thursdayButton.alpha = mondayButton.alpha
    fridayButton.alpha = mondayButton.alpha
    saturdayButton.alpha = mondayButton.alpha
    sundayButton.alpha = mondayButton.alpha
  }

  @IBAction func dayTapped(_ sender: UIButton) {
    dayTapped(sender, day: getDayFromButton(sender))
  }

  private func getDayFromButton(_ button: UIButton) -> WeekDay{
    switch button{
    case sundayButton:
      return .sunday
    case mondayButton:
      return .monday
    case tuesdayButton:
      return .tuesday
    case wednesdayButton:
      return .wednesday
    case thursdayButton:
      return .thursday
    case fridayButton:
      return .friday
    default:
      return .saturday
    }
  }

  private func dayTapped(_ button: UIButton, day: WeekDay){
    button.isSelected = !button.isSelected
    if button.isSelected{
      row.value?.insert(day)
    }
    else{
      _ = row.value?.remove(day)
    }
  }

  private func imageTopTitleBottom(_ button : UIButton){

    guard let imageSize = button.imageView?.image?.size else { return }
    let spacing : CGFloat = 3.0
    button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
    guard let titleLabel = button.titleLabel, let title = titleLabel.text else { return }
    let titleSize = title.size(withAttributes: [.font: titleLabel.font!])
    button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
  }
}
