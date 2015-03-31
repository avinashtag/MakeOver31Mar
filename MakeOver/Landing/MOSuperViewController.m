//
//  MOSuperViewController.m
//  MakeOver
//
//  Created by Ekta on 26/02/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "MOSuperViewController.h"
#import "CustomSelection.h"
#import "ServiceInvoker.h"
#import "City.h"

@interface MOSuperViewController ()

@end

@implementation MOSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ServiceInvoker sharedInstance];

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

@end
