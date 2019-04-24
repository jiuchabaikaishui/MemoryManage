//
//  ARCObject.m
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/27.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "ARCObject.h"

@interface ARCObject ()
{
    __strong id _strongObj;
    __weak id _weakObj;
}

@end

@implementation ARCObject

- (void)dealloc {
    NSLog(@"%@(%@)销毁了", NSStringFromClass(self.class), self);
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    ARCObject *obj = [super allocWithZone:zone];
    NSLog(@"%@生成了", obj);
    
    return obj;
}

+ (instancetype)object {
    ARCObject __autoreleasing *obj = [[self alloc] init];
    return obj;
}
- (void)setStrongObject:(id)obj {
    _strongObj = obj;
}
- (void)setWeakObject:(id)obj {
    _weakObj = obj;
}

@end
