//
//  ViewController.swift
//  ZPFallsLayoutDemo
//
//  Created by gongwan2 on 2017/11/30.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 布局属性
        let layout = ZPFallsLayout()
        layout.delegate = self
        // collectionView
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "ZPCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view .addSubview(collectionView)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, ZPFallsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ZPCollectionViewCell
        cell.backgroundColor = UIColor.orange
        cell.identifLable.text = "\(indexPath.item)"
        return cell
    }
    func zp_fallsLayout(layout: ZPFallsLayout, cellForHeightAt IndexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(100) + 50)
    }
}
