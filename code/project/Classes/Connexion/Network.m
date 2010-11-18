//
//  network.m
//  iStingerProject
//
//  Created by UTBM on 25/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import "Network.h"

@implementation Network

@synthesize _port;
@synthesize _host;
@synthesize _writeStream;
@synthesize _readStream;

- (bool) connect:(NSString *)host port:(NSString *)port callback:(void *)callback withData:(void *)data {
	CFOptionFlags registeredEvents;       
	
	_host = [NSString stringWithString:host];
	_port = [port intValue];
	_readStream = NULL;
	_writeStream = NULL;
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)_host, (UInt32)_port, &_readStream, &_writeStream);
	
	if(!CFReadStreamOpen(_readStream) || !CFWriteStreamOpen(_writeStream)) {
		[self destroy];
		NSLog(@"Echec de la connexion: CFStreamCreatePairWithSocketToHost");
		return (FALSE);
	}
	registeredEvents = kCFStreamEventHasBytesAvailable | kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered;
	CFStreamClientContext myContext = {0, data, NULL, NULL, NULL};
	
	if (CFReadStreamSetClient(_readStream, registeredEvents, callback, &myContext)) {
		CFReadStreamScheduleWithRunLoop(_readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
	} else {
		[self destroy];
		NSLog(@"Echec de la creation des streams: CFReadStreamSetClient");
		return (FALSE);
	}
    return (TRUE);
}

- (void) sendString:(NSString *)string {
	const uint8_t *rawstring = (const uint8_t *)[string UTF8String];
	CFWriteStreamWrite(_writeStream, rawstring, strlen(rawstring)); 
	//CFReadStreamRead(<#CFReadStreamRef stream#>, <#UInt8 *buffer#>, <#CFIndex bufferLength#>)
}

- (bool) destroy {
	NSLog(@"Fermeture des streams");
	CFReadStreamUnscheduleFromRunLoop(_readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
	if (!CFReadStreamOpen(_readStream))
		CFReadStreamClose(_readStream);
	if (!CFWriteStreamOpen(_writeStream))
		CFWriteStreamClose(_writeStream);
	if (_readStream != NULL)
		CFRelease(_readStream);
	if (_writeStream != NULL)
		CFRelease(_writeStream);
	_readStream = NULL;
	_writeStream = NULL;
	return (TRUE);
}

- (bool) start {
	CFRunLoopRun();
	return (TRUE);
}

- (bool) stop {
	CFReadStreamUnscheduleFromRunLoop(_readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
	return (TRUE);
}

- (void)dealloc {
	[self destroy];
    [super dealloc];
}

@end
