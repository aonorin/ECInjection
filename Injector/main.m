// --------------------------------------------------------------------------
//! @author Sam Deane
//! @date 15/12/2011
//
//  Copyright 2011 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <launch.h>
#import <mach/mach_init.h>
#import <servers/bootstrap.h>
#import <stdio.h>
#import <unistd.h>

#import "Injector.h"
#import "ECASLClient.h"

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        // use our bundle id as our service name
        NSString* name = [[NSBundle mainBundle] bundleIdentifier];
        const char* name_c = [name UTF8String];

        // make a helper object - this is what we'll publish with the connection
        ECASLClient* asl = [[ECASLClient alloc] initWithName:name];
        Injector* injector = [[Injector alloc] initWithASL:asl];
    
        // get the mach port to use from launchd
        mach_port_t mp;
        mach_port_t bootstrap_port;
        task_get_bootstrap_port(mach_task_self(), &bootstrap_port);
        kern_return_t result = bootstrap_check_in(bootstrap_port, name_c, &mp);
        if (result != err_none)
        {
            [asl error:@"unable to get bootstrap port"];
            exit(1);
        }

        // set up the connection
        NSMachPort *receivePort = [[NSMachPort alloc] initWithMachPort:mp];
        NSConnection*server = [NSConnection connectionWithReceivePort:receivePort sendPort:nil];
        [receivePort release];
        [server setRootObject:injector];
        
        // run
        [[NSRunLoop currentRunLoop] run];
        
        // cleanup
        [asl log:@"injector finishing"];
        [server release];
        [injector release];
        [asl release];
    }
    
    return 0;
}
