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
    // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
    [page getPagePropertiesWithCompletionHandler:^(SFSafariPageProperties *properties) {
        NSLog(@"The extension received a message (%@) from a script injected into (%@) with userInfo (%@)", messageName, properties.url, userInfo);
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [page dispatchMessageToScriptWithName:@"message" userInfo:@{@"url": properties.url.absoluteString}];
//        });
        NSError *error;
        NSDictionary *data = @{@"URL": properties.url.absoluteString,
                               @"Browser": @{@"agent": @"Safari", @"version": @"12.0"},
                               @"Title": properties.title,
//                               @"BodyRaw": userInfo[@"BodyRaw"]
                               @"BodyRaw": @"<html><body>test content wiki page.</body></htlm>"
                               };
        NSLog(@"[%@ %@] data to send=%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), data);
        BOOL result = [self sendData:data withPage:page serverPath:@"rawBody" error:&error];
        if (!result) {
            NSLog(@"Error occurred while sending data to WebLobServer, %@", error);
        }
    }];
}
/**
 Send data to server, then send its response to JavaScript
 
 @param dataDic data to send
 @param page Safari page
 @param serverPath path to add server URL
 */
- (BOOL)sendData:(NSDictionary *)dataDic withPage:(SFSafariPage *)page serverPath:(NSString *)serverPath error:(NSError * _Nullable *)error
{
    // WebLogServerのURL
    NSURL *serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:21670/%@", serverPath]];
    
    // Convert data to JSON
    NSError *localError;
    NSData *postData;
    postData = [NSJSONSerialization dataWithJSONObject:dataDic options:0 error:&localError];
    @try {
        postData = [NSJSONSerialization dataWithJSONObject:dataDic options:0 error:&localError];
    } @catch (NSException *exception) {
        NSDictionary *userInfo = @{ @"reason": exception.reason};
        localError = [NSError errorWithDomain:@"jp.co.xxx.SafariAppExtNoDispatch" code:1001 userInfo:userInfo];
    } @finally {
        if (localError) {
            NSLog(@"Data convert error, %@, data=%@", localError, dataDic);
            *error = localError;
            return NO;
        }
    }
    
    // Make ssesion
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    // Make request data
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:serverURL
                                    cachePolicy: NSURLRequestReloadIgnoringCacheData
                                    timeoutInterval: 10.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: postData];
    
    // Send data
    [[session dataTaskWithRequest: request  completionHandler: ^(NSData *data, NSURLResponse *response, NSError *requestError) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init]; // for sending JavaScript
        if (response && ! requestError) { // Success
            NSString *responseString = [[NSString alloc] initWithData: data  encoding: NSUTF8StringEncoding];
            NSLog(@"Success in sending data, response=%@", responseString);
            if (responseString.length){
                dic[@"res"] = responseString;
            }
        } else { // Fail
            NSLog(@"Fail in sending data, %@", requestError);
            dic[@"err"] = requestError.localizedDescription;
        }
        
        // Send response to JavaScript
        [page dispatchMessageToScriptWithName:@"message" userInfo:dic];
        NSLog(@"Response data sent to JavaScript in page(%@), %@", page, dic);
        
        // Close session
        [session finishTasksAndInvalidate];
    }] resume];
    
    return YES;
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
