//
//  AppDelegate.m
//  VersionCheck
//
//  Created by KentarOu on 2015/05/24.
//  Copyright (c) 2015年 KentarOu. All rights reserved.
//

#import "AppDelegate.h"
#import "VersionCheck.h"

@interface AppDelegate ()
{
    VersionCheck *ver;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
     [self performSelector:@selector(versionChech) withObject:nil afterDelay:1.0];
}

- (void)versionChech {
    [[VersionCheck sharedManager] setURL:@"jsonデータを取得するURLを記述"];
    [[VersionCheck sharedManager] versionCheck];
}

@end
