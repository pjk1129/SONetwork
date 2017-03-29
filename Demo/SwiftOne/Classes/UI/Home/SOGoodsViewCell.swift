//
//  SOGoodsViewCell.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/23.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit
import Kingfisher

class SOGoodsViewCell: UICollectionViewCell {
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(rightLine)
        self.contentView.addSubview(mTitleLab)
        self.contentView.addSubview(mFanLab)
        self.contentView.addSubview(mPriceLab)
        self.contentView.addSubview(mRebateLab)
        
        bottomLine.frame = CGRect(x: 0, y: self.contentView.bounds.size.height-lineSize, width: self.contentView.bounds.size.width, height: lineSize)
        rightLine.frame = CGRect(x: self.contentView.bounds.size.width-lineSize, y: 0, width: lineSize, height: self.contentView.bounds.size.height)
        mTitleLab.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.maxY+11, width: imageView.frame.width, height: 30)
        mFanLab.frame = CGRect(x: imageView.frame.minX, y: bottomLine.frame.minY-20, width: 12, height: 12)
        mRebateLab.frame = CGRect(x: mFanLab.frame.maxX+4, y: mFanLab.frame.minY, width: 100, height: 12)
        mPriceLab.frame = CGRect(x: imageView.frame.minX-3, y: mFanLab.frame.minY-20, width: imageView.frame.width, height: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateData(item:SOGoodsItem){
        guard item != goodsItem else {
            return
        }
        goodsItem = item
        mTitleLab.text = goodsItem?.name
        mPriceLab.text = "￥" + (goodsItem?.price)!
        mRebateLab.text = (goodsItem?.rebateMoney)! + "元"
        
        if ((goodsItem?.img) != nil) {
            let url = URL(string: (goodsItem?.img)!)
            imageView.kf.setImage(with: url)
        }
        
    }
    
    var goodsItem: SOGoodsItem? 
    
    private let lineSize = 1/UIScreen.main.scale
    
    //MARK:- 懒加载属性
    lazy var imageView:UIImageView = {
        let width = kScreenW/2 - 10
        let imgView = UIImageView(frame: CGRect(x: 5, y: 5, width: width, height: width))
        imgView.backgroundColor = UIColor.clear
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var mRebateLab:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.so_withHex(hexString: "ff4800")
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mFanLab:UILabel = {
        let label = UILabel()
        label.text = "返"
        label.backgroundColor = UIColor.so_withHex(hexString: "ff4a00")
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mPriceLab:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.so_withHex(hexString: "666666")
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mTitleLab:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.so_withHex(hexString: "333333")
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bottomLine:UIView = {
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor.so_withHex(hexString: "eeeeee")
        return line
    }()
    
    lazy var rightLine:UIView = {
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor.so_withHex(hexString: "eeeeee")
        return line
    }()
}
