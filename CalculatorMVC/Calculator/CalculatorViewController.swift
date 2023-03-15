import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var displayValueOutlet: UILabel!
    var displayValue: Double {
        get {
            return Double(displayValueOutlet.text!)!
        }
        set {
            if Double(Int(newValue)) == newValue {
                displayValueOutlet.text = String(Int(newValue))
            }else {
                displayValueOutlet.text = String(newValue)
            }
        }
    }
    
    var brain = CalcuatorBrain()
    
    var userIsInTyping: Bool = false

    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        let textCurrentInDisplay = displayValueOutlet.text!
        // 如果正在输入中
        if userIsInTyping {
            if digit == "0" && textCurrentInDisplay == "0" {
                displayValueOutlet.text = "0"
            }
            else {
                displayValueOutlet.text = textCurrentInDisplay + digit
            }
        }
        else {
            
            if digit == "." {
                displayValueOutlet.text = "0."
            }else {
                displayValueOutlet.text = digit
            }
            userIsInTyping = true
        }
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        // 1. 设置操作数
        if userIsInTyping {
            brain.setOperand(displayValue)
            // 设置完操作符之后，需要接受第二个操作数
            userIsInTyping = false
        }
        // 2.执行计算
        brain.performOperation(sender.currentTitle!)
        
        // 3.获取结果
        if let result = brain.result {
            displayValue = result
        }
    }
    
}
extension CalculatorViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


