//
//  ViewController.h
//  LeanCloudSMSDemo
//
//  Created by Feng Junwen on 6/12/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end

