//
//  ViewController.m
//  AudioRecorder
//
//  Created by Geeks_Chen on 2020/12/24.
//  Copyright © 2020 zezf. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) NSDictionary *recordSettingDic;
@property (nonatomic, copy) NSString *recordPath;
@property (nonatomic,strong)AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

    [self setupAudioRecord];

}

#pragma mark -- UI设置
- (void)setupUI {
    
    UIButton *recordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    recordBtn.frame = CGRectMake(10, 100, self.view.frame.size.width-20, 50);
    recordBtn.backgroundColor = [UIColor redColor];
    [recordBtn setTitle:@"record" forState:(UIControlStateNormal)];
    [recordBtn addTarget:self action:@selector(recordAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:recordBtn];

    UIButton *stopBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    stopBtn.frame = CGRectMake(10, 160, self.view.frame.size.width-20, 50);
    stopBtn.backgroundColor = [UIColor redColor];
    [stopBtn setTitle:@"stop" forState:(UIControlStateNormal)];
    [stopBtn addTarget:self action:@selector(stopAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:stopBtn];

    UIButton *playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    playBtn.frame = CGRectMake(10, 220, self.view.frame.size.width-20, 50);
    playBtn.backgroundColor = [UIColor redColor];
    [playBtn setTitle:@"play" forState:(UIControlStateNormal)];
    [playBtn addTarget:self action:@selector(playAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:playBtn];
    
}

#pragma mark -- 录音
- (void)recordAction {
    
    if ([self canRecord]) {
        [self.audioRecorder record];
    }
}

#pragma mark -- 停止录音
- (void)stopAction {
    
    [self.audioRecorder stop];
}

#pragma mark -- 播放录音
- (void)playAction {
    
    NSError *playerError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.recordPath] error:&playerError];
    if (self.player == nil) {
       NSLog(@"Error creating player:%@",[playerError description]);
    }else{
       [self.player play];
    }
}

#pragma mark -- 配置audio record
- (void)setupAudioRecord {
    
    // 沙盒路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    self.recordPath = [NSString stringWithFormat:@"%@/play.aac",docDir];
    NSLog(@"%@",self.recordPath);
    
    // 录音设置
    self.recordSettingDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            [NSNumber numberWithInteger:kAudioFormatMPEG4AAC],AVFormatIDKey,[NSNumber numberWithInteger:1000],AVSampleRateKey,
                                            [NSNumber numberWithInteger:2],AVNumberOfChannelsKey,
                                            [NSNumber numberWithInteger:8],AVLinearPCMBitDepthKey,
                                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil];
    
    // 3. 根据路径以及设置项, 创建录音对象
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.recordPath] settings:self.recordSettingDic error:nil];

    // 4. 准备录音
    [self.audioRecorder prepareToRecord];
}

#pragma mark --是否能录音
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted){
            if (granted == YES) {
                bCanRecord = YES;
            }else{
                bCanRecord = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel_action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:NULL];
                    [alert addAction:cancel_action];
                    [self presentViewController:alert animated:YES completion:NULL];
                });
            }
        }];
    }
    return bCanRecord;
}

@end
