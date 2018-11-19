//
//  AppDelegate.m
//  文俊购房
//
//  Created by mac on 16/5/14.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "MyTabBarViewController.h"
#import "MyInforViewController.h"

#import "MessageController.h"//消息

#define APP_ID @"ith9shGEItu6gNMDgFrjtXCj-gzGzoHsz"
#define APP_KEY @"Y8ktMctMdvQgz1uI6GtkvvoY"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置云数据库ID和KEY
    [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY];
 
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSArray *ctr = @[@"ReleaseController",@"ShoppingController",@"RootViewController",@"MessageController",@"MyViewController"];
    NSMutableArray *marr = [NSMutableArray array];
    for (NSString *ctrname in ctr) {
        UIViewController *vc = [[NSClassFromString(ctrname)alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [marr addObject:nav];
    }
    
    NSArray *images = @[@"tabBar_publish_icon",@"mine_points",@"tabBar_homepage_icon",@"tabBar_message_icon",@"tabBar_me_icon"];
    NSMutableArray *imgarr = [NSMutableArray array];
    for (NSString *imgname in images) {
        UIImage *img = [UIImage imageNamed:imgname];
        [imgarr addObject:img];
    }
    
    MyTabBarViewController *mytabbar = [[MyTabBarViewController alloc]init];
    [mytabbar tabbarWithTitle:@[@"发布",@"商城",@"首页",@"通知",@"我"] AndNOImage:imgarr AndTitleColor:[UIColor whiteColor] AndTitleFont:[UIFont systemFontOfSize:15]];
    
    mytabbar.viewControllers = marr;
    //选择第几页语句要放在添加了控制器数组之后才有效
    [mytabbar setSelectedIndex:4];
    
    _window.rootViewController = mytabbar;
    
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
