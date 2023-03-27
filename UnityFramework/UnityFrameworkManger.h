//
//  UnityFrameworkManger.h
//  Test
//
//  Created by jianmei on 2022/11/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define AWUnityManger [UnityFrameworkManger sharedInstance]
NS_ASSUME_NONNULL_BEGIN

@class UnityFramework;
@interface UnityFrameworkManger : NSObject <UIApplicationDelegate>

/// 单例
+ (UnityFrameworkManger *)sharedInstance;

// 预设main参数
- (void)preSetDataArgc:(int)argc argv:(NSString *)argv;

//在addui时需要调此方法
- (void)startUnity;

@property (nonatomic, strong, nullable) UnityFramework *ufw;

@end

NS_ASSUME_NONNULL_END
