//
//  RegistrationViewController.m
//  MakeOver
//
//  Created by PankajYadav on 12/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MOTabBar.h"
#import "ServiceInvoker.h"
#import "ProfileViewController.h"
#import "ActionSheetStringPicker.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.isVerified) {
        view_otpcontainer.hidden = YES;
        view_registrationFields.hidden = !view_otpcontainer.isHidden;
    }else{
        view_otpcontainer.hidden = NO;
        view_registrationFields.hidden = !view_otpcontainer.isHidden;
    }

}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionSelectGender:(id)sender {

    [txtField_name resignFirstResponder];
    [txtField_otp resignFirstResponder];
    
    UIButton *btn = sender;
    
    NSArray *options = @[@"Male",@"Female"];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:options initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [btn setTitle:[options objectAtIndex:selectedIndex] forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        // cancelled
    } origin:btn_male];

//    btn.selected = !btn.isSelected;
//    
//    if ([btn isEqual:btn_male]) {
//        btn_female.selected = NO;
//        [btn_male setBackgroundColor:[UIColor blueColor]];
//        [btn_female setBackgroundColor:[UIColor lightGrayColor]];
//    }
//    else {
//        btn_male.selected = NO;
//        [btn_male setBackgroundColor:[UIColor lightGrayColor]];
//        [btn_female setBackgroundColor:[UIColor blueColor]];
//    }
}

- (IBAction)actionNextButtonClicked:(id)sender {

    if ([sender tag] ==1) {
        // Call API to verify OTP

        [self verifyOTP:txtField_otp.text];
    }
    else {

        NSMutableDictionary *paramsRegister = [[NSMutableDictionary alloc]init];
        paramsRegister[@"email"] = self.string_emailId;
//        if (btn_female.isSelected) {
            paramsRegister[@"gender"] = btn_male.titleLabel.text;
//        }
//        else {
//            paramsRegister[@"gender"] = @"Male";
//        }

        paramsRegister[@"dob"] = @"";//dictionary[@"birthday"];
        paramsRegister[@"mobileNo"] = @"email";
        paramsRegister[@"notificationId"] = @"";
        paramsRegister[@"deviceType"] = @"iPhone";
        paramsRegister[@"fullName"] = txtField_name.text;
        paramsRegister[@"createdBy"] = @"Facebook";//email
        paramsRegister[@"usrImgUrl"] = @"imgUrl";

        // Call API to complete user Registeration
        [self registerUser:paramsRegister];
    }
    
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [txtField_name resignFirstResponder];
    [txtField_otp resignFirstResponder];
    
    return YES;
}


-(void)registerUser:(NSDictionary*)paramsRegister{

    if (txtField_name.text.length == 0) {

        [UtilityClass showAlertwithTitle:@"You must provide your name." message:nil];
        return;
    }
    else {
        [[ServiceInvoker sharedInstance]serviceInvokeWithParameters:paramsRegister requestAPI:API_RegisterUser spinningMessage:@"Registering user.." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {

            NSError *error = nil;
            __block NSDictionary *response = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];

            NSDictionary *dictError = [response objectForKey:@"error"];

            if ([[dictError objectForKey:@"errorCode"] isEqualToString:@"0"]) {

                [UtilityClass SaveDatatoUserDefault:self.string_userid :@"userid"];

                if (self.isInsideProfileTab) {

                    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                else {
                    MOTabBar *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MOTabBar class])];
                    [self.navigationController pushViewController:tabBarController animated:YES];
                }

            }else{

            }


/*        [[UIAlertView alloc] initWithTitle:@"OTP" message:@"Please enter the OTP recived on your email to verify." alertStyle:UIAlertViewStyleSecureTextInput completionHandler:^(NSInteger index) {

            if (index == 0) {
                //Cancel
            }
            else if (index == 1){
                //OK
                //TODO:: send proper response
                [self verifyEMailId:response];
            }

        } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok"];
*/

        }];
    }

}


- (void)verifyOTP:(NSString*)otp {

    if (txtField_otp.text.length < 3) {

        [UtilityClass showAlertwithTitle:@"Invalid OTP" message:nil];
    }
    else {
        [[ServiceInvoker sharedInstance]serviceInvokeWithParameters:@{@"otp":otp, @"userId":self.string_userid} requestAPI:API_RegisterVerifyUser spinningMessage:@"Verify user.." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {

            NSError *error = nil;
            __block NSDictionary *response = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];

            /*        [[UIAlertView alloc] initWithTitle:@"OTP" message:@"Please enter the OTP recived on your email to verify." alertStyle:UIAlertViewStyleSecureTextInput completionHandler:^(NSInteger index) {

             if (index == 0) {
             //Cancel
             }
             else if (index == 1){
             //OK
             //TODO:: send proper response
             [self verifyEMailId:response];
             }

             } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok"];
             */

            NSDictionary *dictError = [response objectForKey:@"error"];

            if ([[dictError objectForKey:@"errorCode"] isEqualToString:@"0"]) {

                view_otpcontainer.hidden = YES;
                view_registrationFields.hidden = !view_otpcontainer.isHidden;

            }else{

                
            }
            
        }];

    }
}




@end
