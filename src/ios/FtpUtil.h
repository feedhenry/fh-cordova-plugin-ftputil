//
//  FtpUtil.h
//  PhoneGapLib
//
//  Created by Wei Li on 04/01/2012.
//  Copyright 2012 FeedHenry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "WhiteRaccoon.h"


@interface FtpUtil : CDVPlugin {
  NSString *callbackId;
}

- (void) ftplist: (CDVInvokedUrlCommand*) command;

@property (nonatomic, retain) NSString *callbackId;

@end