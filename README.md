# UnityBridge
iOS接入unity
## 1.打包成framework
### 1.通过unity导出ios工程

### 2. 拷贝 UnityFramework 里的文件到工程里
    设置头文件public

### 3. 替换main.mm
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
### 4.在UnityFramework里添加方法
    ```
        - (BOOL)isPaused;
    ```

### 5.设置data资源属于动态库

### 6.编译生成动态库

## 2.使用动态库
### 2.1.初始化
   在 iOS 工程main.m初始化
```
        [AWUnityManger preSetDataArgc:argc argv:[NSString stringWithFormat:@"%p",argv]];
```
 ###  2.2 appdelegate里初始化
   ```
       [AWUnityManger application:application didFinishLaunchingWithOptions:launchOptions];
   ```
 ###  2.3 视图添加,在要展示unity的控制器的viewDidload添加
   ```
       [AWUnityManger startUnity];
        UIView *view = [AWUnityManger ufw].appController.rootViewController.view;
        CGRect viewF = self.view.bounds;
        viewF.size.height = self.view.height;
        view.frame = viewF;
        [self.view addSubview:view];
   ```
  ###  2.4为减少耗能,可以再不展示unity的时候暂停
    ```
        [[AWUnityManger ufw] pause:NO];
    ```
