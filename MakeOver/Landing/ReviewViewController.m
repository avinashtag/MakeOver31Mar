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
#import "UIImageView+WebCache.h"

@interface ReviewViewController ()
{
    UITextView *textView_getResizableHeight;

}

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textView_getResizableHeight = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 280, 10)];
    textView_getResizableHeight.scrollEnabled = NO;
    
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
    
    UITextView *textview_dynamic = (UITextView *)[cell viewWithTag:10];
    textview_dynamic.dataDetectorTypes = UIDataDetectorTypeAll;
    textview_dynamic.text = review.review;
    [textview_dynamic sizeToFit];
    [textview_dynamic setTextColor:[UIColor blackColor]];
    
    [cell.name setText:review.user];
    [cell.dateSubtitle setText:review.reviewDate];
    [cell.startRatingView setRating:review.rating];
    cell.startRatingView.canEdit = NO;
    [cell.detail setText:review.review];
    [cell.imgVw_userImage setImageWithURL:[NSURL URLWithString:review.userImgUrl] placeholderImage:nil];

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SaloonReview *review = _reviews[indexPath.row];
    
    CGFloat dynamicHeight;
    
    textView_getResizableHeight.text = review.review;
    [textView_getResizableHeight sizeToFit];
    [textView_getResizableHeight layoutIfNeeded];
    CGRect frame = textView_getResizableHeight.frame;
    frame.size.height = textView_getResizableHeight.contentSize.height;
    textView_getResizableHeight.frame = frame;
    
    dynamicHeight = textView_getResizableHeight.frame.size.height + 50;
    
    NSLog(@"%f",dynamicHeight);
    
    if (dynamicHeight>75)
        return dynamicHeight;
    else
        return 75;
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
