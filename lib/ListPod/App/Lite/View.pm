package ListPod::App::Lite::View;
use strict;
use warnings;
use Text::MicroTemplate qw(build_mt);

sub render {
    my ($self,$args) = @_;
    my $pos = tell DATA;
    local $/; my $t = <DATA>;
    seek DATA, $pos, 0;
    my $renderer = build_mt( $t );
    my $html;
    eval { $html = $renderer->($args->{base})->as_string };
    return $html;
}

1;

__DATA__
? my ( $base ) = @_;
<html>
<head>
<title>ListPod on <?= $base ?></title>
</head>
<body>
<h1>ListPod on <?= $base ?></h1>
<form action="<?= $base ?>playlist">
<label>Input YouTube Playlist URL</lable>
<input type="text" name="url" size="80" />
<input type="submit" value="Submit" />
</form>
</body>
</html>
