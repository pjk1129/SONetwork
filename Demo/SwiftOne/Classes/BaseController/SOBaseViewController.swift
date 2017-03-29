//
//  SOBaseViewController.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/20.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit

class SOBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        if(self.navigationController?.isNavigationBarHidden)!{
            self.view.addSubview(navBarView)
            navBarView.addSubview(navTitleLabel)
        }
        self.view.addSubview(containerView)
        setUIConstraints()
    }
    
    func navLeftBtnDidClicked() {
        self.navigationController!.popViewController(animated: true)
    }

    private func setUIConstraints(){
        // align _collectionView from the left and right
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[containerView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        // align _collectionView from the top and bottom
        var format = "V:|-0-[containerView]-0-|"
        if(self.navigationController?.isNavigationBarHidden)!{
            format = "V:|-64-[containerView]-0-|"
        }
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
    }
    
    //MARK:- setter方法 赋值操作
    var navTitle:NSString? {
        //替代OC中重写setter方法，didSet没有代码提示
        didSet {
            if (self.navigationController?.isNavigationBarHidden)! {
                navTitleLabel.text = navTitle as String?
            }else{
                self.navigationItem.title = navTitle as String?
            }
        }
    }
    
    var backBtnShown: Bool? {
        didSet {
            if backBtnShown! {
                backButton.addTarget(self, action: #selector(navLeftBtnDidClicked), for: UIControlEvents.touchUpInside)
                
                if (self.navigationController?.isNavigationBarHidden)! {
                    navBarView.addSubview(backButton)
                    backButton.frame = CGRect(x: 5, y: 27.5, width: 49, height: 29)
                } else {
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
                }
            }
        }
    }
    
    //MARK:- 懒加载属性
    lazy var backButton:UIButton = {
        let button = UIButton(type: .custom)
        button.isExclusiveTouch = true
        button.frame = CGRect(x: 0, y: 0, width: 49, height: 29)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        return button
    }()
    
    lazy var containerView:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var navBarView:UIImageView = {
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 64)
        imgView.isUserInteractionEnabled = true
        imgView.backgroundColor = UIColor.so_withHex(hexString: "ff4800")
        return imgView
    }()
    
    private lazy var navTitleLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 60, y: 27, width: kScreenW-120, height: 30)
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
}

extension SOBaseViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (navigationController!.viewControllers.count) >= 2 {
            return true
        }
        
        return false
    }
}
