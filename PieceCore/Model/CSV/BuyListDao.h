
#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "BuyListData.h"

@interface BuyListDao : NSObject
- (FMDatabase *)getDb;
-(bool)insertWithArray:(NSMutableArray *)array;
- (bool)insert:(BuyListData *)data db:(FMDatabase*)db;
- (NSMutableArray *)selectAll;
- (bool)deleteAll;
- (NSMutableArray *)selectCarria;
- (NSMutableArray *)selectMaker;
- (NSMutableArray *)selectWithData:(BuyListData *)data;
@end