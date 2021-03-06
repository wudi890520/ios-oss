import KsApi
import Library
import Prelude
import ReactiveExtensions
import UIKit

internal protocol BackingCellDelegate: class {
  /// Call when should navigate to Backing Info.
  func backingCellGoToBackingInfo()
}

internal final class BackingCell: UITableViewCell, ValueCell {
  fileprivate let viewModel: BackingCellViewModelType = BackingCellViewModel()

  @IBOutlet private weak var backingInfoButton: UIButton!
  @IBOutlet private weak var deliveryLabel: UILabel!
  @IBOutlet private weak var dividerView: UIView!
  @IBOutlet private weak var pledgedLabel: UILabel!
  @IBOutlet private weak var rewardLabel: UILabel!
  @IBOutlet private weak var rootStackView: UIStackView!

  internal weak var delegate: BackingCellDelegate?

  internal override func awakeFromNib() {
    super.awakeFromNib()

    self.backingInfoButton.addTarget(self, action: #selector(backingInfoButtonTapped),
                                     for: .touchUpInside)
  }

  internal func configureWith(value: (Backing, Project)) {
    self.viewModel.inputs.configureWith(backing: value.0, project: value.1)
  }

  internal override func bindStyles() {
    super.bindStyles()

    _ = self
      |> baseTableViewCellStyle()
      |> BackingCell.lens.contentView.layoutMargins %~~ { _, cell in
        cell.traitCollection.isRegularRegular
          ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(16))
          : .init(topBottom: Styles.grid(3), leftRight: Styles.grid(2))
    }

    _ = self.backingInfoButton
      |> borderButtonStyle
      |> UIButton.lens.title(forState: .normal) %~ { _ in Strings.backing_info_info_button() }
      |> UIButton.lens.contentEdgeInsets %~~ { _, button in
        button.traitCollection.isRegularRegular
          ? .init(topBottom: Styles.grid(2), leftRight: Styles.grid(3))
          : .init(topBottom: Styles.gridHalf(3), leftRight: Styles.gridHalf(5))
    }

    _ = self.deliveryLabel
      |> UILabel.lens.textColor .~ .ksr_navy_600
      |> UILabel.lens.font .~ UIFont.ksr_caption1()

    _ = self.dividerView
      |> separatorStyle

    _ = self.pledgedLabel
      |> UILabel.lens.textColor .~ .ksr_text_navy_700
      |> UILabel.lens.font .~ UIFont.ksr_headline()

    _ = self.rewardLabel
      |> UILabel.lens.textColor .~ .ksr_text_navy_700
      |> UILabel.lens.font .~ .ksr_subhead()
  }

  internal override func bindViewModel() {
    super.bindViewModel()

    self.pledgedLabel.rac.text = self.viewModel.outputs.pledged
    self.rewardLabel.rac.text = self.viewModel.outputs.reward
    self.deliveryLabel.rac.text = self.viewModel.outputs.delivery
    self.deliveryLabel.rac.accessibilityLabel = self.viewModel.outputs.deliveryAccessibilityLabel
    self.rootStackView.rac.alignment = self.viewModel.outputs.rootStackViewAlignment
  }

  @objc private func backingInfoButtonTapped() {
    self.delegate?.backingCellGoToBackingInfo()
  }
}
