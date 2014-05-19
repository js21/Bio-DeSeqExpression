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

has 'samples_file'       => ( is => 'rw', isa => 'Str' );
has 'conditions_file'    => ( is => 'rw', isa => 'Str' );
has 'pvalue_cut_off'     => ( is => 'rw', isa => 'Str' );
has 'samples_to_compare' => ( is => 'rw', isa => 'Str' );
has 'go_annotation_file' => ( is => 'rw', isa => 'Str' );

sub BUILD {

    my ($self) = @_;

    my ( $samples_file, $conditions_file, $pvalue_cut_off, $samples_to_compare,
        $go_annotation_file, $help );

    GetOptionsFromArray(
        $self->args,
        's|samples_file=s'     => \$samples_file,
        'c|conditions_file=s'  => \$conditions_file,
        'p|pvalue_cut_off=s'   => \$pvalue_cut_off,
        'm|samples_to_compare' => \$samples_to_compare,
        'g|go_annotation_file' => \$go_annotation_file,
        'h|help'               => \$help,
    );

    $self->samples_file($samples_file)       if ( defined($samples_file) );
    $self->conditions_file($conditions_file) if ( defined($conditions_file) );
    $self->pvalue_cut_off($pvalue_cut_off_name)
      if ( defined($pvalue_cut_off_name) );
    $self->samples_to_compare($samples_to_compare)
      if ( defined($samples_to_compare) );
    $self->go_annotation_file($go_annotation_file)
      if ( defined($go_annotation_file) );

}

sub run {
    my ($self) = @_;

    (        $self->samples_to_compare
          && $self->conditions_file
          && $self->go_annotation_file )
      or die <<USAGE;
	
Usage:
  -s|samples_file         <A list of samples to analyse and their corresponding file of expression values (format to be decided)>
  -a|conditions_file       <configuration file specifying the condition type of the sample and if it's a replicate or not>
  -p|pvalue_cut_off              <value between 0 and 1>
  -o|samples_to_compare  <Optional: samples_to_compare>
  -q|go_annotation_file <Optional: go_annotation_file>
  -h|help                  <print this message>

This script takes in an aligned sequence file (BAM) and a corresponding annotation file (GFF) and creates a spreadsheet with expression values.
The BAM must be aligned to the same reference that the annotation refers to and must be sorted.
USAGE

}
