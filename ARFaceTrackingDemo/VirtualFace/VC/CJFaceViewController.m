//
//  CJFaceViewController.m
//  ARFaceTrackingDemo
//
//  Created by Anmo on 2020/1/16.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "CJFaceViewController.h"
// SCNNode
#import "CJVirtualFaceManager.h"
// Node
#import "CJMeshFaceNode.h"
#import "CJMaskFaceNode.h"
#import "CJRebotFaceNode.h"
// System
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface CJFaceViewController ()<ARSessionDelegate,ARSCNViewDelegate,UIGestureRecognizerDelegate>

/** 场景视图*/
@property (nonatomic ,strong) ARSCNView     * sceneView;
/** 追踪会话*/
@property (nonatomic ,weak) ARSession       * trackingSession;
/** 虚拟模型面部节点*/
@property (nonatomic ,strong) SCNNode       * virtualFaceNode;
/** 真实场景面部节点*/
@property (nonatomic ,strong) SCNNode       * faceNode;
/** 人脸坐标轴节点*/
@property (nonatomic ,strong) SCNNode       * axesNode;
/** 面部拓扑网格*/
@property (nonatomic ,strong) CJMeshFaceNode    * meshFaceNode;
/** 面具*/
@property (nonatomic ,strong) CJMaskFaceNode    * maskFaceNode;
/** rebot*/
@property (nonatomic ,strong) CJRebotFaceNode   * rebotFaceNode;

@end

@implementation CJFaceViewController


#pragma mark - lifeCycle

- (void)dealloc {
    
    NSLog(@"%s",__func__);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cj_baseSet];
    [self cj_addSubView];
    [self cj_setupFaceNode];
    [self cj_setupTrackingSession];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 暂停追踪会话
    [self.trackingSession pause];
    
}

#pragma mark - baseSet

- (void)cj_baseSet {
    
    // 开启侧滑手势
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

// 设置面部节点
- (void)cj_setupFaceNode {
    // fillMesh 设置为NO，会空出眼睛和嘴巴的区域
    ARSCNFaceGeometry * faceGeometry = [ARSCNFaceGeometry faceGeometryWithDevice:self.sceneView.device fillMesh:NO];
    switch (self.nodeType) {
        case CJVirtualFaceTypeMesh:
            
            self.meshFaceNode = [[CJMeshFaceNode alloc]initWithFaceGeometry:faceGeometry];
            self.virtualFaceNode = (SCNNode *)self.meshFaceNode;
            // 更改场景的背景内容
            self.sceneView.scene.background.contents = [UIColor blackColor];
            break;
            
        case CJVirtualFaceTypeMask:
            
            self.maskFaceNode = [[CJMaskFaceNode alloc]initWithGeometry:faceGeometry];
            self.virtualFaceNode = (SCNNode *)self.maskFaceNode;
            break;
            
        case CJVirtualFaceTypeRebot:
            
            self.rebotFaceNode = [[CJRebotFaceNode alloc]init];
            self.virtualFaceNode = (SCNNode *)self.rebotFaceNode;
            self.sceneView.scene.background.contents = [UIColor lightGrayColor];
            break;
    }
}

// 设置追踪会话
- (void)cj_setupTrackingSession {
    // 是否可以使用面部追踪
    if (!ARFaceTrackingConfiguration.isSupported) {return;}
    
    // 禁用系统的"空闲计时器"，防止屏幕进入变暗的睡眠状态
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    
    ARFaceTrackingConfiguration * configuration = [[ARFaceTrackingConfiguration alloc]init];
    // YES 为trackingSesstion 中捕获 ARFrame对象的lightEstimate属性提供场景照明信息
    [configuration setLightEstimationEnabled:YES];
    [self.trackingSession runWithConfiguration:configuration
                                       options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
}

// 设置现实面部节点的内容
- (void)cj_setupFaceNodeContent {
    if (!self.faceNode) {return;}
    if (self.virtualFaceNode) {
        [self.faceNode addChildNode:self.virtualFaceNode];
    }
}

#pragma mark - view

- (void)cj_addSubView {
    
    [self.view addSubview:self.sceneView];
}

#pragma mark - ARSCNViewDelegate

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    self.faceNode = node;
    [self cj_setupFaceNodeContent];
    
    ARFaceAnchor * faceAnchor = (ARFaceAnchor *)anchor;
//    NSLog(@"拓扑结构的三角形数量：%@",@(faceAnchor.geometry.triangleCount));
//    NSLog(@"拓扑结构的顶点坐标数量：%@",@(faceAnchor.geometry.vertexCount));
//    NSLog(@"拓扑结构的纹理坐标数量：%@",@(faceAnchor.geometry.textureCoordinateCount));
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (!anchor) {return;}
    switch (self.nodeType) {
        case CJVirtualFaceTypeMesh:
            [self.meshFaceNode cj_updateWithFaceAnchor:(ARFaceAnchor*)anchor];
            break;
            
        case CJVirtualFaceTypeMask:
            [self.maskFaceNode cj_updateWithFaceAnchor:(ARFaceAnchor *)anchor];
            break;
            
        case CJVirtualFaceTypeRebot:
            [self.rebotFaceNode cj_updateWithFaceAnchor:(ARFaceAnchor *)anchor];
            break;
    }
}

#pragma mark - Setter&&Getter

- (void)setVirtualFaceNode:(SCNNode *)virtualFaceNode {
    _virtualFaceNode = virtualFaceNode;
    [self cj_setupFaceNodeContent];
}

- (ARSCNView *)sceneView {
    if (!_sceneView) {
        _sceneView = [[ARSCNView alloc]initWithFrame:self.view.bounds];
        _sceneView.delegate = self;
        _sceneView.automaticallyUpdatesLighting = YES;
    }
    return _sceneView;
}

- (ARSession *)trackingSession {
    return self.sceneView.session;
}

- (SCNNode *)axesNode {
    if (!_axesNode) {
        _axesNode = [[CJVirtualFaceManager shareInstance]cj_getVirtualContentNodeWithResourceName:@"coordinateOrigin"];
    }
    return _axesNode;
}

@end
