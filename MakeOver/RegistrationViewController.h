//
//  RegistrationViewController.h
//  MakeOver
//
//  Created by PankajYadav on 12/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UITextFieldDelegate> {

    __weak IBOutlet UITextField *txtField_name;
    __weak IBOutlet UITextField *txtField_otp;
    __weak IBOutlet UIView *view_otpcontainer;
    __weak IBOutlet UIView *view_registrationFields;
    __weak IBOutlet UIButton *btn_male;
    __weak IBOutlet UIButton *btn_female;
}

- (IBAction)actionSelectGender:(id)sender;
- (IBAction)actionNextButtonClicked:(id)sender;

@end
