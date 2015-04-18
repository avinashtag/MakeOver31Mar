//
//  LoginViewController.m
//  MakeOver
//
//  Created by Ekta on 02/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "LoginViewController.h"
#import "MOTabBar.h"
#import <QuartzCore/QuartzCore.h>
#import "UtilityClass.h"
#import "ServiceInvoker.h"
#import "UIAlertView+MOAlertView.h"
#import "RegistrationViewController.h"
#import "ProfileViewController.h"


#define kFBappId        @"239886072798506"  //Facebook App ID 239886072798506

#define kClientsecret   @"JPfP9NS-C-x6digjIMB9uJeo"
#define kClientID       @"661032643238-6ve9me4qvgnl7i4sc4aakbk381dajijt.apps.googleusercontent.com"

#define CornerRadius 5.0
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_submit.layer setCornerRadius:CornerRadius];
    [_skip.layer setCornerRadius:CornerRadius];
    [_facebookLogin.layer setCornerRadius:CornerRadius];
    // Do any additional setup after loading the view.

    [ServiceInvoker sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -


-(IBAction)submitUserEmail:(id)sender{

    if ([self validateEmail:txtField_email.text]) {

        if (self.view.bounds.size.height <= 480) {

            CGRect frame = self.view.frame;
            frame.origin.y = 0;

            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = frame;
            }];
        }

        NSMutableDictionary *paramsRegister = [[NSMutableDictionary alloc]init];
        paramsRegister[@"email"] = txtField_email.text;
        paramsRegister[@"gender"] = @"";
        paramsRegister[@"dob"] = @"";
        paramsRegister[@"mobileNo"] = @"";
        paramsRegister[@"notificationId"] =@"";
        paramsRegister[@"deviceType"] = @"iPhone";
        paramsRegister[@"fullName"] = @"";
        paramsRegister[@"createdBy"] = @"submit email";//email
        paramsRegister[@"usrImgUrl"] = @"";

        [self registerUser:paramsRegister];
    }
    else {
        [UtilityClass showAlertwithTitle:@"" message:@"Please enter a valid email id"];
    }
}

-(IBAction)skipClicked:(id)sender{
    
    MOTabBar *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MOTabBar class])];
    [self.navigationController pushViewController:tabBarController animated:YES];
}


#pragma mark- TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.view.bounds.size.height <= 480) {

        CGRect frame = self.view.frame;
        frame.origin.y = 0;

        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = frame;
        }];
    }

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (self.view.bounds.size.height <= 480) {

        CGRect frame = self.view.frame;
        frame.origin.y -= 100;

        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = frame;
        }];
    }
    
    return YES;
}



- (IBAction)actionFBLoginDidTap:(id)sender
{
    if (FBSession.activeSession.isOpen)
    {
        [self request];
    }
    else
    {
        NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location",@"email"];
        
        [FBSession openActiveSessionWithReadPermissions:permissionsArray allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             if (error)
             {
                 [UtilityClass removeHudFromView:nil afterDelay:0];
                 //nslog(@"facebook error : %@",error);
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
             else if (FB_ISSESSIONOPENWITHSTATE(status))
             {
                 [self request];
             }
         }];
    }
}

-(void)request {

//    [UtilityClass showSpinnerWithMessage:@"..." onView:self.view];
    
    NSDictionary *param =  [NSDictionary dictionaryWithObject:@"id,birthday,email,name,gender,first_name,last_name,picture" forKey:@"fields"];
    
    [FBRequestConnection startWithGraphPath:@"/me" parameters:param HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dictionary;
             if([result objectForKey:@"data"])
                 dictionary = (NSDictionary *)[(NSArray *)[result objectForKey:@"data"] objectAtIndex:0];
             else
                 dictionary = (NSDictionary *)result;
             
             
             NSMutableDictionary *paramsRegister = [[NSMutableDictionary alloc]init];
             paramsRegister[@"email"] = dictionary[@"email"];
             paramsRegister[@"gender"] = dictionary[@"gender"];
             paramsRegister[@"dob"] = @"";//dictionary[@"birthday"];
             paramsRegister[@"mobileNo"] = @"";
             paramsRegister[@"notificationId"] = dictionary[@"email"];
             paramsRegister[@"deviceType"] = @"iPhone";
             paramsRegister[@"fullName"] = dictionary[@"name"];
             paramsRegister[@"createdBy"] = @"Facebook";//email
             if ([dictionary[@"picture"] isKindOfClass:[NSDictionary class]]) {
                 paramsRegister[@"usrImgUrl"] = ((dictionary[@"picture"])[@"data"])[@"url"];
             }

             [self registerUser:paramsRegister];

             // ****** Login through facebook ******** //

         }
         else
         {
             [UtilityClass removeHudFromView:nil afterDelay:0];
         }

     }];
}

-(void)registerUser:(NSDictionary*)paramsRegister{

//    [UtilityClass showSpinnerWithMessage:@"..." onView:self.view];


    [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:paramsRegister
                                                      requestAPI:API_RegisterUser spinningMessage:@"Registering user.."
                                                            completion:
     ^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {

         [UtilityClass removeHudFromView:nil afterDelay:0.1];

        NSError *error = nil;
       __block NSDictionary *response = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];

         if ([[[response objectForKey:@"error"] objectForKey:@"errorCode"] integerValue]) {

             [UtilityClass showAlertwithTitle:nil message:[[response objectForKey:@"error"] objectForKey:@"errorMessage"]];
             // [self skipClicked:nil];

         }
         else if ([[response objectForKey:@"object"] count]) {

             [UtilityClass SaveDatatoUserDefault:[[response objectForKey:@"object"] objectForKey:@"userId"] :@"userid"];

             if ([[paramsRegister objectForKey:@"fullName"] isEqualToString:@""]) {
                 // Submit email flow
                 RegistrationViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
                 
                 if (self.isInsideProfileTab)
                     nextViewController.isInsideProfileTab = self.isInsideProfileTab;
                 
                 [self.navigationController pushViewController:nextViewController animated:YES];
             }
             else // facebook flow
             {
                 
                 if (self.isInsideProfileTab) {
                     
                     ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                     [self.navigationController pushViewController:controller animated:YES];
                 }
                 else
                     [self skipClicked:nil];
             
             }

         }

    }];

}



-(void)verifyEMailId:(NSDictionary*)params{

    [[ServiceInvoker sharedInstance]serviceInvokeWithParameters:params requestAPI:API_RegisterVerifyUser spinningMessage:nil completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {
        
    }];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}


@end
