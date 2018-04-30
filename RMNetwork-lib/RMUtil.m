//
//  RMUtil.m
//  RMNetwork
//
//  Created by Rohit Mahto on 28/05/16.
//  Copyright © 2016 Rohit Mahto. All rights reserved.
//

#import "RMUtil.h"
#import <UIKit/UIKit.h>
@implementation RMUtil
+ (RMUtil *)sharedInstance {
  static RMUtil *_sharedInstance = nil;
  static dispatch_once_t onceExecuteTables;
  dispatch_once(&onceExecuteTables, ^{
    _sharedInstance = [RMUtil new];
  });
  return _sharedInstance;
}

- (id)init {
  self = [super init];
  return self;
}

+ (BOOL)isStringEmpty:(NSString *)string {
  return ([self isObjectNull:string] || [string isEqualToString:@""]);
}

+ (BOOL)isObjectNull:(id)object {
  return (!object || object == (id)[NSNull null]);
}

void runOnMainQueueWithoutDeadlocking(void (^block)(void)) {
  if ([NSThread isMainThread]) {
    block();
  } else {
    dispatch_sync(dispatch_get_main_queue(), block);
  }
}

+ (NSString *)getStringForKey:(NSString *)key {
  NSString *val = @"";
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
  if (standardUserDefaults)
    val = [standardUserDefaults stringForKey:key];
  if (val == NULL)
    val = @"";
  return val;
}

+ (NSDate *)getDateForKey:(NSString *)key {
  NSDate *val = [NSDate date];
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
  val = [standardUserDefaults objectForKey:key];
  return val;
}

+ (id)getObjectForKey:(NSString *)key {
  @synchronized(self) {
    NSUserDefaults *standardUserDefaults =
        [NSUserDefaults standardUserDefaults];
    id objData = [standardUserDefaults objectForKey:key];
    return objData;
  }
}

+ (NSInteger)getIntForkey:(NSString *)key {
  NSInteger val = 0;
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
  if (standardUserDefaults)
    val = [standardUserDefaults integerForKey:key];
  return val;
}

+ (void)setObject:(id)object ForKey:(NSString *)key {
  @synchronized(self) {
    @try {
      NSUserDefaults *standardUserDefaults =
          [NSUserDefaults standardUserDefaults];
      if (object && object != (id)[NSNull null]) {
        [standardUserDefaults setObject:object forKey:key];
        [standardUserDefaults synchronize];
      }
    } @catch (NSException *exception) {
      NSLog(@"%@", exception.reason);
    }
  }
}

+ (void)popup:(NSString *)string {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App"
                                                    message:string
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
  });
}
@end
