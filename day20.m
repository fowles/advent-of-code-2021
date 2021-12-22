#import <Foundation/Foundation.h>

#import "day20.h"
#import "parsing.h"

@interface Pixel : NSObject <NSCopying>
@property(nonatomic, readwrite) int x;
@property(nonatomic, readwrite) int y;

+ (instancetype)x:(int)x y:(int)y;
- (Pixel*)copy;
- (Pixel*)copyWithZone:(NSZone*)zone;
@end

@implementation Pixel
+ (instancetype)x:(int)x y:(int)y {
  Pixel* p = [Pixel alloc];
  p.x = x;
  p.y = y;
  return p;
}

- (Pixel*)copy {
  return [Pixel x:self.x y:self.y];
}

- (Pixel*)copyWithZone:(NSZone*)zone {
  return [self copy];
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[self class]]) {
    Pixel* o = object;
    return self.x == o.x && self.y == o.y;
  }

  return NO;
}

- (NSUInteger)hash {
  NSUInteger result = 1;
  NSUInteger prime = 31;
  result = prime * result + self.x;
  result = prime * result + self.y;
  return result;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"%d,%d", self.x, self.y];
}
@end

@interface Image:NSObject {
  NSString* key;
  NSMutableSet<Pixel*>* pixels;
  char present;
  char missing;
}

+ (instancetype)parse:(NSString*)text;
- (char)x:(int)x y:(int)y;
- (int)regionAtX:(int)x y:(int)y;
- (Image*)enhance;
- (size_t)countPixels;
- (NSString*)description;
@end

@implementation Image
+ (instancetype)parse:(NSString*)text; {
  id parts = split(text, @"\n\n");

  id pixels = [NSMutableSet setWithCapacity:512];
  id lines = splitLines(parts[1]);
  for (int j = 0; j < [lines count]; ++j) {
    id line = lines[j];
    for (int i = 0; i < [line length]; ++i) {
      if ([line characterAtIndex:i] == '#') {
        [pixels addObject:[Pixel x:i y:j]];
      }
    }
  }

  Image* s = [Image alloc];
  s->key = [parts[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  s->present = '#';
  s->missing = '.';
  s->pixels = pixels;
  return s;
}

- (char)x:(int)x y:(int)y {
  return [pixels containsObject:[Pixel x:x y:y]] ? present : missing;
}

- (int)regionAtX:(int)x y:(int)y {
  int res = 0;
  for (int j = -1; j <= 1; ++j) {
    for (int i = -1; i <= 1; ++i) {
      res <<= 1;
      res |= [self x:x + i y:y + j] == '#' ? 1 : 0;
    }
  }
  return res;
}

- (char)enhanceX:(int)x y:(int)y {
  return [key characterAtIndex:[self regionAtX:x y:y]];
}

- (Image*)enhance {
  int min_x = INT_MAX;
  int max_x = INT_MIN;
  int min_y = INT_MAX;
  int max_y = INT_MIN;
  for (Pixel* p in pixels) {
    if (p.x < min_x) min_x = p.x;
    if (p.y < min_y) min_y = p.y;
    if (p.x > max_x) max_x = p.x;
    if (p.y > max_y) max_y = p.y;
  }

  Image* r = [Image alloc];
  r->pixels = [NSMutableSet setWithCapacity:512];
  r->key = key;
  r->missing = [self enhanceX:INT_MAX y:INT_MAX];
  r->present = r->missing == '#' ? '.' : '#';
  for (int i = min_x - 1; i <= max_x + 1; ++i) {
    for (int j = min_y - 1; j <= max_y + 1; ++j) {
      char c = [self enhanceX:i y:j];
      if (r->present == c) {
        [r->pixels addObject:[Pixel x:i y:j]];
      }
    }
  }
  return r;
}

- (size_t)countPixels {
  assert(missing == '.');
  return [pixels count];
}

- (NSString*)description {
  int min_x = INT_MAX;
  int max_x = INT_MIN;
  int min_y = INT_MAX;
  int max_y = INT_MIN;
  for (Pixel* p in pixels) {
    if (p.x < min_x) min_x = p.x;
    if (p.y < min_y) min_y = p.y;
    if (p.x > max_x) max_x = p.x;
    if (p.y > max_y) max_y = p.y;
  }
  NSString* s = @"Image:\n";
  for (int j = min_y; j <= max_y; ++j) {
    for (int i = min_y; i <= max_y; ++i) {
      Pixel* p = [Pixel x:i y:j];
      char c = [pixels containsObject:p] ? present : missing;
      s = [s stringByAppendingFormat:@"%c", c];
    }
    s = [s stringByAppendingString:@"\n"];
  }
  return s;
}
@end

size_t day20part1(Image* image) {
  image = [image enhance];
  image = [image enhance];
  return [image countPixels];
}

int day20part2() {
  return 0;
}

int day20main(int argc, const char** argv) {
  id raw = readFile(@"input/day20.txt");
  Image* image = [Image parse:raw];
  NSLog(@"Part 1: %zu", day20part1(image));
  NSLog(@"Part 2: %d", day20part2());
  return 0;
}
