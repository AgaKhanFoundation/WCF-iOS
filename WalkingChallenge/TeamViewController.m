
#import "TeamViewController.h"

static NSString *kAddMemberString = @"Add Member";

static const float kNameFontSize = 32.0f;

@interface TeamViewController () <TeamUpdateDelegate, UITableViewDataSource> {
  UILabel *_name;
  UITableView *_members;
  UIButton *_addMember;
}
@end

@implementation TeamViewController
- (instancetype) init {
  if (self = [super init]) {
    _team = [Team new];
    _team.delegate = self;

    _name = [UILabel new];

    _members = [UITableView new];
    _members.dataSource = self;

    _addMember = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return self;
}

- (void) viewDidLoad {
  _name.font = [UIFont boldSystemFontOfSize:kNameFontSize];

  // TODO(compnerd) use auto-layout constraints
  _name.frame = CGRectMake(self.view.frame.origin.x, 32.0f,
                           self.view.frame.size.width, 32.0f);
  _name.textAlignment = NSTextAlignmentCenter;

  // TODO(compnerd) use auto-layout constraints
  _members.frame = CGRectMake(self.view.frame.origin.x + 16.0f, 64.0f,
                              self.view.frame.size.width - 32.0f,
                              self.view.frame.size.height - 148.0f);

  [_addMember setTitle:kAddMemberString forState:UIControlStateNormal];
  [_addMember addTarget:self
                 action:@selector(addMember:)
       forControlEvents:UIControlEventTouchUpInside];
  _addMember.backgroundColor = [UIColor orangeColor];
  // TODO(compnerd) use auto-layout constraints
  _addMember.frame = CGRectMake(self.view.frame.origin.x + 16.0f,
                                self.view.frame.size.height - 96.0f,
                                self.view.frame.size.width - 32.0f, 32.0f);

  [self.view addSubview:_name];
  [self.view addSubview:_members];
  [self.view addSubview:_addMember];
}

- (void)addMember:(id)button {
  NSLog(@"Add Member");
}

#pragma mark TeamUpdateDelegate methods

- (void)teamNameUpdated {
  _name.text = self.team.name;
}

- (void)teamMembersUpdated {
  [_members reloadData];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.team.members count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *kName = @"name";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kName];
  if (cell == nil)
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:kName];
  cell.textLabel.text = [self.team.members objectAtIndex:indexPath.row];
  return cell;
}

@end

