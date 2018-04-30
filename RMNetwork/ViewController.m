//
//  ViewController.m
//  RMNetwork
//
//  Created by Rohit Mahto on 30/04/18.
//  Copyright © 2018 Rohit Mahto. All rights reserved.
//

#import "ViewController.h"
#import "RMUtil.h"
#import "RMNetwork.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)login:(id)sender {
    RMNetwork *rm = [RMNetwork sharedInstance];
    [rm setConnectionTimeOut:20];
    [rm setSessionTimeOut:60];
    
    NSString *login = [NSString stringWithFormat:@"%@%@/%@", kloginEndpoint,
                       _username.text, _password.text];
    [rm doGet:login
        block:^(NSDictionary *_Nullable object, NSError *_Nullable error) {
            if (object != nil && [[object objectForKey:@"success"] boolValue]) {
                [RMUtil popup:@"OK"];
                [RMUtil setObject:_username.text ForKey:kUserNameKey];
                [RMUtil setObject:_password.text ForKey:kPasswordKey];
            }
        }];
}

- (IBAction)checkSession:(id)sender {
    [[RMNetwork sharedInstance]
     doGet:@"/update/username/virat"
     block:^(NSDictionary *_Nullable object, NSError *_Nullable error) {
         if (object != nil && [[object objectForKey:@"success"] boolValue]) {
             [RMUtil popup:@"SESSION OK"];
         }
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
