//
//  CommonUtils.m
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 7/2/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import "CommonUtils.h"
#import <UIKit/UIKit.h>

@implementation CommonUtils

+ (void)displayError:(NSError*)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发生错误" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
