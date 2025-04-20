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
    SELECT
        u.id,
        u.username,
        (
            SELECT json_agg(json_build_object('name', n.name, 'id', n.identity) ORDER BY n.name)
            FROM networks n WHERE u.id = n.user_id
        ) AS networks
    FROM users u
    ORDER BY u.username
    SQL);

$result = $stmt->fetchAll(PDO::FETCH_ASSOC);

print_r($result);

$parsed = array_map(
    static fn (array $row) => array_replace($row, [
        'networks' => json_decode($row['networks'] ?? '[]', true)
    ]),
    $result
);

print_r($parsed);
