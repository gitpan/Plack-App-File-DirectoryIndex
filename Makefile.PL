use inc::Module::Install;

name q(Plack-App-File-DirectoryIndex);
all_from q(lib/Plack/App/File/DirectoryIndex.pm);

bugtracker q(http://rt.cpan.org/NoAuth/Bugs.html?Dist=Plack-App-File-DirectoryIndex);
homepage q(http://search.cpan.org/dist/Plack-App-File-DirectoryIndex);
repository q(git://github.com/jhthorsen/plack-app-file-directoryindex.git);

auto_install;
WriteAll;
