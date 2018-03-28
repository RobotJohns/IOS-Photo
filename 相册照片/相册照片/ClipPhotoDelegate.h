//
//  NSObject+ClipPhotoDelegate.h
//  相册照片
//
//  Created by game912 on 2018/3/27.
//  Copyright © 2018年 john. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ClipPhotoDelegate <NSObject>

- (void)clipPhoto:(UIImage *)image;

@end

@interface ClipViewController : UIViewController
@property (strong, nonatomic) UIImage *image;

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, weak) id<ClipPhotoDelegate> delegate;

@property (nonatomic, assign) BOOL isTakePhoto;
@end
