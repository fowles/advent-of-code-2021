#import <Foundation/Foundation.h>

#import "parsing.h"

NSString* readFile(NSString* path) {
  return [[NSString stringWithContentsOfFile:path
                                    encoding:NSUTF8StringEncoding
                                       error:NULL]
      stringByTrimmingCharactersInSet:NSCharacterSet
                                          .whitespaceAndNewlineCharacterSet];
}

NSArray<NSString*>* splitLines(NSString* s) {
  return [s componentsSeparatedByString:@"\n"];
}

NSArray<NSArray<NSString*>*>* parseLines(NSArray<NSString*>* lines,
                                         NSRegularExpression* regex) {
  id result = [NSMutableArray arrayWithCapacity:lines.count];
  for (NSString* line in lines) {
    NSArray<NSTextCheckingResult*>* matches =
        [regex matchesInString:line
                       options:0
                         range:NSMakeRange(0, line.length)];
    if (matches.count != 1) {
      [NSException raise:@"Parse error" format:@"line %@ with %@", line, regex];
    }
    for (NSTextCheckingResult* match in matches) {
      NSUInteger num_ranges = match.numberOfRanges;
      id m = [NSMutableArray arrayWithCapacity:num_ranges];
      for (NSUInteger i = 1; i < num_ranges; ++i) {
        NSRange r = [match rangeAtIndex:i];
        [m addObject:[line substringWithRange:r]];
      }
      [result addObject:m];
    }
  }
  return result;
}
