# OCJS
oc与js简单的交互
使用JavaScriptCore完成OC与JS简单的交互
    
    这个相当于js的运行环境
    @property (nonatomic ,strong) JSContext* context;

    WebView加载完成后
    - (void)webViewDidFinishLoad:(UIWebView *)webView
    {
        // 拿取js的运行环境
        self.context  = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        // 拿取js文件中的某个方法
        __weak typeof(self)weakSelf = self;
        self.context[@"openCamera"] = ^(void){
        //这里拿到了html中点击按钮的时机，可以做你想做的事情
        };
    }

    //写一段js代码作为字符串
    NSString *scriptString = @"var changePhoto = function (path) {document.getElementById('img').src = path;}";
    //让当前的js运行环境执行这端js代码
    [self.context evaluateScript:scriptString];
    JSValue*value1 = self.context[@"changePhoto"];
    //传入你写的js代码的参数
    [value1 callWithArguments:@[path]];
