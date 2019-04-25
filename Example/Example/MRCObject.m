//
//  MRCObject.m
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/26.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "MRCObject.h"
#import <UIKit/UIKit.h>

@implementation MRCObject
- (void)dealloc {
    NSLog(@"%@销毁了", self);
    
    [super dealloc];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    MRCObject *obj = [super allocWithZone:zone];
    NSLog(@"%@生成了", obj);
    
    return obj;
}

+ (void)generateAndHoldObject {
    MRCObject *obj = [[MRCObject alloc] init];
    NSLog(@"%@", obj);
}
+ (void)holdObject {
    NSMutableArray *array = [NSMutableArray array];
    [array retain];
}
+ (void)releaseNoNeedObject {
    MRCObject *obj = [[MRCObject alloc] init];
    [obj release];
}
+ (void)releaseNoHoldObject {
    MRCObject *obj = [[MRCObject alloc] init];
    [obj release];
    [obj release];
}
+ (void)autoreleaseUse {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    MRCObject *obj = [[MRCObject alloc] init];
    [obj autorelease];
    [pool release];
    NSLog(@"NSAutoreleasePool结束！");
}
struct ErrorStruct {
    MRCObject *obj;
};

@end
