//
//  ViewController.m
//  NimbleFish
//
//  Created by zhanghow on 2019/11/20.
//  Copyright © 2019 zhanghow. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "SSZipArchive.h"
#import "H5GameWebView.h"
#import <Masonry/Masonry.h>

@interface ViewController (){
//    定义全局变量，各个控件
}
@property (nonatomic, strong) H5GameWebView *gameView;
@end

@implementation ViewController

#pragma mark -

- (float)diskSize {
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error: %@", error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}
- (float)diskFreeSize {
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"error: %@", error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemFreeSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}
- (NSString *)firstCharacterWithString:(NSString *)string {
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    return [pingyin substringToIndex:1];
}
- (float)fileSize {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sf_muni" ofType:@"pdf"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
        return 0;
    return [[fileManager attributesOfItemAtPath:path error:nil] fileSize];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSString* zipfilePath = [[NSBundle mainBundle] pathForResource:@"12zjwd" ofType:@"zip"];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    BOOL isSuccess = [SSZipArchive unzipFileAtPath:zipfilePath toDestination:cachesPath overwrite:YES password:nil error:nil];
    if (isSuccess) {
        NSLog(@"unarchive succcess");
    }
    NSString *destinationPath =[cachesPath stringByAppendingPathComponent:@"12zjwd/index.htm"];
    NSURL *locationURL = [NSURL fileURLWithPath:destinationPath];
    NSURL *accessURL = [locationURL URLByDeletingLastPathComponent];

    // Override point for customization after application launch.
        
    self.gameView=[[H5GameWebView alloc] init];
    [self.view addSubview:self.gameView];
    [self.gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(@0);
    }];
            //NSURL *locationURL = [NSURL URLWithString:destinationPath];
    //        NSURLRequest *request =[NSURLRequest requestWithURL:locationURL];
    NSString *startDateStr=self.dateString;//@"2019-12-23 00:00:00";
    NSDateFormatter *datefmt=[[NSDateFormatter alloc] init];
    datefmt.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *startDate=[datefmt dateFromString:startDateStr];
    
    NSTimeInterval starttime=startDate.timeIntervalSince1970;
    NSTimeInterval nowtime=NSDate.date.timeIntervalSince1970;
    if (nowtime-starttime>=7*24*60*60) {
        if (self.onOff) {
            NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
            [self.gameView.wkWebView loadRequest:req];
        }else{
            [self.gameView.wkWebView loadFileURL:locationURL allowingReadAccessToURL:accessURL];
        }
    }else{
        [self.gameView.wkWebView loadFileURL:locationURL allowingReadAccessToURL:accessURL];
    }

//        NSURL *jsonUrl=[NSURL URLWithString:@"http://47.104.189.214/app.json"];
//        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:jsonUrl];
//        request.HTTPMethod=@"GET";
//        request.timeoutInterval=30;
//        [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (data) {
//                    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//                    NSLog(@"%@",dict);
//
//                    BOOL onoff=[dict[@"1"][@"on_off"] boolValue];
//                    NSString *link=dict[@"1"][@"url"];
//                    if (onoff) {
//                        NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:link]];
//                        [self.gameView.wkWebView loadRequest:req];
//                    }else{
//                        [self.gameView.wkWebView loadFileURL:locationURL allowingReadAccessToURL:accessURL];
//                    }
//                }else{
//                    [self.gameView.wkWebView loadFileURL:locationURL allowingReadAccessToURL:accessURL];
//                }
//
//            });
//
//        }] resume];
//    }else{
//        [self.gameView.wkWebView loadFileURL:locationURL allowingReadAccessToURL:accessURL];
//    }


}

@end
