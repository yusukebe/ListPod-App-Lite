package ListPod::App::Lite::YouTube;
use strict;
use warnings;
use Carp ();
use Encode;

sub new {
    my ( $class, %opt ) = @_;
    Carp::croak("ua parameter is required!") unless $opt{ua};
    my $self = bless { ua => $opt{ua} }, $class;
    $self;
}

sub mp4_url {
    my ($self, $video_id) = @_;
    my $fmt = '18'; #mp4 default
    my $token = $self->token($video_id);
    my $ua = $self->{ua};
    return unless $token;
    my $url =
        "http://www.youtube.com/get_video?video_id=$video_id&t=$token&fmt=$fmt";
    $ua->max_redirect(0);
    my $res = $ua->get( $url );
    return $res->headers->header('Location');
}

sub token {
    my ($self, $video_id) = @_;
    my $url = "http://www.youtube.com/watch?v=$video_id";
    $self->{ua}->get($url);
    $url = "http://www.youtube.com/get_video_info?video_id=$video_id";
    my $res     = $self->{ua}->get($url);
    my $content = $res->content;
    if ( $content =~ m!&token=([^&]+)&! ) {
        return $1;
    }
    else {
        #XXX TODO: Check status code.
        warn $res->status_line . "\n";
        return;
    }
}

sub playlist {
    my ( $self, $playlist_id ) = @_;
    my $url = "http://gdata.youtube.com/feeds/api/playlists/$playlist_id";
    my $res = $self->{ua}->get( $url );
    my $content = $res->content;
    my ($title) = $content =~ m!>([^<>]+)</title><subtitle!m;
    my $videos;
    while ( $content =~ m!vi/([^/]+)/0.jpg'.*?<media:title type='plain'>([^<>]+)</media:title>!g ){
        push @$videos, { title => $2, id => $1 };
    }
    return { videos => $videos, title => $title, id => $playlist_id };
}

1;
__END__

=head1 NAME

ListPod::App::Lite::YouTube - Utilities for Enjoying YouTube Hacking.

=head1 SYNOPSIS

  my $youtube = ListPod::App::Lite::YouTube->new( ua => $ua );
  my $token = $youtube->token( $video_id );
  my $mp4_url = $youtube->mp4_url( $video_id );
  my $playlist = $youtube->playlist( $playlist_id );

=head1 DESCRIPTION

Enjoy YouTube Hacking ♥

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

http://listpod.tv/

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
