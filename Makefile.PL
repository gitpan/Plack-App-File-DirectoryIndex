use inc::Module::Install;

name q(Plack-App-File-DirectoryIndex);
all_from q(lib/Plack/App/File/DirectoryIndex.pm);

requires q(Plack) => 0.99;
requires q(base) => 2.14;

bugtracker q(http://rt.cpan.org/NoAuth/Bugs.html?Dist=Plack-App-File-DirectoryIndex);
homepage q(http://search.cpan.org/dist/Plack-App-File-DirectoryIndex);
repository q(git://github.com/jhthorsen/plack-app-file-directoryindex.git);

# install_script glob('bin/*');
auto_install;
WriteAll;
