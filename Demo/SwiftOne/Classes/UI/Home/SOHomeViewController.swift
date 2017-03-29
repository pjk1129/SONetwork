//
//  SOHomeViewController.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/20.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit

private let kHomeCollectionViewCell = "kHomeCollectionViewCell"

class SOHomeViewController: SOBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navTitle = "首页"
        setupCollectionView()
        reloadData()
    }

    fileprivate func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreenW/2, height: 268)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SOGoodsViewCell.self, forCellWithReuseIdentifier: kHomeCollectionViewCell)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(collectionView!)
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView" : collectionView]))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView" : collectionView]))

    }
    
    //MARK:- 变量
    var collectionView: UICollectionView!
    
    fileprivate lazy var dataArr: [SOGoodsItem] = [SOGoodsItem]()


}

extension SOHomeViewController{
    fileprivate func reloadData(){
        let dic = ["key": "value" as AnyObject]
        SOHomeManager.request("apiname", dic: dic, success: { (items) in
            self.dataArr = items!
            //回到主线程中更新UI
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            
        }) { (error) in
            
        }
    }
}

//MARK:- collectionView的代理和数据源方法
extension SOHomeViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHomeCollectionViewCell, for: indexPath) as! SOGoodsViewCell
        cell.updateData(item: self.dataArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let item = self.dataArr[indexPath.row]
        let controller = SODetailViewController()
        controller.goodsItem = item
        self.tabBarController?.navigationController?.pushViewController(controller, animated: true)
    }
    
}


