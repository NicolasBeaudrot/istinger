//
//  ConnexionManager.m
//  iStingerProject
//
//  Created by UTBM on 25/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import "ConnexionManager.h"

@implementation ConnexionManager
@synthesize host;

static ConnexionManager *sharedConnexionManager = nil;

- (id) init {
	host = @"127.0.0.1";
	connected = FALSE;
	arCommand = [[NSMutableArray alloc] init];  
	return self;
}

- (void) connect {
	server = [[Network alloc] init];
	void* ptr;
	if ([server connect:host port:@"6780" callback:&receivedStream withData:ptr] == TRUE) {
		NSLog(@"Try to connect to %@ ", host);
		connected = TRUE;
	} else {
		NSLog(@"Error while connecting.");
		connected = FALSE;
	}
}

- (void) send:(NSString *)string {
	if (connected == TRUE) {
		NSArray *tabString = [string componentsSeparatedByString:@" "];
		[arCommand addObject:(NSString *)[tabString objectAtIndex:0]];
		[server sendString:string];
	}
}

- (void) disconnect {
	connected = FALSE;
}

- (void) setHost:(NSString *)ip {
	host = ip;
}

- (Boolean) isConnected {
	return connected;
}

- (void) receivedMessage:(NSString *)message {
	if ([arCommand count] > 0) {
		NSString *command = [arCommand objectAtIndex:0];
		[[CommandRobotController sharedCommand] serverResponse:command:message];
		[arCommand removeObjectAtIndex:0];
	}
}

void receivedStream (CFReadStreamRef stream, CFStreamEventType event, void *myPtr) {
	NSString *output;
	
	switch(event) {
        case kCFStreamEventHasBytesAvailable: {
            UInt8 buf[1024];
			CFIndex bytesRead = CFReadStreamRead(stream, buf, 1024);
			if (bytesRead > 0) {
				output = [[NSString alloc] initWithBytes:buf length:bytesRead encoding:NSASCIIStringEncoding];
			}
			
			[[ConnexionManager sharedConnexion] receivedMessage:output];
            break;
		}
        case kCFStreamEventErrorOccurred: {
			NSLog(@"Socket error");
            CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFReadStreamClose(stream);
            CFRelease(stream);
			[[ConnexionManager sharedConnexion] disconnect];
            break; 
		}
		case kCFStreamEventEndEncountered: {
			NSLog(@"Connexion closed");
            CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFReadStreamClose(stream);
            CFRelease(stream);
			[[ConnexionManager sharedConnexion] disconnect];
            break;
		}
	}
}

+ (ConnexionManager *) sharedConnexion {
    if (sharedConnexionManager == nil) {
        sharedConnexionManager = [[super allocWithZone:NULL] init];
    }
    return sharedConnexionManager;
}

@end
