//
//  ReviewViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 15/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewCell.h"
#import "ServiceInvoker.h"
#import "SaloonReview.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_activityIndicator startAnimating];
    [self getreviews];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _reviews.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ReviewIdentifier";
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    SaloonReview *review = _reviews[indexPath.row];
    
    [cell.name setText:review.user];
    [cell.dateSubtitle setText:review.reviewDate];
    [cell.startRatingView setRating:review.rating];
    [cell.detail setText:review.review];
    
    return cell;
    
}


-(void)getreviews{
    
    NSDictionary *prameter = @{ @"saloonId" : self.service.saloonId
                            };
    [[[ServiceInvoker alloc]init] serviceInvokeWithParameters:prameter requestAPI:API_GET_REVIEW_BY_SALOON spinningMessage:nil completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        _reviews = [[NSMutableArray alloc]init];
        NSArray *parse = response[@"object"];
        [parse enumerateObjectsUsingBlock:^(NSDictionary *reviewD, NSUInteger idx, BOOL *stop) {
            [_reviews addObject:[SaloonReview modelObjectWithDictionary:reviewD]];
        }];
        [_reviewsTable reloadData];
        [_activityIndicator stopAnimating];
    }];
    
}

@end
