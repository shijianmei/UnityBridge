# UnityBridge
iOS接入unity

## 1.通过unity导出ios工程

## 2. 拷贝 UnityFramework 里的文件到工程里
    设置头文件public

## 3. 替换main.mm
        主要更新了下面的方法:
        ```
           - (void)runEmbeddedWithArgc:(int)argc argv:(char*[])argv appLaunchOpts:(NSDictionary*)appLaunchOpts
            {
                if (self->runCount)
                {
                    // initialize from partial unload ( sceneLessMode & onPause )
                    UnityLoadApplicationFromSceneLessState();
                    UnitySuppressPauseMessage();
                    [self pause: false];
                    [self showUnityWindow];
                }
                else
                {
                    // full initialization from ground up
                    [self frameworkWarmup: argc argv: argv];

                    id app = [UIApplication sharedApplication];

                    id appCtrl = [[NSClassFromString([NSString stringWithUTF8String: AppControllerClassName]) alloc] init];
                    [appCtrl application: app didFinishLaunchingWithOptions: appLaunchOpts];

            //        [appCtrl applicationWillEnterForeground: app];
            //        [appCtrl applicationDidBecomeActive: app];
                }

                self->runCount += 1;
            }
        ```
        添加了方法:
        ```
            - (BOOL)isPaused {
                return UnityIsPaused();
            }
        ```
## 4.在UnityFramework里添加方法
    ```
        - (BOOL)isPaused;
    ```

## 5.设置data资源属于动态库

## 6.编译生成动态库