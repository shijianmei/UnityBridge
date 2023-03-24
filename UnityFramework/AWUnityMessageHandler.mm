//
//  AWUnityMessageHandler.m
//  UnityFramework
//
//  Created by jianmei on 2022/11/23.
//

// import分组次序：Frameworks、Services、UI
#import "AWUnityMessageHandler.h"
#import "Classes/Unity/UnityInterface.h"

@implementation AWUnityParamModel
@end

@interface AWUnityMessageHandler ()
@property (nonatomic, strong) NSMutableArray<AWUnityServiceImpProtocol> *impList;
@property (nonatomic, strong) NSDictionary *netWorkEventMap;
@property (nonatomic, strong) NSDictionary *otherEventMap;//其它通用请求事件映射

@end

@implementation AWUnityMessageHandler
+ (instancetype)shardInstance {
    static AWUnityMessageHandler *forwarder = nil;
    static dispatch_once_t onceToken;    
    dispatch_once(&onceToken, ^{
        forwarder = [[AWUnityMessageHandler alloc] init];
    });
    return forwarder;
}

- (void)registerUnityServiceImp:(id<AWUnityServiceImpProtocol>)imp {
    if ([imp conformsToProtocol:@protocol(AWUnityServiceImpProtocol)]) {
        if (self.impList.count == 0) {
            [self.impList addObject:imp];
        }
    }
}

/**
 解析Unity发过来的消息
 
 @param str 消息体
 */
- (void)handleFunction:(NSString *)jsonStr{
    NSError *error;
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    if (!messageDict && ![messageDict isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    NSInteger serviceCode = [messageDict[@"service"] integerValue];
    NSDictionary *dataDict = messageDict[@"data"];
    id typeValue = dataDict[@"type"];
    if ([typeValue isKindOfClass:[NSNumber class]]) {
        typeValue = [dataDict[@"type"] stringValue];
    }
    
    AWUnityParamModel *model = [AWUnityParamModel new];
    model.type = typeValue;
    model.param = dataDict[@"param"];
    model.path = dataDict[@"path"];
    model.header = dataDict[@"header"];
    if (![model.path containsString:@"getCondition"]) {
        NSLog(@"jianmei_unityMsg:%@",jsonStr);
    }
    
    for (id<AWUnityServiceImpProtocol> imp in self.impList) {
        if ([imp respondsToSelector:@selector(requestServiceWithType:paramModel:completeCallback:)]) {
            __weak __typeof(self)weakSelf = self;
            [imp requestServiceWithType:(AWUnityCarControlServiceType)serviceCode paramModel:model completeCallback:^(NSDictionary * _Nonnull resultData) {
                AWUnityCarControlEventType eventType = AWUnityCarControlEventType_unknown;
                if (serviceCode == AWUnityCarControlServiceType_network) {
                    int eventValue = [[self.netWorkEventMap valueForKey:dataDict[@"path"]] intValue];
                    eventType = (AWUnityCarControlEventType)eventValue;
                } else if (serviceCode == AWUnityCarControlServiceType_remoteControl) {
                    eventType = (AWUnityCarControlEventType)[dataDict[@"type"] intValue];
                } else {
                    eventType = (AWUnityCarControlEventType)[[self.otherEventMap valueForKey:dataDict[@"type"]] integerValue];
                }
                
                [weakSelf sendMessageToUnityWithEventCode:eventType resultData:resultData];
            }];
        }
    }
}

/**
 发送消息给Unity
 
 @param tempCode 事件code
 @param resultData 返回的数据
 */
- (void)sendMessageToUnityWithEventCode:(AWUnityCarControlEventType)eventCode
                                       resultData:(NSDictionary *)resultData {
    NSDictionary *result = @{
                             @"eventCode" : @(eventCode).stringValue,
                             @"data" : resultData ?: @{},
                             };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jianmei_nativeToUnity:%@",jsonStr);
    UnitySendMessage("Launcher", "ReceiveIOSPush", jsonStr.UTF8String);    
}

- (NSMutableArray<AWUnityServiceImpProtocol> *)impList {
    if (!_impList) {
        _impList = [NSMutableArray<AWUnityServiceImpProtocol> array];
    }
    return _impList;
}


/// url : event
- (NSDictionary *)netWorkEventMap {
    if (!_netWorkEventMap) {
        _netWorkEventMap = @{
            @"app/vc/getCondition":@(AWUnityCarControlEventType_getCondition),
            @"app/vc/refreshConditionResult":@(AWUnityCarControlEventType_refreshConditionResult),
            @"app/vc/refreshConditionSoft":@(AWUnityCarControlEventType_refreshConditionSoft),
            @"aiid/queryVehicle":@(AWUnityCarControlEventType_queryVehicle),
            @"aiid/getShare":@(AWUnityCarControlEventType_getShare),
            @"app/rc/setting/queryAirconSetting":@(AWUnityCarControlEventType_getAirTemperature),
            @"app/rc/schedule/queryAirconSchedule":@(AWUnityCarControlEventType_getAirTiming),
            @"app/rc/schedule/setAirconSchedule":@(AWUnityCarControlEventType_setAirTiming)
        };
    }
    return _netWorkEventMap;
}


/// type: event
- (NSDictionary *)otherEventMap {
    if (!_otherEventMap) {
        _otherEventMap = @{
            @"connect_ble": @(AWUnityCarControlEventType_connectBlueTooth),
            @"get_user_info":@(AWUnityCarControlEventType_getUserInfo),
            @"open_func_popup":@(AWUnityCarControlEventType_openFuncPopup),
            @"open_find_car":@(AWUnityCarControlEventType_openFindCarView),
            @"change_vehicle":@(AWUnityCarControlEventType_switchCarView),
            @"change_page":@(AWUnityCarControlEventType_switchPageView)
        };
    }
    return _otherEventMap;
}

@end
