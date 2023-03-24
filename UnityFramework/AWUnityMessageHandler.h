//
//  AWUnityMessageHandler.h
//  UnityFramework
//
//  Created by jianmei on 2022/11/23.
//

// import分组次序：Frameworks、Services、UI
#import <Foundation/Foundation.h>
#import "AWUnityCarControlMacro.h"

NS_ASSUME_NONNULL_BEGIN
@interface AWUnityParamModel : NSObject

@property (nonatomic, copy) NSString *type;//请求类型： post、get
@property (nonatomic, copy) NSString *path;//接口path
@property (nonatomic, copy) NSString *header;//请求头
@property (nonatomic, strong) NSDictionary *param;// 参数
@end

/**
  resultData：
 网络请求数据格式:  透传接口数据
 远控请求数据: {"result":isSuccess}//isSuccess ：true or false
 */
typedef void (^CompleteCallback)(NSDictionary * resultData);

@protocol AWUnityServiceImpProtocol <NSObject>

@optional
// unity 从 native 请求服务
- (void)requestServiceWithType:(AWUnityCarControlServiceType)serviceType
                    paramModel:(AWUnityParamModel *)paramModel
                    completeCallback:(CompleteCallback)completeCallback;

@end

/**
 * 消息中转器
 */
@interface AWUnityMessageHandler : NSObject

+ (instancetype)shardInstance;

@property (nonatomic, strong, readonly) NSMutableArray<AWUnityServiceImpProtocol> *impList;


/// native注册unity的服务，供unity调, 目前一个app只允许创建一个imp
/// @param imp imp description
- (void)registerUnityServiceImp:(id<AWUnityServiceImpProtocol>)imp;

/**
 接收并解析Unity发过来的消息，unity内部调
 @param str 消息体
 */
- (void)handleFunction:(NSString *)str;


/**
 发送消息给Unity
 Native回调给Unity消息、或主动发给Unity
 @param eventCode 事件code
 @param resultData 返回的数据
 */
- (void)sendMessageToUnityWithEventCode:(AWUnityCarControlEventType)eventCode
                                       resultData:(NSDictionary *)resultData;


@end

NS_ASSUME_NONNULL_END
