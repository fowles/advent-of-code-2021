#import <Foundation/Foundation.h>

#import "day24.h"
#import "parsing.h"

static const char* k_inp = "inp";
static const char* k_add = "add";
static const char* k_mul = "mul";
static const char* k_div = "div";
static const char* k_mod = "mod";
static const char* k_eql = "eql";

@interface Expr:NSObject {
  @public int64_t val;
  @public int input_num;
  @public const char* op;
  @public Expr* lhs;
  @public Expr* rhs;
}

+ (instancetype)literal:(int)n;
+ (instancetype)inp:(int)n;
+ (instancetype)add:(Expr*)lhs rhs:(Expr*)rhs;
+ (instancetype)mul:(Expr*)lhs rhs:(Expr*)rhs;
+ (instancetype)div:(Expr*)lhs rhs:(Expr*)rhs;
+ (instancetype)mod:(Expr*)lhs rhs:(Expr*)rhs;
+ (instancetype)eql:(Expr*)lhs rhs:(Expr*)rhs;
- (NSString*)describe:(int)depth;
- (int64_t)eval:(int*)input;
@end

@implementation Expr
+ (instancetype)literal:(int)n {
  Expr* e = [Expr alloc];
  e->val = n;
  e->input_num = -1;
  return e;
}

+ (instancetype)inp:(int)n {
  Expr* e = [Expr alloc];
  e->op = k_inp;
  e->input_num = n;
  return e;
}

+ (instancetype)add:(Expr*)lhs rhs:(Expr*)rhs {
  Expr* e = [Expr alloc];
  e->input_num = -1;
  if (lhs->op == nil && rhs->op == nil) {
    e->val = lhs->val + rhs->val;
  } else if (lhs->op == nil && lhs->val == 0) {
    return rhs;
  } else if (rhs->op == nil && rhs->val == 0) {
    return lhs;
  } else {
    e->op = k_add;
    e->lhs = lhs;
    e->rhs = rhs;
  }
  return e;
}

+ (instancetype)mul:(Expr*)lhs rhs:(Expr*)rhs {
  Expr* e = [Expr alloc];
  e->input_num = -1;
  if (lhs->op == nil && rhs->op == nil) {
    e->val = lhs->val * rhs->val;
  } else if (lhs->op == nil && lhs->val == 0) {
    e->val = 0;
  } else if (rhs->op == nil && rhs->val == 0) {
    e->val = 0;
  } else if (lhs->op == nil && lhs->val == 1) {
    return rhs;
  } else if (rhs->op == nil && rhs->val == 1) {
    return lhs;
  } else {
    e->op = k_mul;
    e->lhs = lhs;
    e->rhs = rhs;
  }
  return e;
}

+ (instancetype)div:(Expr*)lhs rhs:(Expr*)rhs {
  Expr* e = [Expr alloc];
  e->input_num = -1;
  if (lhs->op == nil && rhs->op == nil) {
    e->val = lhs->val / rhs->val;
  } else if (lhs->op == nil && lhs->val == 0) {
    return lhs;
  } else if (rhs->op == nil && rhs->val == 1) {
    return lhs;
  } else {
    e->op = k_div;
    e->lhs = lhs;
    e->rhs = rhs;
  }
  return e;
}

+ (instancetype)mod:(Expr*)lhs rhs:(Expr*)rhs {
  Expr* e = [Expr alloc];
  e->input_num = -1;
  if (lhs->op == nil && rhs->op == nil) {
    e->val = lhs->val % rhs->val;
  } else if (rhs->op == nil && rhs->val == 1) {
    e->val = 0;
  } else {
    e->op = k_mod;
    e->lhs = lhs;
    e->rhs = rhs;
  }
  return e;
}

+ (instancetype)eql:(Expr*)lhs rhs:(Expr*)rhs {
  Expr* e = [Expr alloc];
  e->input_num = -1;
  if (lhs->op == nil && rhs->op == nil) {
    e->val = (bool)(lhs->val == rhs->val);
    return e;
  }
  if (lhs->op == nil) {
    if (rhs->input_num >= 0) {
      if (lhs->val < 0 || 9 < lhs->val) {
        return [Expr literal:0];
      }
    }
  }
  if (rhs->op == nil) {
    if (lhs->input_num >= 0) {
      if (rhs->val < 0 || 9 < rhs->val) {
        return [Expr literal:0];
      }
    }
  }

  e->op = k_eql;
  e->lhs = lhs;
  e->rhs = rhs;
  return e;
}

- (NSString*)description {
  return [self describe: 0];
}

- (NSString*)describe:(int)depth {
  if (input_num >= 0) {
    return [NSString stringWithFormat:@"inp[%d]", input_num];
  }
  if (op == nil) {
    return [NSString stringWithFormat:@"%lld", val];
  }
  if (depth > 8) {
    return @"...";
  }
  return [NSString stringWithFormat:@"%s(%@, %@)", op, [lhs describe:depth + 1],
                                    [rhs describe:depth + 1]];
}

- (int64_t)eval:(int*)input {
  if (input_num >= 0) {
    return input[input_num];
  }
  int64_t l = [lhs eval:input];
  int64_t r = [rhs eval:input];
  if (op == k_add) return l + r;
  if (op == k_mul) return l * r;
  if (op == k_div) return l / r;
  if (op == k_mod) return l % r;
  if (op == k_eql) return (bool)(l == r);
  return val;
}
@end

typedef struct {
  Expr* w;
  Expr* x;
  Expr* y;
  Expr* z;
} Symbols;

Expr* get(Symbols* symbols, NSString* sym) {
  switch ([sym characterAtIndex:0]) {
  case 'w': return symbols->w;
  case 'x': return symbols->x;
  case 'y': return symbols->y;
  case 'z': return symbols->z;
  default:  return [Expr literal:[sym intValue]];
  }
}

void set(Symbols* symbols, NSString* sym, Expr* e) {
  switch ([sym characterAtIndex:0]) {
  case 'w': symbols->w = e; break;
  case 'x': symbols->x = e; break;
  case 'y': symbols->y = e; break;
  case 'z': symbols->z = e; break;
  }
}

Expr* parseExpr(NSArray<NSString*>* lines) {
  int pos = 0;
  Symbols symbols;
  symbols.w = [Expr literal:0];
  symbols.x = [Expr literal:0];
  symbols.y = [Expr literal:0];
  symbols.z = [Expr literal:0];
  for (id line in lines) {
    id parts = split(line, @" ");
    if ([parts[0] isEqualToString:@"inp"]) {
      set(&symbols, parts[1], [Expr inp:pos++]);
    } else {
      Expr* lhs = get(&symbols, parts[1]);
      Expr* rhs = get(&symbols, parts[2]);
      Expr* res;
      if ([parts[0] isEqualToString:@"add"]) {
        res = [Expr add:lhs rhs:rhs];
      } else if ([parts[0] isEqualToString:@"mul"]) {
        res = [Expr mul:lhs rhs:rhs];
      } else if ([parts[0] isEqualToString:@"div"]) {
        res = [Expr div:lhs rhs:rhs];
      } else if ([parts[0] isEqualToString:@"mod"]) {
        res = [Expr mod:lhs rhs:rhs];
      } else if ([parts[0] isEqualToString:@"eql"]) {
        res = [Expr eql:lhs rhs:rhs];
      }
      set(&symbols, parts[1], res);
    }
  }
  return symbols.z;
}

typedef struct {
  id magic;
  id lines;
  id widgets[14];
} Info;

Expr* parsePair(Info* info, int w0, int w1) {
  return parseExpr(
      [info->widgets[w0] arrayByAddingObjectsFromArray:info->widgets[w1]]);
}

size_t day24part1(Info* info) {
  id magic = info->magic;
  int res[14];

  int stack[14];
  int pos = 0;
  for (int i = 0; i < 14; ++i) {
    if ([magic[i][0] intValue] == 1) {
      stack[pos++] = i;
    } else {
      int j = stack[--pos];
      Expr* z = parsePair(info, j, i);
      int input[14] = {9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9};
      for (int in1 = 9; in1 > 0; --in1) {
        for (int in2 = 9; in2 > 0; --in2) {
          input[0] = in1;
          input[1] = in2;
          if ([z eval:input] == 0) {
            res[j] = in1;
            res[i] = in2;
            goto NEXT;
          }
        }
      }
    }
  NEXT:;
  }
  size_t v = 0;
  for (int i = 0; i < 14; ++i) {
    assert(0 < res[i] && res[i] < 10);
    v *= 10;
    v += res[i];
  }
  return v;
}

size_t day24part2(Info* info) {
  id magic = info->magic;
  int res[14];

  int stack[14];
  int pos = 0;
  for (int i = 0; i < 14; ++i) {
    if ([magic[i][0] intValue] == 1) {
      stack[pos++] = i;
    } else {
      int j = stack[--pos];
      Expr* z = parsePair(info, j, i);
      int input[14] = {9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9};
      for (int in1 = 1; in1 < 10; ++in1) {
        for (int in2 = 1; in2 < 10; ++in2) {
          input[0] = in1;
          input[1] = in2;
          if ([z eval:input] == 0) {
            res[j] = in1;
            res[i] = in2;
            goto NEXT;
          }
        }
      }
    }
  NEXT:;
  }
  size_t v = 0;
  for (int i = 0; i < 14; ++i) {
    assert(0 < res[i] && res[i] < 10);
    v *= 10;
    v += res[i];
  }
  return v;
}


int day24main(int argc, const char** argv) {
  id regex = @"mul x 0\nadd x z\nmod x 26\ndiv z ([-0-9]+)\nadd x "
             @"([-0-9]+)\neql x w\neql x 0\nmul y 0\nadd y 25\nmul y x\nadd y "
             @"1\nmul z y\nmul y 0\nadd y w\nadd y ([-0-9]+)\nmul y x\nadd z y";
  Info info;
  info.magic =
      parseLines(split(readFile(@"input/day24.txt"), @"\ninp w"),
                 [NSRegularExpression regularExpressionWithPattern:regex
                                                           options:0
                                                             error:NULL]);

  info.lines = splitLines(readFile(@"input/day24.txt"));
  assert([info.lines count] == 18 * 14);

  for (int i = 0; i < 14; ++i) {
    info.widgets[i] = [info.lines subarrayWithRange:NSMakeRange(i * 18, 18)];
  }

  NSLog(@"Part 1: %zu", day24part1(&info));
  NSLog(@"Part 2: %zu", day24part2(&info));
  return 0;
}
