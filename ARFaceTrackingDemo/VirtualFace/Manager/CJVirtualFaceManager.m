//
//  CJVirtualFaceManager.m
//  ARFaceTrackingDemo
//
//  Created by Anmo on 2020/1/16.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "CJVirtualFaceManager.h"

@implementation CJVirtualFaceManager

static CJVirtualFaceManager * _instacne = nil;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instacne = [[self alloc]init];
    });
    return _instacne;
}

- (SCNNode *)cj_getVirtualContentNodeWithResourceName:(NSString *)sourceName {
    NSURL * url = [[NSBundle mainBundle]URLForResource:sourceName withExtension:@"scn" subdirectory:@"Models.scnassets"];
    // 参照节点
    SCNReferenceNode * nodel = [[SCNReferenceNode alloc]initWithURL:url];
    [nodel load];
    return nodel;
}

@end
