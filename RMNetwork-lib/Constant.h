//
//  Header.h
//  RMNetwork
//
//  Created by Rohit Mahto on 28/05/16.
//  Copyright © 2016 Rohit Mahto. All rights reserved.
//

static NSString *_Nonnull const kBaseURL = @"http://localhost:9999";
static NSString *_Nonnull const kUserNameKey = @"userName";
static NSString *_Nonnull const kPasswordKey = @"password";
static NSString *_Nonnull const kTokenKey = @"token";
static NSString *_Nonnull const kTimeOutKey = @"timeOut";
static NSString *_Nonnull const kLastSyncTimeKey = @"lst";
static int kSessionTimeOut = 1 * 60;
static int kConectionTimeOut = 20;
static NSString *_Nonnull const kloginEndpoint = @"/login/";
static NSString *_Nonnull const kupdateEndpoint = @"/update/";

typedef void (^ResponceBlock)(NSDictionary *_Nullable object,
                              NSError *_Nullable error);

// enum SESSION_RENEW_MODE{
//    SESSION_RENEW_MODE_TOKEN;
//    SESSION_RENEW_MODE_CREDENTIALS;
//};
