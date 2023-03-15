import Foundation
import SwiftUI


struct CalData{
    var touchOpr = false
    
    var numbers :[Double] = [0]
    
    var operators : [String] = [] {
        didSet{
            if touchOpr == false{
                touchOpr = true
            }else {
                touchOpr = false
            }
        }
    }
    var leftNumber : Double = 0 {
        didSet {
            self.leftSetted = true
            if !self.rightSetted {
                self.rightNumber = self.leftNumber
            }
        }
    }
    var leftSetted : Bool = false
    
    var rightNumber : Double = 0
    {
        didSet {
            self.rightSetted = true
        }
    }
    
    var rightSetted : Bool = false
    
    var resultNum : Double = 0
    
    var currentFmtStr = "%d"
    
    var text : String = "0" {
        didSet{
            print("self.text:\(self.text)")
        }
    }
    
    var opacity : Double = 1
    
    mutating func inputNumber(_ text : String) {
        
        let index = self.numbers.count - 1
        var num = self.numbers[index]
        
        let currentNum = Double(text) ?? 0
        
        if self.text.contains(".")  && touchOpr == false{
            print("包含. : \(self.text)")
            // 包含点说明当前已经是小数
            if text != "."  {
                let pointIndex = self.text.firstIndex(of: ".") ?? self.text.endIndex
                
                let floatNumLength = self.text.distance(from: pointIndex, to: self.text.endIndex)
                
                self.currentFmtStr = "%.\(floatNumLength)f"
                
                num = currentNum / (pow(Double(10), Double(floatNumLength))) + num
                
            }
        }else {
            //是整数
            self.touchOpr = false
            if text == "." {
                self.currentFmtStr = "%d."
            }else {
                num = num * 10.0 + currentNum
            }
        }
        
        self.numbers[index] = num
        
        self.text = String(format: self.currentFmtStr, self.currentFmtStr.contains("d") ? Int(num) : num)
        
        if self.leftSetted {
            self.rightNumber = num
        } else {
            self.resultNum = num
        }
        
        print("leftNumber:\(self.leftNumber) ---rightNumber:\(self.rightNumber) --- resultNumber:\(self.resultNum) ")
    }
    
    
    mutating func setText(_ num : Double) {
        if abs(num) > Double(Int(abs(num))) {
            self.text = "\(num)"
        }else {
            self.text = "\(Int(num))"
        }
    }
    
    mutating func reset() {
        self.numbers = [0]
        self.operators.removeAll()
        
        self.leftNumber = 0
        self.leftSetted = false
        
        self.rightNumber = 0
        self.rightSetted = false
        
        self.text = "0"
        self.currentFmtStr = "%d"
        
        self.resultNum = 0
    }
}

struct CustomButton : View {
    
    let type : CalButtonType
    
    @Binding var data : CalData
    
    init(_ type : CalButtonType,_ data :Binding<CalData>) {
        
        self.type = type
        self._data = data
    }
    
    var body: some View {
        Button(action: {
            
            switch self.type {
            
            case let .number(text) :
                self.data.inputNumber(text)
                break
                
            case let .calOperator(textStr) :
                self.data.leftNumber = self.data.resultNum
                if textStr == "=" {
                    
                    if let calOperator = self.data.operators.last {
                        
                        if calOperator == "+" {
                            self.data.resultNum = self.data.leftNumber + self.data.rightNumber
                        }
                        else if calOperator == "-" {
                            self.data.resultNum = self.data.leftNumber - self.data.rightNumber
                        }
                        else if calOperator == "×" {
                            self.data.resultNum = self.data.leftNumber * self.data.rightNumber
                        }
                        else if calOperator == "÷" {
                            
                            if self.data.rightNumber != 0 {
                                
                                self.data.resultNum = self.data.leftNumber / self.data.rightNumber
                            }
                            else {
                                self.data.reset()
                                self.data.text = "NaN"
                                return
                            }
                        }
                    }
                    else {
                        self.data.leftSetted = false
                    }
                }
                
                else {
                    self.data.operators.append(textStr)
                    self.data.rightSetted = false
                    self.data.numbers.append(0)
                }
                
                print("self.data.resultNum:\(self.data.resultNum)")
                self.data.setText(self.data.resultNum)
                self.data.currentFmtStr = "%d"
                
                //闪烁动画
                withAnimation(Animation.easeInOut(duration: 0.1), {
                    self.data.opacity = 0.5
                })
                
                withAnimation(Animation.easeInOut(duration: 0.1).delay(0.1), {
                    self.data.opacity = 1
                    
                })
                break
                
            case let .calSOperator(textStr) :
                switch textStr {
                case "AC" :
                    self.data.reset()
                    break
                case "±" :
                    self.data.resultNum = -self.data.resultNum
                    self.data.setText(self.data.resultNum)
                    break
                case "％" :
                    self.data.resultNum = self.data.resultNum / 100
                    self.data.setText(self.data.resultNum)
                    break
                default :
                    break
                }
                //闪烁动画
                withAnimation(Animation.easeInOut(duration: 0.1), {
                    self.data.opacity = 0.5
                })
                
                withAnimation(Animation.easeInOut(duration: 0.1).delay(0.1), {
                    self.data.opacity = 1
                })
                break
            }
            
        }){
            Text(self.type.text)
                .modifier(CalculatorModifier(type : self.type))
                .frame(minWidth:0,maxWidth:.infinity,minHeight:0,maxHeight:.infinity,alignment:.center)
        }
    }
}

struct CalculatorModifier : ViewModifier {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let type : CalButtonType
    func body(content: Content) -> some View {
        content.padding(.leading,self.type.text == "0" ? 40 : 20)
            .frame(width:self.type.text == "0" ? (width-200)/4 : (width-200)/4,height: (height-400)/5,alignment: self.type.text == "0" ? .leading : .center)
            
            //.frame(width:self.type.text == "0" ? 165 : 80,height:80,alignment: self.type.text == "0" ? .leading : .center)
            .font(.title)
            .background(self.type.bgColor)
            .foregroundColor(self.type.fgColor)
            //.cornerRadius(500.0)
    }
}

struct CalculatorBrain_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
