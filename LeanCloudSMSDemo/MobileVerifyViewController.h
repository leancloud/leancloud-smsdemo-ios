//
//  MobileVerifyViewController.h
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 7/2/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface MobileVerifyViewController : UIViewController

@property (nonatomic, strong) AVUser *targetUser;
@property (nonatomic, strong) IBOutlet UITextField *verifyCodeText;
@property (nonatomic, strong) IBOutlet UIButton *requestCodeButton;
@property (nonatomic, strong) IBOutlet UIButton *verifyButton;

@end
