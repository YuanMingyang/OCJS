//
//  UIWebViewController.m
//  test
//
//  Created by 袁明洋 on 2021/12/21.
//  Copyright © 2021 A589. All rights reserved.
//

#import "UIWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface UIWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic ,strong) JSContext* context;
@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIWebView";
    self.webView.delegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"调用JS" style:UIBarButtonItemStyleDone target:self action:@selector(showJSAlert)];
}

-(void)showJSAlert{
    [self.webView stringByEvaluatingJavaScriptFromString:@"showAlert('OC调用JS的alert')"];
}
-(void)showOCAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 拿取js的运行环境
    self.context  = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 拿取js文件中的某个方法
    __weak typeof(self)weakSelf = self;
    self.context[@"UIWebViewClick"] = ^(NSString * jsString){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showOCAlert:jsString];
        });
        
    };

}


@end
