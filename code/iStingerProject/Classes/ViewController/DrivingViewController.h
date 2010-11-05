//
//  DrivingViewController.h
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandRobotController.h"

@interface DrivingViewController : UIViewController {
	CommandRobotController *com;
	
}
/*Boutons d'action*/

- (IBAction) btnClicUp:(id)sender;
- (IBAction) btnClicDown:(id)sender;
- (IBAction) btnClicLeft:(id)sender;
- (IBAction) btnClicRight:(id)sender;

/*Ecran d'informations*/

-(NSString *) string;

@end
