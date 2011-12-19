// --------------------------------------------------------------------------
//! @author Sam Deane
//! @date 15/12/2011
//
//  Copyright 2011 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface Injector : NSObject<NSConnectionDelegate>

@property (nonatomic, assign) pid_t pid;
@property (nonatomic, assign) uid_t uid;
@property (nonatomic, assign) uid_t euid;

- (id)initWithName:(NSString*)name;
- (void)log:(NSString*)msg;
- (void)error:(NSString*)msg;
- (NSString*)doCommand:(NSString*)command;

@end
