//
//  AWIOSPort.m
//  UnityFramework
//
//  Created by jianmei on 2022/11/24.
//

// import分组次序：Frameworks、Services、UI
#import "AWUnityMessageHandler.h"

#if defined (__cplusplus)
extern "C" {
#endif

// unity 给ios 发送消息
    
void SendMessage2IOS(char *str)
{
    NSString *jsonStr = [NSString stringWithUTF8String:str];
//    NSLog(@"jianmei_unityMsg:%@",jsonStr);
    [[AWUnityMessageHandler shardInstance] handleFunction:jsonStr];
}

// unity log
void IosLog(const char* log) {
//    NSString *logStr = [NSString stringWithUTF8String:log];
    NSString *logStr = [NSString stringWithCString:log encoding:NSUTF8StringEncoding];
    if ([logStr containsString:@"10001"]) {
        return;
    }
    NSLog(@"jianmei_UnityLog:%@",logStr);
}
    
#if defined (__cplusplus)
}
#endif

