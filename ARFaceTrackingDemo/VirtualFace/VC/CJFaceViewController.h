//
//  CJFaceViewController.h
//  ARFaceTrackingDemo
//
//  Created by Anmo on 2020/1/16.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 虚拟面部节点类型
typedef NS_ENUM(NSUInteger, CJVirtualFaceType) {
    CJVirtualFaceTypeMesh,      // 面部拓扑网格
    CJVirtualFaceTypeMask,      // 面具
    CJVirtualFaceTypeRebot,     // 机器人
};

@interface CJFaceViewController : UIViewController

/** */
@property (nonatomic ,assign) CJVirtualFaceType  nodeType;

@end

NS_ASSUME_NONNULL_END
