//
//  NXBaseListViewController.m
//  NXFramework
//
//  Created by yoyo on 2017/10/16.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import "NXBaseListViewController.h"

static NSString * cellIdentifer = @"NXViewController_Identifer";
@interface NXBaseListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView * tableView;
@end

@implementation NXBaseListViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (void) initDataSource{
    
    NSArray * array = @[
                        @{
                            
                        },
                    ];
    [self.dataSource addObjectsFromArray:array];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initDataSource];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifer];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}
#pragma mark - UITabelViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary * dic = self.dataSource[indexPath.row];
    if (dic) {
        
        cell.textLabel.text = dic[NXListTiltleKey];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dic = nil;
    if (indexPath.row >= 0 && indexPath.row <self.dataSource.count) {
        
        dic = self.dataSource[indexPath.row];
    }
    Class acla = dic[NXListVCKey];
    if ([acla isSubclassOfClass:[UIViewController class]])
    {
        UIViewController * vc = [[acla alloc] init];
        vc.title = dic[NXListTiltleKey];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
