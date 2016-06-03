//
//  functions.swift

// <Grocery-LIst is a simple list appclation for ios 9.3 an above and swift 2.2 an above>
// Copyright (C) <2016>  <DJABHipHop/BAProductions>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import UIKit
//Convert hex color to uicolor
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
    if (cString.hasPrefix("#")) {
        cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
    }
    if ((cString.characters.count) != 6) {
        return UIColor.grayColor()
    }
    var rgbValue:UInt32 = 0
    NSScanner(string: cString).scanHexInt(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
//Dismiss keybard then user tuoches outside UITextField, UITextView or UISearchbar ("Experimental Code")
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
//Add background images to uiview
extension UIView {
    func addBackground(imageName:String) {
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: imageName)
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}
//Hides the search bar
extension UITableView {
    func hideSearchBar() {
        if let bar = self.tableHeaderView as? UISearchBar {
            let height = CGRectGetHeight(bar.frame)
            let offset = self.contentOffset.y
            if offset < height {
                self.contentOffset = CGPointMake(0, height)
            }
        }
    }
}
//Round Button
class RoundButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
//Round Label
class RoundLabel: UILabel {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
extension String {
    func localizedWithComment(comment:String) -> String {
        //print(NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: comment))
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: comment)
    }
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "_")
    }
}
class TipInCellAnimator {
    class func fadeIn(cell:UITableViewCell) {
        let view = cell.contentView
        let rotationDegrees: CGFloat = -15.0
        let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180.0)
        let offset = CGPointMake(-20, -20)
        var startTransform = CATransform3DIdentity // 2
        startTransform = CATransform3DRotate(CATransform3DIdentity, rotationRadians, 0.0, 0.0, 1.0) // 3
        startTransform = CATransform3DTranslate(startTransform, offset.y, offset.x, 0.0) // 4
        //view.layer.transform = startTransform
        view.layer.opacity = 0.0
        UIView.animateWithDuration(1) {
            //view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }
    }
    class func fadeOut(cell:UITableViewCell) {
        let view = cell.contentView
        let rotationDegrees: CGFloat = -15.0
        let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180.0)
        let offset = CGPointMake(-20, -20)
        var startTransform = CATransform3DIdentity // 2
        startTransform = CATransform3DRotate(CATransform3DIdentity, rotationRadians, 0.0, 0.0, 0.0) // 3
        startTransform = CATransform3DTranslate(startTransform, offset.y, offset.x, 0.0) // 4
        //view.layer.transform = startTransform
        view.layer.opacity = 1.0
        UIView.animateWithDuration(1) {
            //view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 0
        }
    }
    
}
//Make String UpperCase
func firstCharacterUpperCase(sentenceToCap:String) -> String {
    //break it into an array by delimiting the sentence using a space
    let breakupSentence = sentenceToCap.componentsSeparatedByString(" ")
    var newSentence = ""
    //Loop the array and concatinate the capitalized word into a variable.
    for wordInSentence  in breakupSentence {
        newSentence = "\(newSentence) \(wordInSentence.capitalizedString)"
    }
    // send it back up.
    return newSentence
}
func firstCharacterLowerCase(sentenceToCap:String) -> String {
    //break it into an array by delimiting the sentence using a space
    let breakupSentence = sentenceToCap.componentsSeparatedByString(" ")
    var newSentence = ""
    //Loop the array and concatinate the capitalized word into a variable.
    for wordInSentence  in breakupSentence {
        newSentence = "\(newSentence) \(wordInSentence.localizedLowercaseString)"
    }
    // send it back up.
    return newSentence
}
//Block Emoji in a string
func noEmoji(text:String) -> String {
    let alphaNumericCharacterSet = NSMutableCharacterSet() //create an empty mutable set
    alphaNumericCharacterSet.formUnionWithCharacterSet(NSCharacterSet.alphanumericCharacterSet())
    alphaNumericCharacterSet.addCharactersInString("?& ")
    let filteredCharacters = text.characters.filter {
        return  String($0).rangeOfCharacterFromSet(alphaNumericCharacterSet) != nil
    }
    let filteredString = String(filteredCharacters)
    // send it back up.
    return filteredString
}
//Block Emoji and letter in a string
func noEmojiOrLatter(text:String) -> String {
    let numericCharacterSet = NSCharacterSet(charactersInString:"0123456789/")
    let filteredCharacters = text.characters.filter {
        return  String($0).rangeOfCharacterFromSet(numericCharacterSet) != nil
    }
    let filteredString = String(filteredCharacters)
    // send it back up.
    return filteredString
}
