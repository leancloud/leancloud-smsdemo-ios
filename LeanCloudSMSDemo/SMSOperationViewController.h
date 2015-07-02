//
//  SMSOperationViewController.h
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 7/1/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SMSSendMode) {
    SMSSendModeSimple = 0,
    SMSSendModeFlex,
    SMSSendModeTemplate,
    SMSSendModeVoice
};

@interface SMSOperationViewController : UIViewController

@property (nonatomic) SMSSendMode mode;  // 短信发送模式选择：简单，复杂，自定义模版，语音
@property (nonatomic) BOOL userLogin;    // 是否用于用户手机号＋验证码登录
@property (nonatomic, strong) IBOutlet UITextField *mobilePhoneText;
@property (nonatomic, strong) IBOutlet UITextField *verifyCodeText;
@property (nonatomic, strong) IBOutlet UIButton *requestCodeButton;
@property (nonatomic, strong) IBOutlet UIButton *verifyButton;

@end
