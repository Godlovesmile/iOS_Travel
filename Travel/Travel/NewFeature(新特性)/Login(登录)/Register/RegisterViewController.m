//
//  RegisterViewController.m
//  WeChat
//
//  Created by Alice on 16/3/21.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UITextField *password;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)dealloc {
    
    NSLog(@"%s",__FUNCTION__);
}

- (IBAction)registerAction:(id)sender {
    
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    __weak RegisterViewController *weakSelf = self;
    
    [[XMPPManager shareManager] registerUser:username password:password successBlock:^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"我提示你了,亲!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //注册成功,切换视图控制器
            //UIViewController *viewCtrl = [self.storyboard instantiateInitialViewController];
            [UIView transitionWithView:weakSelf.view.window duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                
                //self.view.window.rootViewController = viewCtrl;
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
                
                //断开连接
                [[XMPPManager shareManager].stream disconnect];
                
            } completion:nil];
        }];
        [alert addAction:action0];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)cancelRegisterAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
