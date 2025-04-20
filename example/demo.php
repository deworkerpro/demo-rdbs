<?php

declare(strict_types=1);

namespace example;

use PDO;

$pdo = new PDO(
    sprintf('pgsql:host=%s;dbname=%s', getenv('POSTGRES_HOST'), getenv('POSTGRES_DB')),
    getenv('POSTGRES_USER'),
    getenv('POSTGRES_PASSWORD'),
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
);

$stmt = $pdo->query(<<<'SQL'
    SELECT CURRENT_TIMESTAMP as now
    SQL);

$result = $stmt->fetchAll(PDO::FETCH_ASSOC);

print_r($result);
