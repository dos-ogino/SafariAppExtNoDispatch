//
//  SafariExtensionViewController.m
//  MyExtension
//  
//  Created by ogino on 2019/07/16
//  Copyright © 2019 SS1. All rights reserved.
//
// 更新履歴
// *********************************************************************************************************************************
// | 日付        | 氏名       | 修正Ver    | キーワード           | 対応内容                                                            |
// *********************************************************************************************************************************
// | 2019/07/16 | T.Ogino   | xx.x.x     |                    |                                                                   |
// *********************************************************************************************************************************
//

#import "SafariExtensionViewController.h"

@interface SafariExtensionViewController ()

@end

@implementation SafariExtensionViewController

+ (SafariExtensionViewController *)sharedController {
    static SafariExtensionViewController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[SafariExtensionViewController alloc] init];
        sharedController.preferredContentSize = NSMakeSize(320, 240);
    });
    return sharedController;
}

@end
