//
//  LFActionSheetTool.m
//  bluetooth
//
//  Created by archerLj on 16/7/19.
//  Copyright © 2016年 bocodo.zoubudiu. All rights reserved.
//

#import "LFActionSheetTool.h"
#import "LFActionSheet.h"

@interface LFActionSheetTool() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) SelectImageAction selectImageAction;
@end

@implementation LFActionSheetTool
+(instancetype)sharedInstance {
    static LFActionSheetTool *sheetTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sheetTool = [[LFActionSheetTool alloc] init];
    });
    return sheetTool;
}

-(void)showLogoutSheetWithMessage:(NSString *)message completion:(LogoutAction)action {
    LFActionSheet *sheet = [[LFActionSheet alloc] initWithMessage:message cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:NSLocalizedString(@"Log out", nil),nil];
    [sheet setTitleColor:[UIColor redColor] forOtherTitleIndex:0];
    [sheet showWithCompletion:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (action) {
                action();
            }
        }
    }];
}

-(void)showChoseImageSheetWithAction:(SelectImageAction)action {
    self.selectImageAction = action;
    LFActionSheet *actionSheet = [[LFActionSheet alloc] initWithMessage:nil cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:NSLocalizedString(@"take photo", nil), NSLocalizedString(@"select photo from album", nil), nil];
    [actionSheet showWithCompletion:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 1: {
                [self takePicture];
            }
                break;
            case 2: {
                [self choosePictureFromAlbum];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)takePicture {
    UIViewController *currentVC = [self currentViewController];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [currentVC presentViewController:imagePicker animated:YES completion:nil];
}

- (void)choosePictureFromAlbum {
    UIViewController *currentVC = [self currentViewController];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [currentVC presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.selectImageAction(image);
}

- (UIViewController *)currentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}
@end
