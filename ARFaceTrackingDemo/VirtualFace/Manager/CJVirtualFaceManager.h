//
//  CJVirtualFaceManager.h
//  ARFaceTrackingDemo
//
//  Created by Anmo on 2020/1/16.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJVirtualFaceManager : NSObject

+ (instancetype)shareInstance;

- (SCNNode *)cj_getVirtualContentNodeWithResourceName:(NSString  *)sourceName;

@end

NS_ASSUME_NONNULL_END
