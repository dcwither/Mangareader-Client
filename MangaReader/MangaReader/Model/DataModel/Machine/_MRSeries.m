// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MRSeries.m instead.

#import "_MRSeries.h"

const struct MRSeriesAttributes MRSeriesAttributes = {
	.name = @"name",
	.path = @"path",
};

const struct MRSeriesRelationships MRSeriesRelationships = {
	.chapters = @"chapters",
};

const struct MRSeriesFetchedProperties MRSeriesFetchedProperties = {
};

@implementation MRSeriesID
@end

@implementation _MRSeries

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MRSeries" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MRSeries";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MRSeries" inManagedObjectContext:moc_];
}

- (MRSeriesID*)objectID {
	return (MRSeriesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic path;






@dynamic chapters;

	
- (NSMutableSet*)chaptersSet {
	[self willAccessValueForKey:@"chapters"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"chapters"];
  
	[self didAccessValueForKey:@"chapters"];
	return result;
}
	






@end
