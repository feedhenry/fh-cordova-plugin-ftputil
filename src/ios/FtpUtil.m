//
//  FtpUtil.m
//  PhoneGapLib
//
//  Created by Wei Li on 04/01/2012.
//  Copyright 2012 FeedHenry. All rights reserved.
//

#import "FtpUtil.h"


@implementation FtpUtil
@synthesize callbackId;

- (void) ftplist: (CDVInvokedUrlCommand*) command
{
  self.callbackId = command.callbackId;
  NSDictionary *parameters = [command.arguments objectAtIndex:0];
  [self ftplistWithOptions: parameters];
}

- (void) ftplistWithOptions:(NSDictionary*) options
{
  NSString* url = (NSString*)[options objectForKey:@"url"];
  NSString* username = (NSString*)[options objectForKey:@"user"];
  NSString* password = (NSString*)[options objectForKey:@"password"];
  NSURL* listrequest = (NSURL*)[NSURL URLWithString:url];
  if(nil != listrequest){
    WRRequestListDirectory * listReq = [[WRRequestListDirectory alloc] init];
    listReq.delegate = self;
    listReq.path = [listrequest path];
    listReq.hostname = [listrequest host];
    if (nil != [listrequest user]) {
      listReq.username = [[listrequest user] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if (nil != [listrequest password]) {
      listReq.password = [[listrequest password] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
        if (nil != username){
            listReq.username = username;
        }
        if (nil != password) {
            listReq.password = password;
        }
    [listReq start];
  } else {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:5];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
  }
}

-(void) requestCompleted:(WRRequest *) theRequest 
{
  NSLog(@"ftp list request %@ completed", theRequest);
  WRRequestListDirectory * listReq = (WRRequestListDirectory *) theRequest;
  NSMutableArray * jsArray = [NSMutableArray arrayWithCapacity:10];
  
  for (NSDictionary * file in listReq.filesInfo) {
    NSString* fileName = (NSString*)[file objectForKey:(id)kCFFTPResourceName];
    NSLog(@"found %@", fileName);
    NSNumber * fileType = (NSNumber*)[file objectForKey:(id)kCFFTPResourceType];
    NSNumber * fileSize = (NSNumber*)[file objectForKey:(id)kCFFTPResourceSize];
    if (nil == fileSize) {
      fileSize = [NSNumber numberWithInt:0];
    }
    NSDate * fileDate = (NSDate*)[file objectForKey:(id)kCFFTPResourceModDate];
    if (nil == fileDate) {
      fileDate = [NSDate date];
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:fileName forKey:@"name"];
    [dict setObject:fileSize forKey:@"size"];
    NSString* type = @"file";
    if ([fileType intValue] == 4) {
      type = @"directory";
    }
    [dict setObject:type forKey:@"type"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss:SSS"];
    NSString *formattedDateString = [dateFormatter stringFromDate:fileDate];
    NSLog(@"Size: %d, Type : %@, Mod date : %@", [fileSize intValue], type, formattedDateString);
    [dict setObject:formattedDateString forKey:@"timestamp"];
    [jsArray addObject:dict];
  }
  
  CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:jsArray];
  [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}


-(void) requestFailed:(WRRequest *) theRequest
{
  NSLog(@"list failed");
  NSLog(@"Error : %@", theRequest.error.message);
  CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:1];
  [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

@end
