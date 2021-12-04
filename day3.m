#import <Foundation/Foundation.h>

#import "day3.h"
#import "parsing.h"

bool OnesDominate(NSArray<NSString*>* lines, NSUInteger pos) {
  int ones = 0;
  for (id line in lines) {
    if ([line characterAtIndex:pos] == '1') {
      ++ones;
    }
  }

  return ones >= lines.count - ones;
}

NSArray<NSString*>* filterArray(NSArray<NSString*>* lines,
                                int (^block)(NSString* s)) {
  id result = [NSMutableArray arrayWithCapacity:lines.count / 2];
  for (NSString* line in lines) {
    if (block(line)) {
      [result addObject:line];
    }
  }
  return result;
}

NSUInteger day3part1(NSArray<NSString*>* lines) {
  NSUInteger gamma = 0;
  NSUInteger epsilon = 0;

  NSUInteger len = lines[0].length;
  for (NSUInteger pos = 0; pos < len; ++pos) {
    if (OnesDominate(lines, pos)) {
      gamma |= 1 << (len - 1 - pos);
    } else {
      epsilon |= 1 << (len - 1 - pos);
    }
  }
  return gamma * epsilon;
}

NSUInteger day3part2(NSArray<NSString*>* lines) {
  NSUInteger len = lines[0].length;

  NSArray<NSString*>* generator_lines = lines;
  for (NSUInteger pos = 0; pos < len; ++pos) {
    if (generator_lines.count == 1) {
      break;
    }
    bool ones = OnesDominate(generator_lines, pos);
    generator_lines = filterArray(generator_lines, ^(NSString* line) {
      return [line characterAtIndex:pos] == (ones ? '1' : '0');
    });
  }
  NSArray<NSString*>* scrubber_lines = lines;
  for (NSUInteger pos = 0; pos < len; ++pos) {
    if (scrubber_lines.count == 1) {
      break;
    }
    bool ones = OnesDominate(scrubber_lines, pos);
    scrubber_lines = filterArray(scrubber_lines, ^(NSString* line) {
      return [line characterAtIndex:pos] == (ones ? '0' : '1');
    });
  }

  NSUInteger generator = strtol([generator_lines[0] UTF8String], NULL, 2);
  NSUInteger scrubber = strtol([scrubber_lines[0] UTF8String], NULL, 2);
  return generator * scrubber;
}

int day3main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day3.txt"));
  NSLog(@"Part 1: %lu", day3part1(lines));
  NSLog(@"Part 2: %lu", day3part2(lines));
  return 0;
}
