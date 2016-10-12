//
//  LFActionSheet.m
//  bluetooth
//
//  Created by archerLj on 16/7/13.
//  Copyright © 2016年 bocodo.zoubudiu. All rights reserved.
//

#import "LFActionSheet.h"

static CGFloat bigGip = 5.0;
static CGFloat smallGip = 0.5;
static CGFloat buttonHeight = 44.0;
#define gipColor [UIColor colorWithRed:233.0/255.0 green:232.0/255.0 blue:238.0/255.0 alpha:1.0]



@interface LFActionSheet()
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *cancelTitle;
@property (strong, nonatomic) NSMutableArray *otherTitles;
@property (strong, nonatomic) UIButton *lastButton;
@property (strong, nonatomic) UIColor *titleColor;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) UIColor *cancelColor;
@property (assign, nonatomic) CGFloat animationY;
@property (strong, nonatomic) CompletionBlock completionBlock;
@end

@implementation LFActionSheet

-(instancetype)initWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitle,... {
    
    _message = message;
    _cancelTitle = cancelTitle;
    self.otherTitles = [[NSMutableArray alloc] init];
    [self.otherTitles addObject:otherTitle];
    
    
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    id arg;
    va_list argList;
    if(otherTitle) {
        va_start(argList,otherTitle);
        while (arg = va_arg(argList,id)) {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }
    
    
    
    [self.otherTitles addObjectsFromArray:argsArray];
    self = [super init];
    if (self) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        self.frame = keyWindow.bounds;
    }
    return self;
}

-(void)setTitleColor:(UIColor *)color forOtherTitleIndex:(NSInteger)index {
    self.titleColor = color;
    self.index = index;
}

-(void)setTitleColorForCancel:(UIColor *)color {
    self.cancelColor = color;
}

-(void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self initSetting];
}

-(void)showWithCompletion:(CompletionBlock)completion {
    [self show];
    self.completionBlock = completion;
}

-(void)initSetting {
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat selfWidth = self.bounds.size.width;
    
    UIView *bigSuperView = [[UIView alloc] initWithFrame:self.bounds];
    bigSuperView.hidden = YES;
    [self addSubview:bigSuperView];
    
    
    // cancel button.
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, selfHeight - buttonHeight, selfWidth, buttonHeight)];
    [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    cancelButton.tag = 0;
    [bigSuperView addSubview:cancelButton];
    
    if (self.cancelColor) {
        [cancelButton setTitleColor:_cancelColor forState:UIControlStateNormal];
    }
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    
    // big gip view
    UIView *bigGipView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(cancelButton.frame) - bigGip, self.bounds.size.width, bigGip)];
    [bigGipView setBackgroundColor:gipColor];
    [bigSuperView addSubview:bigGipView];
    
    
    
    // other buttons
    for (NSInteger i = 0; i < self.otherTitles.count; i++) {
        
        NSString *title = self.otherTitles[i];
        
        
        UIButton *button = [[UIButton alloc] init];
        if (self.lastButton) {
            UIView *smallGipView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.lastButton.frame) - smallGip, self.bounds.size.width, smallGip)];
            [smallGipView setBackgroundColor:gipColor];
            [bigSuperView addSubview:smallGipView];
            
            button.frame = CGRectMake(0, CGRectGetMinY(smallGipView.frame) - buttonHeight, selfWidth, buttonHeight);
        } else {
            button.frame = CGRectMake(0, CGRectGetMinY(cancelButton.frame) - bigGip - buttonHeight, selfWidth, buttonHeight);
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = i + 1;
        
        
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        [bigSuperView addSubview:button];
        if (self.titleColor && i == self.index) {
            [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        }
        
        
        //        if (i > 0) {
        self.lastButton = button;
        //        }
        
        
        // message label
        if (i == self.otherTitles.count - 1) {
            if (self.message) {
                UIView *smallGipView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(button.frame) - smallGip, self.bounds.size.width, smallGip)];
                [smallGipView setBackgroundColor:gipColor];
                [bigSuperView addSubview:smallGipView];
                
                
                NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0]};
                NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
                CGRect textRect = [self.message boundingRectWithSize:CGSizeMake(selfWidth - 15 * 2, CGFLOAT_MAX) options:options attributes:attrs context:nil];
                
                UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(button.frame) - smallGip - textRect.size.height - 20, selfWidth, textRect.size.height + 20)];
                [messageView setBackgroundColor:[UIColor whiteColor]];
                [bigSuperView addSubview:messageView];
                
                
                UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, selfWidth - 15 * 2, messageView.bounds.size.height)];
                messageLabel.text = self.message;
                messageLabel.numberOfLines = 0;
                [messageLabel setBackgroundColor:[UIColor whiteColor]];
                messageLabel.font = [UIFont systemFontOfSize:11.0];
                messageLabel.textAlignment = NSTextAlignmentCenter;
                if (self.messageColor) {
                    messageLabel.textColor = self.messageColor;
                } else {
                    messageLabel.textColor = [UIColor grayColor];
                }
                [messageView addSubview:messageLabel];
                self.animationY = self.bounds.size.height - CGRectGetMinY(messageView.frame);
            } else {
                self.animationY = self.bounds.size.height - CGRectGetMinY(button.frame);
            }
            
            bigSuperView.transform = CGAffineTransformMakeTranslation(0, self.animationY);
            bigSuperView.hidden = NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                bigSuperView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

-(void)buttonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lfActionSheet:clickedButtonAtIndex:)]) {
        [self.delegate lfActionSheet:self clickedButtonAtIndex:sender.tag];
    } else {
        self.completionBlock(sender.tag);
    }
    
    [self dismiss];
}

-(void)dismiss {
    UIView *bigSuperView = self.subviews[0];
    [UIView animateWithDuration:0.3 animations:^{
        bigSuperView.transform = CGAffineTransformMakeTranslation(0, self.animationY);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
