//
//  ConnexionManager.m
//  iStingerProject
//
//  Created by UTBM on 25/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import "ConnexionManager.h"

@implementation ConnexionManager

static ConnexionManager *sharedConnexionManager = nil;

- (void) connect {
	server = [[Network alloc] init];
	void* ptr;
	
	[server connect:@"127.0.0.1" port:@"6780" callback:&receivedStream withData:ptr];
}

- (void) send:(NSString *)string {
	[server sendString:string];
}

- (void) disconnect {
	[server destroy];
}

void receivedStream (CFReadStreamRef stream, CFStreamEventType event, void *myPtr) {
	NSString *message;
	
	switch(event) {
        case kCFStreamEventHasBytesAvailable: {
            UInt8 buf[1024];
            while ([stream hasBytesAvailable]){
				CFIndex bytesRead = CFReadStreamRead(stream, buf, 1024);
				if (bytesRead > 0) {
					NSString *output = [[NSString alloc] initWithBytes:buf length:bytesRead encoding:NSASCIIStringEncoding];
					message = [NSString stringWithFormat:@"%@", output];
				}
			}
			[[CommandRobotController sharedCommandRobot] response:message];
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
