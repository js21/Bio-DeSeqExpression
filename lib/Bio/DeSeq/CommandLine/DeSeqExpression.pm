package Bio::DeSeq::CommandLine::DeSeqExpression;

# ABSTRACT: Run DeSeq analysis given a list of samples and their corresponding expression values

=head1 SYNOPSIS

Find the expression when given an input aligned file and an annotation file
	use Bio::RNASeq;
	my $expression_results = Bio::RNASeq->new(
	  sequence_filename => 'my_aligned_sequence.bam',
	  annotation_filename => 'my_annotation_file.gff',
	  output_base_filename => 'my_alignement_basename'
	  );
	
	$expression_results->output_spreadsheet();


Optional: A list of samples to analyse and their corresponding file of expression values (format to be decided). If not specified then the default is to look up the results from the automated pipeline.
Optional: p-value cut off
Required: A list of samples labeled by what condition and if it is a replicate. Example 1 (below) shows a possible format.
Required: A pair of samples to compare (format to be decided)
Required: A GO annotation file or a species name

=cut

use Moose;
use Getopt::Long qw(GetOptionsFromArray);
use Bio::DeSeq;

has 'args'        => ( is => 'ro', isa => 'ArrayRef', required => 1 );
has 'script_name' => ( is => 'ro', isa => 'Str',      required => 1 );
has 'help'        => ( is => 'rw', isa => 'Bool',     default  => 0 );

has 'samples_file' => ( is => 'rw', isa => 'Str' );
has 'deseq_setup'  => ( is => 'rw', isa => 'HashRef' );

sub BUILD {

    my ($self) = @_;

    my ( $samples_file, $help );

    GetOptionsFromArray(
        $self->args,
        's|samples_file=s' => \$samples_file,
        'h|help'           => \$help,
    );

    $self->samples_file($samples_file) if ( defined($samples_file) );

}

sub run {
    my ($self) = @_;

    $self->samples_file or die <<USAGE;
	
Usage:
  -s|samples_file         <A list of samples to analyse and their corresponding file of expression values in the format ("filepath","condition","replicate")>
  -h|help                  <print this message>


USAGE

    $self->_set_deseq();

}


sub _set_deseq {
	
	my ( $self ) = @_;

	$self->_validate_samples_file();
	
	
	return;
}


sub _validate_samples_file {
	
	my ( $self ) = @_;
	
	
	
	return;
}


1;