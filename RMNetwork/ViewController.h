//
//  ViewController.h
//  RMNetwork
//
//  Created by Rohit Mahto on 30/04/18.
//  Copyright © 2018 Rohit Mahto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)login:(id)sender;
- (IBAction)checkSession:(id)sender;


@end

