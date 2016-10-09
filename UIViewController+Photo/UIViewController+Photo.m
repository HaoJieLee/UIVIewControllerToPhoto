//
//  UIViewController+Photo.m
//  JiaBian
//
//  Created by JBWL on 16/10/8.
//  Copyright © 2016年 JBWL. All rights reserved.
//

#import "UIViewController+Photo.h"
#import <objc/runtime.h>

@implementation UIViewController (Photo)

#pragma mark --runtime 实现属性
static void *userHeaderImageNameKey = (void *)@"userHeaderImageNameKey";
static void *headerImageKey = (void *)@"headerImageKey";

-(void)setUserHeaderImageName:(NSString *)userHeaderImageName
{
    objc_setAssociatedObject(self, &userHeaderImageNameKey, userHeaderImageName, OBJC_ASSOCIATION_COPY);
}

-(NSString *)userHeaderImageName
{
    return objc_getAssociatedObject(self, &userHeaderImageNameKey);
}

-(void)setHeaderImage:(UIImageView *)headerImage
{
    objc_setAssociatedObject(self, &headerImageKey, headerImage, OBJC_ASSOCIATION_RETAIN);
}

-(UIImageView *)headerImage
{
    return objc_getAssociatedObject(self, &headerImageKey);
}

#pragma make --从缓存路径获得图片加载

- (void)getImageAtSandbox {
    self.headerImage.image = [UIImage imageNamed:@"banner_photo"];
    self.userHeaderImageName = @"UserHeaderImage.jpg";
    NSString *path=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HeaderImage"] stringByAppendingPathComponent:self.userHeaderImageName];//获取头像文件路径
    UIImage *myImage =[[UIImage alloc]initWithContentsOfFile:path];//获取文件路径下的文件
    [self.headerImage setImage:myImage];//图片填充
}

#pragma mark --设置头像
-(void)takePictureClick:(UIButton *)sender {

    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"请选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;

        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;   // 设置委托
        imagePickerController.sourceType = sourceType;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];

    }];

    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;   // 设置委托
        imagePickerController.sourceType = sourceType;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];

    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];

    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark --以下是获取头像的代理方法。
/**
 *  保存图片到沙盒
 */
-(void)saveImage:(UIImage *)currentImage withName:(NSString *)name{
    //读取图片数据
    NSData *imageData=UIImageJPEGRepresentation(currentImage, 1.0);
    //获取沙盒目录
    NSString *path=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HeaderImage"] stringByAppendingPathComponent:name];
    //写入文件
    if (![imageData writeToFile:path atomically:YES]) {
        [imageData writeToFile:path atomically:YES];
    }
}

//UIImagePickerController 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //NSLog(@"%@",info);
    NSString * userHeaderImageName = @"UserHeaderImage.jpg";
    [picker dismissViewControllerAnimated:YES completion:^{
    
    }];
    UIImage *img=[info objectForKey:UIImagePickerControllerEditedImage];
    //获取沙盒目录
    NSString *path=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:userHeaderImageName];


    [self saveImage:img withName:userHeaderImageName];

    UIImage *myImage =[[UIImage alloc]initWithContentsOfFile:path];
    self.headerImage.image = myImage;
}
@end
