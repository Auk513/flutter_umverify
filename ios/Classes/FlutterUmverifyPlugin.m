#import "FlutterUmverifyPlugin.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UMVerify/UMVerify.h>
#import <YYKit/YYKit.h>

#define ScaleH(x) [UIScreen mainScreen].bounds.size.height/844.0*(x)
#define ScaleW(x) [UIScreen mainScreen].bounds.size.width/390.0*(x)

@implementation FlutterUmverifyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"flutter_umverify" binaryMessenger:[registrar messenger]];
    FlutterUmverifyPlugin* instance = [[FlutterUmverifyPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqual: @"setup"]) {
        [self setupSDK:call.arguments[@"sdkInfo"] result:result];
    } else if ([call.method isEqualToString:@"loginAuth"]) {
        [self loginAuthResult:result];
    } else if ([call.method isEqualToString:@"checkVerifyEnable"]) {
        [self checkVerifyEnableResult:result];
    }
}

- (void)setupSDK:(NSString *)sdkInfo result:(FlutterResult)result {
    [UMCommonHandler setVerifySDKInfo:sdkInfo complete:^(NSDictionary *resultDic) {
        result(resultDic);
    }];
}

- (void)checkVerifyEnableResult:(FlutterResult)result {
    if ([UMCommonUtils checkDeviceCellularDataEnable]) {
        [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
            if ([resultDic[@"resultCode"] isEqualToString:PNSCodeSuccess]) {
                [UMCommonHandler accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary * _Nonnull resultDic) {
                    if ([resultDic[@"resultCode"] isEqualToString:PNSCodeSuccess]) {
                        result(@{@"result": @1});
                    }else {
                        result(@{@"result": @0});
                    }
                }];
            }else {
                result(@{@"result": @0});
            }
        }];
    }else {
        result(@{@"result": @0});
    }
}

- (void)loginAuthResult:(FlutterResult)result {
    UMCustomModel *model = [[UMCustomModel alloc] init];
    #pragma mark- 导航栏（只对全屏模式有效）
    model.navIsHidden = YES;

    #pragma mark- 授权页弹出方向
    model.presentDirection = UMPNSPresentationDirectionBottom;

    #pragma mark- 状态栏
    if (@available(iOS 13.0, *)) {
        model.preferredStatusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        model.preferredStatusBarStyle = UIStatusBarStyleDefault;
    }
    
    #pragma mark- logo图片
    model.logoIsHidden = YES;
    #pragma mark- slogan
    model.sloganIsHidden = YES;
    
    #pragma mark- 号码
    model.numberColor = [UIColor colorWithHexString:@"#20201F"];
    model.numberFont = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(frame.origin.x, ScaleH(521), frame.size.width, frame.size.height);;
    };
    
    #pragma mark- 登录
    NSMutableAttributedString *loginBtnText = [[NSMutableAttributedString alloc] initWithString:@"本机号码一键登录/注册"];
    [loginBtnText setColor:[UIColor colorWithHexString:@"#20201F"]];
    [loginBtnText setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightBold]];
    model.loginBtnText = loginBtnText;
    UIImage *loginBtnBG = [[[UIImage imageWithColor:UIColor.whiteColor size:CGSizeMake(ScaleH(40), ScaleH(40))] imageByRoundCornerRadius:ScaleH(20) borderWidth:2.0 borderColor:[UIColor colorWithHexString:@"#20201F"]] stretchableImageWithLeftCapWidth:ScaleH(20) topCapHeight:ScaleH(20)];
    model.loginBtnBgImgs = @[loginBtnBG, loginBtnBG, loginBtnBG];
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake((screenSize.width - ScaleW(200))/2.0, ScaleH(591), ScaleW(200), ScaleH(40));;
    };
    
    #pragma mark- 协议
    model.checkBoxIsHidden = YES;
    model.privacyOne = @[NSLocalizedString(@"《使用条款》", nil), @"https://www.baidu.com"];
    model.privacyTwo = @[NSLocalizedString(@"《隐私政策》", nil), @"https://www.baidu.com"];
    model.privacyColors = @[[UIColor colorWithHexString:@"#ACB3B9"], [UIColor colorWithHexString:@"#5CC9F5"]];
    model.privacyPreText = NSLocalizedString(@"使用手机号码一键登录即代表您已同意", nil);
    model.privacySufText = NSLocalizedString(@"并使用本机号码登录", nil);
    model.privacyOperatorPreText = @"《";
    model.privacyOperatorSufText = @"》";
    model.privacyFont = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    model.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(frame.origin.x, screenSize.height-ScaleH(86), frame.size.width, frame.size.height);
    };
    
    #pragma mark- 切换到其他方式
    NSMutableAttributedString *changeBtnTitle = [[NSMutableAttributedString alloc] initWithString:@"更改手机号"];
    [changeBtnTitle setColor:[UIColor colorWithHexString:@"#5CC9F5"]];
    [changeBtnTitle setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
    model.changeBtnTitle = changeBtnTitle;
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(frame.origin.x, ScaleH(550), frame.size.width, frame.size.height);
    };
    
#pragma mark- 协议详情页
    model.privacyNavBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.privacyNavTitleFont = [UIFont systemFontOfSize:20.0];
    model.privacyNavTitleColor = UIColor.whiteColor;
    
#pragma mark- 其他自定义控件添加及布局
    // 背景图片 -- UIImageView
    __block UIImageView *backgroundImageView = [UIImageView new];
    backgroundImageView.image = [UIImage imageNamed:@"FlutterUmveifyPlugin.bundle/login_bg"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // 返回按钮 -- UIButton
    __block UIButton *backButton = [UIButton new];
    [backButton setImage:[UIImage imageNamed:@"FlutterUmveifyPlugin.bundle/nav_dismiss_btn"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
    
    // 背景图片 -- UIImageView
    __block UIImageView *titleImageView = [UIImageView new];
    titleImageView.image = [UIImage imageNamed:@"FlutterUmveifyPlugin.bundle/login_title_icon"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Apple登录 -- UIButton
    __block UIButton *appleLoginButton = [UIButton new];
    [appleLoginButton setImage:[UIImage imageNamed:@"FlutterUmveifyPlugin.bundle/login_apple_icon"] forState:UIControlStateNormal];
    [appleLoginButton setTitle:NSLocalizedString(@"通过Apple登录", nil) forState:UIControlStateNormal];
    appleLoginButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    UIImage *appleLoginBG = [[[UIImage imageWithColor:UIColor.blackColor size:CGSizeMake(ScaleH(40), ScaleH(40))] imageByRoundCornerRadius:ScaleH(20)] stretchableImageWithLeftCapWidth:ScaleH(20) topCapHeight:ScaleH(20)];
    [appleLoginButton setBackgroundImage:appleLoginBG forState:UIControlStateNormal];
    [appleLoginButton addTarget:self action:@selector(apple) forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:backgroundImageView];
        [superCustomView addSubview:backButton];
        [superCustomView addSubview:titleImageView];
        [superCustomView addSubview:appleLoginButton];
    };
    
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        backgroundImageView.frame = CGRectMake(0, 0, ScaleW(285), ScaleW(295));
        backgroundImageView.centerX = screenSize.width/2.0;
        backgroundImageView.top = ScaleH(166);
        titleImageView.frame = CGRectMake(0, 0, ScaleW(44), ScaleW(34));
        titleImageView.centerX = backgroundImageView.centerX;
        titleImageView.top = ScaleH(62);
        backButton.frame = CGRectMake(16, 0, 44, 44);
        backButton.centerY = titleImageView.centerY;
        CGFloat width = ScaleW(200);
        CGFloat height = ScaleH(40);
        appleLoginButton.frame = CGRectMake(0, 0, width, height);
        appleLoginButton.centerX = backgroundImageView.centerX;
        appleLoginButton.top = ScaleH(644);
    };

    @weakify(self)
    [UMCommonHandler getLoginTokenWithTimeout:3 controller:[UIApplication sharedApplication].keyWindow.rootViewController model:model complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *code = [resultDic objectForKey:@"resultCode"];
        NSLog(@"FlutterUmverifyPlugin = %@ =", resultDic);
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:code]) {
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:code]) {
            [weak_self.channel invokeMethod:@"loginWithCancel" arguments:resultDic];
        } else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:code]) {
            [weak_self.channel invokeMethod:@"loginWithChangeBtn" arguments:resultDic];
        } else if ([PNSCodeLoginControllerClickLoginBtn isEqualToString:code]) {
        } else if ([PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:code]) {
        } else if ([PNSCodeLoginControllerClickProtocol isEqualToString:code]) {
        } else if ([PNSCodeSuccess isEqualToString:code]) {
            [weak_self.channel invokeMethod:@"loginWithToken" arguments:resultDic];
        } else {
        }
    }];
}

- (void)handleBack:(id)sender {
    [UMCommonHandler cancelLoginVCAnimated:YES complete:^{
        
    }];
}

- (void)apple {
    [self.channel invokeMethod:@"loginWithApple" arguments:nil];
}

@end
