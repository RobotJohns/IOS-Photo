//
//  ViewController.m
//  相册照片
//
//  Created by game912 on 2018/3/27.
//  Copyright © 2018年 john. All rights reserved.
//

#import "ViewController.h"
//相机
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
//相册
#import <AssetsLibrary/AssetsLibrary.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *ButtonCamera;
@property (weak, nonatomic) IBOutlet UIButton *ButtonPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewPanel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_ButtonCamera addTarget:self action:@selector(OnButtonCameraDown:) forControlEvents:UIControlEventTouchDown];
    [_ButtonPhoto  addTarget:self action:@selector(OnButtonPhotoDown:)  forControlEvents:UIControlEventTouchDown];
    
}






-(void) OnButtonCameraDown:(UIButton *)sender
{
    if( [self RestoultAuthorizationCamera] == false )
        return;
    NSLog(@"OnButtonCameraDown");
    UIImagePickerController  *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
    
    
    //[imagePickerController release];
    
}
-(void) OnButtonPhotoDown:(UIButton *)sender
{
    if( [self RestoultAuthorizationPhotos] == false )
        return;
    NSLog(@"OnButtonPhotoDown");
    UIImagePickerController  *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate      = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
    //[imagePickerController release];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
//    [self saveImage:image withName:@"currentImage.png"];
//
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
//
//    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
//
//    isFullScreen = NO;
//    [self.imageView setImage:savedImage];
//
//    self.imageView.tag = 100;

    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    CGSize size = CGSizeMake(512.0f, 512.0f);
    image = [self scaleFromImage:image scaledToSize:size];
    [_ImageViewPanel setImage: image];

    
    [self saveImage:image withName:@"userInfo.jpg"];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


// 压缩图片到指定尺寸大小
-(UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size
{
    
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return image;
}
// 压缩图片到指定尺寸大小
- (UIImage*) scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height){
        return image;
    }
    
    if (width == 0 || height == 0){
        return image;
    }
    
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//压缩图片到指定文件大小
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}


#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    //NSLog(@"写入完成 %@path",fullPath);
}

 //检查相机权限
-(Boolean) RestoultAuthorizationCamera
{
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
        return  false;
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //[self loadImage:UIImagePickerControllerSourceTypeCamera];
            return  true;
        }
        else
        {
            NSLog(@"手机不支持相机");
            [self showAlertController:@"提示" message:@"手机不支持相机"];
            return  false;
        }
    }

}

//检查相册权限
-(Boolean) RestoultAuthorizationPhotos
{
    //相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        return  false;
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            return  true;
        }
        else
        {
            [self showAlertController:@"提示" message:@"手机不支持相册"];
            return  false;
            NSLog(@"手机不支持相册");
        }
    }
}




- (void)showAlertController:(NSString *)title message:(NSString *)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
