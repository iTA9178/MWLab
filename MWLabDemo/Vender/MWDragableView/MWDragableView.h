//
//  MWDragableView.h
//  MWLabDemo
//
//  Created by mingwei on 2/4/17.
//  Copyright © 2017 keyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class MWDragableView;

@protocol MWDragableViewDelegate

@optional

- (void)changePicBtnClick:(MWDragableView *)dragableView;

@end

typedef NS_ENUM (int,MWDragableViewStatus) {
    MWDragableViewStatusNone, // 没有状态
    MWDragableViewStatusEditing, // 编辑状态
    MWDragableViewStatusShouldChange, // 可替换
};

@interface MWDragableView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) MWDragableViewStatus dragableViewStatus;
@property (nonatomic, weak) NSObject <MWDragableViewDelegate> *delegate;

- (void)resetWithimage:(UIImage *)image;

@end
