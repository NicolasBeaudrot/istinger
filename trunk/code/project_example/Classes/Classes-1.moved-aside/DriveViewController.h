//
//  DriveViewController.h
//  IStinger
//
//  Created by UTBM on 30/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
	
	//Declarer un "monMenu" de type string
	//Afficher le type de nom menu
	NSString *monMenu;

	IBOutlet UILabel *monLabel;
}

@property(nonatomic,retain) UILabel *monLabel;
@property(nonatomic,retain) NSString *monMenu;

@end
