//
//  ViewController.m
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 6/12/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import "ViewController.h"
#import "SMSOperationViewController.h"
#import "SignupViewController.h"
#import "ResetPasswordViewController.h"
#import "CommonUtils.h"
#import <AVOSCloud/AVOSCloud.h>

static NSString *gSMSOperationCellIdentifier = @"SMSTableViewCellIdentifier";

@interface ViewController () {
    BOOL _featureEnable;
}

@end

@implementation ViewController

@synthesize tableView;

static NSString *gCellTexts[2][4] = {{@"请求短信验证码(简单模式)", @"请求短信验证码(复杂模式)", @"请求短信验证码(自定义模版)", @"请求语音验证码"},
    {@"使用手机号注册用户", @"使用手机号和验证码登录", @"使用验证码重置密码", @"退出当前登录用户"}};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"LeanSMS Demo";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[AVOSCloud getApplicationId] hasPrefix:@"yourAppId"]) {
        _featureEnable = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"你还没有正确初始化 appId 和 appKey，所有功能都不可用！" delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        _featureEnable = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 4;
    } else {
        return 4;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tabView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:gSMSOperationCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gSMSOperationCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = gCellTexts[section][row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"普通用法";
    } else {
        return @"AVUser 相关";
    }
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_featureEnable) {
        return;
    }
    if (indexPath.section == 0) {
        SMSOperationViewController *smsOperationVC = [[SMSOperationViewController alloc] initWithNibName:@"SMSOperationViewController" bundle:nil];
        switch (indexPath.row) {
            case 0:
                smsOperationVC.mode = SMSSendModeSimple;
                break;
            case 1:
                smsOperationVC.mode = SMSSendModeFlex;
                break;
            case 2:
                smsOperationVC.mode = SMSSendModeTemplate;
                break;
            case 3:
                smsOperationVC.mode = SMSSendModeVoice;
                break;
            default:
                smsOperationVC.mode = SMSSendModeSimple;
                break;
        }
        smsOperationVC.userLogin = NO;
        [self.navigationController pushViewController:smsOperationVC animated:YES];
    } else {
        UIViewController *nextViewController = nil;
        switch (indexPath.row) {
            case 0:
                // 注册新用户
                nextViewController = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
                break;
            case 1:
                // 手机号＋验证码登录
                nextViewController = [[SMSOperationViewController alloc] initWithNibName:@"SMSOperationViewController" bundle:nil];
                ((SMSOperationViewController*)nextViewController).userLogin = YES;
                ((SMSOperationViewController*)nextViewController).mode = SMSSendModeSimple;
                break;
            case 2:
                if (![AVUser currentUser]) {
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:@"请先通过手机号＋验证码完成登录。" forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"LeanSMSDemo" code:1024 userInfo:details];
                    [CommonUtils displayError:error];
                } else {
                    nextViewController = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
                }
                break;
            case 3:
                // logout
                if (![AVUser currentUser]) {
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:@"你还没有登录呢。。。" forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"LeanSMSDemo" code:1024 userInfo:details];
                    [CommonUtils displayError:error];
                } else {
                    [AVUser logOut];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"成功退出当前账户！" delegate:nil
                                                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                break;
            default:
                break;
        }
        if (nextViewController) {
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

@end
