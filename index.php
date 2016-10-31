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

?>

</br>

<?php

  echo getenv("DATABASE_SERVICE_NAME");
  echo "\r\n";
  echo getenv("DATABASE_NAME");
  echo "\r\n";
  echo getenv("DATABASE_USER");
  echo "\r\n";
  echo getenv("DATABASE_PASSWORD");
  echo "\r\n";

  $connectionstring='host='.getenv("DATABASE_SERVICE_NAME")." port=5432 dbname=".getenv("DATABASE_NAME")." user=".getenv("DATABASE_USER")." password=".getenv("DATABASE_PASSWORD");

  echo $connectionstring;
  echo "\r\n";

  echo $dbconn=pg_connect($connectionstring);

  echo "\r\n";


?>

</body>
</html>
