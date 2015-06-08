
#import "NetworkConecter.h"

@protocol CsvConnecterDelegate
-(void)receiveSucceedWithCsvData:(NSMutableArray *)array sendId:(NSString *)sendId;
@end

@interface CsvConnecter : NetworkConecter
-(void)sendActionWithUrl:(NSString *)url;
@end



