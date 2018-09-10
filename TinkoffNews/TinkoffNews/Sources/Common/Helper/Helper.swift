//
//  Helper.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    //TODO: - delete if not needed
//    static func makePlainText(fromHTMLtext: String, fontSize: CGFloat) -> String {
//        guard let attrStr = try? NSMutableAttributedString(
//            data: fromHTMLtext.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
//            options: [ .documentType: NSAttributedString.DocumentType.html],
//            documentAttributes: nil) else {
//                return ""
//        }
//
//        attrStr.addAttributes([.font: UIFont.systemFont(ofSize: fontSize)], range: NSMakeRange(0, attrStr.length))
//        let simpleString = attrStr.string
//        return simpleString
//    }
    
    static func stringFromHTMLString(_ htmlString: String) -> String {
        return htmlString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).trimmingCharacters(in: .newlines)
    }

}
