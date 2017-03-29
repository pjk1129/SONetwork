//
//  SOUserViewController.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/20.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit
import WebKit

class SOUserViewController: SOBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navTitle = "我的"
        setupUIConstraints()
        reloadWebView()
    }

    private func reloadWebView() {
        let url = NSURL(string: "https://www.baidu.com") as! URL
        let requst = NSURLRequest(url: url)
        webView.load(requst as URLRequest)
    }

    private func setupUIConstraints(){
        containerView.addSubview(webView)
        containerView.addSubview(progressView)
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView" : webView]))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[webView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView" : webView]))
        progressView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 2)
    }
    
    //MARK:- 变量
    var goodsItem: SOGoodsItem!
    
    lazy var webView : WKWebView = {
        let web  = WKWebView(frame: CGRect.zero)
        web.navigationDelegate = self
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    // 进度条
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.blue
        progress.trackTintColor = .clear
        return progress
    }()
}

extension SOUserViewController: WKNavigationDelegate {
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        /// 获取网页的progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
            self.progressView.isHidden = true
        }
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
    }
}
