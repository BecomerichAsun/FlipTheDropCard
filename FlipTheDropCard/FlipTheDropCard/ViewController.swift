//
//  ViewController.swift
//  FlipTheDropCard
//
//  Created by Asun on 2018/8/9.
//  Copyright © 2018年 Asun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    //设置数值
    fileprivate lazy var controlsStruct:SettingStruct = SettingStruct()
    fileprivate lazy var bangView = Asun_View()
    fileprivate lazy var numberOfItemsInSection = [1]
    fileprivate var bangViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //不是Iphone不需要刘海可以设置为0 按自己需求来
//        controlsStruct.changgeSize(width: 0, height: 0)
        SettingNotchView()
    }
}
// MARK: UI Setting
extension ViewController {
    private func SettingNotchView() {
        //使用AutoLayout
        bangView.translatesAutoresizingMaskIntoConstraints = false
        bangView.backgroundColor = UIColor.black
        bangView.layer.cornerRadius = 20
        bangView.layer.masksToBounds = false
        
        view.addSubview(bangView)
        //约束
        bangView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).activate()
        bangView.widthAnchor.constraint(equalToConstant: controlsStruct.bangWidth).activate()
        bangView.heightAnchor.constraint(equalToConstant: 200).activate()
        bangViewBottomConstraint = bangView.bottomAnchor.constraint(equalTo: self.view.topAnchor,
                                                                    constant: 26)
        bangViewBottomConstraint.activate()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //设置滚动方向 以及 隐藏滑动条
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func SettingAnimationView() {
        let animatableView = UIImageView(frame: bangView.frame)
        animatableView.backgroundColor = UIColor.black
        animatableView.layer.cornerRadius = self.bangView.layer.cornerRadius
        animatableView.layer.masksToBounds = true
        animatableView.frame = bangView.frame
        view.addSubview(animatableView)
        bangViewBottomConstraint.constant = controlsStruct.bangHeight
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let height = flowLayout.itemSize.height + flowLayout.minimumInteritemSpacing
        
        self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -controlsStruct.maxScrollOffset)
        //开始动画   0.3 == 下滑时间
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            let itemSize = flowLayout.itemSize
            //宽度不变 高度拉伸
            animatableView.frame.size = CGSize(width: self.controlsStruct.bangWidth,
                                               height: (itemSize.height / itemSize.width) * self.controlsStruct.bangWidth)
            //只更改当前透明度
            animatableView.image = UIImage.fromColor(self.view.backgroundColor?.withAlphaComponent(0.2) ?? UIColor.black)
            animatableView.frame.origin.y = self.controlsStruct.bangViewTopInset
            self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: height * 0.5)
        }) { _ in
            //获取第0个
            let item = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0))
            animatableView.image = item?.snapshotImage()
            // AnimationType 动画方向 Left Right Top Bottom  0.3 == 翻转时间
            UIView.transition(with: animatableView, duration: 0.3, options: AnimationType.transitionFlipFromBottom, animations: {
                animatableView.frame.size = flowLayout.itemSize
                animatableView.frame.origin = CGPoint(x: (self.collectionView.frame.width - flowLayout.itemSize.width) / 2.0,
                                                      y: self.collectionView.frame.origin.y - height * 0.5)
                self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: height)
            }, completion: { _ in
                self.collectionView.transform = CGAffineTransform.identity
                animatableView.removeFromSuperview()
                self.numberOfItemsInSection.append(1)
                self.collectionView.reloadData()
            }
            )
            let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
            cornerRadiusAnimation.fromValue = 16
            cornerRadiusAnimation.toValue = 10
            cornerRadiusAnimation.duration = 0.3
            animatableView.layer.add(cornerRadiusAnimation, forKey: "cornerRadius")
            animatableView.layer.cornerRadius = 10
        }
    }
}
// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.cornerRadius = controlsStruct.radius
        cell.layer.masksToBounds = true
    }
}
// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    //开始滚动 求出最大偏移Y,更新约束
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = max(controlsStruct.maxScrollOffset, scrollView.contentOffset.y)
        bangViewBottomConstraint.constant = controlsStruct.bangHeight - min(0, scrollView.contentOffset.y)
    }
    //滚动即将停止 调用动画
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= controlsStruct.maxScrollOffset {
            SettingAnimationView()
        }
    }
}


