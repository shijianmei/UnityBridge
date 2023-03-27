//
//  UnityFrameworkManger.m
//  Test
//
//  Created by jianmei on 2022/11/4.
//

// import分组次序：Frameworks、Services、UI
#import "UnityFrameworkManger.h"
#include <UnityFramework/UnityFramework.h>

#define kU3dBoundId "com.unity3d.framework"
#define kUnityFrameworkPath @"/Frameworks/UnityFramework.framework"
@interface UnityFrameworkManger ()<UnityFrameworkListener>

@property (nonatomic, assign) int argc;
@property (nonatomic, copy) NSString *argv;
@property (nonatomic , assign) BOOL isStarted;

@end

@implementation UnityFrameworkManger
// UnityFrameworkLoad
UIKIT_STATIC_INLINE UnityFramework* UnityFrameworkLoad()
{
   NSString* bundlePath = nil;
   bundlePath = [[NSBundle mainBundle] bundlePath];
   bundlePath = [bundlePath stringByAppendingString:kUnityFrameworkPath];
   NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];

   if ([bundle isLoaded] == false) [bundle load];
   UnityFramework* ufw = [bundle.principalClass getInstance];

   if (![ufw appController]) {
      // unity is not initialized
      [ufw setExecuteHeader: &_mh_execute_header];
   }
   return ufw;
}

+ (UnityFrameworkManger *)sharedInstance {
    static UnityFrameworkManger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [UnityFrameworkManger new];
    });
    
    return instance;
}

#pragma mark - Public Fun

- (void)preSetDataArgc:(int)argc argv:(NSString *)argv {
    self.argc = argc;
    self.argv = argv;
}

#pragma mark - Private fun
/// 判断Unity是否已经初始化
- (BOOL)unityIsInitialized {
   return [self ufw] && [[self ufw] appController];
    
}

/// 初始化Unity
- (void)initUnity:(NSDictionary *)launchOptions  {
   // 判断Unity 是否已经初始化
   if ([self unityIsInitialized]) return;

   // 初始化Unity
   self.ufw = UnityFrameworkLoad();
   [self.ufw setDataBundleId:kU3dBoundId];
   [self.ufw registerFrameworkListener:self];
    
   char **argv;
   sscanf([self.argv cStringUsingEncoding:NSUTF8StringEncoding], "%p",&argv);
   
   [self.ufw runEmbeddedWithArgc:self.argc argv:argv appLaunchOpts:launchOptions];
}

- (void)startUnity {
    if (!self.isStarted) {
        self.isStarted = YES;
        [self.ufw.appController preStartUnity];
        [self.ufw.appController startUnity:[UIApplication sharedApplication]];
    }
}

#pragma mark - app Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {        
    NSDate* tmpStartData = [NSDate date];
    
    [self initUnity:launchOptions];
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@">>>>>>>>>>unity_launch_costTime = %f ms", deltaTime*1000);
    
   return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
   [[[self ufw] appController] applicationWillResignActive: application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   [[[self ufw] appController] applicationDidEnterBackground: application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   [[[self ufw] appController] applicationWillEnterForeground: application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   [[[self ufw] appController] applicationDidBecomeActive: application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
   [[[self ufw] appController] applicationWillTerminate: application];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[[self ufw] appController] applicationDidReceiveMemoryWarning:[UIApplication sharedApplication]];
}

#pragma mark - UnityFrameworkListener
- (void)unityDidUnload:(NSNotification *)notification {
   [[self ufw] unregisterFrameworkListener: self];
   [self setUfw: nil];
}

- (void)unityDidQuit:(NSNotification *)notification {
   
}

@end
