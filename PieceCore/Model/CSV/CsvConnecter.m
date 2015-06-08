
#import "CsvConnecter.h"
#import "BuyListData.h"

@implementation CsvConnecter
-(void)sendActionWithUrl:(NSString *)url{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             // 通信に成功した場合の処理
             NSData *data = responseObject;
             NSString* str = [[NSString alloc] initWithData:data encoding:NSShiftJISStringEncoding];
             NSArray *lines = [str componentsSeparatedByString:@"\n"];
             
             if ([url isEqualToString:@"http://153.120.74.91/cgi-bin/business_support/manual/csv/buy.csv"]) {
                 NSMutableArray *result = [self setBuyListDataWithLines:lines];
                 [self.delegate receiveSucceedWithCsvData:result sendId:url];
             }
             
             
             DLog(@"responseObject: %@", str);
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [self.delegate receiveError:error sendId:url];
         }];
}

-(NSMutableArray *)setBuyListDataWithLines:(NSArray *)lines{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    bool isHeader = YES;
    for (NSString *row in lines) {
        if (isHeader) {
            isHeader = NO;
            continue;
        }
        NSString *afterRow = [row stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        BuyListData *data = [[BuyListData alloc]init];
        // コンマで区切って配列に格納する
        NSArray *items = [afterRow componentsSeparatedByString:@","];
        if (items.count < 6) {
            continue;
        }
        data.carria = items[0];
        data.maker = items[1];
        data.model = items[2];
        data.price = items[3];
        data.used_price = items[4];
        data.post_price = items[5];
        [resultArray addObject:data];
    }
    return resultArray;
}

@end
