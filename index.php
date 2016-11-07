<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <title>Titre de la page</title>
  <link rel="stylesheet" href="style.css">
  <script src="script.js"></script>
</head>
<body>

<?php

  echo "Bonjour Tlm!V3\n";


  echo "re bonjour !!!!!!"

?>

</br>

<?php

  echo getenv("DATABASE_SERVICE_NAME");
  echo "</br>";
  echo getenv("DATABASE_NAME");
  echo "</br>";
  echo getenv("DATABASE_USER");
  echo "</br>";
  echo getenv("DATABASE_PASSWORD");
  echo "</br>";

  $connectionstring='host='.getenv("DATABASE_SERVICE_NAME")." port=5432 dbname=".getenv("DATABASE_NAME")." user=".getenv("DATABASE_USER")." password=".getenv("DATABASE_PASSWORD");

  $dbconn=pg_connect($connectionstring);


  if (isset($dbconn)){
    echo "Connexion à la base OK, connectionstring=  ";
    echo $connectionstring;
    echo "</br>";
  }else{
    echo "Connexion à la base KO ... :-(";
  }


?>

</body>
</html>
