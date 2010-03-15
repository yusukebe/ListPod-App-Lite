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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>ListPod on <?= $base ?></title>
<link rel="stylesheet" href="http://yusukebe.github.com/ListPod-App-Lite/static/blueprint/screen.css" type="text/css" media="screen, projection" />
<link rel="stylesheet" href="http://yusukebe.github.com/ListPod-App-Lite/static/blueprint/print.css" type="text/css" media="print" />
<!--[if lt IE 8]><link rel="stylesheet" href="http://yusukebe.github.com/ListPod-App-Lite/static/blueprint/ie.css" type="text/css" media="screen, projection" /><![endif]-->
</head>
<body>
<div class="container">
<hr class="space" />
<h1>ListPod on <?= $base ?></h1>
<form action="<?= $base ?>playlist">
<p>
<label>Input <a href="http://www.youtube.com/" target="_blank">YouTube</a>
 Playlist URL</label><br />
<input type="text" name="url" class="title" style="width:800px" />
<input type="submit" value="Submit" style="width:100px;" class="title"/>
</p>
</form>
<br />
<br />
<hr />
<address>listpod-app-lite is developed on
<a href="http://github.com/yusukebe/ListPod-App-Lite" target="_blank">
GitHub
</a> by Yusuke Wada.
This is branche of <a href="http://listpod.tv/">listpod.tv</a>
</address>
</div>
</body>
</html>
