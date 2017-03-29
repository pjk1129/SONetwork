//
//  SOGoodsItem.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/23.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit

class SOGoodsItem: NSObject {

    var name: String!
    var price: String!
    var rebateMoney: String!
    var img: String!
    var url: String!
    
    //MARK:- 自定义构造函数
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

    
}
