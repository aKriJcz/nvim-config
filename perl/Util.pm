use v5.20;

use Carp;
use Encode qw/ encode decode _utf8_off /;

our $curbuf;

# Returns: ( star_line, start_col, end_line, end_col )
# TODO: there is a issue with column position and UTF-8!!! Does VIM returns a number of bytes instead of column pos?
sub get_visual_sel {
  my $start = VIM::Eval( qw|getpos("'<")| );
  my $end   = VIM::Eval( qw|getpos("'>")| );
  die "arrayref expected!" unless ref( $start ) and ref( $end );
  die "Selection range must be from active buffer!" unless $start->[0] == 0 && $end->[0] == 0;
  return ( $start->[1], $start->[2], $end->[1], $end->[2] )
}

sub correct_pos {
    my $str = shift;
    my ( $scol_vimpos, $ecol_vimpos ) = @_;

    open my $fh, '>/tmp/test2' or die $!;
    $fh->print("scol_vimpos $scol_vimpos, ecol_vimpos: $ecol_vimpos\n");

    my $scol;
    my $ecol;
    my $vimpos = 0;
    for my $i ( 1 .. length($str) ) {
        $fh->print("i: $i\n");
        $vimpos += bytes::length( substr( $str, $i - 1, 1 ) );
        $fh->print("vimpos: $vimpos\n");
        $scol = $i if ( $vimpos >= $scol_vimpos && not defined( $scol ) );
        $ecol = $i if ( $vimpos >= $ecol_vimpos && not defined( $ecol ) );
        last if defined( $scol ) && defined( $ecol );
    }
    return ( $scol, $ecol );
}

sub apply_selection {
    my $func_ref = shift;

    open my $fh, '>/tmp/test' or die $!;

    my @sel = get_visual_sel();
    my ( $srow, $scol, $erow, $ecol ) = @sel;
    $fh->print(Dumper(\@sel));

    # Get the selected lines
    my @lines = $curbuf->Get( $srow .. $erow );
    $fh->print(Dumper(\@lines));

    if (@lines == 1) {
        # Single-line selection
        my $line = $lines[0];
        $fh->print(bytes::length($line) . "\n");
        ( $scol, $ecol ) = correct_pos( $line, $scol, $ecol );
        $fh->print("scol: $scol, ecol: $ecol\n");
        my $selected = substr( $line, $scol - 1, $ecol - $scol + 1 );
        substr( $line, $scol - 1, $ecol - $scol + 1 ) = &$func_ref( $selected );
        $curbuf->Set( $srow, $line );
    } else {
        # First line: encode from scol to end
        my $first = $lines[0];
        $fh->print(bytes::length($first) . "\n");
        # TODO: finish this
        ( $scol ) = correct_pos( $first, $scol );
        my $first_sel = substr( $first, $scol - 1);
        substr( $first, $scol - 1 ) = &$func_ref( $first_sel );
        $lines[0] = $first;

        # Middle lines: encode whole lines
        for my $i ( 1 .. $#lines - 1 ) {
            $lines[$i] = &$func_ref( $lines[$i] );
        }

        # Last line: encode from start to ecol
        my $last = $lines[-1];
        $fh->print(bytes::length($last) . "\n");
        ( $ecol ) = correct_pos( $last, $ecol );
        my $last_sel = substr( $last, 0, $ecol );
        substr( $last, 0, $ecol ) = &$func_ref( $last_sel );
        $lines[-1] = $last;

        # Replace in buffer
        $curbuf->Set( $srow, @lines );
    }
}

1;

__DATA__
Tom & Jerry <3
10 > 5 && 5 < 10
She said "Hello" and left.
Café, Crème Brûlée, and jalapeño
Euro symbol: € — registered trademark: ®
A & B & C or D – E — F
Less than or equal: ≤, greater: ≥
Mixed: 5 < 10 && 10 > 3 😀 😀
Ampersands: &amp;, &#38;, <, "
