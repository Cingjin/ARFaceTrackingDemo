//
//  CJMaskFaceNode.m
//  ARFaceTrackingDemo
//
//  Created by Anmo on 2020/1/16.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "CJMaskFaceNode.h"

@implementation CJMaskFaceNode


- (instancetype)initWithGeometry:(ARSCNFaceGeometry *)faceGeometry {
    if (self = [super init]) {
        SCNMaterial * material = faceGeometry.firstMaterial;
        // 漫反射的内容颜色
        material.diffuse.contents = [UIImage imageNamed:@"head"];
        // 基于物理的阴影，包含了真实世界灯光和材料之间相互作用的光照模型
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        
        self.geometry = faceGeometry;
    }
    return self;
}

- (void)cj_updateWithFaceAnchor:(ARFaceAnchor *)faceAnchor {
    [(ARSCNFaceGeometry *)self.geometry updateFromFaceGeometry:faceAnchor.geometry];
}

@end
