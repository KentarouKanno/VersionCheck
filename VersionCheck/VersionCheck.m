//
//  VersionCheck.m
//  VersionCheck
//
//  Created by KentarOu on 2015/05/24.
//  Copyright (c) 2015年 KentarOu. All rights reserved.
//

#import "VersionCheck.h"


@interface VersionCheck() <UIAlertViewDelegate>

@property (nonatomic) NSString *accessURL;

@property (nonatomic) NSString *alertTitle;
@property (nonatomic) NSString *alertBody;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *requiredVersion;

@end

@implementation VersionCheck

- (id)initWithCheckURL:(NSString*)url {
    self = [super init];
    if(self) {
        _accessURL = url;
        
    }
    return self;
}

-(void) versionCheck {

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
    
    if (![UIAlertController class]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:_alertTitle message:_alertBody preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"DownLoad Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self openStore];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        
        // 親ビューを検索
        UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
            baseView = baseView.presentedViewController;
        }
        [baseView presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:_alertTitle
                                                       message:_alertBody
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"DownLoad Now", nil];
        [alert show];
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

@end
