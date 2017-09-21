//
//  NXSoundVC.m
//  Philm
//
//  Created by yoyo on 2017/8/24.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXSoundVC.h"
#import <AVFoundation/AVFoundation.h>

#import "NXConfig.h"

@interface NXSoundVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, copy)NSArray * files;
@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSDictionary * mapDic;
@property(nonatomic,strong)AVAudioPlayer *player;
@end

@implementation NXSoundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"closed"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(closeMe)];
    
    
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds"];
    _files=[NSArray arrayWithArray:[self showAllFileWithPath:path]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, NX_MAIN_SCREEN_WIDTH, NX_MAIN_SCREEN_HEIGHT - 64 )];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NXSoundCellID"];
    [self.view addSubview:self.tableView];
    
    /*
    NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:jsonPath]];
    self.mapDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
     */
}


- (NSArray*) allFilesAtPath:(NSString*) dirString {
    NSLog(@"%@", dirString);
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    
    NSInteger count = 0;
    for (NSString* fileName in tempArray) {
//        NSLog(@"fileName：%@", fileName);
        
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        BOOL flag = YES;
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            if (!flag) {
                [array addObject:fileName];
                count ++ ;
            } else {
            
                NSLog(@"111 path = %@",[NSString stringWithFormat:@"%@/%@",dirString,fileName]);

            }
        } else {
        
            NSLog(@"path = %@",[NSString stringWithFormat:@"%@/%@",dirString,fileName]);
        }
    }
    
    return array;
}

////改成递归查找文件
- (NSArray * )showAllFileWithPath:(NSString *) path {
    
    NSMutableArray * fileArrays = [[NSMutableArray alloc] init];
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString * subPath = nil;
            for (NSString * str in dirArray) {
                subPath  = [path stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
                
                NSArray * tmpArrar = [self showAllFileWithPath:subPath];
                [fileArrays addObjectsFromArray:tmpArrar];
            }
        }else{

            NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
            NXSoundModel * model = [[NXSoundModel alloc] init];
            model.sound_path = path;
            model.sound_name = fileName;
            [fileArrays addObject:model];
            
            
        }
    }else{
        NSLog(@"this path is not exist!");
    }
    
    return fileArrays;
}
//当音频播放完毕会调用这个函数
static void soundCompleteCallback(SystemSoundID soundID,void* sample){
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(soundID);
    AudioServicesRemoveSystemSoundCompletion(soundID);
    //    CFRelease(&soundID);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

-(void)playSystemSoundWithName:(NSString *)path
{
    if (nil==path) {
        return;
    }
    SystemSoundID soundID = 0;//系统声音的id 取值范围为：1000-2000
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"Error occurred assigning system sound!");
            return;
        }
    }
    
//    NSLog(@"文件 %@ soundID = %d",soundNameType,soundID);
//    self.fileNameLabel.text =[NSString stringWithFormat:@"  文件:%@",soundNameType] ;
//    NSString * sound_id = self.mapDic[soundNameType];
//    self.soundIdLabel.text = [NSString stringWithFormat:@"  soundID :%@",sound_id];
    AudioServicesPlaySystemSound(soundID);
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);//带震动
    //    AudioServicesDisposeSystemSoundID(soundID);
    //    AudioServicesRemoveSystemSoundCompletion(soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NXSoundModel * soundModel = self.files[indexPath.row];
    [self playerMusicWithUrl:soundModel.sound_path];
//    [self playSystemSoundWithName:soundModel.sound_path];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"_files.count==%lu", (unsigned long)_files.count);
    return _files.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NXSoundCellID" forIndexPath:indexPath];
    NXSoundModel * model = self.files[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@", model.sound_name];
    // Configure the cell...
    
    return cell;
}

- (void)playerMusicWithUrl:(NSString *)url{

    [self stopPlayer];
    NSError * error ;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:url] error:&error];
    
    if (!error) {
        
        self.player.numberOfLoops = 1;
        self.player.currentTime = 0.0f;
        [self.player prepareToPlay];
        [self.player play];
        
    } else {
    
        NSLog(@" 音频播放器初始化失败");
    }
}

-(void) stopPlayer{

    if (self.player) {
        
        [self.player stop];
        self.player = nil;
    }
}
- (void)closeMe { [self dismissViewControllerAnimated:YES completion:NULL]; }
@end



@implementation NXSoundModel



@end
