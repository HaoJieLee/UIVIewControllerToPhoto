//
//  UIViewController+Photo.h
//  JiaBian
//
//  Created by JBWL on 16/10/8.
//  Copyright © 2016年 JBWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Photo)<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property(nonatomic, strong) UIImageView *headerImage;
@property(nonatomic, copy) NSString *userHeaderImageName;
-(void)takePictureClick:(UIButton *)sender;//调用相机缓存图片到沙盒
- (void)getImageAtSandbox;//获取图片并加到内存中
@end
