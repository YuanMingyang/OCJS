//
//  ViewController.m
//  test
//
//  Created by A589 on 2017/6/14.
//  Copyright © 2017年 A589. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic ,strong) JSContext* context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    self.webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    // 拿取js的运行环境
    self.context  = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 拿取js文件中的某个方法
    __weak typeof(self)weakSelf = self;
    self.context[@"openCamera"] = ^(void){
        [weakSelf openCamera];
    };

}
-(void)openCamera{
    __weak typeof(self)weakSelf = self;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = weakSelf;
    [weakSelf presentViewController:picker animated:YES completion:nil];
}

#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *name = [NSString stringWithFormat:@"%@.png",[dateFormatter stringFromDate:[NSDate date]]];
    NSString *path = [self savescanresultimage:image imagename:name];
    NSLog(@"%@",path);
    self.imageView.image = [UIImage imageWithContentsOfFile:path];
    NSString *scriptString = @"var changePhoto = function (path) {document.getElementById('img').src = path;}";
    [self.context evaluateScript:scriptString];
    JSValue*value1 = self.context[@"changePhoto"];
    [value1 callWithArguments:@[path]];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSString *)savescanresultimage:(UIImage *)resultimage imagename:(NSString *)strimagename
{
    NSData *imageData = UIImagePNGRepresentation(resultimage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:strimagename]; //Add the file name
    [imageData writeToFile:filePath atomically:YES];
    return filePath;
}

@end
