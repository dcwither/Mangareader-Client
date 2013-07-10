// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MRPage.m instead.

#import "_MRPage.h"

const struct MRPageAttributes MRPageAttributes = {
	.image = @"image",
	.index = @"index",
	.url = @"url",
};

const struct MRPageRelationships MRPageRelationships = {
	.chapter = @"chapter",
};

const struct MRPageFetchedProperties MRPageFetchedProperties = {
};

@implementation MRPageID
@end

@implementation _MRPage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MRPage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MRPage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MRPage" inManagedObjectContext:moc_];
}

- (MRPageID*)objectID {
	return (MRPageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic image;






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





@dynamic url;






@dynamic chapter;

	






@end
