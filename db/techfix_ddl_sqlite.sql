PRAGMA foreign_keys = ON;
BEGIN;
CREATE TABLE IF NOT EXISTS cargo (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 nome_cargo TEXT NOT NULL UNIQUE CHECK (nome_cargo IN ('Atendente','Tecnico','Gerente')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1))
) STRICT;
CREATE TABLE IF NOT EXISTS funcionario (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 nome_funcionario TEXT NOT NULL,
 email TEXT UNIQUE,
 telefone TEXT,
 senha_hash TEXT NOT NULL,
 id_cargo INTEGER NOT NULL,
 data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 FOREIGN KEY(id_cargo) REFERENCES cargo(id)
) STRICT;
CREATE TABLE IF NOT EXISTS cliente (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 nome_cliente TEXT NOT NULL,
 telefone TEXT NOT NULL UNIQUE,
 email TEXT,
 data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 id_funcionario INTEGER NOT NULL,
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
CREATE TABLE IF NOT EXISTS marca (
 id INTEGER PRIMARY KEY AUTOINCREMENT, nome_marca TEXT NOT NULL UNIQUE,
 id_funcionario INTEGER NOT NULL, data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
CREATE TABLE IF NOT EXISTS modelo (
 id INTEGER PRIMARY KEY AUTOINCREMENT, nome_modelo TEXT NOT NULL,
 id_funcionario INTEGER NOT NULL, data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id), UNIQUE(nome_modelo)
) STRICT;
CREATE TABLE IF NOT EXISTS tipo (
 id INTEGER PRIMARY KEY AUTOINCREMENT, nome_tipo TEXT NOT NULL UNIQUE,
 id_funcionario INTEGER NOT NULL, data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
CREATE TABLE IF NOT EXISTS equipamento (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 id_marca INTEGER NOT NULL, id_modelo INTEGER NOT NULL, id_tipo INTEGER NOT NULL,
 id_cliente INTEGER NOT NULL, id_funcionario INTEGER NOT NULL,
 numero_serie TEXT UNIQUE, imei TEXT UNIQUE,
 data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 FOREIGN KEY(id_marca) REFERENCES marca(id), FOREIGN KEY(id_modelo) REFERENCES modelo(id),
 FOREIGN KEY(id_tipo) REFERENCES tipo(id), FOREIGN KEY(id_cliente) REFERENCES cliente(id),
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id),
 CHECK(numero_serie IS NOT NULL OR imei IS NOT NULL)
) STRICT;
CREATE TABLE IF NOT EXISTS categoria (
 id INTEGER PRIMARY KEY AUTOINCREMENT, nome_categoria TEXT NOT NULL UNIQUE,
 id_funcionario INTEGER NOT NULL, data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
CREATE TABLE IF NOT EXISTS servico (
 id INTEGER PRIMARY KEY AUTOINCREMENT, nome_servico TEXT NOT NULL UNIQUE,
 id_categoria INTEGER NOT NULL, preco INTEGER NOT NULL CHECK(preco >= 0),
 horas_trabalho REAL NOT NULL CHECK(horas_trabalho > 0), id_funcionario INTEGER NOT NULL,
 data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 FOREIGN KEY(id_categoria) REFERENCES categoria(id), FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
CREATE TABLE IF NOT EXISTS peca (
 id INTEGER PRIMARY KEY AUTOINCREMENT, nome_peca TEXT NOT NULL UNIQUE,
 id_categoria INTEGER NOT NULL, preco_venda INTEGER NOT NULL CHECK(preco_venda >= 0),
 estoque_atual INTEGER NOT NULL DEFAULT 0 CHECK(estoque_atual >= 0),
 id_funcionario INTEGER NOT NULL, data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 FOREIGN KEY(id_categoria) REFERENCES categoria(id), FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
CREATE TABLE IF NOT EXISTS situacao (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 nome_situacao TEXT NOT NULL UNIQUE CHECK(nome_situacao IN ('Aberto','Em Diagnóstico','Orçamento Aprovado','Em Reparo','Pronto','Entregue','Cancelado')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1))
) STRICT;
CREATE TABLE IF NOT EXISTS forma_pagamento (
 id INTEGER PRIMARY KEY AUTOINCREMENT, nome_forma_pagamento TEXT NOT NULL UNIQUE,
 id_funcionario INTEGER NOT NULL, data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 status INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0,1)),
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
CREATE TABLE IF NOT EXISTS ordem (
 id INTEGER PRIMARY KEY AUTOINCREMENT, id_equipamento INTEGER NOT NULL,
 defeito_relatado TEXT NOT NULL, defeito_constatado TEXT,
 data_abertura TEXT NOT NULL DEFAULT (datetime('now','localtime')), data_fechamento TEXT,
 valor_total INTEGER NOT NULL DEFAULT 0 CHECK(valor_total >= 0),
 id_forma_pagamento INTEGER, id_situacao_atual INTEGER NOT NULL,
 id_funcionario_abertura INTEGER NOT NULL, id_tecnico INTEGER,
 FOREIGN KEY(id_equipamento) REFERENCES equipamento(id),
 FOREIGN KEY(id_forma_pagamento) REFERENCES forma_pagamento(id),
 FOREIGN KEY(id_situacao_atual) REFERENCES situacao(id),
 FOREIGN KEY(id_funcionario_abertura) REFERENCES funcionario(id),
 FOREIGN KEY(id_tecnico) REFERENCES funcionario(id),
 CHECK(data_fechamento IS NULL OR data_fechamento >= data_abertura),
 CHECK((data_fechamento IS NULL AND id_forma_pagamento IS NULL) OR (data_fechamento IS NOT NULL AND id_forma_pagamento IS NOT NULL))
) STRICT;
CREATE TABLE IF NOT EXISTS ordem_situacao (
 id INTEGER PRIMARY KEY AUTOINCREMENT, id_ordem INTEGER NOT NULL,
 id_nova_situacao INTEGER NOT NULL, id_funcionario INTEGER NOT NULL,
 data_situacao TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 FOREIGN KEY(id_ordem) REFERENCES ordem(id), FOREIGN KEY(id_nova_situacao) REFERENCES situacao(id),
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
CREATE TABLE IF NOT EXISTS ordem_servico (
 id INTEGER PRIMARY KEY AUTOINCREMENT, id_ordem INTEGER NOT NULL,
 id_servico INTEGER NOT NULL, preco_praticado INTEGER NOT NULL CHECK(preco_praticado >= 0),
 quantidade INTEGER NOT NULL DEFAULT 1 CHECK(quantidade > 0),
 data_execucao TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 FOREIGN KEY(id_ordem) REFERENCES ordem(id), FOREIGN KEY(id_servico) REFERENCES servico(id),
 UNIQUE(id_ordem,id_servico)
) STRICT;
CREATE TABLE IF NOT EXISTS ordem_peca (
 id INTEGER PRIMARY KEY AUTOINCREMENT, id_ordem INTEGER NOT NULL,
 id_peca INTEGER NOT NULL, preco INTEGER NOT NULL CHECK(preco >= 0),
 quantidade INTEGER NOT NULL CHECK(quantidade > 0),
 data_saida TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 FOREIGN KEY(id_ordem) REFERENCES ordem(id), FOREIGN KEY(id_peca) REFERENCES peca(id)
) STRICT;
CREATE TABLE IF NOT EXISTS entrada_peca (
 id INTEGER PRIMARY KEY AUTOINCREMENT, id_peca INTEGER NOT NULL,
 preco_compra INTEGER NOT NULL CHECK(preco_compra >= 0),
 preco_venda_sugerido INTEGER NOT NULL CHECK(preco_venda_sugerido >= 0),
 quantidade INTEGER NOT NULL CHECK(quantidade > 0), id_funcionario INTEGER NOT NULL,
 data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 FOREIGN KEY(id_peca) REFERENCES peca(id), FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
CREATE TABLE IF NOT EXISTS saida_peca (
 id INTEGER PRIMARY KEY AUTOINCREMENT, id_peca INTEGER NOT NULL,
 preco_venda INTEGER NOT NULL CHECK(preco_venda >= 0), quantidade INTEGER NOT NULL CHECK(quantidade > 0),
 motivo_saida TEXT NOT NULL CHECK(motivo_saida IN ('Uso em Reparo','Descarte por Defeito')),
 id_ordem INTEGER, id_funcionario INTEGER NOT NULL,
 data_cadastro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 FOREIGN KEY(id_peca) REFERENCES peca(id), FOREIGN KEY(id_ordem) REFERENCES ordem(id),
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id),
 CHECK((motivo_saida='Uso em Reparo' AND id_ordem IS NOT NULL) OR (motivo_saida='Descarte por Defeito' AND id_ordem IS NULL))
) STRICT;
CREATE TABLE IF NOT EXISTS auditoria (
 id INTEGER PRIMARY KEY AUTOINCREMENT, id_funcionario INTEGER NOT NULL,
 tabela_afetada TEXT NOT NULL, operacao TEXT NOT NULL CHECK(operacao IN ('INSERT','UPDATE','DELETE')),
 registro_id INTEGER NOT NULL, descricao TEXT, data_hora TEXT NOT NULL DEFAULT (datetime('now','localtime')),
 FOREIGN KEY(id_funcionario) REFERENCES funcionario(id)
) STRICT;
-- Atualiza estoque somente por movimentos de entrada/saída.
CREATE TRIGGER IF NOT EXISTS trg_entrada_estoque AFTER INSERT ON entrada_peca BEGIN
 UPDATE peca SET estoque_atual = estoque_atual + NEW.quantidade WHERE id = NEW.id_peca;
 UPDATE peca SET preco_venda = NEW.preco_venda_sugerido WHERE id = NEW.id_peca;
END;
CREATE TRIGGER IF NOT EXISTS trg_saida_validacao BEFORE INSERT ON saida_peca BEGIN
 SELECT CASE WHEN (SELECT estoque_atual FROM peca WHERE id=NEW.id_peca) < NEW.quantidade
 THEN RAISE(ABORT,'Estoque insuficiente para a saída.') END;
 SELECT CASE WHEN NEW.motivo_saida='Uso em Reparo' AND
 (SELECT s.nome_situacao FROM ordem o JOIN situacao s ON s.id=o.id_situacao_atual WHERE o.id=NEW.id_ordem)
 NOT IN ('Orçamento Aprovado','Em Reparo')
 THEN RAISE(ABORT,'Baixa para OS permitida somente com status Orcamento Aprovado ou Em Reparo.') END;
END;
CREATE TRIGGER IF NOT EXISTS trg_saida_estoque AFTER INSERT ON saida_peca BEGIN
 UPDATE peca SET estoque_atual=estoque_atual-NEW.quantidade WHERE id=NEW.id_peca;
END;
-- A baixa vinculada à OS cria também o movimento de saída correspondente.
CREATE TRIGGER IF NOT EXISTS trg_ordem_peca_saida AFTER INSERT ON ordem_peca BEGIN
 INSERT INTO saida_peca(id_peca,preco_venda,quantidade,motivo_saida,id_ordem,id_funcionario)
 SELECT NEW.id_peca,NEW.preco,NEW.quantidade,'Uso em Reparo',NEW.id_ordem,
        COALESCE((SELECT id_tecnico FROM ordem WHERE id=NEW.id_ordem),
                 (SELECT id_funcionario_abertura FROM ordem WHERE id=NEW.id_ordem));
END;
-- Mantém o status atual e registra a trilha de status.
CREATE TRIGGER IF NOT EXISTS trg_historico_status AFTER INSERT ON ordem_situacao BEGIN
 UPDATE ordem SET id_situacao_atual=NEW.id_nova_situacao WHERE id=NEW.id_ordem;
END;
-- Bloqueia mudança direta do saldo; saldo é consequência de movimentos.
CREATE TRIGGER IF NOT EXISTS trg_peca_saldo_nao_manual BEFORE UPDATE OF estoque_atual ON peca
WHEN NEW.estoque_atual != OLD.estoque_atual AND
 NOT (EXISTS(SELECT 1 FROM entrada_peca WHERE id_peca=OLD.id) OR EXISTS(SELECT 1 FROM saida_peca WHERE id_peca=OLD.id))
BEGIN SELECT RAISE(ABORT,'Altere o estoque por meio de entrada ou saída registrada.'); END;

-- Recalcula o total da OS com os valores históricos congelados nos itens.
CREATE TRIGGER IF NOT EXISTS trg_total_servico_insert AFTER INSERT ON ordem_servico BEGIN
 UPDATE ordem SET valor_total =
   COALESCE((SELECT SUM(preco_praticado * quantidade) FROM ordem_servico WHERE id_ordem=NEW.id_ordem),0) +
   COALESCE((SELECT SUM(preco * quantidade) FROM ordem_peca WHERE id_ordem=NEW.id_ordem),0)
 WHERE id=NEW.id_ordem;
END;
CREATE TRIGGER IF NOT EXISTS trg_total_peca_insert AFTER INSERT ON ordem_peca BEGIN
 UPDATE ordem SET valor_total =
   COALESCE((SELECT SUM(preco_praticado * quantidade) FROM ordem_servico WHERE id_ordem=NEW.id_ordem),0) +
   COALESCE((SELECT SUM(preco * quantidade) FROM ordem_peca WHERE id_ordem=NEW.id_ordem),0)
 WHERE id=NEW.id_ordem;
END;
CREATE TRIGGER IF NOT EXISTS trg_total_servico_delete AFTER DELETE ON ordem_servico BEGIN
 UPDATE ordem SET valor_total =
   COALESCE((SELECT SUM(preco_praticado * quantidade) FROM ordem_servico WHERE id_ordem=OLD.id_ordem),0) +
   COALESCE((SELECT SUM(preco * quantidade) FROM ordem_peca WHERE id_ordem=OLD.id_ordem),0)
 WHERE id=OLD.id_ordem;
END;
CREATE TRIGGER IF NOT EXISTS trg_total_peca_delete AFTER DELETE ON ordem_peca BEGIN
 UPDATE ordem SET valor_total =
   COALESCE((SELECT SUM(preco_praticado * quantidade) FROM ordem_servico WHERE id_ordem=OLD.id_ordem),0) +
   COALESCE((SELECT SUM(preco * quantidade) FROM ordem_peca WHERE id_ordem=OLD.id_ordem),0)
 WHERE id=OLD.id_ordem;
END;

COMMIT;
