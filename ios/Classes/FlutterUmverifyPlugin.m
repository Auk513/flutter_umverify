#import "FlutterUmverifyPlugin.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <YTXMonitor/YTXMonitor.h>
#import <YTXOperators/YTXOperators.h>
#import <UMVerify/UMVerify.h>
#import <UMCommon/UMCommon.h>

@implementation FlutterUmverifyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"flutter_umverify" binaryMessenger:[registrar messenger]];
    FlutterUmverifyPlugin* instance = [[FlutterUmverifyPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqual: @"init"]) {
        [self initSDK:call.arguments[@"sk"]];
    } else if ([call.method isEqualToString:@"login"]) {
        [self login];
    }
}

- (void)initSDK:(NSString *)sk {
    [UMConfigure initWithAppkey:sk channel:@"App Store"];
    [UMConfigure setLogEnabled:YES];

    [UMCommonHandler setVerifySDKInfo:sk complete:^(NSDictionary *resultDic) {
        NSLog(@"witwit =%@=", resultDic);
    }];
}

- (void)login {
   
    UMCustomModel *model = [[UMCustomModel alloc] init];
        model.navColor = UIColor.orangeColor;
        model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录（全屏）" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
        //model.navIsHidden = NO;
        model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
        //model.hideNavBackItem = NO;
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
        model.navMoreView = rightBtn;
        model.privacyNavColor = UIColor.orangeColor;
        model.privacyNavBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
        model.privacyNavTitleFont = [UIFont systemFontOfSize:20.0];
        model.privacyNavTitleColor = UIColor.whiteColor;
        model.logoImage = [UIImage imageNamed:@"taobao"];
        //model.logoIsHidden = NO;
        //model.sloganIsHidden = NO;
        model.sloganText = [[NSAttributedString alloc] initWithString:@"一键登录slogan文案" attributes:@{NSForegroundColorAttributeName : UIColor.orangeColor,NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
        model.numberColor = UIColor.orangeColor;
        model.numberFont = [UIFont systemFontOfSize:30.0];
        model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
        //model.autoHideLoginLoading = NO;
        //model.privacyOne = @[@"《隐私1》",@"https://www.taobao.com/"];
        //model.privacyTwo = @[@"《隐私2》",@"https://www.taobao.com/"];
        model.privacyColors = @[UIColor.lightGrayColor, UIColor.orangeColor];
        model.privacyAlignment = NSTextAlignmentCenter;
        model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13.0];
        model.privacyOperatorPreText = @"《";
        model.privacyOperatorSufText = @"》";
        //model.checkBoxIsHidden = NO;
        model.checkBoxWH = 17.0;
        model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"切换到其他方式" attributes:@{NSForegroundColorAttributeName : UIColor.orangeColor,NSFontAttributeName : [UIFont systemFontOfSize:18.0]}];
        //model.changeBtnIsHidden = NO;
        //model.prefersStatusBarHidden = NO;
        model.preferredStatusBarStyle = UIStatusBarStyleLightContent;
        //model.presentDirection = UMPNSPresentationDirectionBottom;
        //授权页默认控件布局调整
        //model.navBackButtonFrameBlock =
        //model.navTitleFrameBlock =

    
        //model.privacyFrameBlock =
        //添加自定义控件并对自定义控件进行布局
        __block UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [customBtn setTitle:@"这是一个自定义控件" forState:UIControlStateNormal];
        [customBtn setBackgroundColor:UIColor.redColor];
        customBtn.frame = CGRectMake(0, 0, 230, 40);
        model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
             [superCustomView addSubview:customBtn];
        };
        model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
            CGRect frame = customBtn.frame;
            frame.origin.x = (contentViewFrame.size.width - frame.size.width) * 0.5;
            frame.origin.y = CGRectGetMinY(privacyFrame) - frame.size.height - 20;
            frame.size.width = contentViewFrame.size.width - frame.origin.x * 2;
            customBtn.frame = frame;
        };
    // 仅支持竖屏
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;

        __block BOOL support = YES;
        [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
            support = [PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
        }];

        //1. 调用取号接口，加速授权页的弹起
//        [UMCommonHandler accelerateLoginPageWithTimeout:3 complete:^(NSDictionary * _Nonnull resultDic) {
//            if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
////                [ProgressHUD showError:@"取号，加速授权页弹起失败"];
////                [weakSelf showResult:resultDic];
//                return ;
//            }
            //2. 调用获取登录Token接口，可以立马弹起授权页
//            [ProgressHUD dismiss];
    
//    [UMCommonHandler debugLoginUIWithController:[UIApplication sharedApplication].keyWindow.rootViewController model:model complete:^(NSDictionary * _Nonnull resultDic) {
//            NSLog(@"witwit =%@=", resultDic);
//    }];
//
//    return;
            [UMCommonHandler getLoginTokenWithTimeout:3 controller:[UIApplication sharedApplication].keyWindow.rootViewController model:model complete:^(NSDictionary * _Nonnull resultDic) {
                NSString *code = [resultDic objectForKey:@"resultCode"];
                
                NSLog(@"witwit =%@=", resultDic);

                if ([PNSCodeLoginControllerPresentSuccess isEqualToString:code]) {
//                    [ProgressHUD showSuccess:@"弹起授权页成功"];
                } else if ([PNSCodeLoginControllerClickCancel isEqualToString:code]) {
//                    [ProgressHUD showSuccess:@"点击了授权页的返回"];
                } else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:code]) {
//                    [ProgressHUD showSuccess:@"点击切换其他登录方式按钮"];
                } else if ([PNSCodeLoginControllerClickLoginBtn isEqualToString:code]) {
                    if ([[resultDic objectForKey:@"isChecked"] boolValue] == YES) {
//                        [ProgressHUD showSuccess:@"点击了登录按钮，check box选中，SDK内部接着会去获取登陆Token"];
                    } else {
//                        [ProgressHUD showSuccess:@"点击了登录按钮，check box选中，SDK内部不会去获取登陆Token"];
                    }
                } else if ([PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:code]) {
//                    [ProgressHUD showSuccess:@"点击check box"];
                } else if ([PNSCodeLoginControllerClickProtocol isEqualToString:code]) {
//                    [ProgressHUD showSuccess:@"点击了协议富文本"];
                } else if ([PNSCodeSuccess isEqualToString:code]) {
                    //点击登录按钮获取登录Token成功回调
                    NSString *token = [resultDic objectForKey:@"token"];
                    //下面拿Token去服务器换手机号，下面仅做参考
//                    [PNSVerifyTopRequest requestLoginWithToken:token complete:^(BOOL isSuccess, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
//                        NSString *popCode = [data objectForKey:@"code"];
//                        NSDictionary *module = [data objectForKey:@"module"];
//                        NSString *mobile = module[@"mobile"];
//                        if ([popCode isEqualToString:@"OK"] && mobile.length > 0) {
//                            [ProgressHUD showSuccess:@"一键登录成功"];
//                        } else {
//                            [ProgressHUD showSuccess:@"一键登录失败"];
//                        }
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];
//                        });
//                        [weakSelf showResult:data];
//                    }];
                } else {
//                    [ProgressHUD showError:@"获取登录Token失败"];
                }
//                [weakSelf showResult:resultDic];
            }];
//        }];
}

@end
