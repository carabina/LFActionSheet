# LFActionSheet
An UIView works like UIActionSheet<br />


 ![image](https://github.com/archerLj/LFActionSheet/raw/master/效果图/logoutSheet.png)
 ![image](https://github.com/archerLj/LFActionSheet/raw/master/效果图/chooseImageSheet.png)
 ![image](https://github.com/archerLj/LFActionSheet/raw/master/效果图/normalSheet.png)

   
   <br /><br /><br />
   ----------------------------------------------------------------------------------------------------------------------
   It's very easy to use ^_^<br />
   Just like this:

   //**-------------<br/>
   // 1. use it with delegate. <br />
   // show the action sheet.
   
        
        LFActionSheet *sheet = [[LFActionSheet alloc] initWithMessage:@"message to show" cancelTitle:@"cancel button" otherTitles:@"First Button", @"Second Button",nil];
        [sheet setTitleColor:[UIColor redColor] forOtherTitleIndex:0];
        sheet.delegate = self;
        [sheet show];

   
   // do something in the delegate method like this:
        
        -(void)lfActionSheet:(LFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
             ...
         }
   
   
   //**-------------<br/>
   // 2. use with block.
         
         LFActionSheet *sheet = [[LFActionSheet alloc] initWithMessage:@"message" cancelTitle:@"cancel" otherTitles:@"log out",nil];
         [sheet setTitleColor:[UIColor redColor] forOtherTitleIndex:0];
         [sheet showWithCompletion:^(NSInteger buttonIndex) {
            ...
          }];
   
   
   //**-------------<br/>
   // 3. LFActionSheetTool.<br/>
   this class is used to show some particular action sheets, like action sheet used to choose image.<br/>
   
   now you can show a log out action sheet like this:<br/>
        
        [[LFActionSheetTool sharedInstance] showLogoutSheetWithMessage:@"Logout Message" completion:^{
           ...
        }];
        
   
   and show a choose image action sheet like this:<br/>
          
          [[LFActionSheetTool sharedInstance] showChoseImageSheetWithAction:^(UIImage *selectedImage) {
              ... 
          }];
   
   
   
   ^_^ Wish u like use this.
