//
//  SignupViewController.m
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 7/1/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import "SignupViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CommonUtils.h"
#import "MobileVerifyViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize username, password, mobilePhone;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)backgroundTap:(id)sender {
    ;
}

- (IBAction)signUp:(id)sender {
    if (self.username.text.length < 1) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"用户名不能为空。" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"LeanSMSDemo" code:1024 userInfo:details];
        [CommonUtils displayError:error];
        return;
    }
    if (self.password.text.length < 1) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"密码不能为空。" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"LeanSMSDemo" code:1024 userInfo:details];
        [CommonUtils displayError:error];
        return;
    }
    if (self.mobilePhone.text.length < 1) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"手机号码不能为空。" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"LeanSMSDemo" code:1024 userInfo:details];
        [CommonUtils displayError:error];
        return;
    }
    AVUser* user = [[AVUser alloc] init];
    user.username = self.username.text;
    user.password = self.password.text;
    user.mobilePhoneNumber = self.mobilePhone.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [CommonUtils displayError:error];
        } else {
            // 注册成功
            MobileVerifyViewController *verifyVC = [[MobileVerifyViewController alloc] initWithNibName:@"MobileVerifyViewController" bundle:nil];
            verifyVC.targetUser = user;
            [self.navigationController pushViewController:verifyVC animated:YES];
        }
    }];
}

@end
