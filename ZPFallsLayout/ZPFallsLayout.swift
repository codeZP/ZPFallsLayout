//
//  ZPFallsLayout.swift
//  ZPFallsLayoutDemo
//
//  Created by gongwan2 on 2017/11/30.
//  Copyright © 2017年 zp. All rights reserved.
//

import UIKit

// MARK: - 代理
protocol ZPFallsLayoutDelegate: NSObjectProtocol {
    /// 必须实现 返回每一个item高度
    func zp_fallsLayout(layout: ZPFallsLayout, cellForHeightAt IndexPath: IndexPath) -> CGFloat
}

class ZPFallsLayout: UICollectionViewLayout {
    
    // 默认的行列间距
    private let tempCorMargin: CGFloat = 10
    private let tempRowMargin: CGFloat = 10
    // 默认的内边距
    private let tempLayoutEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    // 默认有多少列
    private let tempCorCount = 3
    
    // 用于存放布局属性的数组
    private var attsArray = [UICollectionViewLayoutAttributes]()
    // 用于存放每列多高的数组
    private var corMaxHArray = [CGFloat]()
    
    // MARK: - 外部接口
    /// 代理
    weak var delegate: ZPFallsLayoutDelegate?
    
    /// 行间距
    var zp_corMargin: CGFloat?
    /// 列间距
    var zp_rowMargin: CGFloat?
    // 内边距
    var zp_layoutEdgeInsets: UIEdgeInsets?
    // 多少列
    var zp_corCount: Int?
    
    // MARK: - 外部接口传过来后数据处理
    // 多少列
    private func corCount() -> Int {
        return zp_corCount != nil ? zp_corCount! : tempCorCount
    }
    // 内边距
    private func layoutEdgeInsets() -> UIEdgeInsets {
        return zp_layoutEdgeInsets != nil ? zp_layoutEdgeInsets! : tempLayoutEdgeInsets
    }
    // 列间距
    private func rowMargin() -> CGFloat {
        return zp_rowMargin != nil ? zp_rowMargin! : tempRowMargin
    }
    // 行间距
    private func corMargin() -> CGFloat {
        return zp_corMargin != nil ? zp_corMargin! : tempCorMargin
    }
    
    // MARK: - 核心方法
    // 准备布局时候调用
    override func prepare() {
        super.prepare()
        if delegate == nil {
            fatalError("请遵守协议, 并实现协议方法")
        }
        // 清空存放布局属性的数组
        attsArray.removeAll()
        // 清空存放每列多高的数组
        corMaxHArray.removeAll()
        
        // 给存放每列多高的数组赋值
        for _ in 0..<self.corCount() {
            corMaxHArray.append(self.layoutEdgeInsets().top)
        }
        // 计算布局属性
        let attsCount = collectionView!.numberOfItems(inSection: 0)
        for i in 0..<attsCount {
            let indexPath = IndexPath(item: i, section: 0)
            attsArray.append(self.layoutAttributesForItem(at: indexPath)!)
        }
    }
    
    // 返回可视范围内的布局属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attsArray
    }
    
    // 返回这个位置的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let atts = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        var targetCor = 0
        var targetCorH = corMaxHArray[0]
        for i in 1..<corMaxHArray.count {
            if targetCorH > corMaxHArray[i] {
                targetCorH = corMaxHArray[i]
                targetCor = i
            }
        }
        
        let temp = collectionView!.bounds.width - self.layoutEdgeInsets().left - self.layoutEdgeInsets().right
        let w = (temp - CGFloat(self.corCount() - 1) * self.corMargin()) / CGFloat(self.corCount())
        let x = self.layoutEdgeInsets().left + (self.corMargin() + w) * CGFloat(targetCor)
        let h: CGFloat = delegate!.zp_fallsLayout(layout: self, cellForHeightAt: indexPath)
        var y: CGFloat = 0
        if targetCorH != self.layoutEdgeInsets().top {
            y = targetCorH + self.rowMargin()
        }else {
            y = self.layoutEdgeInsets().top
        }
        atts.frame = CGRect(x: x, y: y, width: w, height: h)
        corMaxHArray[targetCor] = atts.frame.maxY
        return atts
    }
    
    // 返回collectionView滚动范围
    override var collectionViewContentSize: CGSize {
        var targetCorH = corMaxHArray[0]
        for i in 1..<corMaxHArray.count {
            if targetCorH < corMaxHArray[i] {
                targetCorH = corMaxHArray[i]
            }
        }
        return CGSize(width: 0, height: targetCorH + self.layoutEdgeInsets().bottom)
    }
    
}
