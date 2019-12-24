//
//  H5GameWebView.m
//  Dog
//
//  Created by liuwenjie on 2019/12/22.
//  Copyright © 2019 zhanghow. All rights reserved.
//

#import "H5GameWebView.h"
#import <Masonry/Masonry.h>
@interface H5GameWebView ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
@implementation H5GameWebView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=UIColor.whiteColor;
        [self addSubview:self.wkWebView];
        [self.wkWebView addSubview:self.activityIndicator];
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(@0);
        }];
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.equalTo(@0);
            make.width.height.equalTo(@88);
        }];
    }
    return self;
}

-(WKWebView *)wkWebView{
    if (_wkWebView==nil) {
        WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc] init];
        config.preferences=[[WKPreferences alloc] init];
        config.preferences.javaScriptEnabled=YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically=NO;
        config.selectionGranularity = WKSelectionGranularityCharacter;
        config.allowsInlineMediaPlayback = YES;
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        config.userContentController=[[WKUserContentController alloc] init];
        config.suppressesIncrementalRendering = YES; // 是否支持记忆读取
        [config.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        if (@available(iOS 10.0, *)) {
            [config setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
        }

        NSString *js = @" $('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,user-scalable=true\">' );";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:script];
        
        _wkWebView=[[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _wkWebView.backgroundColor = self.backgroundColor;
        _wkWebView.scrollView.backgroundColor = self.backgroundColor;
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.scrollView.bounces = false;

        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }

    }
    return _wkWebView;
}
-(UIActivityIndicatorView *)activityIndicator{
    if (_activityIndicator==nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 88.0f, 88.0f)];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
    }
    return _activityIndicator;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页...");
    [_activityIndicator startAnimating];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"完成网页加载。");
    [_activityIndicator stopAnimating];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    NSLog(@"HTTPHeader:%@",navigationAction.request.allHTTPHeaderFields);
    NSLog(@"href:%@",navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);

}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"网页加载失败：%@",error);
    [_activityIndicator stopAnimating];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"网页加载失败:%@",error);
    [_activityIndicator stopAnimating];
}

@end
