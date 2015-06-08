

#import "BuyListDao.h"

@implementation BuyListDao
- (FMDatabase *)getDb{
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    NSLog(@"%@",dir);
    return [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"otokomae.db"]];
}

-(bool)insertWithArray:(NSMutableArray *)array{
    FMDatabase *db = [self getDb];
    [db open];
    [db beginTransaction];
    
    bool isSuccess = YES;
    for (BuyListData *data in array) {
        
        if (![self insert:data db:db]) {
            isSuccess = NO;
            break;
        }
        
    }
    
    if( isSuccess ){
        [db commit];
    }else{
        [db rollback];
    }
    [db close];
    
    return isSuccess;
}

- (bool)insert:(BuyListData *)data db:(FMDatabase*)db{
    
    bool isClose = NO;
    if (db == nil) {
        db = [self getDb];
        [db open];
        isClose = YES;
    }
    
    
    NSMutableString *sql = [[NSMutableString alloc]init];
    [sql appendString:@"insert into BUY_LIST (carria,maker,model,price,used_price,post_price) VALUES (?,?,?,?,?,?)"];
    
    [db executeUpdate:sql,data.carria, data.maker,data.model,data.price,data.used_price,data.post_price];
    
    
    if (isClose) {
        [db close];
    }
    
    return ![db hadError];
}

- (bool)deleteAll{
    
    FMDatabase *db = [self getDb];
    NSString*   sql = @"DELETE FROM BUY_LIST";
    
    [db open];
    [db executeUpdate:sql];
    [db close];
    
    return ![db hadError];
}

- (NSMutableArray *)selectAll{
    FMDatabase *db = [self getDb];
    NSString *sql = @"SELECT * FROM BUY_LIST where price != 0";
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    BuyListData *data;
    NSMutableArray *dataList = [NSMutableArray array];
    while( [results next] )
    {
        data = [[BuyListData alloc]init];
        data.carria = [results stringForColumn:@"carria"];
        data.maker = [results stringForColumn:@"maker"];
        data.model = [results stringForColumn:@"model"];
        data.price = [results stringForColumn:@"price"];
        data.used_price = [results stringForColumn:@"used_price"];
        data.post_price = [results stringForColumn:@"post_price"];
        
        [dataList addObject:data];
        
    }
    [db close];
    return dataList;
}

- (NSMutableArray *)selectCarria{
    FMDatabase *db = [self getDb];
    NSString *sql = @"select carria from BUY_LIST where price != 0 group by carria";
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    
    NSMutableArray *dataList = [NSMutableArray array];
    while( [results next] )
    {
        [dataList addObject:[results stringForColumn:@"carria"]];
    }
    [db close];
    return dataList;
}

- (NSMutableArray *)selectMaker{
    FMDatabase *db = [self getDb];
    NSString *sql = @"select maker from BUY_LIST where price != 0 group by maker ";
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    
    NSMutableArray *dataList = [NSMutableArray array];
    while( [results next] )
    {
        [dataList addObject:[results stringForColumn:@"maker"]];
    }
    [db close];
    return dataList;
}

- (NSMutableArray *)selectWithData:(BuyListData *)data{
    FMDatabase *db = [self getDb];
    NSString *sql = @"select * from BUY_LIST where model like ? and (carria = ? or ? IS NULL) and (maker = ? or ? IS NULL) and price != 0";
    [db open];
    NSString *model = [NSString stringWithFormat:@"%@%@%@", @"%%", data.model, @"%%"];
    FMResultSet *results = [db executeQuery:sql,model, data.carria, data.carria, data.maker, data.maker];
    
    
    NSMutableArray *dataList = [NSMutableArray array];
    while( [results next] )
    {
        data = [[BuyListData alloc]init];
        data.carria = [results stringForColumn:@"carria"];
        data.maker = [results stringForColumn:@"maker"];
        data.model = [results stringForColumn:@"model"];
        data.price = [results stringForColumn:@"price"];
        data.used_price = [results stringForColumn:@"used_price"];
        data.post_price = [results stringForColumn:@"post_price"];
        
        [dataList addObject:data];
    }
    [db close];
    return dataList;
}
@end
