//
//  VersionCheck.h
//  VersionCheck
//
//  Created by KentarOu on 2015/05/24.
//  Copyright (c) 2015年 KentarOu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VersionCheck : NSObject

// シングルトン
+ (VersionCheck*)sharedManager;

// アクセスURL設定
- (void)setURL:(NSString*)url;
- (void)versionCheck;
- (void)closeAlert;

@end
