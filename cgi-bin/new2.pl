#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $titulo = $q->param('titulo');
my $texto = $q->param('texto');
$texto = getTexto($texto);
eliminar($titulo);
escribir($titulo, $texto);

sub escribir{
  my $titulo = $_[0];
  my $texto = $_[1];

  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.54";
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sth = $dbh->prepare("INSERT INTO websites(titulo, texto) VALUES (?,?)");
  $sth->execute($titulo, $texto);
  $sth->finish;
  $dbh->disconnect;
}

print $q->header('text/html;charset=UTF-8');
print getingreso($texto, $titulo);

sub getingreso{
  my $texto = $_[0];
  my $titulo = $_[1];
  my $html = <<HTML;
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>Nueva pagina</title>
  </head>
  <body>
    <h1>$titulo</h1>
    <a>$texto</a>
    <br>
    <h2>Pagina grabada <a href='list2.pl'>Listado de Paginas</a><h2>
  </body>
</html>
HTML
    return $html;
}
sub getTexto{
  my $texto = $_[0];

  my @temporal = split(/\n+/, $texto);
  $texto = "";
  for(my $i = 0; $i < @temporal; $i++){
    $texto .= $temporal[$i]."\n";
  }
  return $texto;
}

sub eliminar{
  my $titulo = $_[0];

  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.54";
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sth = $dbh->prepare("DELETE FROM websites WHERE titulo = ?");
  $sth->execute($titulo);
  my $texto = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
}
