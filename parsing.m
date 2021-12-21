#import <Foundation/Foundation.h>

#import "parsing.h"

NSString* readFile(NSString* path) {
  return [[NSString stringWithContentsOfFile:path
                                    encoding:NSUTF8StringEncoding
                                       error:NULL]
      stringByTrimmingCharactersInSet:NSCharacterSet
                                          .whitespaceAndNewlineCharacterSet];
}

NSArray<NSString*>* split(NSString* unsplit, NSString* sep) {
  return [unsplit componentsSeparatedByString:sep];
}

NSArray<NSString*>* splitLines(NSString* unsplit) {
  return split(unsplit, @"\n");
}

NSArray<NSString*>* parseLine(NSString* line, NSRegularExpression* regex) {
  NSArray<NSTextCheckingResult*>* matches =
      [regex matchesInString:line options:0 range:NSMakeRange(0, line.length)];
  id m = [NSMutableArray arrayWithCapacity:[regex numberOfCaptureGroups]];
  for (NSTextCheckingResult* match in matches) {
    NSUInteger num_ranges = match.numberOfRanges;
    for (NSUInteger i = 1; i < num_ranges; ++i) {
      NSRange r = [match rangeAtIndex:i];
      [m addObject:[line substringWithRange:r]];
    }
  }
  return m;
}

NSArray<NSArray<NSString*>*>* parseLines(NSArray<NSString*>* lines,
                                         NSRegularExpression* regex) {
  id result = [NSMutableArray arrayWithCapacity:lines.count];
  for (NSString* line in lines) {
    [result addObject:parseLine(line, regex)];
  }
  return result;
}

NSArray<id>* parseObjects(NSArray<NSArray<NSString*>*>* lines,
                          id (^block)(NSArray<NSString*>*)) {
  id result = [NSMutableArray arrayWithCapacity:lines.count];
  for (id line in lines) {
    [result addObject:block(line)];
  }
  return result;
}
