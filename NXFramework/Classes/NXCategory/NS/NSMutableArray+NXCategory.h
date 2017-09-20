//
//  NSMutableArray+Moving.h
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NXCategory)

/**
 Moves the object at the specified indexes to the new location.

 @param indexes The indexes of the objects to move.
 @param idx The index in the mutable array at which to insert the objects.
 */
- (void)nx_moveObjectsAtIndexes:(NSIndexSet *)indexes toIndex:(NSUInteger)idx;

/**
 Inserts a given object at the end of the array.
 
 @param anObject The object to add to the end of the array’s content. This value must not be nil.
 */
- (void)nx_addObject:(id)anObject;

/**
 Inserts a given object into the array’s contents at a given index.
 
 @param anObject The object to add to the array's content. This value must not be nil.
 @param index The index in the mutable array at which to insert the objects.
 */
- (void)nx_insertObject:(id)anObject atIndex:(NSUInteger)index;

/**
 Removes the object at index.
 
 @param index The index from which to remove the object in the array. The value must not exceed the bounds of the array.
 */
- (void)nx_removeObjectAtIndex:(NSUInteger)index;

/**
 Replaces the object at index with anObject.
 
 @param index The index of the object to be replaced. This value must not exceed the bounds of the array.
 @param anObject The object with which to replace the object at index index in the array. This value must not be nil.
 */
- (void)nx_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

/**
 Returns the object located at the specified index.
 
 @param index An index within the bounds of the array.
 */
- (id)nx_objectAtIndex:(NSUInteger)index;

@end
