//
//  MWDragableManagerView.m
//  MWLabDemo
//
//  Created by mingwei on 2/4/17.
//  Copyright © 2017 keyue. All rights reserved.
//

#import "MWDragableManagerView.h"

@interface MWDragableManagerView () <UIGestureRecognizerDelegate, MWDragableViewDelegate>

@end

@implementation MWDragableManagerView

- (void)setDragableViews:(NSMutableArray *)dragableViews {
    _dragableViews = dragableViews;
    [self addGesture];
}

- (void)addGesture {
    for(MWDragableView *view in _dragableViews) {
        view.delegate = self;
        
        // 点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [view addGestureRecognizer:tap];
        
        // 拖动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [view addGestureRecognizer:pan];
        
        // 捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        pinch.delegate = self;
        [view addGestureRecognizer:pinch];
        
        // 旋转手势
        UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
        rotate.delegate = self;
        [view addGestureRecognizer:rotate];
        
        // 轻扫手势
        UISwipeGestureRecognizer *swipeDefault = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDefault:)];
        swipeDefault.delegate = self;
        swipeDefault.direction = UISwipeGestureRecognizerDirectionRight;
        [view addGestureRecognizer:swipeDefault];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDefault:)];
        swipeLeft.delegate = self;
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [view addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDefault:)];
        swipeDown.delegate = self;
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        [view addGestureRecognizer:swipeDown];
        
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDefault:)];
        swipeUp.delegate = self;
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [view addGestureRecognizer:swipeUp];
        
        // 长按手势
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.delegate = self;
        [view addGestureRecognizer:longPress];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    //按住的时候回调用一次，松开的时候还会再调用一次
    NSLog(@"长按图片");
}

- (void)swipeDefault:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction==UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"向右轻扫");
    } else if(swipe.direction==UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"向左轻扫");
    } else if(swipe.direction==UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"向上轻扫");
    } else {
        NSLog(@"向下轻扫");
    }
}

- (void)rotate:(UIRotationGestureRecognizer *)rotate {
    MWDragableView *dragableView = (MWDragableView *)rotate.view;
    
    dragableView.imageView.transform = CGAffineTransformRotate(dragableView.imageView.transform, rotate.rotation);
    // 复位
    rotate.rotation = 0;
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    MWDragableView *dragableView = (MWDragableView *)pinch.view;
    //    CGSize finSize = dragableView.imageView.frame.size;
    CGFloat scale = pinch.scale;
    dragableView.imageView.transform = CGAffineTransformScale(dragableView.imageView.transform, scale, scale);
    
    //    dragableView.imageView.bounds = CGRectMake(0, 0, finSize.width*pinch.scale, finSize.height* pinch.scale);
    //    if (pinch.state == UIGestureRecognizerStateEnded || pinch.state == UIGestureRecognizerStateCancelled) {
    //        finSize = CGSizeMake(finSize.width*pinch.scale, finSize.height*pinch.scale);
    //    }
    pinch.scale=1;
    
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    //    CGPoint transP = [pan locationInView:self.view];
    //    self.center = transP;
    //如果出现复制对象。原view不发生任何变化
    MWDragableView *dragableView = (MWDragableView *)pan.view;
    UIGestureRecognizerState state = pan.state;
    
    CGPoint loc = [pan locationInView:dragableView];
    CGPoint location = [pan locationInView:dragableView.superview];
    if(loc.x<0 || loc.x>dragableView.bounds.size.width || loc.y<0|| loc.y>dragableView.bounds.size.height) {
        if(!_snapshotView) {
            _snapshotView = [self customSnapshotFromView:dragableView.imageView];
            _snapshotView.parentView = dragableView;
            [dragableView.superview addSubview:_snapshotView];
            _snapshotView.bounds = dragableView.imageView.bounds;
            _snapshotView.center = location;
            // 按下的瞬间执行动画
            //            [UIView animateWithDuration:0.25 animations:^{
            //
            //
            //            } completion:^(BOOL finished) {
            //
            //
            //            }];
        }
    }
    if(_snapshotView) {
        switch (state) {
            case UIGestureRecognizerStatePossible: {
                [self setAllViewType:MWDragableViewStatusNone];
                break;
            }
            case UIGestureRecognizerStateBegan: {
                break;
            }
            case UIGestureRecognizerStateChanged: {
                [self startMovingSnapshot:location];
                break;
            }
            case UIGestureRecognizerStateEnded: {
                [self endMovingSnapshot:location];
                break;
            }
            case UIGestureRecognizerStateCancelled: {
                [_snapshotView removeFromSuperview];
                _snapshotView = nil;
                break;
            }
            case UIGestureRecognizerStateFailed: {
                [_snapshotView removeFromSuperview];
                _snapshotView = nil;
                break;
            }
        }
        return;
    }
    
    [dragableView setDragableViewStatus:MWDragableViewStatusNone];
    CGPoint transP = [pan translationInView:dragableView];
    
    // 不能超过1/4
    if(transP.x >0 && dragableView.imageView.frame.origin.x >= dragableView.frame.size.width*3/4.f){
        return;
    } else if (transP.x < 0 && dragableView.imageView.frame.origin.x+ dragableView.imageView.frame.size.width <= dragableView.frame.size.width/4.f) {
        return;
    } else if (transP.y > 0 && dragableView.imageView.frame.origin.y >= dragableView.frame.size.height*3/4.f) {
        return;
    } else if (transP.y < 0 && dragableView.imageView.frame.origin.y+ dragableView.imageView.frame.size.height<= dragableView.frame.size.height/4.f) {
        return;
    }
    
    dragableView.imageView.center = CGPointMake(dragableView.imageView.center.x+transP.x, dragableView.imageView.center.y+transP.y);
    
    //    dragableView.imageView.transform = CGAffineTransformTranslate(dragableView.imageView.transform, transP.x, transP.y);
    [pan setTranslation:CGPointZero inView:dragableView];
    
}

- (void)tap:(UITapGestureRecognizer *)tap {
    MWDragableView *dragableView = (MWDragableView *)tap.view;
    [self setDragableViewEdit:dragableView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return  NO;
}

- (snapShotView *)customSnapshotFromView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    snapShotView *snapview = [[snapShotView alloc] initWithImage:image];
    snapview.layer.masksToBounds = NO;
    snapview.layer.cornerRadius = 0.0;
    snapview.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapview.layer.shadowRadius = 5.0;
    snapview.layer.shadowOpacity = 0.4;
    snapview.alpha = 0.8;
    return snapview;
}

- (void)startMovingSnapshot:(CGPoint)loc {
    static MWDragableView *tempView;
    _snapshotView.center = loc;
    MWDragableView *view = (MWDragableView *)[self inDragableViews:loc];
    MWDragableView *parentView = (MWDragableView *)_snapshotView.parentView;
    [self setAllViewType:MWDragableViewStatusNone];
    if(view && view != parentView) {
        tempView = view;
        [view setDragableViewStatus:MWDragableViewStatusShouldChange];
    }
}

- (void)endMovingSnapshot:(CGPoint)loc {
    MWDragableView *view = (MWDragableView *)[self inDragableViews:loc];
    MWDragableView *parentView = (MWDragableView *)_snapshotView.parentView;
    if(view && view != parentView) {
        UIImage *image = view.image;
        [view resetWithimage:parentView.image];
        [parentView resetWithimage:image];
    }
    [_snapshotView removeFromSuperview];
    _snapshotView = nil;
}

// 编辑状态
- (void)setDragableViewEdit:(MWDragableView *)view {
    if(view.dragableViewStatus == MWDragableViewStatusNone) {
        [self setAllViewType:MWDragableViewStatusNone];
        [view setDragableViewStatus:MWDragableViewStatusEditing];
    } else {
        [view setDragableViewStatus:MWDragableViewStatusNone];
    }
}

- (void)setAllViewType:(MWDragableViewStatus)dragableViewStatue {
    for(MWDragableView *view in _dragableViews) {
        [view setDragableViewStatus:dragableViewStatue];
    }
}

// 是否在别的view里面
- (BOOL)isInDragableViews:(CGPoint)loc {
    for(UIView *view in _dragableViews) {
        if(loc.x > view.frame.origin.x && loc.y > view.frame.origin.y && loc.x < view.frame.origin.x+view.frame.size.width && loc.y < view.frame.origin.y+view.frame.size.height){
            return YES;
        }
    }
    return NO;
}

- (UIView *)inDragableViews:(CGPoint)loc {
    for(UIView *view in _dragableViews) {
        if(loc.x > view.frame.origin.x && loc.y > view.frame.origin.y && loc.x < view.frame.origin.x+view.frame.size.width && loc.y < view.frame.origin.y+view.frame.size.height){
            return view;
        }
    }
    return nil;
}

#pragma mark - MWDragableViewDelegate

- (void)changePicBtnClick:(MWDragableView *)dragableView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeImageClick:)]) {
        [self.delegate changeImageClick:dragableView];
    }
}

@end

@implementation snapShotView

@end
