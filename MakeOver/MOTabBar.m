//
//  MOTabBar.m
//  MakeOver
//
//  Created by Avinash Tag on 18/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "MOTabBar.h"

@interface MOTabBar ()

@end

@implementation MOTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"ic_profilepage_pic"] highlightImage:[UIImage imageNamed:@"ic_profilepage_pic"]];
    
    self.tabBar.tintColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
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
    [sender setHidden:YES];
    [self setSelectedIndex:2];
}


@end
