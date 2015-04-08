//
//  MOSuperViewController.h
//  MakeOver
//
//  Created by Ekta on 26/02/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"

@interface MOSuperViewController : UIViewController<WYPopoverControllerDelegate>{
    
    WYPopoverController *popoverController;
}

@end
