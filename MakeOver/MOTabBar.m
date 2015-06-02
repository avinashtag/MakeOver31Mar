//
//  MOTabBar.m
//  MakeOver
//
//  Created by Avinash Tag on 18/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "MOTabBar.h"

#import "UtilityClass.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"

#import <QuartzCore/QuartzCore.h>


@interface MOTabBar ()

@end

@implementation MOTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"ic_profilepage_pic"] highlightImage:[UIImage imageNamed:@"ic_profilepage_pic"]];
    
    self.tabBar.tintColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    self.delegate = self;
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

-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
    UIViewController* viewController = [[UIViewController alloc] init];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
    return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    _circularButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _circularButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _circularButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    
    NSString *imgUrlString = [UtilityClass RetrieveDataFromUserDefault:@"usrImgUrl"];
    
    if (imgUrlString) {
        [_circularButton setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"ic_foot_profilepic.png"]];
    }
    else
    [_circularButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_circularButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        _circularButton.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        _circularButton.center = center;
    }

    //TODO:: Pankaj
    
    _circularButton.clipsToBounds = YES;

    //half of the width
    _circularButton.layer.cornerRadius = _circularButton.frame.size.width/2.0f;
    
    ///////
    
    [_circularButton addTarget:self action:@selector(profiletab:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_circularButton];
}

-(void)profiletab:(UIButton*)sender{
//    [sender setHidden:YES];
    
    if (!isSelectedIndex2)
    {
        isSelectedIndex2 = YES;
        
        [self setSelectedIndex:2];
        [self tabBarController:self didSelectViewController:[self.viewControllers objectAtIndex:2]];
    }
}


#pragma mark- UITabBar Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *navController = (UINavigationController*)viewController;
    
    if (tabBarController.selectedIndex == 2)
    {
/*        NSString *loggedUserID = [UtilityClass RetrieveDataFromUserDefault:@"userid"];
        if (loggedUserID != nil && ([loggedUserID integerValue] > -1)) {
            ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            [navController setViewControllers:[NSArray arrayWithObject: controller] animated: YES];
            
        }
        else {
            LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            controller.isInsideProfileTab = YES;
            [navController setViewControllers:[NSArray arrayWithObject: controller] animated: YES];
        }
 */
        NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.viewControllers];
        
        UINavigationController *navController = [newArray objectAtIndex:2];//[self.storyboard instantiateViewControllerWithIdentifier:@"NavControllerCenterTabSID"];
        
        
        NSString *loggedUserID = [UtilityClass RetrieveDataFromUserDefault:@"userid"];
        
        if (loggedUserID != nil && ([loggedUserID integerValue] > -1))
        {
            if (![[navController topViewController] isKindOfClass:[ProfileViewController class]]) {
                
                ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                [navController setViewControllers:[NSArray arrayWithObject: controller] animated: YES];
            }
        }
        else if (![[[newArray objectAtIndex:2] topViewController] isKindOfClass:[LoginViewController class]]){
            
            LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            controller.isInsideProfileTab = YES;
            
            [navController setViewControllers:[NSArray arrayWithObject: controller] animated: YES];
            
        }
    }
    else
        isSelectedIndex2 = NO;
}


@end
