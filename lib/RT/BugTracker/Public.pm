# BEGIN BPS TAGGED BLOCK {{{
# 
# COPYRIGHT:
#  
# This software is Copyright (c) 1996-2007 Best Practical Solutions, LLC 
#                                          <jesse@bestpractical.com>
# 
# (Except where explicitly superseded by other copyright notices)
# 
# 
# LICENSE:
# 
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from www.gnu.org.
# 
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 or visit their web page on the internet at
# http://www.gnu.org/copyleft/gpl.html.
# 
# 
# CONTRIBUTION SUBMISSION POLICY:
# 
# (The following paragraph is not intended to limit the rights granted
# to you to modify and distribute this software under the terms of
# the GNU General Public License and is only of importance to you if
# you choose to contribute your changes and enhancements to the
# community by submitting them to Best Practical Solutions, LLC.)
# 
# By intentionally submitting any modifications, corrections or
# derivatives to this work, or any other work intended for use with
# Request Tracker, to Best Practical Solutions, LLC, you confirm that
# you are the copyright holder for those contributions and you grant
# Best Practical Solutions,  LLC a nonexclusive, worldwide, irrevocable,
# royalty-free, perpetual, license to use, copy, create derivative
# works based on those contributions, and sublicense and distribute
# those contributions and any derivatives thereof.
# 
# END BPS TAGGED BLOCK }}}

use 5.008003;
use strict;
use warnings;

package RT::BugTracker::Public;

our $VERSION = '0.03';

=head1 NAME

RT::BugTracker::Public - Adds a public, (hopefully) userfriendly bug tracking UI to RT

=head1 CONFIGURATION

You can find F<local/etc/BugTracker-Public/RT_SiteConfig.pm> with example of
configuration and sane defaults. Add require in the main F<RT_SiteConfig.pm> or
define options there.

=head2 NoAuthRegexp

As public shouldn't require authentication then you should add '/Public/' path
to NoAuthRegexp option, something like:

    Set($WebNoAuthRegex, qr!^(?:/+NoAuth/|
                                /+Public/|
                                /+REST/\d+\.\d+/NoAuth/)!x );

Note that if you have multiple extensions that want to change this option then
you have to merge them manually into one perl regular expression.

=head2 WebPublicUser

Make sure to create the public user in your RT system and add the line below
to your F<RT_SiteConfig.pm>.

    Set( $WebPublicUser, 'guest' );

If you didn't name your public user 'guest', then change accordingly.

The public user should probably be unprivileged and have the following rights

    CreateTicket
    ModifyCustomField
    ReplyToTicket
    SeeCustomField
    SeeQueue
    ShowTicket

If you want the public UI to do anything useful. It should NOT have the
ModifySelf right.

=cut

sub IsPublicUser {
    my $self = shift;

    my $session = \%HTML::Mason::Commands::session;
    # XXX: Not sure when it happens
    return 1 unless $session->{'CurrentUser'} && $session->{'CurrentUser'}->id;
    return 1 if $session->{'CurrentUser'}->Name eq ($RT::WebPublicUser||'');
    return 1 if defined $session->{'BitcardUser'};
    return 1 if defined $session->{'CurrentUser'}->{'OpenID'};
    return 0;
}

=head1 AUTHOR

Thomas Sibley E<lt>trs@bestpractical.comE<gt>

=head1 LICENSE

GPL version 2.

=cut

1;
