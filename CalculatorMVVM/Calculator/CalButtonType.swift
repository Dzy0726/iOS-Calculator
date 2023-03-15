import Foundation
import SwiftUI


enum CalButtonType {
    case number(_ text:String)
    case calOperator(_ text:String)
    case calSOperator(_ text:String)
    
    var text:String {
        switch self {
        case let .number(text) :
            return text;
        case let .calOperator(text) :
            return text;
        case let .calSOperator(text) :
            return text;
        }
    }
    
    var fgColor : Color {
        switch self {
        case .number(_):
            return Color("digit_fg")
        case .calOperator(_):
            return Color("operator_fg")
        case .calSOperator(_):
            return Color("s_operator_fg")
        }
    }
    
    var bgColor : Color {
        switch self {
        case .number(_):
            return Color("digit_bg")
        case .calOperator(_):
            return Color("operator_bg")
        case .calSOperator(_):
            return Color("s_operator_bg")
        }
    }
}


prefix operator %
prefix operator -
prefix operator +

prefix func %(right: String) -> CalButtonType {
    return .calSOperator(right)
}

prefix func -(right: String) -> CalButtonType {
    return .calOperator(right)
}

prefix func +(right: String) -> CalButtonType {
    return .number(right)
}

let calculatorNumber:[[CalButtonType]] = [[%"AC",%"±",%"％",-"÷"],
                                          [+"7",+"8",+"9",-"×"],
                                          [+"4",+"5",+"6",-"-"],
                                          [+"1",+"2",+"3",-"+"],
                                          [+"0",+".",-"="],]
