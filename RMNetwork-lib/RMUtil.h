//
//  RMUtil.h
//  RMNetwork
//
//  Created by Rohit Mahto on 28/05/16.
//  Copyright © 2016 Rohit Mahto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@interface RMUtil : NSObject
+ (RMUtil *)sharedInstance;
- (id)init __attribute__((unavailable(
    "cannot use init for this class, use +(RMUtil*)sharedInstance instead")));
+ (void)setObject:(id)object ForKey:(NSString *)key;
+ (NSInteger)getIntForkey:(NSString *)key;
+ (NSString *)getStringForKey:(NSString *)key;
+ (NSDate *)getDateForKey:(NSString *)key;
+ (id)getObjectForKey:(NSString *)key;
+ (void)popup:(NSString *)string;
void runOnMainQueueWithoutDeadlocking(void (^block)(void));
@end
