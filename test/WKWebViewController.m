//
//  WKWebViewController.m
//  test
//
//  Created by 袁明洋 on 2021/12/21.
//  Copyright © 2021 A589. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>


@interface WKWebViewController ()<WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *webView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userCC = [WKUserContentController new];
    configuration.userContentController = userCC;
    [userCC addScriptMessageHandler:self name:@"WKWebViewClick"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"调用JS" style:UIBarButtonItemStyleDone target:self action:@selector(showJSAlert)];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}
-(void)showJSAlert{

    [self.webView evaluateJavaScript:@"showAlert('OC调用JS的alert')" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"evaluateJavaScript:\n result = %@ error = %@",result, error);
    }];
}

-(void)showOCAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"WKWebViewClick"]) {
        [self showOCAlert:message.body];
    }
}


#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{

}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

#pragma mark -- WKUIDelegate
// 显示一个按钮。点击后调用completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
 
// 显示两个按钮，通过completionHandler回调判断用户点击的确定还是取消按钮
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
 
// 显示一个带有输入框和一个确定按钮的，通过completionHandler回调用户输入的内容
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields.lastObject.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
