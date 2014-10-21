package RDF::SIO::Utils::Trine;
BEGIN {
  $RDF::SIO::Utils::Trine::VERSION = '0.001';
}
use strict;
use Carp;
use RDF::Trine;
use RDF::Trine::Node::Resource;
use RDF::Trine::Node::Literal;
use RDF::Trine::Statement;


use vars qw($AUTOLOAD @ISA);

use vars qw /$VERSION/;


=head1 NAME

SIO::Utils::Trine - Things that make RDF::Trine work the way I think it should

=head1 SYNOPSIS

  use SIO::Utils::Trine;
  my $t = SIO::Utils::Trine->new();
  my $node = $t->iri("http://example.com/nodeid");
  

=cut

=head1 DESCRIPTION

Typing in $node = RDF::Trine::iri("http://blah.com/") every time
was driving me insane.  Wanted it to be a bit more... lazy...

=cut

=head1 AUTHORS

Mark Wilkinson (markw at illuminae dot com)


=cut

=head1 METHODS


=head2 new

 Usage     :	my $trine = SIO::Utils::Trine->new;
 Function  :
 Returns   :	
 Args      :    


=cut


=head2 temporary_model

 Usage     :	my $Model = $trine->temporary_model();
 Function  :
 Returns   :	
 Args      :    



=head2 iri

 Usage     :	my $Node = $trine->iri($uri);
 Function  :
 Returns   :	
 Args      :    


=cut


=head2 blank

 Usage     :	my $bNode = $trine->blank($id);
 Function  :
 Returns   :	
 Args      :    


=cut


=head2 literal

 Usage     :	my $lit = $trine->literal("val", "en", "string");
 Function  :
 Returns   :	
 Args      :    


=cut


=head2 statement

 Usage     :	my $stm = $trine->statement($s, $p, $o);
 Function  :
 Returns   :	
 Args      :    $s, $p, $o as Trine Nodes or literals


=cut


{

	# Encapsulated:
	# DATA
	#___________________________________________________________
	#ATTRIBUTES
	my %_attr_data =    #     				DEFAULT    	ACCESSIBILITY
	  (
	  );

	#_____________________________________________________________
	# METHODS, to operate on encapsulated class data
	# Is a specified object attribute accessible in a given mode
	sub _accessible {
		my ( $self, $attr, $mode ) = @_;
		$_attr_data{$attr}[1] =~ /$mode/;
	}

	# Classwide default value for a specified object attribute
	sub _default_for {
		my ( $self, $attr ) = @_;
		$_attr_data{$attr}[0];
	}

	# List of names of all specified object attributes
	sub _standard_keys {
		keys %_attr_data;
	}

}

sub new {
  my ( $caller, %args ) = @_;
  my $caller_is_obj = ref( $caller );
  return $caller if $caller_is_obj;
  my $class = $caller_is_obj || $caller;
  my $proxy;
  my $self = bless {}, $class;
  foreach my $attrname ( $self->_standard_keys ) {
    if ( exists $args{$attrname} ) {
      $self->{$attrname} = $args{$attrname};
    } elsif ( $caller_is_obj ) {
      $self->{$attrname} = $caller->{$attrname};
    } else {
      $self->{$attrname} = $self->_default_for( $attrname );
    }
  }

  return $self;
}


sub temporary_model {
    my ($self ) = @_;
    my $model = RDF::Trine::Model->temporary_model;
    return $model;
}


sub iri {
    my ($self, $iri ) = @_;
    my $node = RDF::Trine::iri($iri);
    return $node;
}


sub blank {
    my ($self, $id) = @_;
    my $node = RDF::Trine::blank($id);
    return $node;
}

sub literal {
    my ($self, $val, $lang, $dt ) = @_;
    my $node = RDF::Trine::literal($val, $lang, $dt);
    return $node;
}

sub statement {
    my ($self, $s, $p, $o ) = @_;
    my $node = RDF::Trine::statement($s, $p, $o);
    return $node;
}



sub AUTOLOAD {

  no strict "refs";
  my ( $self, $newval ) = @_;
  $AUTOLOAD =~ /.*::(\w+)/;
  my $attr = $1;
  if ( $self->_accessible( $attr, 'write' ) ) {
    *{$AUTOLOAD} = sub {
      if ( defined $_[1] ) { $_[0]->{$attr} = $_[1]; }
      return $_[0]->{$attr};
    };    ### end of created subroutine
    ###  this is called first time only
    if ( defined $newval ) {
      $self->{$attr} = $newval;
    }
    return $self->{$attr};
  } elsif ( $self->_accessible( $attr, 'read' ) ) {
    *{$AUTOLOAD} = sub {
      return $_[0]->{$attr};
    };    ### end of created subroutine
    return $self->{$attr};
  }
  
  # Must have been a mistake then...
  croak "No such method: $AUTOLOAD";
}
sub DESTROY { }
1;