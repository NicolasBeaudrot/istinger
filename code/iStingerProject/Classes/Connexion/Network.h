//
//  network.h
//  iStingerProject
//
//  Created by UTBM on 25/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject {
	NSString           *_host;
	NSInteger          _port;
	CFReadStreamRef    _readStream;
	CFWriteStreamRef   _writeStream;
}

@property (retain) NSString *_host;
@property (assign) NSInteger _port;
@property (readonly, assign) CFReadStreamRef  _readStream;
@property (readonly, assign) CFWriteStreamRef  _writeStream;

- (bool) destroy;
- (bool) connect:(NSString *)host port:(NSString *)port callback:(void *)callback withData:(void *)data;
- (void) sendString:(NSString *)string;
- (bool) start;
- (bool) stop;

@end
