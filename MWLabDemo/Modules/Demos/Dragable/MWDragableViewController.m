//
//  MWDragableViewController.m
//  MWLabDemo
//
//  Created by mingwei on 2/6/17.
//  Copyright © 2017 keyue. All rights reserved.
//

#import "MWDragableViewController.h"
#import "MWDragableView.h"
#import "MWDragableManagerView.h"

@interface MWDragableViewController () <MWDragableManagerViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIAlertController *actionSheet;
@property (strong, nonatomic) MWDragableView *chooseInView;

@end

@implementation MWDragableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    MWDragableView *imageView = [[MWDragableView alloc] initWithFrame:CGRectMake(60, 100, 160, 160)];
    imageView.image = [UIImage imageNamed:@"dog"];
    [self.view addSubview:imageView];
    
    MWDragableView *imageView1 = [[MWDragableView alloc] initWithFrame:CGRectMake(20, 320, 160, 160)];
    imageView1.image = [UIImage imageNamed:@"cat"];
    [self.view addSubview:imageView1];
    
    MWDragableView *imageView2 = [[MWDragableView alloc] initWithFrame:CGRectMake(200, 400, 160, 160)];
    imageView2.image = [UIImage imageNamed:@"cat"];
    [self.view addSubview:imageView2];
    
    MWDragableManagerView *managerView = [[MWDragableManagerView alloc] init];
    managerView.backgroundColor = [UIColor redColor];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:@[imageView,imageView1,imageView2]];
    [managerView setDragableViews:arr];
    [self.view addSubview:managerView];
    managerView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MWDragableManagerViewDelegate

- (void)changeImageClick:(MWDragableView *)dragableView {
    self.chooseInView = dragableView;
    
    [self callActionSheetFunc];
}

- (void)callActionSheetFunc {
    self.actionSheet = [UIAlertController alertControllerWithTitle:@"选择图像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"使用相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionSheetClick:0];
    }];
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"使用相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionSheetClick:1];
    }];
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [self.actionSheet addAction:act1];
    [self.actionSheet addAction:act2];
    [self.actionSheet addAction:act3];
    
    [self presentViewController: self.actionSheet animated:YES completion:nil];
}

- (void)actionSheetClick:(int)actionIndex {
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    switch (actionIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 2:
            return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.chooseInView resetWithImage:image];
}

@end
