//
//  AWUnityCarControlMacro.h
//  UnityFramework
//
//  Created by jianmei on 2022/11/23.
//

#ifndef AWUnityCarControlMacro_h
#define AWUnityCarControlMacro_h

typedef NS_ENUM(NSUInteger, AWUnityCarControlEventType) {
    AWUnityCarControlEventType_unknown = 0x000,   ///未知事件

#pragma mark 网络请求
    AWUnityCarControlEventType_getCondition = 10001,  //获取车况
    AWUnityCarControlEventType_refreshConditionResult  = 10002, //实时车况
    AWUnityCarControlEventType_refreshConditionSoft = 10003, //刷新车况(tbox在线直接返回最新车况）
    AWUnityCarControlEventType_queryVehicle = 10004,//获取车辆列表
    AWUnityCarControlEventType_getShare = 10005, //获取分享车辆列表
    AWUnityCarControlEventType_getAirTemperature = 10010, //获取空调温度信息
    AWUnityCarControlEventType_getAirTiming = 10011, //获取空调定时信息
    AWUnityCarControlEventType_setAirTiming = 10012, //设定空调定时信息
    
#pragma mark - 其它通用请求
    AWUnityCarControlEventType_getUserInfo = 10006, //获取用户信息
    AWUnityCarControlEventType_connectBlueTooth = 10007, //连接蓝牙
    AWUnityCarControlEventType_openFuncPopup = 10008, //打开二级功能弹窗
    AWUnityCarControlEventType_openFindCarView = 10009, //打开寻车界面
    AWUnityCarControlEventType_DisconnectBLE = 10013,  // 断开蓝牙连接
    AWUnityCarControlEventType_switchCarView = 11000, //切换车辆
    AWUnityCarControlEventType_switchPageView = 11001, //有车/无车界面切换
            
#pragma mark native的一些主动事件
    AWUnityCarControlEventType_push_Unbinding = 12000, //解绑车辆,授权车辆
    AWUnityCarControlEventType_push_authorize = 12001, //登录
    AWUnityCarControlEventType_push_blue = 12002, //蓝牙推送
};

typedef NS_ENUM(NSUInteger, AWUnityCarControlServiceType) {
    AWUnityCarControlServiceType_network   = 0x01, //网络请求
    AWUnityCarControlServiceType_remoteControl = 0x02, //远控
    AWUnityCarControlServiceType_other = 0x03,  //其它请求 : 连接蓝牙、获取用户信息
};


#endif /* AWUnityCarControlMacro_h */
