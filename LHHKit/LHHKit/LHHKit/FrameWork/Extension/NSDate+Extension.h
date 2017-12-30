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


#import <Foundation/Foundation.h>

#pragma mark -

#define SECOND        (1)
#define MINUTE        (60 * SECOND)
#define HOUR          (60 * MINUTE)
#define DAY           (24 * HOUR)
#define MONTH         (30 * DAY)
#define YEAR          (12 * MONTH)
#define NOW           [NSDate date]

#pragma mark -

typedef NS_ENUM(NSUInteger, WeekdayType) {
    WeekdayType_Sunday = 1,
    WeekdayType_Monday,
    WeekdayType_Tuesday,
    WeekdayType_Wednesday,
    WeekdayType_Thursday,
    WeekdayType_Friday,
    WeekdayType_Saturday
    
};

#pragma mark -

@interface NSDate(Extension)
@property (nonatomic, readonly) NSInteger  year;
@property (nonatomic, readonly) NSInteger  month;
@property (nonatomic, readonly) NSInteger  day;
@property (nonatomic, readonly) NSInteger  hour;
@property (nonatomic, readonly) NSInteger  minute;
@property (nonatomic, readonly) NSInteger  second;
@property (nonatomic, readonly) WeekdayType weekday;

@property (nonatomic,copy,readonly) NSString *timestamp;
@property (nonatomic,assign,readonly) BOOL isThisYear;
@property (nonatomic,assign,readonly) BOOL isToday;
@property (nonatomic,assign,readonly) BOOL isYesToday;
@property (nonatomic,strong,readonly) NSDate * ymdDate;

+ (NSTimeInterval)unixTime;
+ (NSString *)unixDate;

+ (NSDate *)fromString:(NSString *)string;

+ (NSDateFormatter *)format;
+ (NSDateFormatter *)format:(NSString *)format;
+ (NSDateFormatter *)format:(NSString *)format timeZoneGMT:(NSInteger)hours;
+ (NSDateFormatter *)format:(NSString *)format timeZoneName:(NSString *)name;

- (NSString *)toString:(NSString *)format;
- (NSString *)toString:(NSString *)format timeZoneGMT:(NSInteger)hours;
- (NSString *)toString:(NSString *)format timeZoneName:(NSString *)name;


- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月

/**
 *  获取当前日期过指定天数后的日期
 *
 *
 *  @return 日期
 */
- (NSDate *)dayInTheFollowingDay:(int)day;

/**
 *  获取当前日期到指定日期之间有多少天
 *
 
 */
- (NSInteger)dayInTheFollowingDate:(NSDate *)endDate;

- (NSDateComponents *)YMDComponents;
- (NSDateComponents *)YMDHMComponents;
- (NSString *)currentDateForMatterYMD;
- (NSString *)currentDateForMatterMD;
- (NSString *)currentDateForMatterYMDHM;

- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSString *)stringFromDate;//NSDate转NSString

+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

- (NSInteger)getWeekIntValueWithDate;


//判断日期是今天,明天,后天,周几
- (NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+ (NSString *)getWeekStringFromInteger:(NSInteger)week;

- (NSDate *)nextDayInTheFollowwingDay:(NSInteger)type;
@end
