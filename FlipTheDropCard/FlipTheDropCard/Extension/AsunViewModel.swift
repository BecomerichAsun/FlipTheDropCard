//
//  AsunTableView.swift
//  TIps
//
//  Created by 钟宏阳 on 2018/8/13.
//  Copyright © 2018年 Asun. All rights reserved.
//

import UIKit

typealias AsunCellRenderBlock = (_ indexPath:IndexPath,_ collectionView:UICollectionView) -> UICollectionViewCell?
typealias AsunCellSelectBlock = (_ indexPath:IndexPath,_ collectionView:UICollectionView) -> Void

class AsunViewModel:NSObject,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var cellRender: AsunCellRenderBlock! //Cell
    var cellSelect: AsunCellSelectBlock! //Cell点击
    var sectionCount:Int = 0 //组
    var rawCount: Int = 0 //行
}

extension AsunViewModel {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rawCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellRender(indexPath,collectionView)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectBlock = cellSelect else{
            print("cell的选中block没有实例")
            return
        }
        selectBlock(indexPath,collectionView)
    }
}

