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
use Data::Dumper;

has 'args'        => ( is => 'ro', isa => 'ArrayRef', required => 1 );
has 'script_name' => ( is => 'ro', isa => 'Str',      required => 1 );
has 'help'        => ( is => 'rw', isa => 'Bool',     default  => 0 );

has 'samples_file' => ( is => 'rw', isa => 'Str' );
has 'deseq_file' => (is => 'rw', isa => 'Str');


sub BUILD {

    my ($self) = @_;

    my ( $samples_file, $deseq_file, $help );

    GetOptionsFromArray(
        $self->args,
        's|samples_file=s' => \$samples_file,
		'd|deseq_file=s' => \$deseq_file,
        'h|help'           => \$help,
    );

    $self->samples_file($samples_file) if ( defined($samples_file) );
	$self->deseq_file($deseq_file) if ( defined($deseq_file) );

}

sub run {
    my ($self) = @_;

    ( $self->samples_file && $self->deseq_file ) or die <<USAGE;
	
Usage:
  -s|samples_file         <A file with the list of samples to analyse and their corresponding file of expression values in the format ("filepath","condition","replicate")>
  -d|deseq_file           <The name of the file that will be used as the DeSeq analysis input>  
  -h|help                  <print this message>


USAGE

	my $deseq_setup = Bio::DeSeq->new(
  	samples_file    => $self->samples_file,
  	deseq_file  => $self->deseq_file,
  	);
	$deseq_setup->set_deseq();
	#print "Hello\n";
    print Dumper($deseq_setup);

}





1;