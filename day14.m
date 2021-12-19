#import <Foundation/Foundation.h>

#import "day14.h"
#import "parsing.h"

NSString* GrowTemplate(NSString* template,
                       NSDictionary<NSString*, NSString*>* replacement) {
  NSMutableString* res =
      [NSMutableString stringWithCapacity:2 * template.length];
  for (size_t i = 0; i < template.length - 1; ++i) {
    id pair = [template substringWithRange:NSMakeRange(i, 2)];
    [res appendFormat:@"%c", [pair characterAtIndex: 0]];
    [res appendFormat:@"%c", [replacement[pair] characterAtIndex:0]];
  }
  [res appendFormat:@"%c", [template characterAtIndex:template.length - 1]];
  return res;
}

int GrowAndCount(int steps, NSString* template,
               NSDictionary<NSString*, NSString*>* replacements) {
  for (int i = 0; i < steps; ++i) {
    template = GrowTemplate(template, replacements);
  }

  int counts[26] = {};
  for (size_t i = 0; i < template.length; ++i) {
    ++counts[[template characterAtIndex: i] - 'A'];
  }

  int min_pos = 0;
  int max_pos = 0;
  for (int i = 0; i < 26; ++i) {
    if (counts[i] > counts[max_pos]) max_pos = i;
    if (counts[i] != 0) {
      if (counts[i] < counts[min_pos] || counts[min_pos] == 0)
        min_pos = i;
    }
  }
  return counts[max_pos] - counts[min_pos];
}

int day14part1(NSString* template,
               NSDictionary<NSString*, NSString*>* replacement) {
  return GrowAndCount(10, template, replacement);
}

int day14part2(NSString* template,
               NSDictionary<NSString*, NSString*>* replacement) {
  return GrowAndCount(0, template, replacement);
}

int day14main(int argc, const char** argv) {
  id parts = split(readFile(@"input/day14.txt"), @"\n\n");
  id template = splitLines(parts[0])[0];
  id rules =
      parseLines(splitLines(parts[1]),
                 [NSRegularExpression regularExpressionWithPattern:@"(..) -> (.)"
                                                           options:0
                                                             error:NULL]);
  NSMutableDictionary<NSString*, NSString*>* replacements =
      [NSMutableDictionary dictionaryWithCapacity:[rules count]];
  for (id rule in rules) {
    replacements[rule[0]] = rule[1];
  }

  NSLog(@"Part 1: %d", day14part1(template, replacements));
  NSLog(@"Part 2: %d", day14part2(template, replacements));
  return 0;
}
