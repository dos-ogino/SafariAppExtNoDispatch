//
//  SafariExtensionHandler.m
//  MyExtension
//  
//  Created by ogino on 2019/07/16
//  Copyright © 2019 SS1. All rights reserved.
//
//

#import "SafariExtensionHandler.h"
#import "SafariExtensionViewController.h"

@interface SafariExtensionHandler ()<NSURLSessionDelegate>

@end

@implementation SafariExtensionHandler

- (void)messageReceivedWithName:(NSString *)messageName fromPage:(SFSafariPage *)page userInfo:(NSDictionary *)userInfo {
        // send to JavaScript
        NSError *error;
        NSData *jsonData ;
        NSError *localError;
        NSDictionary *resDic = @{
                                 @"logType": @"0",
                                 @"observerMode": @"0",
                                 @"key": @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                                 };
        @try {
            jsonData = [NSJSONSerialization dataWithJSONObject:resDic options:0 error:&localError];
        } @catch (NSException *exception) {
            NSDictionary *userInfo = @{ @"reason": exception.reason};
            localError = [NSError errorWithDomain:@"jp.co.xxx.SafariAppExtNoDispatch" code:1001 userInfo:userInfo];
        } @finally {
            if (localError) {
                NSLog(@"Data convert error, %@, data=%@", localError, resDic);
                error = localError;
                return;
            }
        }
        
        NSDictionary *dic = @{@"res": jsonData };  // add JSON data
//        NSDictionary *dic = @{@"res": resDic };  // add NSDictionary data
        NSLog(@"[%@ %@] dic%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), dic);
        [page dispatchMessageToScriptWithName:@"message" userInfo:dic];
}
#pragma mark - DO NOT USE
- (void)toolbarItemClickedInWindow:(SFSafariWindow *)window {
    // This method will be called when your toolbar item is clicked.
    NSLog(@"The extension's toolbar item was clicked");
}

- (void)validateToolbarItemInWindow:(SFSafariWindow *)window validationHandler:(void (^)(BOOL enabled, NSString *badgeText))validationHandler {
    // This method will be called whenever some state changes in the passed in window. You should use this as a chance to enable or disable your toolbar item and set badge text.
    validationHandler(YES, nil);
}

- (SFSafariExtensionViewController *)popoverViewController {
    return [SafariExtensionViewController sharedController];
}

@end
