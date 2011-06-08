package Plack::App::File::DirectoryIndex;

=head1 NAME

Plack::App::File::DirectoryIndex - Autoload resources in directories

=head1 VERSION

0.10

=head1 DESCRIPTION

This app will automatically load files if a directory is given.

=head1 SYNOPSIS

    builder {
        mount '/' =>
            Plack::App::File::DirectoryIndex->new(
                root => '/some/directory',
                index_files => [qw/ index.html README /],
            );
    };

=cut

use strict;
use warnings;
use Carp qw/confess/;
use Plack::Util::Accessor qw(index_files);

use base 'Plack::App::File';

our $VERSION = eval '0.10';

my $DEFAULT_INDEX_FILES = ['index.html'];

=head1 ATTRIBUTES

=head2 file

This attribute exists in L<Plack::App::File>, but setting this in L</new>
will cause an exception.

=head2 index_files

Holds a list of files to search for when a directory is given. Default
value holds one element: "index.html".

=head1 METHODS

=head2 new

Will construct a new object, with the given attributes as input.

=cut

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    if(!$self->{'index_files'}) {
        $self->{'index_files'} = $DEFAULT_INDEX_FILES;
    }
    elsif(ref $self->{'index_files'} ne 'ARRAY') {
        $self->{'index_files'} = [$self->{'index_files'}];
    }

    if($self->{'file'}) {
        confess "$class->new() does not accept 'file'. Use 'root' instead";
    }
    if(!defined $self->{'root'}) {
        confess "$class->new() require 'root' attribute";
    }

    return $self;
}

=head2 should_handle

Will return true if the given file is a diectory or plain file.

=cut

sub should_handle {
    my($self, $file) = @_;
    return $self->SUPER::should_handle($file) || -d $file;
}

=head2 serve_path

Does the same as L<Plack::App::File/serve_path>, but will load files from
L</index_files> if a directory is given.

=cut

sub serve_path {
    my($self, $env, $file) = @_;

    if(-f $file) {
        return $self->SUPER::serve_path($env, $file);
    }
    if(!-d $file) {
        return $self->return_404;
    }

    for my $index (@{ $self->index_files }) {
        next unless(-f "$file/$index");
        return $self->SUPER::serve_path($env, "$file/$index");
    }

    return $self->return_403;
}

=head1 COPYRIGHT & LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Jan Henning Thorsen C<< jhthorsen at cpan.org >>

=cut

1;
