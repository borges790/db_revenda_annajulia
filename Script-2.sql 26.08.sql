create database db_revenda_annajulia;

create table cliente(
	id serial primary key,
	nome varchar(40) not null,
	cpf char(11) not null unique,
	email varchar(60) not null,
	telefone char(11) not null unique
);

create table produto(
	id serial primary key,
	nome varchar(40) not null,
	tipo varchar(30) not null,
	preco numeric(5,2) not null,
	quantidade int not null
);

create table entrega(
	id serial primary key,
	endereco varchar(200) not null,
	pedido_id int not null,
	foreign key (pedido_id) references pedido(id),
	data_entrega date not null,
	data_pedido date not null
);

create table pedido(
	id serial primary key,
	produto_id int not null,
	foreign key (produto_id) references produto(id),
	cliente_id int not null,
	foreign key (cliente_id) references cliente(id),
	data_pedido date not null,
	valor_total numeric(5,2) not null
);

create table pagamento(
	id serial primary key,
	pedido_id int not null,
	foreign key (pedido_id) references pedido(id),
	metodo varchar(20) not null,
	codigo_transacao varchar(50) not null,
	data_pagamento date not null
);

create table produto_pedido(
	produto_id int not null,
	foreign key (produto_id) references produto(id),
	pedido_id int not null,
	foreign key (pedido_id) references pedido(id),
	valor_total numeric(5,2) not null,
	pagamento_id int not null,
	foreign key (pagamento_id) references pagamento(id),
	data_entrega date not null
);


CREATE VIEW vw_detalhes_pedido AS
SELECT
    p.id AS pedido_id,
    c.nome AS cliente_nome,
    c.cpf AS cliente_cpf,
    c.email AS cliente_email,
    c.telefone AS cliente_telefone,
    pr.nome AS produto_nome,
    pr.tipo AS produto_tipo,
    p.data_pedido,
    p.valor_total AS valor_pedido,
    pg.metodo AS metodo_pagamento,
    pg.codigo_transacao,
    pg.data_pagamento,
    e.endereco AS endereco_entrega,
    e.data_entrega
FROM pedido p
JOIN cliente c ON p.cliente_id = c.id
JOIN produto pr ON p.produto_id = pr.id
JOIN pagamento pg ON pg.pedido_id = p.id
JOIN entrega e ON e.pedido_id = p.id;

CREATE VIEW vw_resumo_pedido_produto AS
SELECT
    p.id AS pedido_id,
    c.nome AS cliente_nome,
    pr.nome AS produto_nome,
    pr.tipo AS produto_tipo,
    pp.valor_total AS valor_produto,
    pg.metodo AS metodo_pagamento,
    pg.data_pagamento,
    e.data_entrega,
    CASE 
        WHEN pg.data_pagamento IS NOT NULL THEN 'Pago'
        ELSE 'Pendente'
    END AS status_pagamento,
    CASE
        WHEN e.data_entrega IS NOT NULL THEN 'Entregue'
        ELSE 'Aguardando Entrega'
    END AS status_entrega
FROM pedido p
JOIN cliente c ON p.cliente_id = c.id
JOIN produto_pedido pp ON pp.pedido_id = p.id
JOIN produto pr ON pp.produto_id = pr.id
JOIN pagamento pg ON pp.pagamento_id = pg.id
JOIN entrega e ON e.pedido_id = p.id;


insert into cliente (nome, cpf, email, telefone) 
values ('Ana Silva', '12345678901', 'ana.silva@mail.com', '11987654321'),
('João Pereira', '23456789012', 'joao.pereira@mail.com', '11987654322'),
('Maria Santos', '34567890123', 'maria.santos@mail.com', '11987654323'),
('Carlos Souza', '45678901234', 'carlos.souza@mail.com', '11987654324'),
('Beatriz Lima', '56789012345', 'beatriz.lima@mail.com', '11987654325'),
('Pedro Oliveira', '67890123456', 'pedro.oliveira@mail.com', '11987654326'),
('Juliana Costa', '78901234567', 'juliana.costa@mail.com', '11987654327'),
('Ricardo Alves', '89012345678', 'ricardo.alves@mail.com', '11987654328'),
('Fernanda Rocha', '90123456789', 'fernanda.rocha@mail.com', '11987654329'),
('Lucas Martins', '01234567890', 'lucas.martins@mail.com', '11987654330');

insert into produto (nome, tipo, preco, quantidade) 
values ('Iphone 16 Pro Max', 'Eletrônicos', 650.00, 50),
('Notebook Pro', 'Eletrônicos', 350.00, 30),
('Fone de Ouvido', 'Acessórios', 200.00, 100),
('Camiseta', 'Vestuário', 50.00, 200),
('Tênis Esportivo', 'Calçados', 300.00, 80),
('Relógio Digital', 'Eletrônicos', 400.00, 60),
('Bolsa Feminina', 'Acessórios', 250.00, 90),
('Maquiagem', 'Acessórios', 120.00, 40),
('Livro Romance', 'Livros', 40.00, 150),
('Mochila Escolar', 'Acessórios', 150.00, 100);

insert into pedido (produto_id, cliente_id, data_pedido, valor_total) 
values (1, 1, '2025-08-01', 650.00),
(2, 2, '2025-08-02', 350.00),
(3, 3, '2025-08-03', 200.00),
(4, 4, '2025-08-04', 50.00),
(5, 5, '2025-08-05', 300.00),
(6, 6, '2025-08-06', 400.00),
(7, 7, '2025-08-07', 250.00),
(8, 8, '2025-08-08', 120.00),
(9, 9, '2025-08-09', 40.00),
(10, 10, '2025-08-10', 150.00);

insert into pagamento (pedido_id, metodo, codigo_transacao, data_pagamento)
values (1, 'Cartão', 'TX1001', '2025-08-02'),
(2, 'Boleto', 'TX1002', '2025-08-03'),
(3, 'Pix', 'TX1003', '2025-08-04'),
(4, 'Cartão', 'TX1004', '2025-08-05'),
(5, 'Pix', 'TX1005', '2025-08-06'),
(6, 'Boleto', 'TX1006', '2025-08-07'),
(7, 'Cartão', 'TX1007', '2025-08-08'),
(8, 'Pix', 'TX1008', '2025-08-09'),
(9, 'Cartão', 'TX1009', '2025-08-10'),
(10, 'Boleto', 'TX1010', '2025-08-11');

insert into produto_pedido (produto_id, pedido_id, valor_total, pagamento_id, data_entrega) 
values (1, 1, 650.00, 1, '2025-08-05'),
(2, 2, 350.00, 2, '2025-08-06'),
(3, 3, 200.00, 3, '2025-08-07'),
(4, 4, 50.00, 4, '2025-08-08'),
(5, 5, 300.00, 5, '2025-08-09'),
(6, 6, 400.00, 6, '2025-08-10'),
(7, 7, 250.00, 7, '2025-08-11'),
(8, 8, 120.00, 8, '2025-08-12'),
(9, 9, 40.00, 9, '2025-08-13'),
(10, 10, 150.00, 10, '2025-08-14');

insert into entrega (endereco, pedido_id, data_entrega, data_pedido) 
values ('Rua A, 123, São Paulo, SP', 1, '2025-08-05', '2025-08-01'),
('Av. B, 456, Rio de Janeiro, RJ', 2, '2025-08-06', '2025-08-02'),
('Travessa C, 789, Belo Horizonte, MG', 3, '2025-08-07', '2025-08-03'),
('Rua D, 101, Porto Alegre, RS', 4, '2025-08-08', '2025-08-04'),
('Av. E, 202, Curitiba, PR', 5, '2025-08-09', '2025-08-05'),
('Rua F, 303, Salvador, BA', 6, '2025-08-10', '2025-08-06'),
('Alameda G, 404, Fortaleza, CE', 7, '2025-08-11', '2025-08-07'),
('Rua H, 505, Recife, PE', 8, '2025-08-12', '2025-08-08'),
('Av. I, 606, Brasília, DF', 9, '2025-08-13', '2025-08-09'),
('Rua J, 707, Manaus, AM', 10, '2025-08-14', '2025-08-10');


select * from vw_detalhes_pedido;

select * from vw_resumo_pedido_produto;














