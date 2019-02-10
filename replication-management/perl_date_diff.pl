#!/usr/bin/perl -w

use Date::Calc qw(Today_and_Now Delta_YMDHMS Add_Delta_YMDHMS Delta_DHMS Date_to_Text);

my $today = [Today_and_Now()];
  my $target = [2005,1,1,0,0,0];

print "Today: $today->[2] \n";

  my $delta = Normalize_Delta_YMDHMS($today,$target);
  
print "$delta->[3]\n";


  printf("Today is %s %02d:%02d:%02d\n", Date_to_Text(@{$today}[0..2]), @{$today}[3..5]);


######  Following is needed to fix seconds, minutes, hours
  sub Normalize_Delta_YMDHMS
  {
      my($date1,$date2) = @_;
      my(@delta);

      @delta = Delta_YMDHMS(@$date1,@$date2);
      while ($delta[1] < 0 or
             $delta[2] < 0 or
             $delta[3] < 0 or
             $delta[4] < 0 or
             $delta[5] < 0)
      {
          if ($delta[1] < 0) { $delta[0]--; $delta[1] += 12; }
          if ($delta[2] < 0)
          {
              $delta[1]--;
              @delta[2..5] = (0,0,0,0);
              @delta[2..5] = Delta_DHMS(Add_Delta_YMDHMS(@$date1,@delta),@$date2);
          }
          if ($delta[3] < 0) { $delta[2]--; $delta[3] += 24; }
          if ($delta[4] < 0) { $delta[3]--; $delta[4] += 60; }
          if ($delta[5] < 0) { $delta[4]--; $delta[5] += 60; }
      }
      return \@delta;
  }
