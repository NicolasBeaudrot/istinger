//
//  DrivingViewController.m
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import "DrivingViewController.h"


@implementation DrivingViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction) btnClicUp:(id)sender {
	NSLog(@"Button Up");
}

- (IBAction) btnClicDown:(id)sender {
	NSLog(@"Button Down");
}

- (IBAction) btnClicLeft:(id)sender {
	NSLog(@"Button Left");
}

- (IBAction) btnClicRight:(id)sender {
	NSLog(@"Button Right");
}

@end
