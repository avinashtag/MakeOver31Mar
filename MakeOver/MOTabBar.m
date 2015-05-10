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
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }

    [button addTarget:self action:@selector(profiletab:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

-(void)profiletab:(UIButton*)sender{
//    [sender setHidden:YES];
    
    if (!isSelectedIndex2) {
        
        isSelectedIndex2 = YES;
        
        //AppDelegate *delegateObj = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavControllerCenterTabSID"];

        NSString *loggedUserID = [UtilityClass RetrieveDataFromUserDefault:@"userid"];
        if (loggedUserID != nil && ([loggedUserID integerValue] > -1)) {
            ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
//            [delegateObj.navConCenterTab setViewControllers:[NSArray arrayWithObject: controller] animated: YES];
            [navController setViewControllers:[NSArray arrayWithObject: controller] animated: YES];
        }
        else {
            LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            controller.isInsideProfileTab = YES;
            //[delegateObj.navConCenterTab setViewControllers:[NSArray arrayWithObject: controller] animated: YES];
            [navController setViewControllers:[NSArray arrayWithObject: controller] animated: YES];

        }
        
        NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.viewControllers];
        [newArray removeObjectAtIndex:2];
        //[newArray insertObject:delegateObj.navConCenterTab atIndex:2];
        [newArray insertObject:navController atIndex:2];
        [self.tabBarController setViewControllers:newArray animated:YES];
        
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
        NSString *loggedUserID = [UtilityClass RetrieveDataFromUserDefault:@"userid"];
        if (loggedUserID != nil && ([loggedUserID integerValue] > -1)) {
            ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            [navController setViewControllers:[NSArray arrayWithObject: controller] animated: YES];
            
        }
        else {
            LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            controller.isInsideProfileTab = YES;
            [navController setViewControllers:[NSArray arrayWithObject: controller] animated: YES];
        }
    }
    else
        isSelectedIndex2 = NO;
}


@end
