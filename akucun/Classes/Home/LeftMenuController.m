//
//  LeftMenuController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LeftMenuController.h"
#import "LiveManager.h"
#import "RequestLivePackage.h"
#import "RequestLiveListNew.h"

@interface LeftMenuController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *livesData;
//@property (nonatomic, strong) NSArray *dxLivesData;
//@property (nonatomic, strong) NSArray *explosionList;

//@property (nonatomic, strong) NSArray *livesPackage;

@end

@implementation LeftMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) setupContent
{
    self.view.backgroundColor = RGBCOLOR(0xF5, 0xF6, 0xF7);

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).offset(-1.0f);
    }];
    
    self.livesData = [NSArray array];
//    self.dxLivesData = [NSArray array];
//    self.explosionList = [NSArray array];
}

- (void) updateData
{
    self.livesData = [LiveManager instance].liveDatas;
//    self.dxLivesData = [LiveManager instance].dxLives;
//    self.explosionList = [LiveManager instance].explosionLives;

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.shouldUpdate) {
        [self requestLiveList];
        self.shouldUpdate = NO;
    }
}

- (void) hideMenu
{
    self.livesData = [NSArray array];
//    self.dxLivesData = [NSArray array];
//    self.explosionList = [NSArray array];
    [self.tableView reloadData];
}

- (void) requestLiveList
{
    RequestLiveListNew *request = [RequestLiveListNew new];
    request.modeltype = -1;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         self.livesData = [LiveManager instance].liveDatas;
         [self.tableView reloadData];
     } onFailed:nil];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return self.livesData.count;
//    }
//    else if (section == 1) {
//        return self.dxLivesData.count;
//    }
//    else if (section == 2) {
//        return self.explosionList.count;
//    }
    return self.livesData.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return isPad ? kPadCellHeight : kTableCellHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
//    if (section == 0) {
//        return self.livesData.count > 0 ? height*0.5 : 0;
//    }
//    else if (section == 1) {
//        return self.dxLivesData.count > 0 ? height*0.5 : 0;
//    }
//    else if (section == 2) {
//        return self.explosionList.count > 0 ? height*0.5 : 0;
//    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, height*0.5)];
    header.backgroundColor = COLOR_SEPERATOR_LINE;
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 19.5f, header.width, 0.5f)];
//    line.backgroundColor = COLOR_SEPERATOR_LINE;
//    [header addSubview:line];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, 200, height*0.5)];
    titleLabel.textColor = COLOR_SELECTED;
    titleLabel.font = BOLDSYSTEMFONT(13);
    if (section == 0) {
        titleLabel.text = @"直 播";
    }
    else if (section == 1) {
        titleLabel.text = @"DX利丰"; //@"今日爆款";
    }
    else if (section == 2) {
        titleLabel.text = @"爆 款";
    }
    [header addSubview:titleLabel];
    return header;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuTableCell *cell = [[LeftMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row == self.livesData.count-1) {
        cell.showSeperator = NO;
    }
    LiveInfo *liveInfo = self.livesData[indexPath.row];
    cell.liveInfo = liveInfo;
    /*
    if (indexPath.section == 0) {
        if (indexPath.row == self.livesData.count-1) {
            cell.showSeperator = NO;
        }
        LiveInfo *liveInfo = self.livesData[indexPath.row];
        cell.liveInfo = liveInfo;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == self.dxLivesData.count-1) {
            cell.showSeperator = NO;
        }
        LiveInfo *liveInfo = self.dxLivesData[indexPath.row];
        cell.liveInfo = liveInfo;
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == self.explosionList.count-1) {
            cell.showSeperator = NO;
        }
        LiveInfo *liveInfo = self.explosionList[indexPath.row];
        cell.liveInfo = liveInfo;
    }*/

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    if (self.selectBlock) {
        LiveInfo *liveInfo = self.livesData[indexPath.row];
        self.selectBlock((int)indexPath.row, liveInfo);
        /*
        if (indexPath.section == 0) {
            LiveInfo *liveInfo = self.livesData[indexPath.row];
            self.selectBlock((int)indexPath.row, liveInfo);
        }
        else if (indexPath.section == 1) {
            LiveInfo *liveInfo = self.dxLivesData[indexPath.row];
            self.selectBlock((int)indexPath.row, liveInfo);
        }
        else if (indexPath.section == 2) {
            LiveInfo *liveInfo = self.explosionList[indexPath.row];
            self.selectBlock((int)indexPath.row, liveInfo);
        }*/
    }
}

#pragma mark - Views

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE+kSafeAreaBottomHeight)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPIXEL_WIDTH)];
        line.backgroundColor = COLOR_SEPERATOR_LIGHT;
        [footer addSubview:line];
        _tableView.tableFooterView = footer;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _tableView;
}

@end
