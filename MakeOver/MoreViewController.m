//
//  MoreViewController.m
//  MakeOver
//
//  Created by Pankaj Yadav on 01/05/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "MoreViewController.h"
#import "AboutViewController.h"

#import <MessageUI/MessageUI.h>

@interface MoreViewController () <MFMailComposeViewControllerDelegate>

- (void)openMail:(id)sender;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
        
    cell.textLabel.textColor = [UIColor whiteColor];
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"About us";

            break;
        
        case 1:
            cell.textLabel.text = @"Contact us";

            break;
            
        case 2:
            cell.textLabel.text = @"Rate us";

            break;
            
            
        default:
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row ==0) {
        AboutViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row ==1) {
        [self openMail:indexPath];
    }
    else if (indexPath.row == 2) {
        // Rate app.
        NSString * appId = @"1010170694";
//        NSString * theUrl = [NSString  stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appId];
//        if ([[UIDevice currentDevice].systemVersion integerValue] > 6)
        NSString *theUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
    }
}

- (void)openMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"My feedback"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"office@geto.co.in", nil];
        [mailer setToRecipients:toRecipients];
        
//        UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
//        NSData *imageData = UIImagePNGRepresentation(myImage);
//        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        
//        NSString *emailBody = @"Have you seen the MobileTuts+ web site?";
//        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the mailing functionality"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
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
