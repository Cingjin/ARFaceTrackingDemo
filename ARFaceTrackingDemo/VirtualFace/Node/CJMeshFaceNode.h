//
//  CJMeshFaceNode.h
//  ARFaceTrackingDemo
//
//  Created by Anmo on 2020/1/16.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import <Foundation/Foundation.h>

// System
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJMeshFaceNode : SCNNode

- (instancetype)initWithFaceGeometry:(ARSCNFaceGeometry *)faceGeometry;
- (void)cj_updateWithFaceAnchor:(ARFaceAnchor *)faceAnchor;

@end

NS_ASSUME_NONNULL_END
