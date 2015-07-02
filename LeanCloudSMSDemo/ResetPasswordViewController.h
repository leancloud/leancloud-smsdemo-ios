//
//  ResetPasswordViewController.h
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 7/1/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *mobilePhoneText;
@property (nonatomic, strong) IBOutlet UITextField *verifyCodeText;
@property (nonatomic, strong) IBOutlet UIButton *requestCodeButton;
@property (nonatomic, strong) IBOutlet UITextField *passwordText;
@property (nonatomic, strong) IBOutlet UIButton *resetPasswordButton;

@end
