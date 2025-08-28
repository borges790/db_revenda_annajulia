select * from cliente
where nome like 'Maria%';

explain
select * from vw_detalhes_pedido
where cliente_nome like 'Maria%';

create index idx_cliente_nome on cliente(nome);

explain
select * from vw_detalhes_pedido
where cliente_nome like 'Maria%';

alter table pagamento
alter column codigo_transacao type int
using codigo_transacao::integer;

alter table produto
alter column quantidade type varchar
using quantidade::varchar;

CREATE USER annajulia WITH PASSWORD 'senha_segura';

GRANT CONNECT ON DATABASE db_revenda_annajulia TO annajulia;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO annajulia;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO annajulia;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO annajulia;

CREATE USER manu WITH PASSWORD 'senha_segura';

GRANT CONNECT ON DATABASE db_revenda_annajulia to manu;

GRANT SELECT ON cliente TO manu;

SELECT c.nome, p.data_pedido, p.valor_total
FROM cliente c
INNER JOIN pedido p ON c.id = p.cliente_id;

SELECT c.nome, p.data_pedido, p.valor_total
FROM cliente c
LEFT JOIN pedido p ON c.id = p.cliente_id;

SELECT c.nome, p.data_pedido, p.valor_total
FROM cliente c
RIGHT JOIN pedido p ON c.id = p.cliente_id;

SELECT pr.nome AS produto, pp.valor_total
FROM produto pr
INNER JOIN produto_pedido pp ON pr.id = pp.produto_id;

SELECT pr.nome AS produto, pp.valor_total
FROM produto pr
LEFT JOIN produto_pedido pp ON pr.id = pp.produto_id;

SELECT pr.nome AS produto, pp.valor_total
FROM produto pr
RIGHT JOIN produto_pedido pp ON pr.id = pp.produto_id;

SELECT p.id AS pedido_id, pg.metodo, pg.data_pagamento
FROM pedido p
INNER JOIN pagamento pg ON p.id = pg.pedido_id;

SELECT p.id AS pedido_id, pg.metodo, pg.data_pagamento
FROM pedido p
LEFT JOIN pagamento pg ON p.id = pg.pedido_id;

SELECT p.id AS pedido_id, pg.metodo, pg.data_pagamento
FROM pedido p
RIGHT JOIN pagamento pg ON p.id = pg.pedido_id;

SELECT p.id AS pedido_id, e.endereco, e.data_entrega
FROM pedido p
INNER JOIN entrega e ON p.id = e.pedido_id;

SELECT p.id AS pedido_id, e.endereco, e.data_entrega
FROM pedido p
LEFT JOIN entrega e ON p.id = e.pedido_id;

SELECT p.id AS pedido_id, e.endereco, e.data_entrega
FROM pedido p
RIGHT JOIN entrega e ON p.id = e.pedido_id;

alter table cliente alter column telefone drop not null;

UPDATE cliente SET telefone = NULL WHERE id IN (1,2,3);



































