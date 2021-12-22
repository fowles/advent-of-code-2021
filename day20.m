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
  bool pixels[10000][10000];
  char present;
  char missing;
  int min_x;
  int max_x;
  int min_y;
  int max_y;
}

+ (instancetype)parse:(NSString*)text;
- (void)setX:(int)x Y:(int)y;
- (char)getX:(int)x Y:(int)y;
- (int)regionAtX:(int)x y:(int)y;
- (Image*)enhance;
- (size_t)countPixels;
- (NSString*)description;
@end

@implementation Image
+ (instancetype)parse:(NSString*)text; {
  id parts = split(text, @"\n\n");

  id lines = splitLines(parts[1]);

  Image* s = [Image alloc];
  s->key = [parts[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  s->present = '#';
  s->missing = '.';
  for (int j = 0; j < [lines count]; ++j) {
    id line = lines[j];
    for (int i = 0; i < [line length]; ++i) {
      if ([line characterAtIndex:i] == '#') {
        [s setX:i Y:j];
      }
    }
  }
  return s;
}

- (void)setX:(int)x Y:(int)y {
  if (x < min_x) min_x = x;
  if (x > max_x) max_x = x;
  if (y < min_y) min_y = y;
  if (y > max_y) max_y = y;
  pixels[5000 + x][5000+y] = true;
}
- (char)getX:(int)x Y:(int)y {
  return pixels[5000 + x][5000+y] ? present : missing;
}

- (int)regionAtX:(int)x y:(int)y {
  int res = 0;
  for (int j = -1; j <= 1; ++j) {
    for (int i = -1; i <= 1; ++i) {
      res <<= 1;
      res |= [self getX:x + i Y:y + j] == '#' ? 1 : 0;
    }
  }
  return res;
}

- (char)enhanceX:(int)x y:(int)y {
  return [key characterAtIndex:[self regionAtX:x y:y]];
}

- (Image*)enhance {
  Image* r = [Image alloc];
  r->min_x = min_x;
  r->max_x = max_x;
  r->min_y = min_y;
  r->max_y = max_y;
  r->key = key;
  if (missing == '.') {
    r->missing = [key characterAtIndex:0];
  } else {
    r->missing = [key characterAtIndex:511];
  }
  r->present = r->missing == '#' ? '.' : '#';
  for (int i = min_x - 1; i <= max_x + 1; ++i) {
    for (int j = min_y - 1; j <= max_y + 1; ++j) {
      char c = [self enhanceX:i y:j];
      if (r->present == c) {
        [r setX:i Y:j];
      }
    }
  }
  return r;
}

- (size_t)countPixels {
  assert(missing == '.');
  size_t res = 0;
  for (int i = min_x - 1; i <= max_x + 1; ++i) {
    for (int j = min_y - 1; j <= max_y + 1; ++j) {
      if ([self getX:i Y:j] == '#') {
        ++res;
      }
    }
  }
  return res;
}

- (NSString*)description {
  NSString* s = @"Image:\n";
  for (int j = min_y; j <= max_y; ++j) {
    for (int i = min_y; i <= max_y; ++i) {
      char c = [self getX:i Y:j];
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

size_t day20part2(Image* image) {
  for (int i = 0; i < 50; ++i) {
    image = [image enhance];
  }
  return [image countPixels];
}

int day20main(int argc, const char** argv) {
  id raw = readFile(@"input/day20.txt");
  Image* image = [Image parse:raw];
  NSLog(@"Part 1: %zu", day20part1(image));
  NSLog(@"Part 2: %zu", day20part2(image));
  return 0;
}
