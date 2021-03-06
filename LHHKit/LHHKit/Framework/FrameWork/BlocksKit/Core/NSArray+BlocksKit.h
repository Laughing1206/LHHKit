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
#import <CoreGraphics/CGBase.h>

/** Block extensions for NSArray.

 Both inspired by and resembling Smalltalk syntax, these utilities
 allows for iteration of an array in a concise way that
 saves quite a bit of boilerplate code for filtering or finding
 objects or an object.

 Includes code by the following:

- [Robin Lu](https://github.com/robin)
- [Michael Ash](https://github.com/mikeash)
- [Aleks Nesterow](https://github.com/nesterow)
- [Zach Waldowski](https://github.com/zwaldowski)

 @see NSDictionary(BlocksKit)
 @see NSSet(BlocksKit)
 */
@interface NSArray (BlocksKit)

/** Loops through an array and executes the given block with each object.

  block A single-argument, void-returning code block.
 */
- (void)bk_each:(void (^)(id obj))block;

/** Enumerates through an array concurrently and executes
 the given block once for each object.

 Enumeration will occur on appropriate background queues. This
 will have a noticeable speed increase, especially on dual-core
 devices, but you *must* be aware of the thread safety of the
 objects you message from within the block. Be aware that the
 order of objects is not necessarily the order each block will
 be called in.

  block A single-argument, void-returning code block.
 */
- (void)bk_apply:(void (^)(id obj))block;

/** Loops through an array to find the object matching the block.

 bk_match: is functionally identical to bk_select:, but will stop and return
 on the first match.

  block A single-argument, `BOOL`-returning code block.
 @return Returns the object, if found, or `nil`.
 @see bk_select:
 */
- (id)bk_match:(BOOL (^)(id obj))block;

/** Loops through an array to find the objects matching the block.

  block A single-argument, BOOL-returning code block.
 @return Returns an array of the objects found.
 @see bk_match:
 */
- (NSArray *)bk_select:(BOOL (^)(id obj))block;

/** Loops through an array to find the objects not matching the block.

 This selector performs *literally* the exact same function as bk_select: but in reverse.

 This is useful, as one may expect, for removing objects from an array.
	 NSArray *new = [computers bk_reject:^BOOL(id obj) {
	   return ([obj isUgly]);
	 }];

  block A single-argument, BOOL-returning code block.
 @return Returns an array of all objects not found.
 */
- (NSArray *)bk_reject:(BOOL (^)(id obj))block;

/** Call the block once for each object and create an array of the return values.

 This is sometimes referred to as a transform, mutating one of each object:
	 NSArray *new = [stringArray bk_map:^id(id obj) {
	   return [obj stringByAppendingString:@".png"]);
	 }];

  block A single-argument, object-returning code block.
 @return Returns an array of the objects returned by the block.
 */
- (NSArray *)bk_map:(id (^)(id obj))block;

/** Arbitrarily accumulate objects using a block.

 The concept of this selector is difficult to illustrate in words. The sum can
 be any NSObject, including (but not limited to) a string, number, or value.

 For example, you can concentate the strings in an array:
	 NSString *concentrated = [stringArray bk_reduce:@"" withBlock:^id(id sum, id obj) {
	   return [sum stringByAppendingString:obj];
	 }];

 You can also do something like summing the lengths of strings in an array:
	 NSUInteger value = [[[stringArray bk_reduce:nil withBlock:^id(id sum, id obj) {
	   return @([sum integerValue] + obj.length);
	 }]] unsignedIntegerValue];

  initial The value of the reduction at its start.
  block A block that takes the current sum and the next object to return the new sum.
 @return An accumulated value.
 */
- (id)bk_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block;

/**
 Sometimes we just want to loop an objects list and reduce one property, where
 each result is a primitive type.

 For example, say we want to calculate the total age of a list of people.

 Code without using block will be something like:

	 NSArray *peoples = @[p1, p2, p3];
	 NSInteger totalAge = 0;
	 for (People *people in peoples) {
	     totalAge += [people age];
	 }

 We can use a block to make it simpler:

	 NSArray *peoples = @[p1, p2, p3];
	 NSInteger totalAge = [peoples reduceInteger:0 withBlock:^(NSInteger result, id obj, NSInteger index) {
	 	 return result + [obj age];
	 }];

 */
- (NSInteger)bk_reduceInteger:(NSInteger)initial withBlock:(NSInteger(^)(NSInteger result, id obj))block;

/**
 Sometimes we just want to loop an objects list and reduce one property, where
 each result is a primitive type.
 
 For instance, say we want to caculate the total balance from a list of people.
 
 Code without using a block will be something like:
 
	 NSArray *peoples = @[p1, p2, p3];
	 CGFloat totalBalance = 0;
	 for (People *people in peoples) {
	     totalBalance += [people balance];
	 }
 
 We can use a block to make it simpler:
 
	 NSArray *peoples = @[p1, p2, p3];
	 CGFloat totalBalance = [peoples reduceFloat:.0f WithBlock:^CGFloat(CGFloat result, id obj, NSInteger index) {
	 	 return result + [obj balance];
	 }];

 */

- (CGFloat)bk_reduceFloat:(CGFloat)inital withBlock:(CGFloat(^)(CGFloat result, id obj))block;

/** Loops through an array to find whether any object matches the block.

 This method is similar to the Scala list `exists`. It is functionally
 identical to bk_match: but returns a `BOOL` instead. It is not recommended
 to use bk_any: as a check condition before executing bk_match:, since it would
 require two loops through the array.

 For example, you can find if a string in an array starts with a certain letter:

	 NSString *letter = @"A";
	 BOOL containsLetter = [stringArray bk_any:^(id obj) {
	   return [obj hasPrefix:@"A"];
	 }];

  block A single-argument, BOOL-returning code block.
 @return YES for the first time the block returns YES for an object, NO otherwise.
 */
- (BOOL)bk_any:(BOOL (^)(id obj))block;

/** Loops through an array to find whether no objects match the block.

 This selector performs *literally* the exact same function as bk_all: but in reverse.

  block A single-argument, BOOL-returning code block.
 @return YES if the block returns NO for all objects in the array, NO otherwise.
 */
- (BOOL)bk_none:(BOOL (^)(id obj))block;

/** Loops through an array to find whether all objects match the block.

  block A single-argument, BOOL-returning code block.
 @return YES if the block returns YES for all objects in the array, NO otherwise.
 */
- (BOOL)bk_all:(BOOL (^)(id obj))block;

/** Tests whether every element of this array relates to the corresponding element of another array according to match by block.

 For example, finding if a list of numbers corresponds to their sequenced string values;
 NSArray *numbers = @[ @(1), @(2), @(3) ];
 NSArray *letters = @[ @"1", @"2", @"3" ];
 BOOL doesCorrespond = [numbers bk_corresponds:letters withBlock:^(id number, id letter) {
	return [[number stringValue] isEqualToString:letter];
 }];

  list An array of objects to compare with.
  block A two-argument, BOOL-returning code block.
 @return Returns a BOOL, true if every element of array relates to corresponding element in another array.
 */
- (BOOL)bk_corresponds:(NSArray *)list withBlock:(BOOL (^)(id obj1, id obj2))block;

@end
