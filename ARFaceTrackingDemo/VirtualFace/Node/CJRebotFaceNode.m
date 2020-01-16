//
//  CJRebotFaceNode.m
//  ARFaceTrackingDemo
//
//  Created by Anmo on 2020/1/16.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "CJRebotFaceNode.h"
#import "CJVirtualFaceManager.h"

@interface CJRebotFaceNode ()

/** 下巴节点*/
@property (nonatomic ,strong) SCNNode   * jawNode;
/** 左边眼睛节点*/
@property (nonatomic ,strong) SCNNode   * leftEyeNode;
/** 右边眼睛节点*/
@property (nonatomic ,strong) SCNNode   * rightEyeNode;
/** 下巴位置*/
@property (nonatomic ,assign) CGFloat   jawOriginY;
/** 下巴高度*/
@property (nonatomic ,assign) CGFloat   jawHeight;
/** 五官运动系数字典*/
@property (nonatomic ,strong) NSDictionary <ARBlendShapeLocation,NSNumber *>*blendShapes;

@end

@implementation CJRebotFaceNode

#pragma mark - lifeCycle

- (instancetype)init {
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"robotHead" withExtension:@"scn" subdirectory:@"Models.scnassets"];
    if (!url) {return nil;}
    if (self = [super initWithURL:url]) {
        
        [self load];
        _jawNode = [self childNodeWithName:@"jaw" recursively:YES];
        _leftEyeNode = [self childNodeWithName:@"eyeLeft" recursively:YES];
        _rightEyeNode = [self childNodeWithName:@"eyeRight" recursively:YES];
        _jawOriginY = _jawNode.position.y;
    }
    return self;
}

- (void)cj_updateWithFaceAnchor:(ARFaceAnchor *)anchor {
    self.blendShapes = anchor.blendShapes;
    
//    SCNNode * leftAxesNode = [[CJVirtualFaceManager shareInstance]cj_getVirtualContentNodeWithResourceName:@"coordinateOrigin"];
//    [self.leftEyeNode addChildNode:leftAxesNode];
//
//    SCNNode * rightAxesNode = [[CJVirtualFaceManager shareInstance]cj_getVirtualContentNodeWithResourceName:@"coordinateOrigin"];
//    [self.rightEyeNode addChildNode:rightAxesNode];
    
}



#pragma mark - Setter&Getter

- (void)setBlendShapes:(NSDictionary<ARBlendShapeLocation,NSNumber *> *)blendShapes {
    _blendShapes = blendShapes;
    
    // 左眼表情系数
    CGFloat leftEyeBlink = [blendShapes[ARBlendShapeLocationEyeBlinkLeft]floatValue];
    CGFloat leftEyeLookLeft = [blendShapes[ARBlendShapeLocationEyeLookOutLeft]floatValue];
    CGFloat leftEyeLookRight = [blendShapes[ARBlendShapeLocationEyeLookInLeft]floatValue];
    
    SCNVector3 leftEyeScale = self.leftEyeNode.scale;
    // 当其中一个表情系数有值时，其他表情系数为0
    if (leftEyeLookLeft > 0) {
        leftEyeScale.x = 1 - leftEyeLookLeft;
    } else {
        leftEyeScale.x = 1 - leftEyeLookRight;
    }
    leftEyeScale.z = 1 - leftEyeBlink;
    self.leftEyeNode.scale = leftEyeScale;
    
    // 右眼表情系数
    CGFloat rightEyeBlink = [blendShapes[ARBlendShapeLocationEyeBlinkRight]floatValue];
    CGFloat rightEyeLookLeft = [blendShapes[ARBlendShapeLocationEyeLookInRight]floatValue];
    CGFloat rightEyeLookRight = [blendShapes[ARBlendShapeLocationEyeLookOutRight]floatValue];
    
    SCNVector3 rightEyeScale = self.rightEyeNode.scale;
    if (rightEyeLookLeft > 0) {
        rightEyeScale.x = 1 - leftEyeLookLeft;
    } else {
        rightEyeScale.x = 1 - rightEyeLookRight;
    }
    rightEyeScale.z = 1 - rightEyeBlink;
    self.rightEyeNode.scale = rightEyeScale;
    
    // 下巴开口表情系数
    CGFloat jawOpen = [blendShapes[ARBlendShapeLocationJawOpen]floatValue];
    self.jawNode.position = (SCNVector3){self.jawNode.position.x,self.jawOriginY - self.jawHeight*jawOpen,self.jawNode.position.z};
}

- (CGFloat)jawHeight {
    SCNVector3 min = (SCNVector3){0,0,0};
    SCNVector3 max = (SCNVector3){0,0,0};
    
    [self getBoundingBoxMin:&min max:&max];
    return max.y - min.y;
}

@end
