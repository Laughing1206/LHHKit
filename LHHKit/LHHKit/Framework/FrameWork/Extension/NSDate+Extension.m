//
//   ___           ___        ___      ___        ___
//  /\  \         /\  \      /\  \    /\  \      /\  \
//  \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//   \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//    \ \  \______  \ \  \     \ \  \   \ \  \     \ \  \
//     \ \________\  \ \__\     \ \__\   \ \__\     \ \__\
//      \/________/   \/__/      \/__/    \/__/      \/__/
//
//  欢欢为人民服务
//  有问题请联系我，http://www.jianshu.com/u/3c6ff28fdc63
//
// -----------------------------------------------------------------------------


#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSInteger)year
{
#ifdef __IPHONE_8_0
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
#else
    return [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self].year;
#endif
}

- (NSInteger)month
{
#ifdef __IPHONE_8_0
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].year;
#else
    return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self].month;
#endif
}

- (NSInteger)day
{
#ifdef __IPHONE_8_0
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].year;
#else
    return [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self].day;
#endif
}

- (NSInteger)hour
{
#ifdef __IPHONE_8_0
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].year;
#else
    return [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self].hour;
#endif
}

- (NSInteger)minute
{
#ifdef __IPHONE_8_0
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].year;
#else
    return [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self].minute;
#endif
}

- (NSInteger)second
{
#ifdef __IPHONE_8_0
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self].year;
#else
    return [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self].second;
#endif
}

- (WeekdayType)weekday
{
#ifdef __IPHONE_8_0
    return (WeekdayType)[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
#else
    return (WeekdayType)[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self].weekday;
#endif
}

/*
 *  时间戳
 */
- (NSString *)timestamp
{
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    
    return [timeString copy];
}

/*
 *  时间成分
 */
- (NSDateComponents *)components
{
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //定义成分
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:self];
}

/*
 *  是否是今年
 */
- (BOOL)isThisYear
{
    //取出给定时间的components
    NSDateComponents *dateComponents=self.components;
    
    //取出当前时间的components
    NSDateComponents *nowComponents=[NSDate date].components;
    
    //直接对比年成分是否一致即可
    BOOL res = dateComponents.year==nowComponents.year;
    
    return res;
}

/*
 *  是否是今天
 */
- (BOOL)isToday
{
    //差值为0天
    return [self calWithValue:0];
}

/*
 *  是否是昨天
 */
- (BOOL)isYesToday
{
    //差值为1天
    return [self calWithValue:1];
}


- (BOOL)calWithValue:(NSInteger)value
{
    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents=self.ymdDate.components;
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents=[NSDate date].ymdDate.components;
    
    //比较
    BOOL res=dateComponents.year==nowComponents.year && dateComponents.month==nowComponents.month && (dateComponents.day + value)==nowComponents.day;
    
    return res;
}

/*
 *  清空时分秒，保留年月日
 */
- (NSDate *)ymdDate
{
    //定义fmt
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    
    //设置格式:去除时分秒
    fmt.dateFormat=@"yyyy-MM-dd";
    
    //得到字符串格式的时间
    NSString *dateString=[fmt stringFromDate:self];
    
    //再转为date
    NSDate *date=[fmt dateFromString:dateString];
    
    return date;
}

+ (NSTimeInterval)unixTime
{
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)unixDate
{
    return [[NSDate date] toString:@"yyyy/MM/dd HH:mm:ss z"];
}

+ (NSDate *)fromString:(NSString *)string
{
    if ( nil == string || 0 == string.length )
        return nil;
    
    NSDate * date = [[NSDate format:@"yyyy/MM/dd HH:mm:ss z"] dateFromString:string];
    if ( nil == date )
    {
        date = [[NSDate format:@"yyyy-MM-dd HH:mm:ss z"] dateFromString:string];
        if ( nil == date )
        {
            date = [[NSDate format:@"yyyy-MM-dd HH:mm:ss"] dateFromString:string];
            if ( nil == date )
            {
                date = [[NSDate format:@"yyyy/MM/dd HH:mm:ss"] dateFromString:string];
            }
        }
    }
    
    return date;
}

+ (NSDateFormatter *)format
{
    return [self format:@"yyyy/MM/dd HH:mm:ss z"];
}

+ (NSDateFormatter *)format:(NSString *)format
{
    return [self format:format timeZoneGMT:[[NSTimeZone defaultTimeZone] secondsFromGMT]];
}

+ (NSDateFormatter *)format:(NSString *)format timeZoneGMT:(NSInteger)seconds
{
    static __strong NSMutableDictionary * __formatters = nil;
    
    if ( nil == __formatters )
    {
        __formatters = [[NSMutableDictionary alloc] init];
    }
    
    NSString * key = [NSString stringWithFormat:@"%@ %ld", format, (long)seconds];
    NSDateFormatter * formatter = [__formatters objectForKey:key];
    if ( nil == formatter )
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:seconds]];
        [__formatters setObject:formatter forKey:key];
    }
    
    return formatter;
}

+ (NSDateFormatter *)format:(NSString *)format timeZoneName:(NSString *)name
{
    static __strong NSMutableDictionary * __formatters = nil;
    
    if ( nil == __formatters )
    {
        __formatters = [[NSMutableDictionary alloc] init];
    }
    
    NSString * key = [NSString stringWithFormat:@"%@ %@", format, name];
    NSDateFormatter * formatter = [__formatters objectForKey:key];
    if ( nil == formatter )
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:name]];
        [__formatters setObject:formatter forKey:key];
    }
    
    return formatter;
}

- (NSString *)toString:(NSString *)format
{
    return [self toString:format timeZoneGMT:[[NSTimeZone defaultTimeZone] secondsFromGMT]];
}

- (NSString *)toString:(NSString *)format timeZoneGMT:(NSInteger)seconds
{
    return [[NSDate format:format timeZoneGMT:seconds] stringFromDate:self];
}

- (NSString *)toString:(NSString *)format timeZoneName:(NSString *)name
{
    return [[NSDate format:format timeZoneName:name] stringFromDate:self];
}


/*计算这个月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
    //    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}


//获取这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1;
        days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}



/*计算这个月的第一天是礼拜几*/
- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}



//计算这个月最开始的一天
- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}


- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

//上一个月
- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//下一个月
- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

// 获取当前日期之后的几个月
- (NSDate *)dayInTheFollowingMonth:(int)month
{
    static NSDateComponents *dateComponents = nil;
    
    if ( dateComponents == nil )
    {
        dateComponents = [[NSDateComponents alloc] init];
    }
    
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

// 获取当前日期之后的几个天
- (NSDate *)dayInTheFollowingDay:(int)day
{
    static NSDateComponents *dateComponents = nil;
    
    if ( dateComponents == nil )
    {
        dateComponents = [[NSDateComponents alloc] init];
    }
    
    dateComponents.day = day;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSInteger)dayInTheFollowingDate:(NSDate *)endDate
{
    //得到相差秒数
    NSTimeInterval time=[endDate timeIntervalSinceDate:self];
    
    NSInteger days = ((int)time)/(3600*24);
    
    return days;
}

// 获取根据传入数值得到当前日期之后或者是以前的一天
- (NSDate *)nextDayInTheFollowwingDay:(NSInteger)type
{
    static NSDateComponents *dateComponents = nil;
    
    if ( dateComponents == nil  )
    {
        dateComponents = [[NSDateComponents alloc] init];
    }
    
    int day = 0;
    
    if ( type == 0 )
    {
        day = 0;
    }
    else if ( type == 1 )
    {
        day = -1;
    }
    else
    {
        day = 1;
    }
    
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    
}

//获取年月日对象
- (NSDateComponents *)YMDComponents
{
    return [[NSCalendar currentCalendar] components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitWeekday fromDate:self];
}

// 获取年月日时分对象
- (NSDateComponents *)YMDHMComponents
{
    return [[NSCalendar currentCalendar] components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitHour|
            NSCalendarUnitMinute|
            NSCalendarUnitSecond fromDate:self];
}

// 时间格式化
- (NSString *)currentDateForMatterYMD
{
    //实例化一个NSDateFormatter对象
    static NSDateFormatter *dateFormatter = nil;
    
    if ( dateFormatter == nil )
    {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:self];
    return currentDateStr;
}

// 时间格式化
- (NSString *)currentDateForMatterYMDHM
{
    //实例化一个NSDateFormatter对象
    static NSDateFormatter *dateFormatter = nil;
    
    if ( dateFormatter == nil )
    {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:self];
    return currentDateStr;
}

// 时间格式化
- (NSString *)currentDateForMatterMD
{
    //实例化一个NSDateFormatter对象
    static NSDateFormatter *dateFormatter = nil;
    
    if ( dateFormatter == nil )
    {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:self];
    return currentDateStr;
}

//-----------------------------------------
//
//NSString转NSDate
- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//NSDate转NSString
- (NSString *)stringFromDate
{
    static NSDateFormatter *dateFormatter = nil;
    
    if ( !dateFormatter )
    {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return destDateString;
}


+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//日历控件对象
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:today toDate:beforday options:0];
    //    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    NSInteger day = [components day];//两个日历之间相差多少月//    NSInteger days = [components day];//两个之间相差几天
    return (int)day;
}


//周日是“1”，周一是“2”...
- (NSInteger)getWeekIntValueWithDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps= [calendar components:(NSCalendarUnitYear |
                                                   NSCalendarUnitMonth |
                                                   NSCalendarUnitDay |
                                                   NSCalendarUnitWeekday) fromDate:self];
    return [comps weekday];
}




//判断日期是今天,明天,后天,周几
- (NSString *)compareIfTodayWithDate
{
    //获取星期对应的数字
    NSInteger weekIntValue = [self getWeekIntValueWithDate];
    
    //直接返回当时日期的字符串(这里让它返回空)
    return [NSDate getWeekStringFromInteger:weekIntValue];//周几
}

//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(NSInteger)week
{
    NSString *str_week;
    
    switch (week) {
        case 1:
            str_week = @"周日";
            break;
        case 2:
            str_week = @"周一";
            break;
        case 3:
            str_week = @"周二";
            break;
        case 4:
            str_week = @"周三";
            break;
        case 5:
            str_week = @"周四";
            break;
        case 6:
            str_week = @"周五";
            break;
        case 7:
            str_week = @"周六";
            break;
    }
    return str_week;
}

@end
