//
//  ResetPasswordViewController.m
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 7/1/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "CommonUtils.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ResetPasswordViewController () {
    NSTimer *counterDownTimer;
    int freezeCounter;
}

@end

@implementation ResetPasswordViewController

@synthesize mobilePhoneText, requestCodeButton, verifyCodeText, passwordText, resetPasswordButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mobilePhoneText setText:[AVUser currentUser].mobilePhoneNumber];
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

- (IBAction)requestSMSCode:(id)sender {
    [AVUser requestPasswordResetWithPhoneNumber:[AVUser currentUser].mobilePhoneNumber block:^(BOOL succeeded, NSError *error) {
        if (error) {
            [CommonUtils displayError:error];
        } else {
            [self freezeMoreRequest];
        }
        ;
    }];
}

- (IBAction)resetPassword:(id)sender {
    NSString *newPassword = self.passwordText.text;
    NSString *smsCode = self.verifyCodeText.text;
    if (newPassword.length < 6) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"密码长度必须在 6 位（含）以上。" forKey:NSLocalizedDescriptionKey];
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
    [AVUser resetPasswordWithSmsCode:smsCode newPassword:newPassword block:^(BOOL succeeded, NSError *error) {
        if (error) {
            [CommonUtils displayError:error];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"已经成功重置当前用户的密码！" delegate:nil
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

@end
