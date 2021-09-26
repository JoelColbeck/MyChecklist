//
//  Extensions.swift
//  nespresso-academy-ios
//
//  Created by Ekaterina on 23.11.2018.
//  Copyright © 2017 Trinity Digital. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import Alamofire

enum InternetConnectionStatus {
    case unknown
    case notReachable
    case reachableViaWiFi
    case reachableViaCellular
}

enum NAError: Error {
    case connectionError
    case incorrectData
    case cancel
    case removeFile
    case syncError
    case permissionDenied
    case unknown
    case transactionValidation
    case noResponse
    case unauthorized
}

var connectionStatus: InternetConnectionStatus {
    return .unknown
}

var bottomSafeAreaInset: CGFloat {
    guard
        let window = UIApplication.shared
            .windows
            .filter( {$0.isKeyWindow} ).first
    else { return .zero }
    return window.safeAreaInsets.bottom
}

var topSafeAreaInset: CGFloat {
    guard
        let window = UIApplication.shared
            .windows
            .filter( {$0.isKeyWindow} ).first
    else { return .zero }
    return window.safeAreaInsets.top
}

var window: UIWindow {
    UIApplication.shared.windows[0]
}

private enum CountTextType: Int {
    case one, two, many
}

private func countTextTypeWithCount(_ count: Int) -> CountTextType {
    var countLastSymbol: String = "\(count)"
    let countString = NSString(string: countLastSymbol)
    if countString.length > 1 {
        let prevSymbol = countString.substring(with: NSRange(location: countString.length - 2, length: 1))
        let lastSymbol = countString.substring(with: NSRange(location: countString.length - 1, length: 1))
        if prevSymbol == "1" {
            return .many
        }
        countLastSymbol = lastSymbol
    }
    if countLastSymbol == "1" {
        return .one
    } else if countLastSymbol == "2" || countLastSymbol == "3" || countLastSymbol == "4" {
        return .two
    }
    return .many
}

func createDateFromComponents(year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, timezone: String? = nil) -> Date? {
    var gregorianCalendar = Calendar(identifier: .gregorian)
    if let timezone = timezone {
        gregorianCalendar.timeZone = TimeZone(abbreviation: timezone) ?? TimeZone.current
    } else {
        gregorianCalendar.timeZone = TimeZone.current
    }
    var components = DateComponents()
    components.setValue(year, for: .year)
    components.setValue(month, for: .month)
    components.setValue(day, for: .day)
    components.setValue(hour, for: .hour)
    components.setValue(minute, for: .minute)
    components.setValue(0, for: .second)
    return gregorianCalendar.date(from: components)
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension Int {
    
    public static var random: Int {
        return Int.random(n: Int.max)
    }
    
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    public static func random(min: Int, max: Int) -> Int {
        return Int.random(n: max - min + 1) + min
    }
    
    func hourWithTimezone() -> Int {
        let difference = TimeZone.current.secondsFromGMT()
        return self + (difference/3600)
    }
    
    func convertToReadableCurrency(numToSeparate: Int = 3) -> String {
        let pointerDefaultValue = 1
        let string = String(self)
        var result = ""
        var pointer = pointerDefaultValue
        
        for char in string.reversed() {
            result = String(char) + result
            
            if pointer == numToSeparate {
                result = " " + result
                pointer = pointerDefaultValue
            } else {
                pointer += 1
            }
        }
        
        return result.trimmingCharacters(in: .whitespaces)
    }
    
    func toReadableFormatString(terminator: String = "") -> String {
        let formatter = NumberFormatter()
//        formatter.minimumFractionDigits = 2
        formatter.groupingSize = 3
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        let selfPositive = self < 0 ? self * -1 : self
        let number = NSNumber(value: selfPositive)
        
        return formatter.string(from: number)! + terminator
    }
    
    var isNullable: Bool {
        return self == 0
    }
}

extension Double {
    
    public static var random: Double {
        return Double(arc4random())/0xFFFFFFFF
    }
    
    public static func random(min: Double, max: Double) -> Double {
        return Double.random*(max-min)+min
    }
    
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var isNullable: Bool {
        return self == 0.0
    }
    
    func toReadableFormatString(terminator: String = "") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSize = 3
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        let selfPositive = self < 0 ? self * -1.0 : self
        let number = NSNumber(value: selfPositive)
        
        return formatter.string(from: number)! + terminator
    }
}

extension UITableView {
    func reloadData(transition type: String,
                    subtype: String? = nil,
                    timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: . easeInEaseOut),
                    duration: TimeInterval = 0.2) {
        let animation = CATransition()
        animation.type = CATransitionType(rawValue: type)
        if let subtype = subtype {
            animation.subtype = CATransitionSubtype(rawValue: subtype)
        }
        animation.timingFunction = timingFunction
        animation.fillMode = CAMediaTimingFillMode.both
        animation.duration = duration
        self.layer.add(animation, forKey: "UITableViewReloadDataAnimationKey")
        self.reloadData()
    }
}

extension UIImage {
    
    class func backgroundImage(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func multiplyImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        self.draw(in: rect, blendMode: .multiply, alpha: 1)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    static func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func resizeImageToMaxSide(maxSize: CGFloat) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        guard width > maxSize || height > maxSize else { return self }
        let aspect = width / height
        
        var newWidth: CGFloat!
        var newHeight: CGFloat!
        if aspect > 1 {
            newWidth = maxSize
            newHeight = newWidth / aspect
        } else {
            newHeight = maxSize
            newWidth = newHeight * aspect
        }
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    enum GradientDirection: Int {
        case vertical = 0, horizontal
    }
    
    func makeGradientedImage(_ size: CGSize, endColor: UIColor, startColor: UIColor, direction: GradientDirection = .vertical) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        let startPoint = direction == .vertical ? CGPoint(x: size.width * 0.5, y: size.height) : CGPoint(x: size.width, y: size.height * 0.5)
        let endPoint = direction == .vertical ? CGPoint(x: size.width * 0.5, y: 0) : CGPoint(x: 0, y: size.height * 0.5)
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState state: UIControl.State) {
        let backgroundImage = UIImage.backgroundImage(withColor: color)
        setBackgroundImage(backgroundImage, for: state)
    }
}
extension Date {
    
    func offsetFrom(date: Date) -> String {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: self, to: date)

        let seconds = "\(difference.second ?? 0) секунд"
        let minutes = "\(difference.minute ?? 0) минут"
        let hours = "\(difference.hour ?? 0) часов" + " " + minutes

        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone.init(identifier: "Europe/Moscow")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toShortYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone.init(identifier: "Europe/Moscow")
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: self)
    }
    
    func toReadableMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = TimeZone.init(identifier: "Europe/Moscow")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    static func serverStringToDate(_ string: String) -> Date? {
        //2019-02-13T19:29:13+03:00
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(identifier: "Europe/Moscow")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: string)
    }
    
    func toOptimizedTitleString() -> String {
        if self.isToday {
            return "Сегодня в " + self.toTimeString()
        } else if self.isTomorrow {
            return "Завтра в " + self.toTimeString()
        } else if self.isYesterday {
            return "Вчера в " + self.toTimeString()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "E, d MMM"
        return (dateFormatter.string(from: self) + " в " + toTimeString())
    }
    
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func isGreater(thanDate date: Date, minutes: Int = 0) -> Bool {
        return self.timeIntervalSince(date) > Double(60 * minutes)
    }
    
    func getComponent(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    var isCurrentYear: Bool {
        return Calendar.current.component(Calendar.Component.year, from: self) == Calendar.current.component(Calendar.Component.year, from: Date())
    }
    
    /// Получаем дату — текущая +/- дни
    public func dateByAddingDays(_ days: Int) -> Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day,
                                             value: days,
                                             to: self,
                                             options: [])!
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
}

extension NumberFormatter {
    static let timerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        formatter.minimumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}

extension String {
    
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    func clean() -> String {
        return self
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
    }
    
    static func height(boundingWidth width: CGFloat, text: String, font: UIFont) -> CGFloat {
        return ceil(NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                        options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                        attributes: [.font: font],
                                                        context: nil).size.height)
    }
    
    static func width(boundingHeight height: CGFloat, text: String, font: UIFont) -> CGFloat {
        return ceil(NSString(string: text).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
                                                        options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                        attributes: [.font: font],
                                                        context: nil).size.width)
    }
    
    static func timerString(interval: TimeInterval) -> String {
        let minutes = Int(interval / 60)
        let hours = Int(minutes / 60)
        let extraMinutes = minutes - hours*60
        let extraSeconds = Int(interval) - minutes*60
        var result = ""
        if hours > 0 {
            result += (NumberFormatter.timerFormatter.string(from: hours as NSNumber) ?? "") + ":"
        }
        result += (NumberFormatter.timerFormatter.string(from: extraMinutes as NSNumber) ?? "") + ":"
        result += (NumberFormatter.timerFormatter.string(from: extraSeconds as NSNumber) ?? "")
        return result
    }
    
    var first: String {
        return String(prefix(1))
    }
    var last: String {
        return String(suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
    }
    
    func makeSpaces() -> String {
        guard self.count > 0 else { return self }
        let tryRegexPattern = try? NSRegularExpression(pattern: "\\d{4}", options: .caseInsensitive)
        guard let regexPattern = tryRegexPattern else { return self }
        let nsString = NSString(string: self)
        let matches = regexPattern.matches(in: self, options: .withoutAnchoringBounds, range: nsString.range(of: self))
        guard matches.count > 0 else { return self }
        let matchStrings = matches.compactMap { (result) -> String? in
            return nsString.substring(with: result.range)
        }
        let count = matches.count > 4 ? 4 : matches.count
        let components = matchStrings.prefix(count)
        let lastMatchRange = matches[count-1].range
        let number = components.joined(separator: " ") + nsString.substring(from: lastMatchRange.location + lastMatchRange.length)
        return number
    }
    
    var localized: String {
        return localizedWithComment("")
    }
    
    func localizedWithComment(_ comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
    
    var isEmptyOrWhitespace: Bool {
        return self.trim() == ""
    }
    
    func trim() -> String {
        if self.isEmpty {
            return ""
        }
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    /** Implement attributes to characters surrounded within the delimiter characters & return them. Example: "This is $$bold$$ text". */
    func customize(attributes: [NSAttributedString.Key: Any], delimiter: String) -> NSMutableAttributedString {
        let string = self as NSString
        let attributedString = NSMutableAttributedString(string: string as String)
        attributedString.customize(attributes: attributes, delimiter: delimiter)
        return attributedString
    }
    
    /** Simplification of the 'customize()' method. It only accepts color. */
    func highlight(with color: UIColor, delimiter: String) -> NSMutableAttributedString {
        return self.customize(attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color], delimiter: delimiter)
    }
    func addAttributes(attributes: [NSAttributedString.Key: Any], delimiter: String) -> NSMutableAttributedString {
        return self.customize(attributes: attributes, delimiter: delimiter)
    }
    
    func applyCardMask() -> String {
        if self.count >= 8 {
            let arr = Array(self)
            return "\(arr[0])\(arr[1])\(arr[2])\(arr[3]) **** **** \(arr[count - 4])\(arr[count - 3])\(arr[count - 2])\(arr[count - 1])"
        } else {
            return self
        }
    }
    
    public static func getDescriptionString(value: [String: Any]?, header: String) -> String {
        guard let value = value else { return "" }
        var logString = "\(header): ["
        value.forEach({ (key, value) in
            logString += key + ": \(value), "
        })
        logString.removeLast()
        logString += "]\n"
        return logString
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func getSymbol() -> String? {
        let locale = NSLocale(localeIdentifier: self)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: self)
    }
}

extension Optional where Wrapped == String {
    func isNilOrEmpty() -> Bool {
        self == nil || self!.isEmpty
    }
    
    func hasValue() -> Bool {
        !isNilOrEmpty()
    }
}

extension NSMutableAttributedString {
    func highlight(with color: UIColor, delimiter: String) {
        self.customize(attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color], delimiter: delimiter)
    }
    func addAttributes(attributes: [NSAttributedString.Key: Any], delimiter: String) {
        self.customize(attributes: attributes, delimiter: delimiter)
    }
    func customize(attributes: [NSAttributedString.Key: Any], delimiter: String) {
        let escaped = NSRegularExpression.escapedPattern(for: delimiter)
        if let regex = try? NSRegularExpression(pattern: "\(escaped)(.*?)\(escaped)", options: []) {
            var offset = 0
            regex.enumerateMatches(in: self.string,
                                   options: [],
                                   range: NSRange(location: 0,
                                                  length: self.string.count)) { (result, _, _) -> Void in
                                                    guard let result = result else {
                                                        return
                                                    }
                                                    
                                                    let range = NSRange(location: result.range.location + offset, length: result.range.length)
                                                    self.addAttributes(attributes, range: range)
                                                    let replacement = regex.replacementString(for: result, in: self.string, offset: offset, template: "$1")
                                                    self.replaceCharacters(in: range, with: replacement)
                                                    offset -= (2 * delimiter.count)
            }
        }
    }
}


extension UIView {
    
    private var gradientlayer: CAGradientLayer? {
        var grLayer: CAGradientLayer?
        if let sublayers = self.layer.sublayers {
            for layer in sublayers {
                if let glayer  = layer as? CAGradientLayer {
                    grLayer = glayer
                    break
                }
            }
        }
        return grLayer
    }
    
    func shake() {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.values = [ NSValue.init(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0)),
                             NSValue.init(caTransform3D: CATransform3DMakeTranslation(5, 0, 0)) ]
        animation.autoreverses = true
        animation.repeatCount = 2
        animation.duration = 0.07
        self.layer.add(animation, forKey: nil)
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.duration = 0.2
        self.layer.add(transition, forKey: kCATransition)
    }
    
    func setGradient(_ colors: [UIColor], horizontal: Bool = false) {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        self.gradientlayer?.removeFromSuperlayer()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map({ (color) -> CGColor in
            return color.cgColor
        })
        gradient.startPoint = horizontal ? CGPoint(x: 0.0, y: 0.5) : CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = horizontal ? CGPoint(x: 1.0, y: 0.5) : CGPoint(x: 0.5, y: 1.0)
        var locations = [NSNumber]()
        for i in 0..<colors.count {
            let doubleValue = Double(i)*1.0/Double(colors.count - 1)
            let location = NSNumber(value: Double(round(100*doubleValue)/100) as Double)
            locations.append(location)
        }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func updateGradient(rect: CGRect? = nil) {
        gradientlayer?.frame = rect ?? self.bounds
    }
    
    func addShadow(_ color: UIColor = UIColor.black, offset: CGSize = CGSize(width: 0.0, height: 0.0), radius: CGFloat = 10, opacity: Float = 0.15) {
        shadowColor = color
        shadowOffset = offset
        shadowOpacity = opacity
        shadowRadius = radius
    }
    
    func fadeIn(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
            self.isHidden = true
        })
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(withClass: T.Type) -> T? {
        return instantiateViewController(withIdentifier: withClass.identifier) as? T
    }
}

extension UITableView {
    func register<T: UITableViewCell>(nib: T.Type) {
        self.register(UINib(nibName: String(describing: nib), bundle: nil), forCellReuseIdentifier: String(describing: nib))
    }
    func register<T: UITableViewCell>(class cellClass: T.Type) {
        self.register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func register<T: UITableViewHeaderFooterView>(nib: T.Type) {
        self.register(UINib(nibName: String(describing: nib), bundle: nil),
                      forHeaderFooterViewReuseIdentifier:  String(describing: nib))
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(nib: T.Type) {
        self.register(UINib(nibName: String(describing: nib), bundle: nil), forCellWithReuseIdentifier: String(describing: nib))
    }
    func register<T: UICollectionViewCell>(class cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}


extension UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}

extension URL {
    
    @discardableResult
    func addSkipBackupAttributeToItemAtURL() -> Bool {
        var url = self
        var success: Bool
        
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try url.setResourceValues(resourceValues)
            success = true
        } catch let error as NSError {
            success = false
            print("Error excluding \(url.lastPathComponent) from backup \(error)")
        }
        return success
    }
}

extension URLRequest {
  
    var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = #"curl "\#(url.absoluteString)""#
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
    
    init?(curlString: String) {
        return nil
    }
    
}

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

extension Sequence {
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension Sequence where Iterator.Element: Equatable {
    func unique() -> [Iterator.Element] {
        return reduce([], { collection, element in collection.contains(element) ? collection : collection + [element] })
    }
}

extension UISearchBar {
    func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    // swiftlint:disable:next file_length
}

extension UIView {
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
            else { fatalError("missing expected nib named: \(name)") }
        guard
            let view = nib.first as? Self
            else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}

extension UITableView {

    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6,
                           delay: 0.08 * Double(delayCounter),
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform.identity
                           }, completion: nil)
            delayCounter += 1
        }
    }
}

extension UIView {
    
    func strokeBorder() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.mask = maskLayer
        
        let line = NSNumber(value: Float(self.bounds.width / 2))
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineDashPattern = [line]
        borderLayer.lineDashPhase = self.bounds.width / 4
        borderLayer.lineWidth = 10
        borderLayer.frame = self.bounds
        self.layer.cornerRadius = 5
        self.layer.addSublayer(borderLayer)
    }
}

extension UILabel {

    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(spacingValue: CGFloat = 2) {

        // MARK: - Check if there's any text
        guard let textString = text else { return }

        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString(string: textString)

        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()

        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue

        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }
    
    var textOrEmpty: String {
        return text ?? ""
    }
}

extension UIStackView {
    func clear() {
        for subview in arrangedSubviews {
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}

extension Array {
    func some(fn: (Element) -> Bool) -> Bool {
        for item in self {
            if fn(item) {
                return true
            }
        }
        
        return false
    }
    
    func every(fn: (Element) -> Bool) -> Bool {
        for item in self {
            if !fn(item) {
                return false
            }
        }
        
        return true
    }
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

extension UITextField {
    var textOrEmpty: String {
        return text ?? ""
    }
    
    func setDefaultHighlighting() {
        layer.borderColor = UIColor.clear.cgColor
    }
}

extension FloatingPoint {
    static func getProjection(initialVelocity: Self, decelerationRate: Self) -> Self {
        if decelerationRate >= 1 {
            assert(false)
            return initialVelocity
        }
        
        return initialVelocity * decelerationRate / (1 - decelerationRate)
    }
    
    func getProjection(initialVelocity: Self, decelerationRate: Self) -> Self {
        return self + Self.getProjection(initialVelocity: initialVelocity, decelerationRate: decelerationRate)
    }
    
    func isLess(than other: Self, eps: Self) -> Bool {
        return self < other - eps
    }
    
    func isGreater(than other: Self, eps: Self) -> Bool {
        return self > other + eps
    }
    
    func isEqual(to other: Self, eps: Self) -> Bool {
        return abs(self - other) < eps
    }
}

extension Collection where Element: Comparable & SignedNumeric {
    func nearestElement(to value: Element) -> Element? {
        
        return self.min(by: { abs($0 - value) < abs($1 - value) })
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension ClosedRange where Bound: FloatingPoint {
    func contains(_ element: Bound, eps: Bound) -> Bool {
        return element.isGreater(than: lowerBound, eps: eps) && element.isLess(than: upperBound, eps: eps)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

extension UIDevice {
    var hasNotch: Bool {
        guard
            let window = UIApplication.shared
                .windows
                .filter({ $0.isKeyWindow })
                .first
        else { return false }
        return window.safeAreaInsets.top >= 44
    }
}
