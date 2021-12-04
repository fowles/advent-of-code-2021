//
//  main.m
//  aoc-2021
//
//  Created by Beaker Kulukundis on 12/3/21.
//

#import <Foundation/Foundation.h>

NSString* readFile(NSString* path) {
  return [[NSString stringWithContentsOfFile:@"input/day1.txt"
                                    encoding:NSUTF8StringEncoding
                                       error:NULL]
      stringByTrimmingCharactersInSet:NSCharacterSet
                                          .whitespaceAndNewlineCharacterSet];
}

NSArray *splitLines(NSString *s) { return [s componentsSeparatedByString:@"\n"]; }

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    id lines = splitLines(readFile(@"input/day1.txt"));
    id iter = [lines objectEnumerator];

    NSString* last = [iter nextObject];
    NSString* next;
    int increasing = 0;
    while (next = [iter nextObject]) {
      if (last.intValue < next.intValue) {
        ++increasing;
      }
      last = next;
    }

    NSLog(@"%d", increasing);
  }
  return 0;
}
