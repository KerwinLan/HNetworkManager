//
//  HNetworkBaseManager.h
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLRequest+HExtension.h"
#import "HNetworkSignature.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HNetworkCachePolicy) {
    HNetworkCachePolicyRemote = 0,    //直接从服务器获取数据
    HNetworkCachePolicyLocal,         //直接从本地缓存获取数据
    HNetworkCachePolicyLocalAndRemote //先加载本地缓存数据，在从服务器获取新数据
};

@protocol HNetworkCacheManager <NSObject>

/**
 请求完成后会调用该函数，可自行编写缓存逻辑

 @param instance 缓存数据
 @param identifier 缓存标识
 */
- (void)cacheManagerSaveInstance:(NSData *)instance forIdentifier:(NSString *)identifier;

/**
 需要获取缓存数据时会调用该函数，可根据缓存的标识获取缓存

 @param identifier 缓存标识
 @return 需要返回缓存数据
 */
- (NSData *)cacheManagerFetchInstanceForIdentifier:(NSString *)identifier;

@end

@interface HNetworkManager<__covariant T> : NSObject


/**
    当前接口最后一次返回的数据
 */
@property (nonatomic, strong, nullable) T responseModel;

/**
    接口请求的回调（从缓存获取数据也会调用）
 */
@property (nonatomic, copy, nullable) void(^callResult)(T _Nullable model, id _Nullable parameter, NSError * _Nullable error);

/**
 当前请求在队列中的标识，可以根据该标识从队列中取消该次请求
 */
@property (nonatomic) NSInteger requestId;

/**
   请求的域名，如果不设置将会从HNetworkOptions中获取全局域名
 */
@property (nonatomic, copy) NSString *baseURL;

/**
    请求路径，必须设置
 */
@property (nonatomic, copy) NSString *methodName;

/**
    请求方式，默认为GET
 */
@property (nonatomic, assign) HNetworkRequestType requestType;

/**
    请求的头部参数，可不设置
 */
@property (nonatomic, strong, nullable) NSDictionary *headerFields;

/**
  该参数在服务器响应数据时和响应数据一同委托给HNetworkResponseHandler类或者其子类处理
 */
@property (nonatomic, assign) Class parseClass;


/**
 请求参数，只接受NSArray和NSDictionary
 */
@property (nonatomic, strong, nullable) id requestBody;


/**
    接口参数签名, 可自行设置参数签名规则，该类需遵循HNetworkSignature协议。也可以不签名
 */
@property (nonatomic, weak, nullable) id<HNetworkSignature> signature;

/**
  是否允许该接口在上一次请求没结束之前继续发起新的请求，默认为NO
 */
@property (nonatomic, assign) BOOL allowMultiRequest;

/**
  当前接口是否显示请求错误提示，该参数在请求失败时会委托给HNetworkResponseHandler类或其子类处理，默认为YES
 */
@property (nonatomic, assign) BOOL showMessageEnable;

/**
 缓存协议
 */
@property (nonatomic, weak) id<HNetworkCacheManager> cacheManager;

/**
 缓存策略, 默认不使用缓存，每次都会从服务器获取新数据，目前只有GET请求方式可启用缓存，默认为Remote
 */
@property (nonatomic, assign) HNetworkCachePolicy cachePolicy;


/**
 发起请求之前会调用该函数

 @param request 组装好的请求
 @return 返回YES则会开始执行请求，返回NO则本次请求取消，默认YES
 */
- (BOOL)managerInterceptRequest:(NSURLRequest *)request;

/**
 当前接口请求成功会调用该函数

 @param model 服务端返回数据
 @return 返回YES将执行callResult回调，返回NO不执行，默认YES
 */
- (BOOL)managerInterceptResponseSuccess:(T)model;

/**
 当接口请求失败会调用该函数

 @param error 错误信息
 @return 返回YES将执行callResult回调，返回NO不执行，默认YES
 */
- (BOOL)managerInterceptResponseFailure:(NSError *)error;

/**
    发起请求
 */
- (void)fetch;

@end

NS_ASSUME_NONNULL_END
