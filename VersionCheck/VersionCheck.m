//
//  VersionCheck.m
//  VersionCheck
//
//  Created by KentarOu on 2015/05/24.
//  Copyright (c) 2015年 KentarOu. All rights reserved.
//

#import "VersionCheck.h"

static VersionCheck *sharedData_ = nil;


@interface VersionCheck() <UIAlertViewDelegate>
{
    UIAlertView *alert1;
    UIAlertController *alert2;
}

@property (nonatomic) NSString *accessURL;

@property (nonatomic) NSString *alertTitle;
@property (nonatomic) NSString *alertBody;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *requiredVersion;

@end

@implementation VersionCheck


+ (VersionCheck*)sharedManager {
    @synchronized(self){
        if (!sharedData_) {
            sharedData_ = [VersionCheck new];
        }
    }
    return sharedData_;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setURL:(NSString*)url {
     _accessURL = url;
}

-(void) versionCheck {
    
    [self closeAlert];

    NSURL* myURL = [NSURL URLWithString:_accessURL];
    NSURLRequest* myRequest = [NSURLRequest requestWithURL:myURL];
    
    [NSURLConnection sendAsynchronousRequest:myRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
                               
                               NSLog(@"NSURLResponse is %@",resp);
                               
                               /* 取得JSON形式
                                {
                                    "required_version":"【アプリバージョン】",
                                    "type":"force",
                                    "title":"【アラートタイトル】",
                                    "message":"【アラートメッセージ"】,
                                    "update_url":"【safari起動URL】"
                                }
                                */
                               
                               if (data) {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&error];
                                   
                                   NSLog(@"dict = %@",dict);
                                   
                                   _alertTitle = [dict objectForKey:@"title"];
                                   _alertBody = [dict objectForKey:@"message"];
                                   _url = [dict objectForKey:@"update_url"];
                                   _requiredVersion = [dict objectForKey:@"required_version"];
                                   
                                   if ([self isVersionUpNeeded]) {
                                       
                                       [self showAlert];
                                   }
                               }
                           }];
    
}



- (void) showAlert {
    
    if ([UIAlertController class]) {
        
        alert2 = [UIAlertController alertControllerWithTitle:_alertTitle message:_alertBody preferredStyle:UIAlertControllerStyleAlert];
        [alert2 addAction:[UIAlertAction actionWithTitle:@"DownLoad Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self openStore];
        }]];
        
        [alert2 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        
        // 親ビューを検索
        UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
            baseView = baseView.presentedViewController;
        }
        [baseView presentViewController:alert2 animated:YES completion:nil];
        
    } else {
        
        alert1 = [[UIAlertView alloc]initWithTitle:_alertTitle
                                                       message:_alertBody
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"DownLoad Now", nil];
        [alert1 show];
    }
}

- (BOOL) isVersionUpNeeded {
    NSString *currentVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *requiredVersion = _requiredVersion;
    return ( [requiredVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending );
}

- (void)openStore {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _url]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.cancelButtonIndex != buttonIndex) {
        [self openStore];
    }
}

- (void)closeAlert {
    if (alert1) {
        [alert1 dismissWithClickedButtonIndex:alert1.cancelButtonIndex animated:NO];
        alert1 = nil;
    }
    
    if (alert2) {
        [alert2 dismissViewControllerAnimated:NO completion:nil];
        alert2 = nil;
    }
}

- (void)dealloc {
    [self closeAlert];
}

@end
