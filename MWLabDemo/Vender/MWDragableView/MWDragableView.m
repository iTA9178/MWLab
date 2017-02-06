//
//  MWDragableView.m
//  MWLabDemo
//
//  Created by mingwei on 2/4/17.
//  Copyright © 2017 keyue. All rights reserved.
//

#import "MWDragableView.h"

@interface MWDragableView () <UIGestureRecognizerDelegate>
{
    UIView *bordView;
    UIButton *changePicBtn;
}
@end

@implementation MWDragableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self UIInit];
    }
    return self;
}

- (void)setNeedsLayout {
    
}

- (void)UIInit {
    self.clipsToBounds = YES;
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
    changePicBtn = [[UIButton alloc] init];
    [changePicBtn setImage:[UIImage imageNamed:@"icon_grid_image"] forState:UIControlStateNormal];
    changePicBtn.bounds = CGRectMake(0, 0, 30, 30);
    changePicBtn.center = _imageView.center;
    changePicBtn.hidden = YES;
    [changePicBtn addTarget:self action:@selector(changePic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changePicBtn];
}

- (void)resetWithImage:(UIImage *)image {
    _image = image;
    [_imageView removeFromSuperview];
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.image = image;
    [self addSubview:_imageView];
    [self bringSubviewToFront:changePicBtn];
    [self setDragableViewStatus:MWDragableViewStatusNone];
}

- (void)setImage:(UIImage *)image {
    [self resetWithImage:image];
}

- (void)setDragableViewStatus:(MWDragableViewStatus)dragableViewStatus {
    
    if(_dragableViewStatus == dragableViewStatus){
        return;
    }
    _dragableViewStatus = dragableViewStatus;
    
    if(!bordView){
        CGRect rect = [self.superview convertRect:self.frame toView:self.superview];
        bordView = [[UIView alloc] init];
        bordView.frame = rect;
        bordView.backgroundColor = [UIColor clearColor];
        bordView.userInteractionEnabled = NO;
        [self.superview addSubview:bordView];
    }
    changePicBtn.hidden = YES;
    
    switch (dragableViewStatus) {
        case MWDragableViewStatusNone:
        {
            bordView.layer.borderColor = [UIColor clearColor].CGColor;
            bordView.layer.borderWidth = 0.5;
            break;
        }
        case MWDragableViewStatusEditing:
        {
            changePicBtn.hidden = NO;
            bordView.layer.borderColor = [UIColor redColor].CGColor;
            bordView.layer.borderWidth = 0.5;
            
            break;
        }
        case MWDragableViewStatusShouldChange:
        {
            bordView.layer.borderColor = [UIColor redColor].CGColor;
            bordView.layer.borderWidth = 0.5;
            break;
        }
        default:
            break;
    }
}

- (void)changePic:(UIButton*)btn {
    if(self.delegate && [_delegate respondsToSelector:@selector(changePicBtnClick:)]) {
        [self.delegate changePicBtnClick:self];
    }
}

@end
