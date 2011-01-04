//
//  ConnexionManager.h
//  iStingerProject
//
//  Created by UTBM on 25/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network.h"
#import "CommandRobotController.h"

@interface ConnexionManager : NSObject {
	Network *server;
	NSString *host;
	NSString *_port;
	Boolean connected;
	NSMutableArray *arCommand;
}

@property (retain, nonatomic) NSString *host;
@property (retain, nonatomic) NSString *_port;

+ (ConnexionManager *) sharedConnexion;
- (void) connect;
- (void) disconnect;
- (void) setConnected:(BOOL)status;
- (void) send:(NSString *)string;
- (void) setHost:(NSString *)ip;
- (void) setPort:(NSString *)port;
- (Boolean) isConnected;
- (NSString*) getPort;
- (void) receivedMessage:(NSString *)message;
void receivedStream (CFReadStreamRef stream, CFStreamEventType event, void *myPtr);

@end
