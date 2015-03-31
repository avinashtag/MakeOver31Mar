//
//  RatingViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 16/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "RatingViewController.h"
#import "WYPopoverController.h"

@interface RatingViewController ()

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _starRating.canEdit = YES;
    _starRating.maxRating = 5;
    _starRating.rating = 4;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClicked:(id)sender{
    self.ratingcompletion!=nil?self.ratingcompletion(_reviewDescription.text   , _starRating.rating ,YES):NSLog(@"");
}

- (IBAction)submitClicked:(id)sender{
    self.ratingcompletion!=nil?self.ratingcompletion(_reviewDescription.text   , _starRating.rating ,NO):NSLog(@"");
}

- (void)ratingCompletion:(RatingCompletion)completion{
    self.ratingcompletion = completion;
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
