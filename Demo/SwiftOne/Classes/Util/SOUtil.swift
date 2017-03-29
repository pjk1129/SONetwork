//
//  SOUtil.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/20.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit
import Foundation

// 屏幕宽度
let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
let kScreenW = UIScreen.main.bounds.width

let SERVER_DOMAIN = "http://api.xxxx.com"

//自定义 log
func DLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("\(fileName):\(lineNum))-\(message)");
        
    #endif
}

func parametersFromQuery(_ string: String) -> NSDictionary {
    let array = string.components(separatedBy: "?")
    let queryDic = NSMutableDictionary()
    if array.count == 2{
        let query = array[1]
        let queryArray = query.components(separatedBy: "&")
        for queryStr in queryArray {
            let valueArray = queryStr.components(separatedBy: "=")
            if valueArray.count == 2 {
                let key = valueArray[0].removingPercentEncoding
                let value = valueArray[1].removingPercentEncoding
                queryDic.setValue(value, forKey: key!)
            }
        }
    }
    return queryDic
}

/*
 NSCharacterSet常用的类型有以下：
 urlHostAllowed      "#%/<>?@\^`{|}
 urlFragmentAllowed  "#%<>[\]^`{|}
 urlPasswordAllowed  "#%/:<>?@[\]^`{|}
 urlPathAllowed      "#%;<>?[\]^`{|}
 urlQueryAllowed     "#%<>[\]^`{|}
 urlUserAllowed      "#%/:<>?@[\]^`
 */
func urlEncode(string: String) -> String {
    return string.addingPercentEncoding(withAllowedCharacters: NSCharacterSet(charactersIn:"!*'();:@&=+$,/?%#[]").inverted)!
}

