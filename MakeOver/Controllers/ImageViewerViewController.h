//
//  ImageViewerViewController.h
//  MakeOver
//
//  Created by Avinash Tag on 18/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;
@property(strong, nonatomic) NSArray *images;
@property (nonatomic, assign) NSIndexPath *startImageIndexPath;
@property (weak, nonatomic) IBOutlet UITextView *textVw_description;
@property (assign) BOOL isTextDescription;
@property(strong, nonatomic) NSString *text_description;
@property(weak, nonatomic) IBOutlet UIButton* btnCancel_textViewer;

@property (copy) void(^callbackCancel)(void);

@end
