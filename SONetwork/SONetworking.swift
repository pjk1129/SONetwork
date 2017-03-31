//
//  SONetworking.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/23.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit


open class SONetworking: NSObject {
    
    open class func request( _ method : String = "GET", url : String , parameters : Dictionary<String,AnyObject> = [:], success : @escaping (_ result : String?)->Void, fail:@escaping (_ error : NSError?)->Void){
        
        SOSessionManager.default.request(method, url: url, parameters: parameters, success: { (data) in
            //此处只返回最原始的数据
            let res = String(data: data!, encoding: String.Encoding.utf8)
            success(res!)
        }) { (error) in
            fail(error)
        }        
    }
}
