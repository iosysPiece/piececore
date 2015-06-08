

#import "DBManager.h"

@implementation DBManager
-(void)createDB{
    bool stat = YES;
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"otokomae.db"]];
    [db open];
    [db beginTransaction];
    NSMutableString *sqlByList = [[NSMutableString alloc]init];
    [sqlByList appendString:@"CREATE TABLE IF NOT EXISTS BUY_LIST ("];
    [sqlByList appendString:@"id INTEGER PRIMARY KEY AUTOINCREMENT,"];
    [sqlByList appendString:@"carria TEXT,"];
    [sqlByList appendString:@"maker TEXT,"];
    [sqlByList appendString:@"model TEXT,"];
    [sqlByList appendString:@"price TEXT,"];
    [sqlByList appendString:@"used_price TEXT,"];
    [sqlByList appendString:@"post_price TEXT"];
    [sqlByList appendString:@");"];
    
    if(![db executeUpdate:sqlByList]){
        stat = false;
    }    if( stat ){
        [db commit];
    }else{
        [db rollback];
    }
    [db close];
    
}

@end

