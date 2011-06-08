use warnings;
use strict;
use lib qw(lib);
use Test::More;
use Plack::App::File::DirectoryIndex;

plan skip_all => 'no test files' unless -d 't/file';
plan tests => 12;

my($app, $res, $content);

{
    eval { Plack::App::File::DirectoryIndex->new(file => 'foo') };
    like($@, qr{does not accept}, 'new() does not accept file attribute');

    $app = Plack::App::File::DirectoryIndex->new(root => 't/file');
    is_deeply($app->index_files, ['index.html'], 'default index_files has index.html');
}

{
    ok($app->should_handle('t/file'), 'should_handle() handle directories');
    ok($app->should_handle('t/file/readme.txt'), '...and files');

    $res = $app->serve_path({}, 't/file/readme.txt');
    is($res->[0], 200, 'serve_path(t/file/readme.txt) = 200');

    $res = $app->serve_path({}, 't/not-found/');
    is($res->[0], 404, 'serve_path(t/not-found) = 404');

    $res = $app->serve_path({}, 't/');
    is($res->[0], 403, 'serve_path(t/) = 403');

    $res = $app->serve_path({}, 't/file/');
    is($res->[0], 200, 'serve_path(t/file) = 200');
    $content = do { local $/; readline $res->[2] };
    like($content, qr{lorem ipsum}, 't/file => t/file/index.html');
}

{
    $app = Plack::App::File::DirectoryIndex->new(root => 't/file', index_files => 'readme.txt');
    is($app->index_files->[0], 'readme.txt', 'index_files set as plain string');

    $app = Plack::App::File::DirectoryIndex->new(root => 't/file', index_files => ['foo', 'readme.txt']);
    is($app->index_files->[1], 'readme.txt', 'index_files set as array');
    $res = $app->serve_path({}, 't/file/');
    $content = do { local $/; readline $res->[2] };
    like($content, qr{test data from readme.txt}, 't/file => t/file/readme.txt');
}
