//
//  LFActionSheet.h
//  bluetooth
//
//  Created by archerLj on 16/7/13.
//  Copyright © 2016年 bocodo.zoubudiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(NSInteger buttonIndex);

/**************************************************************/
#pragma mark - LFActionSheetDelegate
/**************************************************************/
@class LFActionSheet;
@protocol LFActionSheetDelegate <NSObject>
-(void)lfActionSheet:(LFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end



/**************************************************************/
#pragma mark - LFActionSheet
/**************************************************************/
@interface LFActionSheet : UIView
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, weak) id<LFActionSheetDelegate> delegate;


-(instancetype)initWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitle,...;
-(void)setTitleColor:(UIColor *)color forOtherTitleIndex:(NSInteger)index;
-(void)setTitleColorForCancel:(UIColor *)color;
-(void)showWithCompletion:(CompletionBlock)completion;
-(void)show;
@end
