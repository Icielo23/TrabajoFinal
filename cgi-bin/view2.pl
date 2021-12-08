#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $titulo = $q->param('titulo');

print $q->header('text/html;charset=UTF-8');
#my $titulo = "hola";
my $texto = "";
my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.54";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  
my $sth = $dbh->prepare("SELECT texto FROM websites WHERE titulo = ? ");
$sth->execute($titulo);
  $texto = $sth->fetchrow_array;
$sth->finish;
$dbh->disconnect;
my $body = getbody($texto);

  print <<"HTML";
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>Listado de paginas</title>
  </head>
  <body>
    <a href='../cgi-bin/list2.pl'>Retroceder</a>
    <h2>$titulo</h2>
    <p>$body</p>
  </body>
</html>
HTML

sub getbody{
  my $texto = $_[0];
  my $line = "";
  my $body = "";

  my @temporal = split(/\n+/, $texto);
  my $valor = 1;
  for(my $i = 0; $i < @temporal; $i++){
    my @temporal2 = evaluar($temporal[$i], $valor);
    $valor = $temporal2[1];
    $body .= $temporal2[0]."\n";
  }
  return $body;
}

sub evaluar{
  my $line = $_[0];
  my $valor = $_[1];
  my @temporal2;
  if ($line =~ /^(######)(.+)/){
    $temporal2[0] = "<h6>".$2."</h6>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(##)(.+)/){
    $temporal2[0] = "<h2>".$2."</h2>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(#)(.+)/){
    $temporal2[0] = "<h1>".$2."</h1>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\*\*\*)(.+)(\*\*\*)/){
    $temporal2[0] = "<i><b>".$2."</b></i><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\*\*)(.+)(\*\*)/){
    if ($line =~ /^(\*\*)(.+)(\_)(.+)(\_)(.+)(\*\*)/){
      $temporal2[0] = "<b>".$2."<i>".$4."</i>".$6."</b><br>";
      $temporal2[1] = $valor;
      return @temporal2;
    }
    $temporal2[0] = "<b>".$2."</b><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\*)(.+)(\*)/){
    $temporal2[0] = "<i>".$2."</i><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\`\`\`)/){
    if($valor == 1){
      $temporal2[0] = "<code><br>";
      $temporal2[1] = 0;
      return @temporal2;
    }else{
      $temporal2[0] = "</code><br>";
      $temporal2[1] = 1;
      return @temporal2;
    }
  }
  if ($line =~ /(.*)(\[)(.+)(\])(\()(.+)(\))/){
    $temporal2[0] = "<a>".$1."<a href='".$6."'>".$3."</a></a><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  if ($line =~ /^(\~)(.+)(\~)/){
    $temporal2[0] = "<del>".$2."</del><br>";
    $temporal2[1] = $valor;
    return @temporal2;
  }
  $temporal2[0] = "<a>$line</a><br>";
  $temporal2[1] = $valor;
  return @temporal2;
}



