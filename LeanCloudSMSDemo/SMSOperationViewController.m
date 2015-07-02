//
//  SMSOperationViewController.m
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 7/1/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import "SMSOperationViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CommonUtils.h"


@interface SMSOperationViewController () {
    NSTimer *counterDownTimer;
    int freezeCounter;
}

@end

@implementation SMSOperationViewController

@synthesize mode, userLogin, mobilePhoneText, verifyCodeText, requestCodeButton, verifyButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.userLogin) {
        [self.verifyButton setTitle:@"用户登录" forState:UIControlStateNormal];
    } else {
        [self.verifyButton setTitle:@"验证手机号" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)freezeMoreRequest {
    // 一分钟内禁止再次发送
    [self.requestCodeButton setEnabled:NO];
    freezeCounter = 60;
    counterDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownRequestTimer) userInfo:nil repeats:YES];
    [counterDownTimer fire];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证码已发送" message:@"验证码已发送到你请求的手机号码。如果没有收到，可以在一分钟后尝试重新发送。"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)requestVerifyCode:(id)sender {
    NSLog(@"requestVerifyCode");
    NSString *mobileNum = self.mobilePhoneText.text;
    if (mobileNum.length != 11) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"手机号码无效。" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"LeanSMSDemo" code:1024 userInfo:details];
        [CommonUtils displayError:error];
        return;
    }
    if (self.userLogin) {
        [AVUser requestLoginSmsCode:mobileNum withBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [CommonUtils displayError:error];
            } else {
                [self freezeMoreRequest];
            }
        }];
    } else if (self.mode == SMSSendModeSimple) {
        // 简单模式
        [AVOSCloud requestSmsCodeWithPhoneNumber:mobileNum callback:^(BOOL succeeded, NSError *error) {
            if (error) {
                [CommonUtils displayError:error];
            } else {
                [self freezeMoreRequest];
            }
        }];
    } else if (self.mode == SMSSendModeFlex) {
        // 复杂模式
        [AVOSCloud requestSmsCodeWithPhoneNumber:mobileNum appName:@"LeanTest" operation:@"测试" timeToLive:30 callback:^(BOOL succeeded, NSError *error) {
            if (error) {
                [CommonUtils displayError:error];
            } else {
                [self freezeMoreRequest];
            }
        }];
    } else if (self.mode == SMSSendModeTemplate) {
        // 模版
        NSDictionary *templateArgs = [NSDictionary dictionaryWithObject:@"各单位请注意，这是在测试 LeanCloud 短信。" forKey:@"data"];
        [AVOSCloud requestSmsCodeWithPhoneNumber:mobileNum templateName:@"mongo-index-alert" variables:templateArgs callback:^(BOOL succeeded, NSError *error) {
            if (error) {
                [CommonUtils displayError:error];
            } else {
                [self freezeMoreRequest];
            }
        }];
    } else {
        // 语音验证码
        [AVOSCloud requestVoiceCodeWithPhoneNumber:mobileNum IDD:nil callback:^(BOOL succeeded, NSError *error) {
            if (error) {
                [CommonUtils displayError:error];
            } else {
                [self freezeMoreRequest];
            }
        }];
    }
}

- (void)countDownRequestTimer {
    static NSString *counterFormat = @"%d 秒后再获取";
    --freezeCounter;
    if (freezeCounter<= 0) {
        [counterDownTimer invalidate];
        counterDownTimer = nil;
        [self.requestCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.requestCodeButton setEnabled:YES];
    } else {
        [self.requestCodeButton setTitle:[NSString stringWithFormat:counterFormat, freezeCounter] forState:UIControlStateNormal];
    }
}

- (IBAction)verifySMSCode:(id)sender {
    NSString *mobileNum = self.mobilePhoneText.text;
    NSString *smsCode = self.verifyCodeText.text;
    if (mobileNum.length != 11) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"手机号码无效。" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"LeanSMSDemo" code:1024 userInfo:details];
        [CommonUtils displayError:error];
        return;
    }
    if (smsCode.length < 6) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"验证码无效。" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"LeanSMSDemo" code:1024 userInfo:details];
        [CommonUtils displayError:error];
        return;
    }
    if (self.userLogin) {
        [AVUser logInWithMobilePhoneNumberInBackground:mobileNum smsCode:smsCode block:^(AVUser *user, NSError *error) {
            if (error) {
                [CommonUtils displayError:error];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"用户登录成功！" delegate:nil
                                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    } else {
        [AVOSCloud verifySmsCode:smsCode mobilePhoneNumber:mobileNum callback:^(BOOL succeeded, NSError *error) {
            if (error) {
                [CommonUtils displayError:error];
            } else if (succeeded){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"验证码确认有效！" delegate:nil
                                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"表玩我" message:@"验证码无效哦！" delegate:nil
                                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }
}

@end
