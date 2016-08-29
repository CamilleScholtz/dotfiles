#!/usr/bin/perl
use warnings;
use strict;
use Irssi;

my %IRSSI = (
  version   => '1.0.0',
  author    => 'Amanda Folson',
  contact   => 'amanda@incredibl.org',
  name    => 'irssi-greentext',
  uri   => 'https://github.com/afolson/irssi-greentext',
  description => 'An irssi script that makes text prefixed with > green. >implying it would do something else.',
  license   => 'GPL',
);

# Look for >messages sent to us/from us
sub greentext {
  my $sig = Irssi::signal_get_emitted();
  # Crappy workaround to parse these since public/private have different args :(
  if ($sig eq "message public") {
    my ($server, $msg, $nick, $address, $target) = @_;
    if ($msg =~ /^\>\s*/) {
      Irssi::signal_emit("message public", $server, "\x{03}3$msg", $nick, $address, $target);
      Irssi::signal_stop();
    }
  }
  if ($sig eq "message private") {
    my ($server, $msg, $nick, $address) = @_;
    if ($msg =~ /^\>\s*/) {
      Irssi::signal_emit("message private", $server, "\x{03}3$msg", $nick, $address);
      Irssi::signal_stop();
    }
  }
  # We sent something!
  if ($sig eq "send text") {
    my ($msg, $server, $witem) = @_;
    if ($msg =~ /^\>\s*/) {
      Irssi::signal_emit('send text', "\x{03}3$msg", $server, $witem);
      Irssi::signal_stop();
    }
  }
}

# Public and private messages sent to us
Irssi::signal_add('message public', 'greentext');
Irssi::signal_add('message private', 'greentext');
# Public and private messages sent from us
Irssi::signal_add('send text', 'greentext');
