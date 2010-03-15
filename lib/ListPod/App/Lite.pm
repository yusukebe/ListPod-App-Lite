package ListPod::App::Lite;
use strict;
use warnings;
our $VERSION = '0.01';
use Plack::Request;
use ListPod::App::Lite::View;
use ListPod::App::Lite::RSS;
use ListPod::App::Lite::YouTube;
use ListPod::App::Lite::UserAgent;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless {
        cookie_file => $opt{cookie_file},
    }, $class;
    $self->{ua} = ListPod::App::Lite::UserAgent->new( cookie_file => $opt{cookie_file} );
    $self->{youtube} = ListPod::App::Lite::YouTube->new( ua => $self->{ua} );
    $self;
}

sub handler {
    my $self = shift;
    sub {
        my $env = shift;
        my $req = Plack::Request->new($env);
        $self->{base} = $req->base unless $self->{base};
        if ( $req->path_info eq '/' ) {
            my $html = ListPod::App::Lite::View->render({ base => $self->{base} });
            return $self->response( $html, 'text/html' );
        }
        elsif( $req->path_info eq "/playlist" ){
            my ($playlist_id) = $req->param('url') =~ /p=([^&\s]+)/;
            return $self->handle_404 unless $playlist_id;
            $self->redirect( $self->{base} . 'playlist/' . $playlist_id );
        }
        elsif( $req->path_info =~ m!/playlist/([0-9A-Z]+)! ){
            my $playlist_id = $1;
            my $playlist = $self->{youtube}->playlist($playlist_id);
            my $rss      = ListPod::App::Lite::RSS->render(
                { base => $self->{base}, playlist => $playlist } );
            return $self->response( $rss, 'application/rss+xml' );
        }
        elsif ( $req->path_info =~ m!/video/([^\.]+)\.mp4! ) {
            my $video_id = $1;
            my $mp4_url  = $self->{youtube}->mp4_url($video_id);
            return [402, ['Content-Type'=>'text/plain'], ['402 Payment Required'] ] unless $mp4_url;
            return $self->handle_video_anyevent($mp4_url) if $self->{cookie_file};
            return $self->redirect($mp4_url);
        }
        else {
            return [ 404, [], ['404 Not Found'] ];
        }
    };
}

sub response {
    my ( $self, $content, $type ) = @_;
    return [ 200, [ 'Content-Type' => $type ], [$content] ];
}

sub handle_404 {
    return [ 404, [], ['404 Not Found'] ];
}

sub redirect {
    my ( $self, $url ) = @_;
    return [ 302, [ Location => $url ], [] ];
}


sub handle_video_anyevent {
    my ($self, $url) = @_;
    warn "Handle video with AnyEvent::HTTP\n";
    require AnyEvent;
    require AnyEvent::HTTP;
    my $headers = $self->{ua}->http_headers_raw;
    my $cv      = AnyEvent->condvar;
    warn "Donwloading ... $url\n";
    AnyEvent::HTTP::http_get(
        $url,
        headers => $headers,
        sub {
            my $content = shift;
            $cv->send(
                [
                    200,
                    [
                        'Content-Type'   => 'video/mp4',
                        'Content-Length' => length $content
                    ],
                    [$content]
                ]
            );
        }
    );
    return sub {
        my $start_response = shift;
        $cv->cb(
            sub {
                warn "Downloaded\n";
                $start_response->( shift->recv );
            }
        );
    };
}



1;
__END__

=head1 NAME

ListPod::App::Lite - Modules for listpod-app-lite command.

=head1 SYNOPSIS

in your .psgi

  use ListPod::App::Lite;
  my $app = ListPod::App::Lite->new(%options);
  return $app->handler;

=head1 DESCRIPTION

ListPod::App::Lite is Module(s) for listpod-app-lite command.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

http://listpod.tv/

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
