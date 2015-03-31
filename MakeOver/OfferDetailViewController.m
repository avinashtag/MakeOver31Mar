//
//  OfferDetailViewController.m
//  MakeOver
//
//  Created by Ekta on 08/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "OfferDetailViewController.h"
#import "ServiceInvoker.h"

@implementation OfferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    //    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-big.png"]] ];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
