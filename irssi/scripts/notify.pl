use strict;
use vars qw($VERSION %IRSSI);

$VERSION = '1.00';
%IRSSI = (
    authors     => 'Erwin Atuli',
    contact     => 'erwinatuli\@gmail.com',
    name        => 'Notify',
    description => 'This script allows forwarding notifications' .
                    'to notification engine',
    license     => 'Public Domain',
);

sub send_notification {
    my($msg) = @_;
    $msg = add_slashes($msg);
    system("notify -l \"$msg\" &");
}

sub event_privmsg {
    my ($server, $data, $nick, $address) = @_;
    my $own_nick = $server->{nick};
    
    if($data =~ /$own_nick/i && $data =~ /^(.*?):(.*)/) {
        my($source, $msg) = split(':', $data, 2);
        send_notification("Mentioned in ${source}by $nick: $msg");
    }
}

sub add_slashes {
    my($text) = shift;
    $text =~ s/\\/\\\\/g;
    $text =~ s/"/\\"/g;
    $text =~ s/\\0/\\\\0/g;
    return $text;
}
Irssi::signal_add("event privmsg", "event_privmsg")
