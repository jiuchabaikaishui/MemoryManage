//
//  MRCObject.h
//  ProfessionalExample
//
//  Created by 綦帅鹏 on 2019/3/26.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCObject : NSObject

/**
 生成并持有对象
 */
+ (void)generateAndHoldObject;

/**
 持有对象
 */
+ (void)holdObject;

/**
 释放不需要的对象
 */
+ (void)releaseNoNeedObject;

/**
 释放不持有的对象
 */
+ (void)releaseNoHoldObject;

/**
 autorelease使用
 */
+ (void)autoreleaseUse;

@end

NS_ASSUME_NONNULL_BEGIN

NS_ASSUME_NONNULL_END
