//
//  RMNetwork.h
//  RMNetwork
//
//  Created by Rohit Mahto on 28/05/16.
//  Copyright © 2016 Rohit Mahto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@interface RMNetwork : NSObject {
}

+ (nonnull RMNetwork *)sharedInstance;
- (nonnull id)init
    __attribute__((unavailable("cannot use init for this class, use "
                               "+(RMNetwork*)sharedInstance instead")));
- (void)doPost:(nonnull NSString *)body
      endPoint:(nonnull NSString *)endPoint
         block:(nullable ResponceBlock)block;
- (void)doGet:(nonnull NSString *)endPoint block:(nullable ResponceBlock)block;
- (void)setConnectionTimeOut:(int)timeOut;
- (void)setSessionTimeOut:(int)timeOut;
@end
