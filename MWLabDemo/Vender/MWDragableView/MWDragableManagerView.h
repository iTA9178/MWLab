//
//  MWDragableManagerView.h
//  MWLabDemo
//
//  Created by mingwei on 2/4/17.
//  Copyright © 2017 keyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "MWDragableView.h"
@class snapShotView;

@protocol MWDragableManagerViewDelegate

@optional

- (void)changeImageClick:(MWDragableView *)dragableView;

@end

@interface MWDragableManagerView : UIView

@property (nonatomic, strong) NSMutableArray *dragableViews;
@property (nonatomic, strong) snapShotView *snapshotView;
@property (nonatomic, weak) NSObject <MWDragableManagerViewDelegate> *delegate;

@end

@interface snapShotView : UIImageView

@property (nonatomic, strong) UIView *parentView;

@end
