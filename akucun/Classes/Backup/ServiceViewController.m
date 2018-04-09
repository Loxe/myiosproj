//
//  ServiceViewController.m
//  akucun
//
//  Created by Jarry on 2017/9/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ServiceViewController.h"
#import "ECChatViewController.h"
#import "IQKeyboardManager.h"
#import "RequestKefuRefresh.h"
#import "RequestKefuPull.h"
#import "RequestKefuSend.h"
#import "RequestKefuCheck.h"
#import "UserManager.h"

@interface ServiceViewController () <ECChatControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ECChatViewController *chatBoxVC;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSTimer   *timer;

@end

@implementation ServiceViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(240, 237, 237);
    self.title = @"爱库存客服";

    //
    [self addChildViewController:self.chatBoxVC];
    [self.view addSubview:self.chatBoxVC.view];
    
    [self.view addSubview:self.tableView];
    
    [self.chatBoxVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).offset(-CHAT_BAR_HEIGHT-kSafeAreaBottomHeight);
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.chatBoxVC.view.mas_top);
    }];
    
    _dataSource = [NSMutableArray array];
    /*
    ChatMsg *msg1 = [ChatMsg new];
    msg1.content = @"测试是常识手册测试是常识手册测试是常识手册测试是常识手册测试是常识手册测试是常识手册测试是常识手册";
    msg1.direction = 1;
    [_dataSource addObject:[[ECChatMsgFrame alloc] initWithModel:msg1]];
    
    ChatMsg *msg2 = [ChatMsg new];
    msg2.content = @"回复消息回复消息回复消息回复消息回复消息回复消息回复消息回复消息回复消息";
    msg2.direction = 0;
    [_dataSource addObject:[[ECChatMsgFrame alloc] initWithModel:msg2]];
    ChatMsg *msg3 = [ChatMsg new];
    msg3.content = @"OK !";
    msg3.direction = 1;
    [_dataSource addObject:[[ECChatMsgFrame alloc] initWithModel:msg3]];
    
    [self.tableView reloadData];*/
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.dataSource removeAllObjects];
    [self refreshMessages];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    [self stopTimer];
}

- (void) addDataSource:(NSArray *)msgs
{
    if (self.dataSource.count == 0) {
        ChatMsg *welcomeMsg = [ChatMsg new];
        UserInfo *userInfo = [UserManager instance].userInfo;
        welcomeMsg.content = FORMAT(@"%@ 您好！爱库存客服小爱为您服务！", userInfo.name);
        welcomeMsg.direction = 1;
        [self.dataSource insertObject:[[ECChatMsgFrame alloc] initWithModel:welcomeMsg] atIndex:0];
    }
    
    for (ChatMsg *msg in msgs) {
        ECChatMsgFrame *item = [[ECChatMsgFrame alloc] initWithModel:msg];
        [self.dataSource addObject:item];
    }
    
    [self.tableView reloadData];
    if (msgs.count > 0) {
        [self scrollToBottom];
    }
}

#pragma mark - Request

- (void) refreshMessages
{
    RequestKefuRefresh *request = [RequestKefuRefresh new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        ResponseKefuMsgList *response = content;
        [self addDataSource:response.result];
        
        [self startTimer];
        
    } onFailed:^(id content) {
        
    }];
}

- (void) sendMessage:(NSString *)content
{
    RequestKefuSend *request = [RequestKefuSend new];
    request.content = content;
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSDictionary *msgDic = [response.responseData objectForKey:@"msg"];
         ChatMsg *msg = [ChatMsg yy_modelWithDictionary:msgDic];
         ECChatMsgFrame *lastItem = [self.dataSource lastObject];
         lastItem.model.xuhao = msg.xuhao;
         
     } onFailed:^(id content) {
         
     }];
}

- (void) requestCheckMessage
{
    RequestKefuCheck *request = [RequestKefuCheck new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSDictionary *msgDic = response.responseData;
         NSInteger count = [msgDic getIntegerValueForKey:@"cnt"];
         
         if (count > 0) {
             [self requestPullMessage];
         }
         
     } onFailed:^(id content) {
         
     }];
}

- (void) requestPullMessage
{
    RequestKefuPull *request = [RequestKefuPull new];
    
    if (self.dataSource.count == 0) {
        request.lastxuhao = 0;
    }
    else {
        ECChatMsgFrame *lastItem = [self.dataSource lastObject];
        request.lastxuhao = lastItem.model.xuhao;
    }
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseKefuMsgList *response = content;
         [self addDataSource:response.result];
         
     } onFailed:^(id content) {
         
     }];
}

#pragma mark - ECChatControllerDelegate

- (void) chatViewController:(ECChatViewController *)chatViewController
            sendTextMessage:(NSString *)messageStr
{
    if (messageStr && messageStr.length > 0) {

        ChatMsg *msg = [ChatMsg new];
        msg.content = messageStr;
        msg.direction = 0;
        
        [self.dataSource addObject:[[ECChatMsgFrame alloc] initWithModel:msg]];
        [self.tableView reloadData];
        
        [self scrollToBottom];
        
        // Send
        [self sendMessage:messageStr];
    }
}

- (void) chatViewController:(ECChatViewController *)chatViewController
            didChangeHeight:(CGFloat)height
{
    [self.chatBoxVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).offset(-height);
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    [self.view layoutIfNeeded];
    
    if (height == CHAT_BAR_HEIGHT) {
        [self.tableView reloadData];
        [self scrollToBottom];
//        _isKeyBoardAppear  = NO;
    }
    else {
        [self scrollToBottom];
//        _isKeyBoardAppear  = YES;
    }
//    if (self.textView == nil) {
//        self.textView = chatboxViewController.chatBox.textView;
//    }
}

#pragma mark - Tableview data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = self.dataSource[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return nil;
    }
    else {
        ECChatMsgFrame *modelFrame = (ECChatMsgFrame *)obj;
        ECChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CHAT_MESSAGE_TEXT];
//        cell.longPressDelegate = self;
        cell.modelFrame = modelFrame;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECChatMsgFrame *messageF = [self.dataSource objectAtIndex:indexPath.row];
    return messageF.cellHeight;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.chatBoxVC resignFirstResponder];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.chatBoxVC resignFirstResponder];
}

- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
//    if ([cell isKindOfClass:[ICChatMessageVideoCell class]] && self) {
//        ICChatMessageVideoCell *videoCell = (ICChatMessageVideoCell *)cell;
//        [videoCell stopVideo];
//    }
}

- (void) scrollToBottom
{
    if (self.dataSource.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.dataSource.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Timer

- (void) startTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void) stopTimer
{
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void) timerFired:(NSTimer *)timer
{
    [self requestCheckMessage];
}

#pragma mark - Getter and Setter

- (ECChatViewController *) chatBoxVC
{
    if (_chatBoxVC == nil) {
        _chatBoxVC = [[ECChatViewController alloc] init];
        [_chatBoxVC.view setFrame:CGRectMake(0, SCREEN_HEIGHT-CHAT_BAR_HEIGHT-64, SCREEN_HEIGHT, SCREEN_HEIGHT)];
        _chatBoxVC.delegate = self;
    }
    return _chatBoxVC;
}

-(UITableView *) tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[ECChatTextCell class] forCellReuseIdentifier:CHAT_MESSAGE_TEXT];
    }
    return _tableView;
}

@end
