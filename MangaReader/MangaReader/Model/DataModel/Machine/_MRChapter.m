// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MRChapter.m instead.

#import "_MRChapter.h"

const struct MRChapterAttributes MRChapterAttributes = {
	.index = @"index",
	.pageCount = @"pageCount",
	.path = @"path",
	.title = @"title",
};

const struct MRChapterRelationships MRChapterRelationships = {
	.pages = @"pages",
	.series = @"series",
};

const struct MRChapterFetchedProperties MRChapterFetchedProperties = {
};

@implementation MRChapterID
@end

@implementation _MRChapter

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MRChapter" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MRChapter";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MRChapter" inManagedObjectContext:moc_];
}

- (MRChapterID*)objectID {
	return (MRChapterID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pageCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pageCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic index;



- (int32_t)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int32_t)value_ {
	[self setIndex:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int32_t)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithInt:value_]];
}





@dynamic pageCount;



- (int32_t)pageCountValue {
	NSNumber *result = [self pageCount];
	return [result intValue];
}

- (void)setPageCountValue:(int32_t)value_ {
	[self setPageCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePageCountValue {
	NSNumber *result = [self primitivePageCount];
	return [result intValue];
}

- (void)setPrimitivePageCountValue:(int32_t)value_ {
	[self setPrimitivePageCount:[NSNumber numberWithInt:value_]];
}





@dynamic path;






@dynamic title;






@dynamic pages;

	
- (NSMutableSet*)pagesSet {
	[self willAccessValueForKey:@"pages"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"pages"];
  
	[self didAccessValueForKey:@"pages"];
	return result;
}
	

@dynamic series;

	






@end
