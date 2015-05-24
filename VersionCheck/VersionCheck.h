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

- (id)initWithCheckURL:(NSString*)url;
- (void) versionCheck;

@end
