//
//  extension.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/26.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Foundation

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}


extension UIColor {
    class var sandBrown: UIColor {
        return UIColor(red: 211.0 / 255.0, green: 150.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
    }

    class var brownish: UIColor {
        return UIColor(red: 160.0 / 255.0, green: 98.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    }

    class var darkSalmon: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 113.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0)
    }

    class var darkSand: UIColor {
        return UIColor(red: 166.0 / 255.0, green: 145.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    }

    class var paleTwo: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 241.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }

    class var paleGold: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 197.0 / 255.0, blue: 111.0 / 255.0, alpha: 1.0)
    }

    class var denimBlue: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }

    class var coolGrey: UIColor {
        return UIColor(red: 171.0 / 255.0, green: 179.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)
    }

    class var pale: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 239.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }

    class var dustyOrange: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 96.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    }

    class var slate: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 87.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }

    class var darkBlueGrey: UIColor {
        return UIColor(red: 8.0 / 255.0, green: 20.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    }

    class var black26: UIColor {
        return UIColor(white: 0.0, alpha: 0.26)
    }

    class var white: UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 1.0)
    }

    class var tealish85: UIColor {
        return UIColor(red: 53.0 / 255.0, green: 184.0 / 255.0, blue: 208.0 / 255.0, alpha: 0.85)
    }

    class var coolGreyTwo: UIColor {
        return UIColor(red: 165.0 / 255.0, green: 170.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
    }

    class var greyish: UIColor {
        return UIColor(white: 178.0 / 255.0, alpha: 1.0)
    }

    class var charcoalGrey: UIColor {
        return UIColor(white: 74.0 / 255.0, alpha: 1.0)
    }

    class var darkishBlue: UIColor {
        return UIColor(red: 3.0 / 255.0, green: 63.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
    }

    class var black50: UIColor {
        return UIColor(white: 0.0, alpha: 0.5)
    }

    class var black10: UIColor {
        return UIColor(white: 0.0, alpha: 0.1)
    }

    class var black30: UIColor {
        return UIColor(white: 0.0, alpha: 0.3)
    }

    class var seaBlue: UIColor {
        return UIColor(red: 4.0 / 255.0, green: 107.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
    }

    class var greyishBrown75: UIColor {
        return UIColor(red: 82.0 / 255.0, green: 66.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.75)
    }

    class var black20: UIColor {
        return UIColor(white: 0.0, alpha: 0.2)
    }

    class var grapefruit: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 94.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
    }

    class var lightishRed: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 53.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    }

    class var tealish: UIColor {
        return UIColor(red: 53.0 / 255.0, green: 184.0 / 255.0, blue: 208.0 / 255.0, alpha: 1.0)
    }

    class var paleSalmon85: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 174.0 / 255.0, blue: 171.0 / 255.0, alpha: 0.85)
    }

    class var greyishBrown: UIColor {
        return UIColor(red: 82.0 / 255.0, green: 66.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }

    class var black: UIColor {
        return UIColor(white: 43.0 / 255.0, alpha: 1.0)
    }

    class var dandelion: UIColor {
        return UIColor(red: 249.0 / 255.0, green: 223.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0)
    }

    class var white5: UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 0.05)
    }

    class var black25: UIColor {
        return UIColor(white: 0.0, alpha: 0.25)
    }
    
    class var standardOrange: UIColor {
        return UIColor(red: 247/255.0, green: 207/255.0, blue: 54/255.0, alpha: 1)

    }
}

// Text styles

extension UIFont {
    class func textStyle3Font() -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: 80.0)
    }

    class func textStyle7Font() -> UIFont? {
        return UIFont(name: "Georgia-Bold", size: 50.0)
    }

    class func textStyle19Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 24.0)
    }

    class func textStyle23Font() -> UIFont {
        return UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightHeavy)
    }

    class func textStyleFont() -> UIFont? {
        return UIFont(name: "PingFangTC-Medium", size: 20.0)
    }

    class func textStyle5Font() -> UIFont? {
        return UIFont(name: "Georgia-Bold", size: 18.0)
    }

    class func textStyle14Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 18.0)
    }

    class func textStyle6Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 18.0)
    }

    class func textStyle8Font() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
    }

    class func textStyle22Font() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
    }

    class func textStyle11Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 16.0)
    }

    class func textStyle20Font() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
    }

    class func textStyle4Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 14.0)
    }

    class func textStyle9Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 14.0)
    }

    class func textStyle2Font() -> UIFont? {
        return UIFont(name: "PingFangTC-Regular", size: 14.0)
    }

    class func textStyle15Font() -> UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightRegular)
    }

    class func textStyle13Font() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBold)
    }

    class func textStyle18Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 12.0)
    }

    class func textStyle21Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 12.0)
    }

    class func textStyle17Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }

    class func textStyle16Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }

    class func textStyle10Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }

    class func textStyle12Font() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
    }
}
