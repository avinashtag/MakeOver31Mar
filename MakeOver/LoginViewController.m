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
#import "UIButton+WebCache.h"

//#import <SMPageControl/SMPageControl.h>
#import "EAIntroView.h"


#define kFBappId        @"1602592673358708" //@"408218362688859"// //Facebook App ID 239886072798506

#define kClientsecret   @"JPfP9NS-C-x6digjIMB9uJeo"
#define kClientID       @"661032643238-6ve9me4qvgnl7i4sc4aakbk381dajijt.apps.googleusercontent.com"

#define CornerRadius 5.0


@interface LoginViewController () <EAIntroDelegate> {

    UIView *rootView;
    EAIntroView *_intro;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ServiceInvoker sharedInstance];

    NSString *string_userId = [[UtilityClass RetrieveDataFromUserDefault:@"userid"] stringValue];

    if ((string_userId != nil) && string_userId.length) {
        [self skipClicked:nil];
    }
    else {
        [_submit.layer setCornerRadius:CornerRadius];
        [_skip.layer setCornerRadius:CornerRadius];
        [_facebookLogin.layer setCornerRadius:CornerRadius];
    }

    if (![UtilityClass RetrieveDataFromUserDefault:@"appLaunchedBefore"]) {
        rootView = self.navigationController.view;
        [self showIntroWithCrossDissolve];
    }
    
}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    [UtilityClass SaveDatatoUserDefault:@"1" :@"appLaunchedBefore"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.isInsideProfileTab)
        self.skip.hidden = YES;
}

#pragma mark - Demo

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    //    page1.title = @"Hello world";
    //    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"home01"];
    //    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    //    page2.title = @"This is page 2";
    //    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"hair01"];
    //    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    //    page3.title = @"This is page 3";
    //    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"rating01"];
    //    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    //    EAIntroPage *page4 = [EAIntroPage page];
    //    page4.title = @"This is page 4";
    //    page4.desc = sampleDescription4;
    //    page4.bgImage = [UIImage imageNamed:@"bg4"];
    //    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3]]; //page4
    [intro setDelegate:self];
    
    [intro showInView:rootView animateDuration:0.3];
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
        paramsRegister[@"notificationId"] = @"";
        paramsRegister[@"deviceType"] = @"iPhone";
        paramsRegister[@"fullName"] = @"";
        paramsRegister[@"createdBy"] = @"email";//email
        paramsRegister[@"usrImgUrl"] = @"";

        [self registerUser:paramsRegister];
    }
    else {
        [UtilityClass showAlertwithTitle:@"" message:@"Please enter a valid email id"];
    }
}

-(IBAction)skipClicked:(id)sender{
    [txtField_email setText:@""];
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
                 paramsRegister[@"usrImgUrl"] = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",dictionary[@"id"]];//((dictionary[@"picture"])[@"data"])[@"url"];
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
         else if ([[response objectForKey:@"object"] count])
         {

             if ([[[response objectForKey:@"object"] objectForKey:@"fullName"] isEqualToString:@""])
             {
                 RegistrationViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
                 nextViewController.string_emailId = txtField_email.text;
                 if ([[[response objectForKey:@"object"] objectForKey:@"isVerified"] isEqualToString:@"Y"]) {
                     //already verified... will enter name only
                     nextViewController.isVerified = YES;
                 }else{
                     //not verified.. otp verification needed.. then enter name
                     nextViewController.isVerified = NO;
                 }
                 //                 [UtilityClass SaveDatatoUserDefault:[[response objectForKey:@"object"] objectForKey:@"userId"] :@"userid"];
                 self.string_userid = [[response objectForKey:@"object"] objectForKey:@"userId"];
                 // Submit email flow
                 
                 nextViewController.string_userid = self.string_userid;
                 if (self.isInsideProfileTab)
                     nextViewController.isInsideProfileTab = self.isInsideProfileTab;
                 
                 [self.navigationController pushViewController:nextViewController animated:YES];
             }
             else // Registered user/ facebook flow
             {
                 [UtilityClass SaveDatatoUserDefault:[[response objectForKey:@"object"] objectForKey:@"userId"] :@"userid"];
                 
                 NSString *imgUrlString = [[response objectForKey:@"object"] objectForKey:@"usrImgUrl"];
                 
                 if (imgUrlString != [NSNull null]) {
                     
                     [UtilityClass SaveDatatoUserDefault:imgUrlString :@"usrImgUrl"];
                 }
                 else
                     [UtilityClass SaveDatatoUserDefault:@"" :@"usrImgUrl"];
                 
                 if (self.isInsideProfileTab) {
                     
                     ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                     [self.navigationController pushViewController:controller animated:YES];
                     
                     if([controller.tabBarController isKindOfClass:[MOTabBar class]]) {
                         
                         MOTabBar *tabBarController = (MOTabBar*)controller.tabBarController;
                         if (imgUrlString != [NSNull null]) {
                             [tabBarController.circularButton setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"ic_foot_profilepic.png"]];
                         }
                         
                     }
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
