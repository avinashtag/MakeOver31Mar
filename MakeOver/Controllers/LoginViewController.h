//
//  LoginViewController.h
//  MakeOver
//
//  Created by Ekta on 02/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface LoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    
    __weak IBOutlet UITextField *txtField_email;
}

@property (nonatomic,assign) BOOL isInsideProfileTab;
@property(nonatomic, weak)IBOutlet UIButton *submit;
@property(nonatomic, weak)IBOutlet UIButton *skip;
@property(nonatomic, weak)IBOutlet UIButton *facebookLogin;
@end
