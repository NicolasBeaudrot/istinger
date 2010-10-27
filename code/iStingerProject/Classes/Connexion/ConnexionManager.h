//
//  ConnexionManager.h
//  iStingerProject
//
//  Created by UTBM on 25/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network.h"

@interface ConnexionManager : NSObject {
	Network *server;
}

+ (ConnexionManager *) sharedConnexion;
- (void) connect;
- (void) disconnect;
- (void) send:(NSString *)string;
void receivedStream (CFReadStreamRef stream, CFStreamEventType event, void *myPtr);

@end
