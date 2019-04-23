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
    
}
+ (void)holdObject {
    
}
+ (void)releaseNoNeedObject {
    
}
+ (void)releaseNoHoldObject {
    
}
+ (void)autoreleaseUse {
    
}

@end
