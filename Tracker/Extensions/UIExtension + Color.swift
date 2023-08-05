import UIKit

extension UIColor {
    static var ypBlue: UIColor { UIColor(named: "YP Blue") ?? UIColor.blue }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var ypGrayTwo: UIColor { UIColor(named: "YP GrayTwo") ?? UIColor.gray }
    static var ypGrayThree: UIColor { UIColor(named: "YP GrayThree") ?? UIColor.gray }
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black }
    
    static func bunchOfSChoices(_ number: Int) -> UIColor? { UIColor(named: "ColorSelection\(number)") }
    static let bunchOfSChoices = [
        UIColor(named: "ColorSelection1")!,
        UIColor(named: "ColorSelection2")!,
        UIColor(named: "ColorSelection3")!,
        UIColor(named: "ColorSelection4")!,
        UIColor(named: "ColorSelection5")!,
        UIColor(named: "ColorSelection6")!,
        UIColor(named: "ColorSelection7")!,
        UIColor(named: "ColorSelection8")!,
        UIColor(named: "ColorSelection9")!,
        UIColor(named: "ColorSelection10")!,
        UIColor(named: "ColorSelection11")!,
        UIColor(named: "ColorSelection12")!,
        UIColor(named: "ColorSelection13")!,
        UIColor(named: "ColorSelection14")!,
        UIColor(named: "ColorSelection15")!,
        UIColor(named: "ColorSelection16")!,
        UIColor(named: "ColorSelection17")!,
        UIColor(named: "ColorSelection18")!
    ]
}
