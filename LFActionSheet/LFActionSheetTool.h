//
//  LFActionSheetTool.h
//  bluetooth
//
//  Created by archerLj on 16/7/19.
//  Copyright © 2016年 bocodo.zoubudiu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LogoutAction)();
typedef void(^SelectImageAction)(UIImage *selectedImage);

@interface LFActionSheetTool : NSObject

+(instancetype)sharedInstance;

/**
 *  show a log out action sheet with given message, cancel button and log out button.
 *
 *  @param action action when log out button clicked.
 */
-(void)showLogoutSheetWithMessage:(NSString *)message completion:(LogoutAction)action;

/**
 *  show a chose image action sheet
 *
 *  @param action action when image is selected.
 */
-(void)showChoseImageSheetWithAction:(SelectImageAction)action;

@end
