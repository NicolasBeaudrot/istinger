//
//  DriveViewController.m
//  IStinger
//
//  Created by UTBM on 30/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DriveViewController.h"
#import "IStingerAppDelegate.h"

@implementation DriveViewController

@synthesize monMenu, monLabel;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//mon label peut prendre la valeur de mon menu
	[monLabel setText:monMenu];
}

@end
