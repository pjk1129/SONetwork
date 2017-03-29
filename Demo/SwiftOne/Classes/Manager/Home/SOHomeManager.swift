//
//  SOHomeManager.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/27.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit

class SOHomeManager: NSObject {

    class func request( _ apiName : String , dic : Dictionary<String,AnyObject> = [:], success : @escaping (_ items : [SOGoodsItem]?)->Void, fail:@escaping (_ error : NSError?)->Void){
        let url = SERVER_DOMAIN + "/" + apiName
        SONetworking.request("POST", url: url, parameters: dic, success: { (jsonString) in
            let data = jsonString?.data(using: .utf8)!
            if let parsedData = try? JSONSerialization.jsonObject(with: data!) as! [String:Any] {
                let data = parsedData["data"] as? [String:Any]
                let finelist = data?["finelist"] as? [String:Any]
                let list = finelist?["list"] as! Array<[String:Any]>!
                var result = [SOGoodsItem]()
                for dic in list! {
                    let item = SOGoodsItem(dict: dic)
                    result.append(item)
                }
                success(result)
            } else {
                print("bad json - do some recovery")
            }
            
        }) { (error) in
            
        }

       
    }
 
}
