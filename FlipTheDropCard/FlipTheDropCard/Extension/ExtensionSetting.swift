//
//  CornRidusView.swift
//  FlipTheDropCard
//
//  Created by Asun on 2018/8/9.
//  Copyright © 2018年 Asun. All rights reserved.
//

import UIKit

let Asun_Scale = UIScreen.main.scale
public typealias Asun_View = UIView
public typealias AnimationType = UIViewAnimationOptions

extension UIView {
//包含最近的屏幕更新内容 //高度太大便无法渲染
    func snapshotImage(afterScreenUpdated: Bool = true) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            self.drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdated)
        }
    }

}

extension UIImage {
    
    static func fromColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate([self])
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate([self])
    }
    
}
