//
//  MobileVerifyViewController.m
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 7/2/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import "MobileVerifyViewController.h"
#import "CommonUtils.h"

@interface MobileVerifyViewController () {
    NSTimer *counterDownTimer;
    int freezeCounter;
}

@end

@implementation MobileVerifyViewController

@synthesize targetUser, verifyCodeText, requestCodeButton, verifyButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self freezeMoreRequest];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backgroundTap:(id)sender {
    ;
}

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
    [AVUser requestMobilePhoneVerify:self.targetUser.mobilePhoneNumber withBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [CommonUtils displayError:error];
        } else {
            [self freezeMoreRequest];
        }
    }];
}

- (IBAction)verifySMSCode:(id)sender {
    NSString *smsCode = self.verifyCodeText.text;
    if (smsCode.length < 6) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"验证码无效。" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"LeanSMSDemo" code:1024 userInfo:details];
        [CommonUtils displayError:error];
        return;
    }
    [AVUser verifyMobilePhone:smsCode withBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [CommonUtils displayError:error];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"验证码确认有效！" delegate:nil
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

@end
