//
//  RMNetwork.m
//  RMNetwork
//
//  Created by Rohit Mahto on 28/05/16.
//  Copyright © 2016 Rohit Mahto. All rights reserved.
//

#import "RMNetwork.h"
#import "Constant.h"
#import "RMUtil.h"
@interface RMNetwork () {
  dispatch_queue_t _requestQueue;
  dispatch_semaphore_t _renewSessionSemaphore;
  int _timeOut;
  int _sessionTimeOut;
  NSObject *_lock;
}
@end

@implementation RMNetwork
+ (RMNetwork *)sharedInstance {
  static RMNetwork *_sharedInstance = nil;
  static dispatch_once_t onceExecuteTables;
  dispatch_once(&onceExecuteTables, ^{
    _sharedInstance = [RMNetwork new];

  });
  return _sharedInstance;
}

- (id)init {
  self = [super init];
  if (self) {
    _requestQueue =
        dispatch_queue_create("com.rmNetwork.queue", DISPATCH_QUEUE_CONCURRENT);
    _renewSessionSemaphore = dispatch_semaphore_create(0);
    _timeOut = 10;
  }
  return self;
}

- (NSString *)getBaseUrlWithEndPoint:(NSString *)endpointUrl {
  return [NSString stringWithFormat:@"%@%@", kBaseURL, endpointUrl];
}

- (void)doPost:(NSString *)body
      endPoint:(NSString *)endPoint
         block:(ResponceBlock)block {
  dispatch_async(_requestQueue, ^{
    if (![endPoint containsString:kloginEndpoint] && ![self isSeesionAlive]) {
      [self renewSession];
      dispatch_semaphore_wait(_renewSessionSemaphore, DISPATCH_TIME_FOREVER);
      if (![self isSeesionAlive]) {
        NSLog(@"Can not renew Session , send User to login");
        return;
      }
    }
    NSString *requestUrl = [self getBaseUrlWithEndPoint:endPoint];
    if (!requestUrl) {
      NSLog(@"Error creating request Url");
      return;
    }
    NSLog(@"Posting data to end point %@", requestUrl);
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (error == nil && data != nil) {
      NSError *error;
      NSDictionary *responseObject =
          [NSJSONSerialization JSONObjectWithData:data
                                          options:kNilOptions
                                            error:&error];
      if (!responseObject) {
        NSLog(@"Internal Error Occured");
        runOnMainQueueWithoutDeadlocking(^{
          block(responseObject, error);
        });
        return;
      }
      NSDictionary *response = (NSMutableDictionary *)responseObject;
      if (!(response[@"success"] && [response[@"success"] boolValue])) {
        NSString *error_msg = response[@"error_message"];
        if (error_msg) {
          error_msg = response[@"error_message"];
        } else {
          error_msg = @"Invalid response, please contact Marketo support.";
        }
        NSLog(@"%@", error_msg);
        runOnMainQueueWithoutDeadlocking(^{
          block(responseObject, error);
          [RMUtil
              setObject:[NSNumber numberWithDouble:[[NSDate date]
                                                       timeIntervalSince1970]]
                 ForKey:kLastSyncTimeKey];
        });
        return;
      } else {
        runOnMainQueueWithoutDeadlocking(^{
          block(responseObject, error);
        });
        return;
      }
    } else {
      runOnMainQueueWithoutDeadlocking(^{
        block(nil, error);
      });
      return;
    }

  });
}

- (void)doGet:(NSString *)endPoint
        block:(nullable void (^)(NSDictionary *_Nullable object,
                                 NSError *_Nullable error))block {
  dispatch_async(_requestQueue, ^{
    if (![endPoint containsString:kloginEndpoint] && ![self isSeesionAlive]) {
      [self renewSession];
      dispatch_semaphore_wait(_renewSessionSemaphore, DISPATCH_TIME_FOREVER);
      if (![self isSeesionAlive]) {
        NSLog(@"Can not renew Session , send User to login");
        return;
      }
    }
    NSString *requestUrl = [self getBaseUrlWithEndPoint:endPoint];
    if (!requestUrl) {
      NSLog(@"Error creating request Url");
      return;
    }
    NSLog(@"Getting data from end point %@", requestUrl);
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:url
                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                            timeoutInterval:10];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (error == nil && data != nil) {
      NSError *error;
      NSDictionary *responseObject =
          [NSJSONSerialization JSONObjectWithData:data
                                          options:kNilOptions
                                            error:&error];
      if (!responseObject) {
        NSLog(@"Internal Error Occured");
        runOnMainQueueWithoutDeadlocking(^{
          block(responseObject, error);
        });
        return;
      }
      NSDictionary *response = (NSMutableDictionary *)responseObject;
      if (!(response[@"success"] && [response[@"success"] boolValue])) {
        NSString *error_msg = response[@"error_message"];
        if (error_msg) {
          error_msg = response[@"error_message"];
        } else {
          error_msg = @"Invalid response, please contact Marketo support.";
        }
        NSLog(@"%@", error_msg);
        runOnMainQueueWithoutDeadlocking(^{
          block(responseObject, error);
        });

        return;
      } else {
        runOnMainQueueWithoutDeadlocking(^{
          [RMUtil
              setObject:[NSNumber numberWithDouble:[[NSDate date]
                                                       timeIntervalSince1970]]
                 ForKey:kLastSyncTimeKey];
          block(responseObject, error);
          NSLog(@"Updated lst %f",
                (double)[[NSDate date] timeIntervalSince1970]);

        });
        return;
      }
    } else {
      runOnMainQueueWithoutDeadlocking(^{
        block(nil, error);
      });
      return;
    }

  });
}

- (void)setConnectionTimeOut:(int)timeOut {
  _timeOut = timeOut;
  kConectionTimeOut = _timeOut;
}

- (void)setSessionTimeOut:(int)timeOut {
  kSessionTimeOut = timeOut;
  _sessionTimeOut = timeOut;
}

- (BOOL)isSeesionAlive {
  NSNumber *lst = (NSNumber *)[RMUtil getObjectForKey:kLastSyncTimeKey];
  if (lst == nil) {
    NSLog(@"lSession is expired");
    return NO;
  }
  if (((double)[[NSDate date] timeIntervalSince1970] - [lst doubleValue]) >
      kSessionTimeOut) {
    NSLog(@"lSession is expired");
    return NO;
  }

  NSLog(@"Session is live");
  return YES;
}

- (void)renewSession {
  @synchronized(self) {
    NSString *userName = [RMUtil getObjectForKey:kUserNameKey];
    NSString *password = [RMUtil getObjectForKey:kPasswordKey];
    NSString *login = [NSString
        stringWithFormat:@"%@%@/%@", kloginEndpoint, userName, password];
    [self
        doGet:login
        block:^(NSDictionary *_Nullable object, NSError *_Nullable error) {
          if (error == nil && [object objectForKey:@"success"]) {
            [RMUtil setObject:[object objectForKey:@"token"] ForKey:kTokenKey];
          }
          dispatch_semaphore_signal(_renewSessionSemaphore);
        }];
  }
}

@end
