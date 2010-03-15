package ListPod::App::Lite::UserAgent;
use strict;
use warnings;
use base ('LWP::UserAgent');

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {}, $class;
    my $cookie_jar = $self->_cookie_jar($opt{cookie_file}) if $opt{cookie_file};
    $self->cookie_jar( $cookie_jar );
    $self;
}

sub http_headers_raw {
    my $self = shift;
    my $jar  = $self->cookie_jar;
    my $cookie = '';
    if ($jar) {
        my $array = [];
        $jar->scan(
            sub {
                return unless $_[4] =~ /\.youtube\.com$/;
                push @$array, "$_[1]=$_[2]";
            }
        );
        $cookie = join "; ", @$array;
    }
    my $headers = {
        'cookie' => $cookie,
        #XXX
    };
    return $headers;
}

sub _cookie_jar {
    my ( $self, $file ) = @_;
    return {} unless $file;
    if( $file =~ /\.plist$/ ) {
        return $self->_safari_cookie_jar( $file );
    }elsif( $file =~ /\.sqlite$/ ){
        require HTTP::Cookies::Mozilla;
        HTTP::Cookies::Mozilla->new( file => $file );
    }else{
        require HTTP::Cookies;
        HTTP::Cookies->new( file => $file );
    }
}

sub _safari_cookie_jar {
    my ( $self, $file ) = @_;
    # parse Safari cookie, it can't work with HTTP::Cookies::Safari
    # maybe problem of "Expires"??
    require HTTP::Cookies;
    require Mac::PropertyList;
    my $cookie_jar = HTTP::Cookies->new;
    open my ($fh), $file or return;
    my $data    = do { local $/; <$fh> };
    my $plist   = Mac::PropertyList::parse_plist($data);
    my $cookies = $plist->value;
    for my $hash (@$cookies) {
        my $cookie = $hash->value;
        if ( $cookie->{Domain}->value =~ /\.youtube\.com/ ) {
            $cookie_jar->set_cookie(
                undef,
                $cookie->{Name}->value,
                $cookie->{Value}->value,
                $cookie->{Path}->value,
                $cookie->{Domain}->value
            );
        }
    }
    close $fh;
    return $cookie_jar;
}

1;
__END__

=head1 NAME

ListPod::App::Lite::UserAgent - UserAgent for fight! It's LWP::UserAgent based.

=head1 SYNOPSIS

  my $ua = ListPod::App::Lite::UserAgent->new(%options);
  my $res = $ua->get( 'http://www.youtube.com/' );

=head1 DESCRIPTION

It's subclass of LWP::UserAgent.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

http://listpod.tv/

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
