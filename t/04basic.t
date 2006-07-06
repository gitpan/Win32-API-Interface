use Test::More tests => 6;

use_ok('Win32::API::Interface');                     
  
package ITest;
use base qw/Win32::API::Interface/;

Test::More::ok( __PACKAGE__->provide( "kernel32", "GetCurrentProcessId", "", "I", 'GetCurrentProcessId' ) );
Test::More::ok( __PACKAGE__->provide( "kernel32", "GetCurrentProcessId", "", "I", 'get_pid' ) );

1;

Test::More::ok( my $obj = ITest->new );
Test::More::ok( $obj->GetCurrentProcessId );
Test::More::ok( $obj->get_pid );
