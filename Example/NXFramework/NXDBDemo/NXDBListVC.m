
//
//  NXDBListVC.m
//  NXFramework_Example
//
//  Created by zll on 2018/3/13.
//  Copyright © 2018年 wangcheng. All rights reserved.
//

#import "NXDBListVC.h"
#import "NXDB.h"
#import "NSJSONSerialization+Utils.h"
#import "NXAppsDataViewModel.h"
#import "SQLiteReserveModel.h"
#import "NXMutilKeyModel.h"
#import "NXBlackListModel.h"
#import "NXAutoPrimaryKeyModel.h"
#import "NXTableA.h"
#import "NXDBHelper.h"

@interface NXDBListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NXDBHelper *_helper;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * models;
@end

@implementation NXDBListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadDataBase];
    [self loadData];
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView;
    })];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)loadDataBase
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _helper = [NXDBHelper sharedInstance];
    _helper.dbPath = [path stringByAppendingString:@"/NXDATA.db"];
}

- (void)loadData
{
    NSArray *modelJsons = [NSJSONSerialization JSONObjectWithContentsOfFile:@"model.json"];

    self.models = [NSArray yy_modelArrayWithClass:[NXAppsDataViewModel class] json:modelJsons];

}


#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    cell.textLabel.text = @"  ";
    if (indexPath.row == 0) {
        cell.textLabel.text = @"单条数据插入";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"批量数据插入(不开始事务)";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"批量数据插入(开始事务)";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"全部数据读取";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"数据条件查询";
    }else if (indexPath.row == 5) {
        cell.textLabel.text = @"排序和limit";
    }else if (indexPath.row == 6) {
        cell.textLabel.text = @"update";
    }else if (indexPath.row == 7) {
        cell.textLabel.text = @"多条件查询";
    }else if (indexPath.row == 8) {
        cell.textLabel.text = @"sqlite 保留关键字测试 存储";
    }else if (indexPath.row == 9) {
        cell.textLabel.text = @"sqlite 保留关键字测试 读取";
    }else if (indexPath.row == 10) {
        cell.textLabel.text = @"sqlite 存储模型黑名单处理";
    }else if (indexPath.row == 11) {
        cell.textLabel.text = @"sqlite 读取模型黑名单处理";
    }else if (indexPath.row == 12) {
        cell.textLabel.text = @"sqlite 多主键表创建存储";
    }else if (indexPath.row == 13) {
        cell.textLabel.text = @"sqlite 多主键表读取";
    }else if (indexPath.row == 14) {
        cell.textLabel.text = @"sqlite 自增主键列表";
    }else if (indexPath.row == 15) {
        cell.textLabel.text = @"数据表 count 字段查询";
    }else if (indexPath.row == 16) {
        cell.textLabel.text = @"从数据库中删除模型";
    }else if (indexPath.row == 17) {
        cell.textLabel.text = @"从数据库中查询字典集合";
    } else if (indexPath.row == 18) {
        cell.textLabel.text = @"数据嵌套存储";
    }else if (indexPath.row == 19) {
        cell.textLabel.text = @"数据库升级字段更改";
    }

    return cell;
}


#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self insertOneRowData];
    } else if (indexPath.row == 1) {
        [self insertLargeDataNOInTransaction];
    } else if (indexPath.row == 2) {
        [self insertLargeData];
    } else if (indexPath.row == 3) {
        [self readSqlData];
    } else if (indexPath.row == 4) {
        [self querySqlData];
    }else if (indexPath.row == 5) {
        [self queryOrderbylimit];
    }else if (indexPath.row == 6) {
        [self updateSqlData];
    }else if (indexPath.row == 7) {
        [self querySelectSqlData];
    } else if (indexPath.row == 8) {
        [self saveSqliteReserveWord];
    } else if (indexPath.row == 9) {
        [self querySqliteReserveWord];
    }else if (indexPath.row == 10) {
        [self saveBlackListModel];
    }else if (indexPath.row == 11) {
        [self queryBlackListModel];
    }else if (indexPath.row == 12) {
        [self saveMutiKeyModel];
    } else if (indexPath.row == 13) {
        [self queryMutiKeyModel];
    }else if (indexPath.row == 14) {
        [self createAutoPrimarykey];
    }else if (indexPath.row == 15) {
        [self querySqlTableCount];
    }else if (indexPath.row == 16) {
        [self deleteObject];
    }else if (indexPath.row == 17) {
        [self querySqlDictionany];
    }else if (indexPath.row == 18) {
        [self saveMutiData];
    }else if (indexPath.row == 19) {
        [self dbchanges];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)insertOneRowData
{
    NXAppsDataViewModel * model = [[NXAppsDataViewModel alloc] init];
    model.dataID = @"12";
    model.fields = @"1234567";
    model.dataGroup = 12;
    model.dataIndex = 12;
    model.myProperty = @"aaaa";
    NXAppsDataViewModel * model1 = [[NXAppsDataViewModel alloc] init];
    model1.dataID = @"888";
    model1.fields = @"1234567";
    model1.dataGroup = 12;
    model1.dataIndex = 12;
    model1.myProperty = @"bbbb";

    [_helper dbOperation:NXDBOperationCreate model:model updateAttributes:nil orderBy:nil limit:0 condition:nil inTrasaction:NO completionHandler:^(BOOL operationResult, id dataSet) {
        [_helper dbOperation:NXDBOperationCreate model:model1 updateAttributes:nil orderBy:nil limit:0 condition:nil inTrasaction:NO completionHandler:^(BOOL operationResult, id dataSet) {

        }];
    }];
}

- (void)insertLargeDataNOInTransaction
{
    [_helper dbOperation:NXDBOperationCreate model:self.models updateAttributes:nil orderBy:nil limit:0 condition:nil inTrasaction:NO completionHandler:^(BOOL operationResult, id dataSet) {}];
}

- (void)insertLargeData
{
    [_helper dbOperation:NXDBOperationCreate model:self.models updateAttributes:nil orderBy:nil limit:0 condition:nil inTrasaction:YES completionHandler:nil];
}

- (void)readSqlData
{
    [_helper dbOperation:NXDBOperationRead model:[NXAppsDataViewModel class] updateAttributes:nil orderBy:nil limit:0 condition:nil inTrasaction:NO completionHandler:^(BOOL operationResult, id dataSet) {
        NSString *jsons = [dataSet yy_modelDescription];
        NSLog(@"alldata__ %@",jsons);
    }];
}

- (void)querySqlData
{
    [_helper dbOperation:NXDBOperationRead model:[NXAppsDataViewModel class] updateAttributes:nil orderBy:nil limit:0 condition:[NXDBUtil sqlConditionWithArray:@[[NXDBCondition conditionWithString:@"dataID|E|12"]]] inTrasaction:NO completionHandler:^(BOOL operationResult, id dataSet) {
        NSString *jsons = [dataSet yy_modelDescription];
        NSLog(@"alldata__ %@",jsons);
    }];
}

- (void)queryOrderbylimit
{
    [_helper queryObject:[NXAppsDataViewModel class] conditions:@[[NXDBCondition conditionWithString:@"dataID|E|12"], [NXDBCondition conditionWithString:@"dataGroup|E|12"]] orderBy:@"dataID" limit:10 completionHandler:^(BOOL operationResult, id dataSet) {
        NSString *jsons = [dataSet yy_modelDescription];
        NSLog(@"alldata__ %@",jsons);
    }];
}

- (void)updateSqlData
{
    [_helper updateObject:[NXAppsDataViewModel class] updateAttributes:@{@"fields":@"我被修改了"} conditions:@[[NXDBCondition conditionWithString:@"dataIndex|E|12"], [NXDBCondition conditionWithString:@"dataGroup|E|12"]] completionHandler:nil];
}

- (void)querySelectSqlData
{
    [_helper queryObject:[NXAppsDataViewModel class] conditions:@[[NXDBCondition conditionWithString:@"dataID|E|WOSHI_dataID"]] orderBy:@"dataID" limit:10 completionHandler:nil];
}

- (void)saveSqliteReserveWord
{
    SQLiteReserveModel *model = [SQLiteReserveModel new];
    model.index = 1;
    model.group = @"12";
    model.add = @"add";
    model.as = @"as";
    model.desc = @"desc";
    SQLiteReserveModel *model1 = [SQLiteReserveModel new];
    model1.index = 2;
    model1.group = @"12";
    model1.add = @"add";
    model1.as = @"as";
    model1.desc = @"desc";
    [_helper insertObject:model completionHandler:nil];
}

- (void)querySqliteReserveWord
{
    [_helper queryObject:[SQLiteReserveModel class] conditions:nil completionHandler:nil];
}

- (void)saveBlackListModel
{
    NXBlackListModel *black = [NXBlackListModel new];
    black.dataID = @"asdfjkasdhjklghsad";
    black.name = @"我是黑名单模型";
    ///这三个字段会自动过滤. 数据表中也不会有这三个字段
    black.blackField1 =@[@"1"];
    black.blackField2 = YES;
    black.blackField3 = @"asdlkfljaksd";
    [_helper insertObject:black completionHandler:nil];
}

- (void)queryBlackListModel
{
    [_helper queryObject:[NXBlackListModel class] conditions:nil completionHandler:nil];
}

/// 多主键
- (void)saveMutiKeyModel
{
    NXMutilKeyModel *key = [NXMutilKeyModel new];
    key.primaryKey1 = @"primaryKey1";
    key.primaryKey2 = 10;
    key.primaryKey3 = @"primaryKey1";
    key.other = @"test";
    NXMutilKeyModel *key1 = [NXMutilKeyModel new];
    key1.primaryKey1 = @"primaryKey1";
    key1.primaryKey2 = 10;
    key1.primaryKey3 = @"primaryKey1";
    key1.other = @"test1";
    NXMutilKeyModel *key2 = [NXMutilKeyModel new];
    key2.primaryKey1 = @"primaryKey1";
    key2.primaryKey2 = 11;
    key2.primaryKey3 = @"primaryKey1";
    key2.other = @"test";
    // key 与key1 所有主键均相同. so key1 会覆盖key
    [_helper insertObject:@[key,key1,key2] completionHandler:nil];
}

- (void)queryMutiKeyModel
{
    [_helper queryObject:[NXMutilKeyModel class] conditions:nil completionHandler:nil];
}

- (void)createAutoPrimarykey
{
    NXAutoPrimaryKeyModel *model = [NXAutoPrimaryKeyModel new];
    model.key = @"WOSHI_dataID";
    NXAutoPrimaryKeyModel *model1 = [NXAutoPrimaryKeyModel new];
    model1.key = @"WOSHI_dataID";
    NXAutoPrimaryKeyModel *model2 = [NXAutoPrimaryKeyModel new];
    model2.key = @"WOSHI_dataID";
    NXAutoPrimaryKeyModel *model3 = [NXAutoPrimaryKeyModel new];
    model3.key = @"WOSHI_dataID";
    NXAutoPrimaryKeyModel *model4 = [NXAutoPrimaryKeyModel new];
    model4.key = @"WOSHI_dataID";

    [_helper insertObject:@[model,model1,model2,model3,model4] completionHandler:nil];
}

- (void)querySqlTableCount
{
    long count = [_helper querySqlTableCount:[NXAppsDataViewModel class]];
    NSLog(@"count -- %ld",count);
}

- (void)deleteObject
{
    [_helper queryObject:[NXAutoPrimaryKeyModel class] conditions:nil completionHandler:^(BOOL operationResult, id dataSet) {
        [_helper deleteObject:[dataSet firstObject] completionHandler:nil];
    }];
}

- (void)querySqlDictionany
{
    NSArray *datas = [_helper resultDictionaryWithModel:NXAutoPrimaryKeyModel.class];
    NSLog(@"alldata__ %@",datas);
}

- (void)updateObject
{
    [_helper queryObject:[NXAppsDataViewModel class] conditions:nil completionHandler:^(BOOL operationResult, id dataSet) {
        NXAppsDataViewModel* object = [dataSet firstObject];
        long autoPri = [object nx_autoPrimaryKey];
        NXAppsDataViewModel * dataModel = [NXAppsDataViewModel new];
        dataModel.dataID = @"WOSHI_dataID";
        dataModel.fields = @"1234567";
        dataModel.dataGroup = 12;
        dataModel.dataIndex = 12;
        [dataModel setValue:@(autoPri) forKey:NXAUTOPRIMARYKEY];
        [_helper insertObject:dataModel completionHandler:nil];
    }];
}

- (void)saveMutiData
{
    NXSubTableA * sub = [NXSubTableA new];
    sub.key = @"ceshi";
    NXTableA *tableA = [NXTableA new];
    tableA.datas = @[sub];
    tableA.subA = sub;
    NSString *str = @"asdf";
    tableA.data = [str dataUsingEncoding:NSUTF8StringEncoding];
    tableA.realData =[str dataUsingEncoding:NSUTF8StringEncoding];
    [_helper insertObject:tableA completionHandler:nil];

    [_helper queryObject:[NXTableA class] conditions:nil completionHandler:^(BOOL operationResult, id dataSet) {
        NSString *jsons = [dataSet yy_modelDescription];
        NSLog(@"alldata__ %@",jsons);
    }];
}

- (void)dbchanges
{
    [_helper dbChanges:nil];
}

@end
