//
//  SafariExtensionViewController.h
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

#import <SafariServices/SafariServices.h>

@interface SafariExtensionViewController : SFSafariExtensionViewController

+ (SafariExtensionViewController *)sharedController;

@end
