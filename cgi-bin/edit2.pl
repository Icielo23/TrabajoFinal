#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;

my $q = CGI->new;
my $titulo = $q->param('titulo');

print $q->header('text/html;charset=UTF-8');
my $texto = gettexto($titulo);

sub gettexto{
  my $titulo = $_[0];

  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.54";
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sth = $dbh->prepare("SELECT texto FROM websites WHERE titulo = ?");
  $sth->execute($titulo);
  my $texto = $sth->fetchrow_array;
  $dbh->disconnect;
  $sth->finish; 
  return $texto;
}

print  <<HTML;
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>editar $titulo</title>
  </head>
  <body>
    <h1>$titulo</h1>
    <form action="new2.pl" method="GET">
      <label for="texto">Texto</label>
      <input type="hidden" name="titulo" value="$titulo">
      <textarea id="texto" name="texto" rows="10" cols="50">$texto</textarea>
      <br>
      <input type="submit" value="modificar">
    </form>
    <a href="../cgi-bin/list2.pl">Cancelar</a>
  </body>
</html>
HTML

