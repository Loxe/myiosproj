//
//  ProductBaseController.m
//  akucun
//
//  Created by Jarry on 2017/8/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductBaseController.h"
#import "UserManager.h"
#import "RequestProductBuy.h"
#import "RequestProductForward.h"
#import "RequestSendComment.h"
#import "RequestCancelComment.h"
#import "RequestProductRemark.h"
#import "RequestGetSKU.h"
#import "RequestUpdateSKU.h"
#import "RequestProductFollow.h"
#import "ShareActivity.h"
#import "MMAlertView.h"
#import "AKShareConfirm.h"
#import "AkRemarkAlert.h"
#import "VIPPurchaseController.h"
#import "BuyViewController.h"
#import "MyOrderController.h"
#import "OrderDetailController.h"
#import "JXMCSUserManager.h"
#import "UIView+DDExtension.h"
#import "SCLAlertView.h"

@interface ProductBaseController ()

@end

@implementation ProductBaseController

- (void) setupContent
{
    [super setupContent];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecvNotVIP:) name:NOTIFICATION_NOT_VIP object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void) didRecvNotVIP:(NSNotification *)notification
//{
//    if (!self.isVisible) {
//        return;
//    }
//    NSDictionary *msgData = notification.userInfo;
//    NSString *msg = [msgData objectForKey:HTTP_KEY_MSG];
//}

- (void) showNotVIPMsg:(NSString *)msg
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOT_VIP object:nil];
    /*
    @weakify(self)
    MMPopupItemHandler block = ^(NSInteger index) {
        @strongify(self)
        if (index == 1) {
            VIPPurchaseController *controller = [VIPPurchaseController new];
            controller.isPresented = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    };
    
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),
      MMItemMake(@"去开通", MMItemTypeHighlight, block)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"请开通会员" detail:FORMAT(@"\n%@",msg) items:items];
    [alertView show];*/
}

- (void) showForwardMsg:(NSString *)msg product:(ProductModel *)product
{
    MMPopupItemHandler block = ^(NSInteger index) {
        if (index == 1) {
            [self forwardAction:product checked1:NO checked2:NO updated:^(id content) {
                [SVProgressHUD showSuccessWithStatus:@"转发成功，您现在可以继续下单了"];
            }];
        }
    };
    
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),
      MMItemMake(@"去转发", MMItemTypeHighlight, block)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"未转发不能下单" detail:FORMAT(@"\n%@",msg) items:items];
    [alertView show];
}

// 有未支付订单 提示先支付
- (void) showPayErrorDialog:(NSString *)msg
{
    @weakify(self)
    [self confirmWithTitle:@"有未支付订单" detail:msg btnText:@"支付" block:^{
        @strongify(self)
        //
        MyOrderController *controller = [MyOrderController new];
        controller.orderType = 0;
        if (self.parentViewController.navigationController) {
            [self.parentViewController.navigationController pushViewController:controller animated:YES];
        }
        else {
            [self.navigationController pushViewController:controller animated:YES];
        }
    } canceled:nil];
}

#pragma mark - Actions

- (void) forwardAction:(ProductModel *)product checked1:(BOOL)checked1 checked2:(BOOL)checked2 updated:(idBlock)updatedBlock
{
//    LiveInfo *liveInfo = [LiveManager getLiveInfo:product.liveid];
//    if (!liveInfo) {
//        [SVProgressHUD showInfoWithStatus:@"该品牌活动已结束 ！"];
//        return;
//    }
    
    [SVProgressHUD showWithStatus:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil];

    NSInteger type = ShareOptionOnlyPictures;
    if (checked1) {
        type = ShareOptionMergedPicture;
    }
    else if (checked2) {
        type = ShareOptionPicturesAndText;
    }
    
    if (!product.skus || product.skus.count == 0) {
        NSArray *imagesUrl = [product imagesUrl];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = product.desc;
        
        [ShareActivity forwardWithItems:imagesUrl
                                   text:(checked1||checked2) ? product.desc:nil
                                   data:nil
                                   type:type
                                 parent:self
                                   view:nil
                               finished:^(int flag)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
        }
                               canceled:^
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
        }];
        return;
    }
    
    NSString *content = [product weixinDesc];
    NSArray *imagesUrl = [product imagesUrl];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = content;
    
    //
    NSInteger price = product.bohuojia/100;
    NSInteger priceOption = [UserManager instance].userConfig.priceOption;
    if (price > 0 && priceOption > 0) {
        price += priceOption;
    }
    NSInteger diaopai = product.diaopaijia/100;
    @weakify(self)
    [ShareActivity forwardWithItems:imagesUrl
                               text:(checked1||checked2) ? content:nil
                               data:@{@"price":@(price),@"diaopai":@(diaopai)}
                               type:type
                             parent:self
                               view:nil
                           finished:^(int type)
     {
         @strongify(self)
         [self requestForwardPorduct:product type:type finished:^{
             product.forward = 1;
             if (updatedBlock) {
                 updatedBlock(product);
             }
         }];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
     }
                           canceled:^
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
    }];
    /*
    [self requestGetSKU:product finished:^(id content){
        //
        ProductModel *model = content;
        //
        if ([model isQuehuo]) {
            // 更新库存显示
            if (updatedBlock) {
                updatedBlock(model);
            }
            [SVProgressHUD showInfoWithStatus:@"该商品已卖光了 ！"];
            return;
        }
    }];
     */
}

- (void) buyProduct:(ProductModel *)product sku:(ProductSKU *)sku finished:(idBlock)finishedBlock
{
    if (![UserManager isVIP]) {
        [self showNotVIPMsg:nil];
        return;
    }
    
    @weakify(self)
    //
    LiveInfo *liveInfo = [LiveManager getLiveInfo:product.liveid];
    if (liveInfo && liveInfo.buymodel > 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil];
        
        BuyViewController *controller = [BuyViewController new];
        controller.isPresented = YES;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.sku = sku;
        controller.product = product;
        [self.navigationController presentViewController:navController animated:YES completion:nil];
        controller.finishBlock = ^(id content) {
            @strongify(self)
            //
            if ([content isKindOfClass:[OrderModel class]]) {
                OrderDetailController *controller = [OrderDetailController new];
                controller.orderModel = content;
                if (self.parentViewController.navigationController) {
                    [self.parentViewController.navigationController pushViewController:controller animated:YES];
                }
                else {
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
            else {
                NSDictionary *msgData = content;
                NSNumber *codeObj = [msgData objectForKey:HTTP_KEY_CODE];
                NSInteger code = codeObj ? codeObj.integerValue : 0;
                NSString *msg = [msgData objectForKey:HTTP_KEY_MSG];
                if (code == ERR_NOT_PAYED) {
                    [SVProgressHUD dismiss];
                    [self showPayErrorDialog:msg];
                }
                else {
                    NSString *text = FORMAT(@"[E%ld]\n%@", (long)code, msg);
                    [SVProgressHUD showErrorWithStatus:text];
                }
            }
        };
        return;
    }
    
    if (![UserManager instance].userConfig.remarkSwitch) {
        [self requestBuyProduct:product sku:sku remark:@"" finished:finishedBlock];
        return;
    }
    
    AkRemarkAlert *alertView = [[AkRemarkAlert alloc] initWithInputTitle:@"确认加入购物车 ？"
                                                                  detail:@"您可以在设置中关闭备注开关，该确认框将不再显示"
                                                                 content:@""
                                                            placeholder:@"请输入商品备注信息"
                                                                handler:^(NSString *text)
    {
        @strongify(self)
        [self requestBuyProduct:product sku:sku remark:text finished:finishedBlock];
    }];
//    alertView.attachedView = self.view;
    [alertView show];
}
/*
- (void) commentAction:(ProductModel *)product
{
    if (![UserManager isVIP]) {
        [self showNotVIPMsg:@"非会员不支持评论，请先购买会员资格"];
        return;
    }

    self.commentView.object = product;
    self.commentView.placeHolder = @"添加评论";
    self.commentView.hidden = NO;
    [self.commentView show];
}

- (void) hideCommentView
{
    [self.commentView hide];
}

- (void) cancelComment:(Comment *)comment product:(ProductModel *)product finished:(idBlock)finishedBlock
{
    [self requestCancelComment:comment product:product finished:finishedBlock];
}*/

- (void) followProductAction:(ProductModel *)product index:(NSIndexPath *)indexPath
{
    NSInteger status = 1;
    if (product.follow > 0) {
        status = 0;
        [self confirmWithTitle:@"取消关注该商品 ？"
                         block:^
        {
            [self requestFollowProduct:product status:status finished:^{
                product.follow = status;
                [[ProductsManager instance] updateProductFollow:product];
                //
                [self productFollowCancelled:product index:indexPath];
            }];
            
        } canceled:nil];
        
        return;
    }
    
    [self requestFollowProduct:product status:status finished:^{
        product.follow = status;
        [[ProductsManager instance] updateProductFollow:product];
        //
        [self updateRowAtIndex:indexPath model:product];
    }];
}

- (void) productFollowCancelled:(ProductModel *)product index:(NSIndexPath *)indexPath
{
    [self updateRowAtIndex:indexPath model:product];
}

- (void) kefuAction:(ProductModel *)product
{
    /** 佳信售前客服 */
    if ([ServiceTypeManager instance].serviceType == ServiceTypeFeed) {
        [sClient.mcsManager leaveService];
    }
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    // 获取当前登录用户的信息
    NSString *userID = [UserManager subuserId]; // 子账号ID
    NSString *name   = [UserManager instance].userInfo.name;
    NSString *bianhao = [UserManager instance].userInfo.yonghubianhao;
    NSString *viplevel = kIntergerToString([UserManager instance].userInfo.viplevel);
    NSDictionary *clientConfig = @{@"cid" : userID,
                                   @"crm" : @{@"name" : FORMAT(@"%@ [%@]",name,bianhao),
                                              @"extend1" : bianhao,
                                              @"extend2" : viplevel
                                              }
                                   };
    [sClient initializeSDKWithAppKey:JX_SALEAPPKEY andLaunchOptions:nil andConfig:clientConfig];
    
    WEAKSELF;
    [[JXMCSUserManager sharedInstance] loginWithCallback:^(BOOL success, id response) {
        [SVProgressHUD dismiss];
        if (success) {
            // 隐藏“转发”按钮
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil];
            [ServiceTypeManager instance].serviceType = ServiceTypeSale;
            JXMcsChatConfig *config = [JXMcsChatConfig defaultConfig];
            NSString *avatorStr = [UserManager instance].userInfo.avatar;
            NSURL *url = [NSURL URLWithString:avatorStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            config.avatorImage = [UIImage imageWithData:data];
            
            JXGoods *goods   = [[JXGoods alloc] init];
            goods.title      = product.pinpai;
            goods.content    = product.desc;
            //goods.url        = @"www.aikucun.com";
            NSURL *goodUrl   = [NSURL URLWithString:product.imageUrl1];
            NSData *goodData = [NSData dataWithContentsOfURL:goodUrl];
            goods.image      = [UIImage imageWithData:goodData];
            config.goodsInfo = goods;
            UIViewController *topVC = [weakSelf.view topViewController];
            [[JXMCSUserManager sharedInstance] requestCSForUI:topVC.navigationController witConfig:config];
        } else {
            POPUPINFO(@"客服页面请求失败");
            NSLog(@"佳信客服页面请求失败 %@", response);
        }
    }];
}

#pragma mark - Request

- (void) requestBuyProduct:(ProductModel *)product sku:(ProductSKU *)sku remark:(NSString *)remark finished:(idBlock)finishedBlock
{
    [SVProgressHUD showWithStatus:nil];
    RequestProductBuy *request = [RequestProductBuy new];
    request.productId = product.Id;
    request.skuId = sku.Id;
    request.remark = remark;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_TO_CART object:nil];
         
         [SVProgressHUD showSuccessWithStatus:@"已成功添加到购物车"];

         //
         [self requestGetSKU:product finished:finishedBlock];
     }
                                 onFailed:^(id content)
     {
         NSDictionary *msgData = content;
         NSNumber *codeObj = [msgData objectForKey:HTTP_KEY_CODE];
         NSInteger code = codeObj ? codeObj.integerValue : 0;
         NSString *msg = [msgData objectForKey:HTTP_KEY_MSG];
         
         if (code == ERR_SOLD_OUT) {
             // 纠正库存
             [self requestGetSKU:product finished:finishedBlock];
             return;
         }
         
         if (code == ERR_VIP_DISABLED) {
             [SVProgressHUD dismiss];
             [self showNotVIPMsg:msg];
         }
         else if (code == ERR_NOT_FORWARD) {
             [SVProgressHUD dismiss];
             [self showForwardMsg:msg product:product];
         }
         else {
             NSString *text = FORMAT(@"[E%ld]\n%@", (long)code, msg);
             [SVProgressHUD showErrorWithStatus:text];
         }
         
         if (finishedBlock) {
             finishedBlock(product);
         }
     }];
}

- (void) requestForwardPorduct:(ProductModel *)product type:(NSInteger)dest finished:(voidBlock)finishedBlock
{
    RequestProductForward *request = [RequestProductForward new];
    request.productId = product.Id;
    request.dest = dest;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         //
         product.forward = 1;
         [[ProductsManager instance] updateProductForward:product];
         
         if (finishedBlock) {
             finishedBlock();
         }
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestComment:(ProductModel *)product comment:(NSString *)comment
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestSendComment *request = [RequestSendComment new];
    request.productId = product.Id;
    request.content = comment;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"评论发表成功"];
         //
         HttpResponseBase *response = content;
         Comment *commentObj = [[Comment alloc] init];
         commentObj.Id = [response.responseData objectForKey:@"commentid"];
         commentObj.content = comment;
         commentObj.name = [UserManager instance].userInfo.name;
         commentObj.productid = product.Id;
         commentObj.pinglunzheID = [UserManager userId];
         [product addComment:commentObj];
         
         [self updateRowAtIndex:self.clickedIndexPath model:product];
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestCancelComment:(Comment *)comment product:(ProductModel *)product finished:(idBlock)finishedBlock
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestCancelComment *request = [RequestCancelComment new];
    request.productId = comment.productid;
    request.commentId = comment.Id;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"评论已取消"];
         //
         [product removeComment:comment];
         
         if (finishedBlock) {
             finishedBlock(product);
         }
     }
                                 onFailed:^(id content)
     {
         
     }];
}

- (void) requestRemark:(NSString *)remark productId:(NSString *)cartproductid
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestProductRemark *request = [RequestProductRemark new];
    request.productId = cartproductid;
    request.remark = remark;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"已成功添加到购物车"];
     }
                                 onFailed:nil];
}

- (void) requestGetSKU:(ProductModel *)product finished:(idBlock)finished
{
    RequestGetSKU *request = [RequestGetSKU new];
    request.productId = product.Id;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseSKUList *response = content;
         if (finished) {
             finished(response.product);
         }
     }
                                 onFailed:nil];
}

- (void) requestFollowProduct:(ProductModel *)product status:(NSInteger)status finished:(voidBlock)finishedBlock
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestProductFollow *request = [RequestProductFollow new];
    request.productId = product.Id;
    request.statu = status;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         if (status == 1) {
             [SVProgressHUD showSuccessWithStatus:@"已添加关注 ！"];
             [ProductsManager instance].followCount ++;
         }
         else {
             [SVProgressHUD showSuccessWithStatus:@"已取消关注 ！"];
             if ([ProductsManager instance].followCount > 0) {
                 [ProductsManager instance].followCount --;
             }
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_FOLLOW object:nil];

         if (finishedBlock) {
             finishedBlock();
         }
     }
                                 onFailed:nil];
}

#pragma mark - 

- (void) updateRowAtIndex:(NSIndexPath *)indexPath model:(ProductModel *)model
{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    ProductCellLayout *newLayout = [[ProductCellLayout alloc] initWithModel:model];
    AKTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell coverScreenshotAndDelayRemoved:self.tableView cellHeight:newLayout.cellHeight];
    
    [self.tableView beginUpdates];
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataSource.count) {
        return 0;
    }
    ProductCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    ProductTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProductTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self configueCell:cell atIndexPath:indexPath];
    return cell;
}

- (void) configueCell:(ProductTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    
    cell.indexPath = indexPath;
    ProductCellLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
    
    [self callbackWithCell:cell];
}

- (void) callbackWithCell:(ProductTableCell *)cell
{
    @weakify(self)
    /*
    cell.clickedCommentCallback = ^(ProductTableCell* cell, ProductModel *model) {
        @strongify(self)
        self.clickedIndexPath = cell.indexPath;
        [self commentAction:model];
    };
    
    cell.clickedCancelCallback = ^(ProductTableCell* cell, ProductModel *model, Comment *comment) {
        @strongify(self)
        self.clickedIndexPath = cell.indexPath;
        [self cancelComment:comment product:model finished:^(id content) {
            [self updateRowAtIndex:cell.indexPath model:model];
        }];
    };*/
    
    cell.clickedBuyCallback = ^(ProductTableCell* cell, ProductModel *model, ProductSKU *sku) {
        @strongify(self)
//        [self.commentView hide];
        [self buyProduct:model sku:sku finished:^(id content) {
            [self updateRowAtIndex:cell.indexPath model:content];
        }];
    };
    
    cell.clickedImageCallback = ^(ProductTableCell* cell, NSInteger imageIndex) {
        @strongify(self)
//        [self.commentView hide];
        self.isImageBrowser = YES;
    };
    
    cell.clickedForwardCallback = ^(ProductTableCell* cell, ProductModel *model) {
        @strongify(self)
//        [self.commentView hide];
        [AKShareConfirm showWithConfirmed:^(BOOL check1, BOOL check2) {
            [self forwardAction:model checked1:check1 checked2:check2 updated:^(id content) {
                [self updateRowAtIndex:cell.indexPath model:content];
            }];
        } model:model showOption:YES];
    };
    
    cell.clickedFollowCallback = ^(ProductTableCell* cell, ProductModel *model) {
        @strongify(self)
//        [self.commentView hide];
        [self followProductAction:model index:cell.indexPath];
    };
    
    cell.clickedKefuCallback = ^(ProductTableCell* cell, ProductModel *model) {
        @strongify(self)
//        [self.commentView hide];
        [self kefuAction:model];
    };
}

#pragma mark - Views

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        //        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
#ifdef XCODE9VERSION
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
#endif
    }
    return _tableView;
}
/*
- (CommentView *) commentView
{
    if (_commentView) {
        return _commentView;
    }
    _commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kEDIT_BAR_HEIGHT)];
    _commentView.offsetHeight = kBOTTOM_BAR_HEIGHT;
    _commentView.containerView = self.view;
    @weakify(self)
    _commentView.sendBlock = ^(id content1, id content2) {
        @strongify(self)
        [self requestComment:content1 comment:content2];
    };
    
    _commentView.hidden = YES;
    
    return _commentView;
}*/

@end
