//
//  SettingStruct.swift
//  FlipTheDropCard
//
//  Created by Asun on 2018/8/9.
//  Copyright © 2018年 Asun. All rights reserved.
//

import UIKit

protocol NecessaryNumerical {
    var bangHeight:CGFloat {get set}
    var bangWidth:CGFloat {get set}
    var corners:UIRectCorner {get set}
    var radius:CGFloat {get set}
    //滚动范围
    var maxScrollOffset:CGFloat {get set}
    var bangViewTopInset:CGFloat {get set}
    //调用改变刘海宽高
    mutating func changgeSize(width:CGFloat,height:CGFloat)
    //调用改变圆角 以及 设置圆角位置
    mutating func changgeCellCorners(corner:UIRectCorner,radiu:CGFloat)
}
// 所需数据
struct SettingStruct:NecessaryNumerical {
    var maxScrollOffset: CGFloat = -86
    var radius: CGFloat = 10
    var bangHeight: CGFloat = 26
    var bangWidth: CGFloat = 209
    var bangViewTopInset: CGFloat = 40
    var corners:UIRectCorner = [UIRectCorner.topLeft,UIRectCorner.topRight,UIRectCorner.bottomLeft,UIRectCorner.bottomRight]
    
    mutating func changgeSize(width: CGFloat, height: CGFloat) {
        self.bangHeight = height
        self.bangWidth = width
    }
    
    mutating func changgeCellCorners(corner: UIRectCorner,radiu:CGFloat) {
        self.corners = corner
        self.radius = radiu
    }
}
