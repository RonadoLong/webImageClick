//
//  ViewController.m
//  WebViewImageClick
//

//

#import "ViewController.h"
#import "IDMPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "NSData+Base64Additions.h"

@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _webView.dataDetectorTypes = UIDataDetectorTypeLink;
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.htxq.net/shop/PGoodsAction/goodsDetail.do?goodsId=df277edb-a0c6-43fb-919a-cf2a9ac7e952"]]];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //加载本地js
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"image" withExtension:@"js"];
    NSString *jsStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];

    //执行js 给图片设置点击事件
    [webView stringByEvaluatingJavaScriptFromString:@"setImageClick()"];
//    [webView stringByEvaluatingJavaScriptFromString:@"getAllImageUrl()"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];
    if ([requestString hasPrefix:@"http://pos.baidu.com"]) {// ignore baidu ad
        return NO;
    }
    
    
    NSArray *components = [requestString componentsSeparatedByString:@"::"];
    if ([components[0] isEqualToString:@"imageclick"]) {
        int imgIndex = [components[1] intValue];
        
        //截取frame
        CGRect frame = CGRectMake([components[2] floatValue], [components[3] floatValue], [components[4] floatValue], [components[5] floatValue]);
        
        UIImageView *showView = [[UIImageView alloc] initWithFrame:frame];
        
        //获取图片数据
        NSString *javascript = [NSString stringWithFormat:
                                @"getImageData(%d);", imgIndex];
        NSString *stringData = [webView stringByEvaluatingJavaScriptFromString:javascript];
        stringData = [stringData substringFromIndex:22]; // strip the string "data:image/png:base64,"
        NSData *data = [NSData decodeWebSafeBase64ForString:stringData];
        UIImage *image = [UIImage imageWithData:data];
        showView.image = image;
        [webView addSubview:showView];
        
        //获取全部图片URL
        NSString *urls = [webView stringByEvaluatingJavaScriptFromString:@"getAllImageUrl()"];
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:[IDMPhoto photosWithURLs:[urls componentsSeparatedByString:@","]] animatedFromView:showView];
        [browser setInitialPageIndex:imgIndex];
        browser.useWhiteBackgroundColor = YES;
        [self presentViewController:browser animated:YES completion:nil];
        [showView removeFromSuperview];
        
    }
    return YES;
}
@end
