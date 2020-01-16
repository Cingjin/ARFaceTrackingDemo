//
//  CJMeshFaceNode.m
//  ARFaceTrackingDemo
//
//  Created by Anmo on 2020/1/16.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "CJMeshFaceNode.h"

@implementation CJMeshFaceNode

#pragma mark - lifeCycle

- (instancetype)initWithFaceGeometry:(ARSCNFaceGeometry *)faceGeometry {
    if (self = [super init]) {
        SCNMaterial * material = faceGeometry.firstMaterial;
        // 更改材料的填充模型为线条
        material.fillMode = SCNFillModeLines;
        // 漫反射的内容颜色
        material.diffuse.contents = [UIColor whiteColor];
        // 基于物理的阴影，包含了真实世界灯光和材料之间相互作用的光照模型
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        self.geometry = faceGeometry;
    }
    return self;
}

#pragma mark - publicMethod

- (void)cj_updateWithFaceAnchor:(ARFaceAnchor *)faceAnchor {

    [(ARSCNFaceGeometry *)self.geometry updateFromFaceGeometry:faceAnchor.geometry];
    
}

@end
