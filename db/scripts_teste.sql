PRAGMA foreign_keys;

CREATE TABLE cargo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_cargo TEXT NOT NULL COLLATE NOCASE UNIQUE,
    status INTEGER NOT NULL DEFAULT 1
) STRICT;

CREATE TABLE funcionario (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_funcionario TEXT NOT NULL COLLATE NOCASE,
    id_cargo INTEGER NOT NULL,
    status INTEGER NOT NULL DEFAULT 1,
    data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    FOREIGN KEY(id_cargo) REFERENCES cargo(id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (id, id_cargo)
) STRICT;

INSERT INTO cargo (nome_cargo) VALUES ('Gerente'), ('Atendente'), ('Técnico');

INSERT INTO funcionario (nome_funcionario, id_cargo)
VALUES
    ('João Silva', 3),
    ('Carlos Souza', 3),
    ('Marcos Oliveira', 3),
    ('Ana Santos', 2),
    ('Juliana Costa', 2),
    ('Ricardo Almeida', 1),
    ('Juliana Batista', 1);

CREATE TABLE cliente (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_cliente TEXT NOT NULL COLLATE NOCASE,
    email TEXT NOT NULL UNIQUE,
    status INTEGER NOT NULL DEFAULT 1,
    id_funcionario INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK(id_funcionario_cargo IN (1,2)),
    data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

INSERT INTO cliente (nome_cliente, email, id_funcionario, id_funcionario_cargo)
VALUES
    ('João', 'joao@email.com', 5, 2),
    ('Maria Oliveira', 'maria@email.com', 4, 2),
    ('Pedro Santos', 'pedro@email.com', 5, 2);

CREATE TABLE equipamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL,
    tipo_equipamento TEXT NOT NULL,
    numero_serie TEXT,
    imei TEXT,
    status INTEGER NOT NULL DEFAULT 1,
    id_funcionario INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK(id_funcionario_cargo IN (1,2)),
    data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo),
    UNIQUE (numero_serie),
    UNIQUE (imei)
) STRICT;

INSERT INTO equipamento (id_cliente, marca, modelo, tipo_equipamento, numero_serie, imei, id_funcionario, id_funcionario_cargo)
VALUES
    (1, 'Samsung', 'Galaxy A54', 'Celular', 'SN-001', '359123456789012', 4, 2),
    (2, 'Dell', 'Inspiron 15', 'Notebook', 'SN-002', NULL, 5, 2),
    (3, 'Apple', 'iPhone 11', 'Celular', 'SN-003', '359123456789013', 4, 2);

CREATE TABLE categoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_categoria TEXT NOT NULL COLLATE NOCASE UNIQUE,
    id_funcionario INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK(id_funcionario_cargo = 1),
    status INTEGER NOT NULL DEFAULT 1,
    data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo)
VALUES
    ('Computadores', 6, 1),
    ('Celulares', 6, 1),
    ('Smart TVs', 7, 1),
    ('Redes', 6, 1),
    ('Videogames', 6, 1),
    ('Áudio', 6, 1),
    ('Recuperação de Dados', 6, 1),
    ('Eletrônica Avançada', 7, 1),
    ('Informática', 7, 1),
    ('Insumos', 7, 1),
    ('Acessórios', 6, 1),
    ('Telas', 6, 1),
    ('Baterias', 7, 1),
    ('Componentes', 6, 1),
    ('Carcaças', 7, 1),
    ('TVs', 6, 1);

CREATE TABLE servico (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_servicos TEXT NOT NULL COLLATE NOCASE UNIQUE,
    id_categoria INTEGER NOT NULL,
    preco INTEGER NOT NULL CHECK(preco >= 0),
    horas_trabalho REAL NOT NULL CHECK(horas_trabalho > 0),
    id_funcionario INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
    status INTEGER NOT NULL DEFAULT 1,
    data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id)
) STRICT;

INSERT INTO servico (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_cargo)
VALUES
    ('Formatação e Instalação de Sistema Operacional', 1, 12000, 2.0, 6, 1),
    ('Limpeza Interna e Troca de Pasta Térmica', 1, 15000, 1.5, 6, 1),
    ('Upgrade de Hardware (RAM/SSD)', 1, 8000, 1.0, 6, 1),
    ('Remoção de Vírus e Malwares', 1, 10000, 1.5, 6, 1),
    ('Troca de Tela de Notebook', 1, 18000, 1.5, 6, 1),
    ('Troca de Display/Frontal de Celular', 2, 15000, 1.0, 6, 1),
    ('Troca de Bateria de Smartphone', 2, 9000, 0.5, 6, 1),
    ('Desoxidação após Contato com Líquido', 2, 20000, 3.0, 6, 1),
    ('Reparo em Conector de Carga (Micro USB / Type-C)', 2, 11000, 1.5, 6, 1),
    ('Troca de Barra de LED de Smart TV', 3, 35000, 3.0, 6, 1),
    ('Reparo na Placa Principal de Smart TV', 3, 28000, 2.5, 6, 1),
    ('Conserto de Fonte de Alimentação Interna (TV)', 3, 22000, 2.0, 6, 1),
    ('Configuração de Rede e Roteador Wi-Fi', 4, 9000, 1.0, 6, 1),
    ('Higienização e Troca de Metal Líquido / Pasta Térmica (Console)', 5, 22000, 2.0, 6, 1),
    ('Reparo de Drift em Analógico de Controle (Joy-Con / DualSense / Xbox)', 5, 8000, 1.0, 6, 1),
    ('Substituição de HDMI / Conector de Vídeo (Console)', 5, 25000, 2.5, 6, 1),
    ('Troca de Bateria de Caixa de Som Portátil (Bluetooth)', 6, 12000, 1.5, 6, 1),
    ('Troca de Almofadas / Reparo de Cabo de Headset Gamer', 6, 7000, 1.0, 6, 1),
    ('Recuperação de Dados de HD / SSD / Pendrive Danificado', 7, 30000, 4.0, 6, 1),
    ('Rebaling / Reparo de BGA em Placa Mãe ou Placa de Vídeo', 8, 45000, 5.0, 6, 1),
    ('Gravação e Reprogramação de BIOS Eprom (Notebook / Desktop)', 8, 16000, 2.0, 6, 1),
    ('Troca de Vidro Traseiro de Smartphone a Laser / Manual', 2, 18000, 2.5, 6, 1),
    ('Reparo e Solda de Conector Jack P2/P10 de Mesa de Som ou Amplificador', 6, 9500, 1.0, 6, 1);

CREATE TABLE peca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL COLLATE NOCASE UNIQUE,
    id_categoria INTEGER NOT NULL,
    preco_compra INTEGER NOT NULL,
    preco_venda INTEGER NOT NULL,
    estoque_atual INTEGER NOT NULL DEFAULT 0 CHECK (estoque_atual >= 0),
    id_funcionario INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
    status INTEGER NOT NULL DEFAULT 1,
    data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id)
) STRICT;

INSERT INTO peca (nome, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_cargo)
VALUES
    ('SSD NVMe 512GB M.2', 9, 14000, 26000, 15, 7, 1),
    ('SSD SATA III 480GB 2.5"', 9, 11000, 21000, 20, 7, 1),
    ('Memória RAM DDR4 8GB 2666MHz (Notebook)', 9, 9000, 17000, 12, 7, 1),
    ('Memória RAM DDR4 16GB 3200MHz (Desktop)', 9, 18000, 32000, 8, 7, 1),
    ('Pasta Térmica de Alta Performance (Bisnaga 4g)', 10, 2500, 6000, 25, 7, 1),
    ('Fonte ATX 500W 80 Plus Bronze', 9, 19000, 34000, 6, 7, 1),
    ('Bateria Célula Moeda CR2032 (Cartela c/ 5)', 10, 800, 2500, 30, 7, 1),
    ('Cooler para Processador Socket Universal', 9, 4500, 9500, 10, 7, 1),
    ('Cabo SATA III 6Gbps 50cm', 11, 300, 1500, 50, 7, 1),
    ('Tela LED 15.6" Slim 30 Pinos Full HD', 12, 28000, 48000, 5, 7, 1),
    ('Display Frontal Completo iPhone 11', 12, 18000, 35000, 4, 7, 1),
    ('Display Frontal Completo Samsung Galaxy A54', 12, 16000, 31000, 6, 7, 1),
    ('Display Frontal Completo Motorola Moto G84', 12, 14000, 28000, 5, 7, 1),
    ('Bateria Compatível iPhone 11 (3110mAh)', 13, 7500, 16000, 8, 7, 1),
    ('Bateria Compatível Samsung Galaxy A32', 13, 6000, 13000, 7, 7, 1),
    ('Bateria Compatível Moto G30', 13, 5500, 12000, 6, 7, 1),
    ('Conector de Carga Type-C Universal (Unidade)', 14, 250, 2000, 100, 7, 1),
    ('Conector de Carga Micro USB V8', 14, 150, 1500, 100, 7, 1),
    ('Flex de Carga e Microfone Moto G9 Play', 14, 1800, 5500, 10, 7, 1),
    ('Tampa Traseira de Vidro iPhone 12', 15, 4000, 11000, 4, 7, 1),
    ('Câmera Traseira Principal Redmi Note 11', 14, 6500, 14000, 3, 7, 1),
    ('Alto-Falante Auricular Universal', 14, 500, 2500, 40, 7, 1),
    ('Barra de LED TV Samsung 50" (Kit com 3 barras)', 16, 11000, 23000, 4, 7, 1),
    ('Barra de LED TV LG 43" (Kit com 3 barras)', 16, 9500, 19500, 5, 7, 1),
    ('Placa Fonte TV Samsung UN50TU8000', 16, 16000, 31000, 2, 7, 1),
    ('Placa Principal TV LG 43UP7500', 16, 21000, 42000, 2, 7, 1),
    ('Cabo Flat T-Con para Display TV 55"', 16, 2200, 6500, 8, 7, 1),
    ('Receptor Infravermelho para Controle Remoto TV', 14, 400, 2000, 15, 7, 1),
    ('Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)', 10, 8500, 15000, 3, 7, 1),
    ('Álcool Isopropílico 99.8% 1 Litro', 10, 2200, 4500, 12, 7, 1),
    ('Fita Kapton Térmica 10mm x 33m', 10, 1200, 3000, 15, 7, 1),
    ('Fita Dupla Face Fixação de Telas (3mm x 50m)', 10, 1500, 3500, 10, 7, 1),
    ('Fusível de Louça 5A 250V (Pacote c/ 10)', 14, 500, 1800, 20, 7, 1),
    ('Capacitor Eletrolítico 1000uF x 25V', 14, 80, 500, 150, 7, 1);

CREATE TABLE entrada_peca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_peca INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK(quantidade > 0),
    preco_custo INTEGER NOT NULL,
    preco_sugerido_venda INTEGER NOT NULL,
    data_entrada TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    id_funcionario INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK(id_funcionario_cargo = 1),
    observacao TEXT,
    FOREIGN KEY (id_peca) REFERENCES peca(id),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

CREATE TABLE forma_pagamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_forma_pagamento TEXT NOT NULL COLLATE NOCASE UNIQUE,
    id_funcionario INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK(id_funcionario_cargo = 1),
    data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

INSERT INTO forma_pagamento (nome_forma_pagamento, id_funcionario, id_funcionario_cargo)
VALUES
    ('Dinheiro', 6, 1),
    ('Cartão de Crédito', 6, 1),
    ('Cartão de Débito', 6, 1),
    ('Pix', 6, 1),
    ('Boleto', 6, 1);

CREATE TABLE ordem (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    id_equipamento INTEGER NOT NULL,
    id_tecnico INTEGER NOT NULL,
    id_atendente INTEGER NOT NULL,
    data_entrada TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    defeito_relato TEXT NOT NULL,
    status_atual TEXT NOT NULL CHECK(status_atual IN ('Aberto','Em Diagnóstico','Orçamento Aprovado','Em Reparo','Pronto','Entregue','Cancelado')),
    valor_total INTEGER NOT NULL DEFAULT 0 CHECK(valor_total >= 0),
    id_forma_pagamento INTEGER,
    data_fechamento TEXT,
    observacao TEXT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    FOREIGN KEY (id_equipamento) REFERENCES equipamento(id),
    FOREIGN KEY (id_tecnico) REFERENCES funcionario(id),
    FOREIGN KEY (id_atendente) REFERENCES funcionario(id),
    FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id)
) STRICT;

INSERT INTO ordem (id_cliente, id_equipamento, id_tecnico, id_atendente, defeito_relato, status_atual, id_forma_pagamento)
VALUES
    (1, 1, 1, 4, 'Tela trincada e bateria com falha', 'Orçamento Aprovado', 4),
    (2, 2, 2, 5, 'Notebook lento e sem inicialização', 'Em Diagnóstico', NULL),
    (3, 3, 1, 4, 'Celular reiniciando sozinho', 'Aberto', NULL);

CREATE TABLE ordem_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    status_anterior TEXT,
    status_novo TEXT NOT NULL CHECK(status_novo IN ('Aberto','Em Diagnóstico','Orçamento Aprovado','Em Reparo','Pronto','Entregue','Cancelado')),
    data_alteracao TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    id_funcionario INTEGER NOT NULL,
    observacao TEXT,
    FOREIGN KEY (id_ordem) REFERENCES ordem(id),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
) STRICT;

CREATE TABLE ordem_servico (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    id_servico INTEGER NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1 CHECK(quantidade > 0),
    valor_aplicado INTEGER NOT NULL CHECK(valor_aplicado >= 0),
    data_execucao TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    id_tecnico INTEGER NOT NULL,
    FOREIGN KEY (id_ordem) REFERENCES ordem(id),
    FOREIGN KEY (id_servico) REFERENCES servico(id),
    FOREIGN KEY (id_tecnico) REFERENCES funcionario(id)
) STRICT;

INSERT INTO ordem_servico (id_ordem, id_servico, quantidade, valor_aplicado, id_tecnico)
VALUES
    (1, 6, 1, 15000, 1),
    (2, 1, 1, 12000, 2),
    (3, 7, 1, 9000, 1);

CREATE TABLE ordem_peca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    id_peca INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK(quantidade > 0),
    valor_unitario INTEGER NOT NULL CHECK(valor_unitario >= 0),
    valor_total INTEGER NOT NULL CHECK(valor_total >= 0),
    data_uso TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    id_tecnico INTEGER NOT NULL,
    FOREIGN KEY (id_ordem) REFERENCES ordem(id),
    FOREIGN KEY (id_peca) REFERENCES peca(id),
    FOREIGN KEY (id_tecnico) REFERENCES funcionario(id)
) STRICT;

INSERT INTO ordem_peca (id_ordem, id_peca, quantidade, valor_unitario, valor_total, id_tecnico)
VALUES
    (1, 12, 1, 31000, 31000, 1),
    (2, 1, 1, 26000, 26000, 2),
    (3, 15, 1, 16000, 16000, 1);

CREATE TABLE saida_peca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_peca INTEGER NOT NULL,
    id_ordem INTEGER,
    quantidade INTEGER NOT NULL CHECK(quantidade > 0),
    valor_unitario INTEGER NOT NULL CHECK(valor_unitario >= 0),
    valor_total INTEGER NOT NULL CHECK(valor_total >= 0),
    motivo TEXT NOT NULL CHECK(motivo IN ('OS', 'DESCARTE')),
    data_saida TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    id_funcionario INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK(id_funcionario_cargo IN (1,3)),
    id_tecnico INTEGER,
    FOREIGN KEY (id_peca) REFERENCES peca(id),
    FOREIGN KEY (id_ordem) REFERENCES ordem(id),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo),
    FOREIGN KEY (id_tecnico) REFERENCES funcionario(id)
) STRICT;

INSERT INTO saida_peca (id_peca, id_ordem, quantidade, valor_unitario, valor_total, motivo, data_saida, id_funcionario, id_funcionario_cargo, id_tecnico)
VALUES
    (12, 1, 1, 31000, 31000, 'OS', DATETIME('now','localtime'), 1, 1, 1),
    (1, 2, 1, 26000, 26000, 'OS', DATETIME('now','localtime'), 1, 1, 2),
    (15, 3, 1, 16000, 16000, 'OS', DATETIME('now','localtime'), 1, 1, 1);

CREATE TABLE gasto_os (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    tipo TEXT NOT NULL CHECK(tipo IN ('servico', 'peca')),
    id_referencia INTEGER NOT NULL,
    valor_total INTEGER NOT NULL CHECK(valor_total >= 0),
    data_registro TEXT NOT NULL DEFAULT (DATETIME('now','localtime')),
    FOREIGN KEY (id_ordem) REFERENCES ordem(id)
) STRICT;

INSERT INTO gasto_os (id_ordem, tipo, id_referencia, valor_total)
VALUES
    (1, 'servico', 6, 15000),
    (1, 'peca', 12, 31000),
    (2, 'servico', 1, 12000),
    (2, 'peca', 1, 26000),
    (3, 'servico', 7, 9000),
    (3, 'peca', 15, 16000);


