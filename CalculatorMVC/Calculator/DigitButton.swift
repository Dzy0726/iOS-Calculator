import UIKit

class DigitButton: UIButton {
    
    // MARK: 将矩形Button变为圆角，仿iOS原生计算器

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height * 0.5
        layer.masksToBounds = true
    }

}
