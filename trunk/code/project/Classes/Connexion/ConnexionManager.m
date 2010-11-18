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
	return self;
}

- (void) connect {
	server = [[Network alloc] init];
	void* ptr;
	if ([server connect:host port:@"6780" callback:&receivedStream withData:ptr] == TRUE) {
		NSLog(@"Connected to %@ ", host);
		connected = TRUE;
	} else {
		NSLog(@"Not connected");
		connected = FALSE;
	}
}

- (void) send:(NSString *)string {
	[server sendString:string];
}

- (void) disconnect {
	connected = FALSE;
	[server destroy];
}

- (void) setHost:(NSString *)ip {
	host = ip;
}

- (Boolean) isConnected {
	return connected;
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
			[[CommandRobotController sharedCommand] serverResponse:output];
            break;
		}
        case kCFStreamEventErrorOccurred: {
			NSLog(@"Socket error");
            CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFReadStreamClose(stream);
            CFRelease(stream);
            break; 
		}
		case kCFStreamEventEndEncountered: {
			NSLog(@"Connexion closed");
            CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFReadStreamClose(stream);
            CFRelease(stream);
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
