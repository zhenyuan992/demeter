package Demeter::UI::Athena::Cursor;

use strict;
use warnings;

use Wx qw( :everything );
use Wx::DND;
use base qw( Exporter );
our @EXPORT = qw(cursor);


# my %map = (
# 	   bkg_e0    => 'E0',
# 	   bkg_rbkg  => 'Rbkg',
# 	   bkg_pre1  => 'lower bound of pre-edge range',
# 	   bkg_pre2  => 'upper bound of pre-edge range',
# 	   bkg_nor1  => 'lower bound of normalization range',
# 	   bkg_nor2  => 'upper bound of normalization range',
# 	   bkg_spl1  => 'lower bound of spline range',
# 	   bkg_spl2  => 'upper bound of spline range',
# 	   bkg_spl1e => 'lower bound of spline range',
# 	   bkg_spl2e => 'upper bound of spline range',
# 	   fft_kmin  => 'lower bound of forward Fourier transform range',
# 	   fft_kmax  => 'upper bound of forward Fourier transform range',
# 	   bft_rmin  => 'lower bound of backward Fourier transform range',
# 	   bft_rmax  => 'upper bound of backward Fourier transform range',
# 	  );

sub cursor {
  my ($app) = @_;
  my ($ok, $x, $y) = (1, -100000, -100000);

  my $busy;
  if ($app->current_data->mo->template_plot eq 'pgplot') {
    $app->{main}->status("Click on a point to pluck its value...", "wait");
    $app->current_data->dispose("cursor(crosshair=true)");
    ($x, $y) = (Ifeffit::get_scalar("cursor_x"), Ifeffit::get_scalar("cursor_y"));

  } elsif ($app->current_data->mo->template_plot eq 'gnuplot') {
    $app->{main}->status("Double click on a point to pluck its value...", "wait");
    $busy = Wx::BusyCursor->new();
    my $tdo = Wx::TextDataObject->new;
    wxTheClipboard->Open;
    wxTheClipboard->GetData( $tdo );
    wxTheClipboard->Close;
    my $top_of_clipboard = $tdo->GetText;
    my $new = $top_of_clipboard;
    while ($new eq $top_of_clipboard) {
      wxTheClipboard->Open;
      wxTheClipboard->GetData( $tdo );
      wxTheClipboard->Close;
      $new = $tdo->GetText;
      sleep 0.5;
    };
    ($x, $y) = split(/,\s+/, $new);

  } else {
    $app->{main}->status("Unknown plotting backend.  Pluck canceled.");
    $ok = 0;

  };

  undef $busy;
  return ($ok, $x, $y);
};

1;