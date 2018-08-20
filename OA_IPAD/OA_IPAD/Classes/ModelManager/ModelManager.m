#import "ModelManager.h"

@implementation ModelManager

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedModelManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (NSMutableDictionary *)dict
{
    if(_dict == nil)
    {
        _dict = [NSMutableDictionary dictionaryWithCapacity:6];
        
        //向词典中动态添加数据
        [_dict setObject:@"" forKey:@"文号头"];         // 文号头
        [_dict setObject:@"" forKey:@"文号年"];         // 文号年
        
        [_dict setObject:@"" forKey:@"文号字"];         // 文号字
        [_dict setObject:@"" forKey:@"标题"];           // 标题
        
        [_dict setObject:@"" forKey:@"文种"];
        [_dict setObject:@"" forKey:@"拟稿人"];
    }
    
    return _dict;
}

- (void)setDictNull
{
    [self.dict setObject:@"" forKey:@"文号头"];         // 文号头
    [self.dict setObject:@"" forKey:@"文号年"];         // 文号年
    
    [self.dict setObject:@"" forKey:@"文号字"];         // 文号字
    [self.dict setObject:@"" forKey:@"标题"];           // 标题
    
    [self.dict setObject:@"" forKey:@"文种"];
    [self.dict setObject:@"" forKey:@"拟稿人"];
}

- (NSMutableDictionary *)receiveDict
{
    if(_receiveDict == nil)
    {
        _receiveDict = [NSMutableDictionary dictionaryWithCapacity:9];
        
        //向词典中动态添加数据
        [_receiveDict setObject:@"" forKey:@"流水号"];          // 收文流水号
        [_receiveDict setObject:@"" forKey:@"缓急"];           // 文件缓急
        
        [_receiveDict setObject:@"" forKey:@"文号头"];         // 文号头
        [_receiveDict setObject:@"" forKey:@"文号年"];         // 文号年
        
        [_receiveDict setObject:@"" forKey:@"文号数"];         // 文号数
        [_receiveDict setObject:@"" forKey:@"标题"];           // 标题
        
        [_receiveDict setObject:@"" forKey:@"来文单位"];        // 来文单位
        [_receiveDict setObject:@"" forKey:@"交办时间开始"];     // 交办时间(开始)
        [_receiveDict setObject:@"" forKey:@"交办时间结束"];     // 交办时间(结束)
    }
    
    return _receiveDict;
}

- (void)setReceiveDictNull
{
    [self.receiveDict setObject:@"" forKey:@"流水号"];          // 收文流水号
    [self.receiveDict setObject:@"" forKey:@"缓急"];           // 文件缓急
    
    [self.receiveDict setObject:@"" forKey:@"文号头"];         // 文号头
    [self.receiveDict setObject:@"" forKey:@"文号年"];         // 文号年
    
    [self.receiveDict setObject:@"" forKey:@"文号数"];         // 文号数
    [self.receiveDict setObject:@"" forKey:@"标题"];           // 标题
    
    [self.receiveDict setObject:@"" forKey:@"来文单位"];        // 来文单位
    [self.receiveDict setObject:@"" forKey:@"交办时间开始"];     // 交办时间(开始)
    [self.receiveDict setObject:@"" forKey:@"交办时间结束"];     // 交办时间(结束)
}

@end
