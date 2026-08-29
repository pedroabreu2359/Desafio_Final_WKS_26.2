-- Criando schema da clínica
CREATE SCHEMA clinica_care;

-- ================
-- Criando tabelas
-- ================

-- Paciente
CREATE TABLE paciente (
	id_paciente INT AUTO_INCREMENT,
    nome_completo VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    genero VARCHAR(20) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY(id_paciente)
);

-- Médico
CREATE TABLE medico (
    id_medico INT AUTO_INCREMENT,
    nome_completo VARCHAR(150) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    data_admissao DATE NOT NULL,
    status_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_medico)
);

-- Especialidade
CREATE TABLE especialidade (
    id_especialidade INT AUTO_INCREMENT,
    nome_especialidade VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255) NOT NULL,
    conselho_regional VARCHAR(50) NOT NULL,
    tempo_medio_consulta_min INT NOT NULL,
    valor_base_consulta DECIMAL(10,2) NOT NULL,
    requisito_residencia BOOLEAN NOT NULL DEFAULT TRUE,
    status_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_especialidade)
);

-- Medico_Especialidade (Associativa N:N)
CREATE TABLE medico_especialidade (
    id_medico_especialidade INT AUTO_INCREMENT,
    id_medico INT NOT NULL,
    id_especialidade INT NOT NULL,
    data_obtencao_titulo DATE NOT NULL,
    numero_rqu VARCHAR(30) UNIQUE,
    instituicao_formacao VARCHAR(150) NOT NULL,
    status_principal BOOLEAN NOT NULL DEFAULT FALSE,
    observacao_registro VARCHAR(255) NULL,
    PRIMARY KEY (id_medico_especialidade),
    CONSTRAINT fk_med_esp_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_med_esp_especialidade FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT un_medico_especialidade UNIQUE (id_medico, id_especialidade)
);

-- Consulta
CREATE TABLE consulta (
    id_consulta INT AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_hora DATETIME NOT NULL,
    motivo_visita VARCHAR(255) NOT NULL,
    status_consulta VARCHAR(30) NOT NULL DEFAULT 'Agendada',
    sala_atendimento VARCHAR(20) NOT NULL,
    valor_cobrado DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_consulta),
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_consulta_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Prontuário
CREATE TABLE prontuario (
    id_prontuario INT AUTO_INCREMENT,
    id_consulta INT NOT NULL UNIQUE,
    id_paciente INT NOT NULL,
    data_registro DATETIME NOT NULL,
    diagnostico VARCHAR(500) NOT NULL,
    historico_doencas TEXT NULL,
    alergias_relatadas VARCHAR(255) NULL,
    observacoes_clinicas TEXT NULL,
    PRIMARY KEY (id_prontuario),
    CONSTRAINT fk_prontuario_consulta FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prontuario_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Prescrição
CREATE TABLE prescricao (
    id_prescricao INT AUTO_INCREMENT,
    id_consulta INT NOT NULL,
    data_emissao DATE NOT NULL,
    medicamento VARCHAR(150) NOT NULL,
    dosagem VARCHAR(50) NOT NULL,
    via_administracao VARCHAR(50) NOT NULL,
    frequencia_intervalo VARCHAR(100) NOT NULL,
    instrucoes_uso VARCHAR(500) NULL,
    PRIMARY KEY (id_prescricao),
    CONSTRAINT fk_prescricao_consulta FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Pagamento
CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT,
    id_consulta INT NOT NULL UNIQUE,
    id_paciente INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME NOT NULL,
    metodo_pagamento VARCHAR(50) NOT NULL,
    status_pagamento VARCHAR(30) NOT NULL DEFAULT 'Pendente',
    comprovante_fiscal VARCHAR(255) UNIQUE NULL,
    PRIMARY KEY (id_pagamento),
    CONSTRAINT fk_pagamento_consulta FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pagamento_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ==================
-- Populando tabelas
-- ==================

-- Paciente (15 registros)
INSERT INTO paciente (nome_completo, cpf, data_nascimento, genero, endereco, telefone, email) VALUES
('Carlos Eduardo Silva', '111.222.333-01', '1985-03-15', 'Masculino', 'Av. Epitácio Pessoa, 1200 - João Pessoa/PB', '(83) 98811-2233', 'carlos.silva@email.com'),
('Mariana Souza Lima', '222.333.444-02', '1992-07-22', 'Feminino', 'Rua Bancário Sérgio Guerra, 450 - João Pessoa/PB', '(83) 98722-3344', 'mariana.lima@email.com'),
('Lucas Pereira Ramos', '333.444.555-03', '1978-11-05', 'Masculino', 'Av. Gov. Flávio Ribeiro Coutinho, 800 - João Pessoa/PB', '(83) 98633-4455', 'lucas.ramos@email.com'),
('Fernanda Costa Oliveira', '444.555.666-04', '2001-01-30', 'Feminino', 'Rua Manoel Arruda Cavalcanti, 102 - João Pessoa/PB', '(83) 98544-5566', 'fernanda.costa@email.com'),
('Roberto Alves Monteiro', '555.666.777-05', '1965-09-18', 'Masculino', 'Av. Cabo Branco, 2100 - João Pessoa/PB', '(83) 98455-6677', 'roberto.monteiro@email.com'),
('Juliana Barbosa Dias', '666.777.888-06', '1995-12-12', 'Feminino', 'Rua Walfredo Macedo Brandão, 305 - João Pessoa/PB', '(83) 98366-7788', 'juliana.dias@email.com'),
('Gabriel Martins Ferreira', '777.888.999-07', '1989-04-25', 'Masculino', 'Av. Esperança, 670 - João Pessoa/PB', '(83) 98277-8899', 'gabriel.martins@email.com'),
('Beatriz Nogueira Mendes', '888.999.000-08', '2003-06-14', 'Feminino', 'Rua Poeta Luiz Raimundo, 89 - João Pessoa/PB', '(83) 98188-9900', 'beatriz.mendes@email.com'),
('Thiago Rocha Cavalcanti', '999.000.111-09', '1973-08-03', 'Masculino', 'Av. Argemiro de Figueiredo, 1540 - João Pessoa/PB', '(83) 99911-0011', 'thiago.rocha@email.com'),
('Camila Farias Albuquerque', '101.202.303-10', '1998-10-20', 'Feminino', 'Rua Presidente Nilo Peçanha, 78 - João Pessoa/PB', '(83) 99822-1122', 'camila.albuquerque@email.com'),
('Antônio Moreira Guimarães', '202.303.404-11', '1958-02-17', 'Masculino', 'Av. João Maurício, 410 - João Pessoa/PB', '(83) 99733-2233', 'antonio.guimaraes@email.com'),
('Larissa Vasconcelos Brito', '303.404.505-12', '1990-05-09', 'Feminino', 'Rua Guarabira, 230 - João Pessoa/PB', '(83) 99644-3344', 'larissa.brito@email.com'),
('Rodrigo Teixeira Santos', '404.505.606-13', '1982-11-28', 'Masculino', 'Av. General Edson Ramalho, 990 - João Pessoa/PB', '(83) 99555-4455', 'rodrigo.santos@email.com'),
('Patrícia Cunha Freitas', '505.606.707-14', '1997-03-04', 'Feminino', 'Rua Professora Maria Sales, 512 - João Pessoa/PB', '(83) 99466-5566', 'patricia.freitas@email.com'),
('Bruno Cardoso Tavares', '606.707.808-15', '2000-08-19', 'Masculino', 'Av. Senador Ruy Carneiro, 300 - João Pessoa/PB', '(83) 99377-6677', 'bruno.tavares@email.com');

-- Médico (12 registros)
INSERT INTO medico (nome_completo, crm, cpf, telefone, email, data_admissao, status_ativo) VALUES
('Dr. Marcelo Henrique Vieira', '8910/PB', '123.456.789-01', '(83) 98800-1111', 'marcelo.vieira@clinicamed.com', '2018-02-01', TRUE),
('Dra. Ana Paula Carvalho', '9123/PB', '234.567.890-12', '(83) 98800-2222', 'ana.carvalho@clinicamed.com', '2019-05-15', TRUE),
('Dr. Renato Gomes Peixoto', '7456/PB', '345.678.901-23', '(83) 98800-3333', 'renato.peixoto@clinicamed.com', '2015-08-10', TRUE),
('Dra. Vanessa Lins Bezerra', '10234/PB', '456.789.012-34', '(83) 98800-4444', 'vanessa.bezerra@clinicamed.com', '2020-01-20', TRUE),
('Dr. Eduardo Fontes Medeiros', '6543/PB', '567.890.123-45', '(83) 98800-5555', 'eduardo.medeiros@clinicamed.com', '2014-03-12', TRUE),
('Dra. Priscila Dantas Xavier', '11456/PB', '678.901.234-56', '(83) 98800-6666', 'priscila.xavier@clinicamed.com', '2021-07-01', TRUE),
('Dr. Gustavo Henrique Neves', '8765/PB', '789.012.345-67', '(83) 98800-7777', 'gustavo.neves@clinicamed.com', '2017-11-03', TRUE),
('Dra. Helena Ribeiro Brandão', '9876/PB', '890.123.456-78', '(83) 98800-8888', 'helena.brandao@clinicamed.com', '2019-09-18', TRUE),
('Dr. Leonardo Barros Pinto', '5432/PB', '901.234.567-89', '(83) 98800-9999', 'leonardo.pinto@clinicamed.com', '2012-06-25', TRUE),
('Dra. Sofia Montenegro Castro', '12345/PB', '012.345.678-90', '(83) 98800-0000', 'sofia.castro@clinicamed.com', '2022-04-10', TRUE),
('Dr. André Luiz Barreto', '6789/PB', '135.246.357-11', '(83) 98700-1122', 'andre.barreto@clinicamed.com', '2016-10-05', TRUE),
('Dra. Cláudia Melo Gusmão', '10987/PB', '246.357.468-22', '(83) 98700-2233', 'claudia.gusmao@clinicamed.com', '2020-08-14', TRUE);

-- 3. Especialidade (12 registros)
INSERT INTO especialidade (nome_especialidade, descricao, conselho_regional, tempo_medio_consulta_min, valor_base_consulta, requisito_residencia, status_ativo) VALUES
('Cardiologia', 'Diagnóstico e tratamento de doenças do coração e vasos sanguíneos', 'CRM', 40, 300.00, TRUE, TRUE),
('Dermatologia', 'Cuidados, prevenção e tratamento de afecções da pele, cabelos e unhas', 'CRM', 30, 250.00, TRUE, TRUE),
('Ortopedia', 'Tratamento de traumas, ossos, articulações e sistema locomotor', 'CRM', 30, 280.00, TRUE, TRUE),
('Pediatria', 'Acompanhamento do desenvolvimento e saúde de crianças e adolescentes', 'CRM', 45, 260.00, TRUE, TRUE),
('Neurologia', 'Investigação e tratamento de distúrbios do sistema nervoso central e periférico', 'CRM', 50, 350.00, TRUE, TRUE),
('Ginecologia e Obstetrícia', 'Saúde do sistema reprodutor feminino e acompanhamento pré-natal', 'CRM', 40, 290.00, TRUE, TRUE),
('Endocrinologia', 'Tratamento de disfunções hormonais, diabetes e metabolismo', 'CRM', 40, 310.00, TRUE, TRUE),
('Oftalmologia', 'Saúde ocular, refração e diagnóstico de patologias da visão', 'CRM', 30, 270.00, TRUE, TRUE),
('Psiquiatria', 'Diagnóstico e manejo de transtornos mentais e comportamentais', 'CRM', 50, 320.00, TRUE, TRUE),
('Gastroenterologia', 'Aparelho digestivo, estômago, fígado e intestinos', 'CRM', 35, 290.00, TRUE, TRUE),
('Pneumologia', 'Doenças respiratórias e pulmonares', 'CRM', 35, 280.00, TRUE, TRUE),
('Clínica Geral', 'Atendimento primário, check-up preventivo e encaminhamentos', 'CRM', 30, 200.00, FALSE, TRUE);

-- 4. Medico_Especialidade (15 registros)
INSERT INTO medico_especialidade (id_medico, id_especialidade, data_obtencao_titulo, numero_rqu, instituicao_formacao, status_principal, observacao_registro) VALUES
(1, 1, '2016-01-15', 'RQU-1011', 'Hospital Universitário Lauro Wanderley (UFPB)', TRUE, 'Especialista titulado pela SBC'),
(2, 2, '2017-06-20', 'RQU-2022', 'Faculdade de Medicina da USP', TRUE, 'Membro titular da SBD'),
(3, 3, '2013-12-10', 'RQU-3033', 'Hospital das Clínicas da UFPE', TRUE, 'Especialização em cirurgia de joelho'),
(4, 4, '2018-03-05', 'RQU-4044', 'Instituto de Medicina Integral Prof. Fernando Figueira (IMIP)', TRUE, 'Pediatria e neonatologia'),
(5, 5, '2011-08-30', 'RQU-5055', 'Escola Paulista de Medicina (UNIFESP)', TRUE, 'Neurofisiologia clínica'),
(6, 6, '2019-11-25', 'RQU-6066', 'Maternidade Cândida Vargas', TRUE, 'Ginecologia geral e colposcopia'),
(7, 7, '2015-05-18', 'RQU-7077', 'Hospital das Clínicas de Ribeirão Preto (USP)', TRUE, 'Membro da SBEM'),
(8, 8, '2017-02-14', 'RQU-8088', 'Fundação Altino Ventura', TRUE, 'Cirurgia refrativa e catarata'),
(9, 9, '2010-09-08', 'RQU-9099', 'Hospital Ulysses Pernambucano', TRUE, 'Psiquiatria da infância e adolescência'),
(10, 10, '2020-04-12', 'RQU-1122', 'Hospital Sírio-Libanês', TRUE, 'Endoscopia digestiva diagnóstica'),
(11, 11, '2014-07-22', 'RQU-3344', 'Hospital Otávio de Freitas', TRUE, 'Especialista em função pulmonar'),
(12, 12, '2018-10-10', 'RQU-5566', 'Faculdade de Ciências Médicas da Paraíba', TRUE, 'Medicina preventiva e saúde comunitária'),
(1, 12, '2014-01-10', 'RQU-1012', 'Universidade Federal da Paraíba', FALSE, 'Formação complementar em clínica médica'),
(7, 12, '2013-02-20', 'RQU-7078', 'Universidade Federal de Pernambuco', FALSE, 'Atuação conjunta em clínica geral'),
(3, 12, '2011-01-15', 'RQU-3034', 'Universidade Federal da Paraíba', FALSE, 'Atuação complementar ambulatorial');

-- 5. Consulta (15 registros)
INSERT INTO consulta (id_paciente, id_medico, data_hora, motivo_visita, status_consulta, sala_atendimento, valor_cobrado) VALUES
(1, 1, '2026-08-01 08:30:00', 'Dor no peito e palpitações ao esforço', 'Realizada', 'Sala 101', 300.00),
(2, 2, '2026-08-01 09:15:00', 'Alergia na pele e coceira persistente', 'Realizada', 'Sala 202', 250.00),
(3, 3, '2026-08-02 10:00:00', 'Dor intensa no joelho direito pós-corrida', 'Realizada', 'Sala 105', 280.00),
(4, 4, '2026-08-03 14:00:00', 'Consulta de rotina pediátrica e ganho de peso', 'Realizada', 'Sala 301', 260.00),
(5, 5, '2026-08-04 15:30:00', 'Episódios frequentes de enxaqueca com aura', 'Realizada', 'Sala 204', 350.00),
(6, 6, '2026-08-05 08:00:00', 'Exame preventivo anual e ultrassom', 'Realizada', 'Sala 108', 290.00),
(7, 7, '2026-08-06 11:00:00', 'Acompanhamento de diabetes tipo 2 e insulina', 'Realizada', 'Sala 205', 310.00),
(8, 8, '2026-08-07 16:00:00', 'Dificuldade para enxergar de longe e vista cansada', 'Realizada', 'Sala 302', 270.00),
(9, 9, '2026-08-08 13:30:00', 'Tratamento de ansiedade e insônia', 'Realizada', 'Sala 210', 320.00),
(10, 10, '2026-08-10 09:00:00', 'Refluxo gastroesofágico e dor epigástrica', 'Realizada', 'Sala 106', 290.00),
(11, 11, '2026-08-11 10:30:00', 'Falta de ar noturna e tosse seca crônica', 'Realizada', 'Sala 207', 280.00),
(12, 12, '2026-08-12 14:30:00', 'Check-up geral de rotina e exames laboratoriais', 'Realizada', 'Sala 102', 200.00),
(13, 1, '2026-08-30 08:00:00', 'Retorno para avaliação de eletrocardiograma', 'Agendada', 'Sala 101', 300.00),
(14, 2, '2026-08-30 10:00:00', 'Avaliação de manchas solares nas costas', 'Agendada', 'Sala 202', 250.00),
(15, 3, '2026-08-31 15:00:00', 'Dor lombar aguda após levantamento de peso', 'Agendada', 'Sala 105', 280.00);

-- 6. Prontuário (12 registros das consultas 1 a 12)
INSERT INTO prontuario (id_consulta, id_paciente, data_registro, diagnostico, historico_doencas, alergias_relatadas, observacoes_clinicas) VALUES
(1, 1, '2026-08-01 09:10:00', 'Hipertensão Arterial Sistêmica Estágio 1 (CID I10)', 'Histórico familiar de infarto agudo', 'Nenhuma alergia conhecida', 'Pressão aferida: 145/95 mmHg. Solicitado ECG e MAPA.'),
(2, 2, '2026-08-01 09:45:00', 'Dermatite de Contato Alérgica (CID L23)', 'Rinite alérgica sazonal', 'Alergia a sulfas', 'Lesões eritematosas em membros superiores. Orientado afastar cosmético novo.'),
(3, 3, '2026-08-02 10:35:00', 'Entorse e distensão do joelho / Tendinite Patelar (CID M76.5)', 'Cirurgia de menisco prévia em 2020', 'Dipirona', 'Teste de gaveta negativo. Edema leve no tendão patelar. Indicado fisioterapia.'),
(4, 4, '2026-08-03 14:40:00', 'Crescimento e desenvolvimento adequados para a idade (CID Z00.1)', 'Nenhum antecedente patológico de relevância', 'Nenhuma', 'Curva de crescimento no percentil 50. Vacinação rigorosamente em dia.'),
(5, 5, '2026-08-04 16:15:00', 'Enxaqueca sem aura, refratária a analgésicos comuns (CID G43.0)', 'Hipertensão leve controlada', 'Penicilina', 'Crises com frequência semanal. Indicado tratamento profilático neuromodulador.'),
(6, 6, '2026-08-05 08:45:00', 'Exame ginecológico geral de rotina dentro dos limites da normalidade (CID Z01.4)', 'Nenhuma comorbidade crônica', 'Nenhuma', 'Coleta de preventivo realizada com sucesso sem intercorrências.'),
(7, 7, '2026-08-06 11:45:00', 'Diabetes Mellitus tipo 2 com controle metabólico inadequado (CID E11.9)', 'Dislipidemia mista', 'Anti-inflamatórios não esteroidais (AINEs)', 'HbA1c recente em 8.4%. Ajustado esquema posológico de antidiabéticos.'),
(8, 8, '2026-08-07 16:30:00', 'Astigmatismo miópico em ambos os olhos (CID H52.2)', 'Sem antecedentes clínicos', 'Nenhuma', 'Refração realizada. Prescrita correção óptica para uso contínuo.'),
(9, 9, '2026-08-08 14:20:00', 'Transtorno de Ansiedade Generalizada (TAG - CID F41.1)', 'Insônia inicial crônica', 'Nenhuma', 'Paciente relata sobrecarga no trabalho e taquicardia situacional. Iniciada farmacoterapia.'),
(10, 10, '2026-08-10 09:35:00', 'Doença do Refluxo Gastroesofágico sem esofagite (CID K21.9)', 'Gastrite superficial pregressa', 'Nenhuma', 'Pirose retroesternal diária. Solicitada endoscopia digestiva alta e prescrito IBP.'),
(11, 11, '2026-08-11 11:10:00', 'Asma brônquica moderada persistente (CID J45.0)', 'Rinite alérgica perene', 'Iodo e frutos do mar', 'Sibilos expiratórios difusos à ausculta. Prescrito corticoide inalatório associado a broncodilatador.'),
(12, 12, '2026-08-12 15:00:00', 'Exame médico geral de rotina / Check-up Preventivo (CID Z00.0)', 'Sem histórico mórbido prévio', 'Nenhuma', 'Exame físico sem alterações. Solicitado painel lipídico, glicemia e hemograma.');

-- 7. Prescrição (13 registros)
INSERT INTO prescricao (id_consulta, data_emissao, medicamento, dosagem, via_administracao, frequencia_intervalo, instrucoes_uso) VALUES
(1, '2026-08-01', 'Losartana Potássica', '50mg', 'Oral', '1 vez ao dia pela manhã', 'Tomar em jejum com água'),
(1, '2026-08-01', 'Hidroclorotiazida', '25mg', 'Oral', '1 vez ao dia pela manhã', 'Associar com a Losartana'),
(2, '2026-08-01', 'Desloratadina', '5mg', 'Oral', '1 comprimido à noite por 10 dias', 'Evitar exposição solar prolongada'),
(2, '2026-08-01', 'Acetato de Hidrocortisona Creme', '10mg/g', 'Tópica', 'Aplicar na área afetada de 12 em 12 horas por 7 dias', 'Lavar o local antes de aplicar'),
(3, '2026-08-02', 'Cetoprofeno', '150mg', 'Oral', '1 comprimido a cada 24 horas por 5 dias', 'Tomar logo após o almoço para proteção gástrica'),
(5, '2026-08-04', 'Topiramato', '25mg', 'Oral', '1 comprimido à noite na 1ª semana, aumentar para 50mg', 'Manter boa ingestão hídrica'),
(7, '2026-08-06', 'Metformina Cloridrato XR', '850mg', 'Oral', '1 comprimido após o jantar', 'Não mastigar nem partir o comprimido'),
(7, '2026-08-06', 'Gliclazida MR', '30mg', 'Oral', '1 comprimido antes do café da manhã', 'Acompanhar glicemia capilar em jejum'),
(8, '2026-08-07', 'Colírio Lubrificante Ocular (Carmelose Sódica)', '5mg/ml', 'Oftálmica', 'Pingar 1 gota em cada olho de 6 em 6 horas', 'Manter frasco bem fechado e refrigerado'),
(9, '2026-08-08', 'Escitalopram Oxalato', '10mg', 'Oral', '1 comprimido pela manhã', 'Não interromper o uso sem orientação médica'),
(10, '2026-08-10', 'Esomeprazol Magnésico', '40mg', 'Oral', '1 cápsula ao acordar por 28 dias', 'Ingerir 30 minutos antes da primeira refeição'),
(11, '2026-08-11', 'Budesonida + Fumarato de Formoterol', '200/6mcg', 'Inalatória', 'Inalar 1 dose de 12 em 12 horas contínuo', 'Enxaguar a boca com água após a inalação'),
(12, '2026-08-12', 'Colecalciferol (Vitamina D3)', '50.000 UI', 'Oral', '1 cápsula por semana durante 8 semanas', 'Tomar junto com refeição com gordura boa');

-- 8. Pagamento (13 registros)
INSERT INTO pagamento (id_consulta, id_paciente, valor_total, data_pagamento, metodo_pagamento, status_pagamento, comprovante_fiscal) VALUES
(1, 1, 300.00, '2026-08-01 09:15:00', 'PIX', 'Aprovado', 'NFE-20260801-0001'),
(2, 2, 250.00, '2026-08-01 09:50:00', 'Cartão de Crédito', 'Aprovado', 'NFE-20260801-0002'),
(3, 3, 280.00, '2026-08-02 10:40:00', 'Cartão de Débito', 'Aprovado', 'NFE-20260802-0003'),
(4, 4, 260.00, '2026-08-03 14:45:00', 'PIX', 'Aprovado', 'NFE-20260803-0004'),
(5, 5, 350.00, '2026-08-04 16:20:00', 'Dinheiro', 'Aprovado', 'NFE-20260804-0005'),
(6, 6, 290.00, '2026-08-05 08:50:00', 'PIX', 'Aprovado', 'NFE-20260805-0006'),
(7, 7, 310.00, '2026-08-06 11:50:00', 'Cartão de Crédito', 'Aprovado', 'NFE-20260806-0007'),
(8, 8, 270.00, '2026-08-07 16:35:00', 'Cartão de Débito', 'Aprovado', 'NFE-20260807-0008'),
(9, 9, 320.00, '2026-08-08 14:25:00', 'PIX', 'Aprovado', 'NFE-20260808-0009'),
(10, 10, 290.00, '2026-08-10 09:40:00', 'Cartão de Crédito', 'Aprovado', 'NFE-20260810-0010'),
(11, 11, 280.00, '2026-08-11 11:15:00', 'PIX', 'Aprovado', 'NFE-20260811-0011'),
(12, 12, 200.00, '2026-08-12 15:05:00', 'Dinheiro', 'Aprovado', 'NFE-20260812-0012'),
(13, 13, 300.00, '2026-08-28 10:00:00', 'PIX', 'Pendente', NULL);

-- ====================
-- Operações de UPDATE
-- ====================

-- Atualizar o status e a sala de uma consulta confirmada
UPDATE consulta
SET status_consulta = 'Realizada', sala_atendimento = 'Sala 103'
WHERE id_consulta = 13;

-- Confirmar o pagamento pendente e registrar o código da nota fiscal
UPDATE pagamento
SET status_pagamento = 'Aprovado', comprovante_fiscal = 'NFE-20260828-0013'
WHERE id_pagamento = 13;

-- Reajuste de 8% no valor base da consulta de Cardiologia e Neurologia
UPDATE especialidade
SET valor_base_consulta = valor_base_consulta * 1.08
WHERE nome_especialidade IN ('Cardiologia', 'Neurologia');

-- ================================================
-- Consultas de agregação/agrupamento
-- (COUNT, SUM, AVG, MAX, MIN e GROUP BY / HAVING)
-- ================================================

-- 1. Faturamento total e quantidade de consultas realizadas por médico
SELECT
	m.nome_completo AS medico,
    m.crm,
    COUNT(c.id_consulta) AS total_consultas_realizadas,
    SUM(c.valor_cobrado) AS faturamento_total
FROM medico m
JOIN consulta c ON m.id_medico = c.id_medico
WHERE c.status_consulta = 'Realizada'
GROUP BY m.id_medico, m.nome_completo, m.crm
ORDER BY faturamento_total DESC;

-- 2. Estatísticas de idade dos pacientes atendidos por especialidade
-- (Média de idade, mais jovem e mais velho)
SELECT 
    e.nome_especialidade,
    COUNT(c.id_consulta) AS total_atendimentos,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, p.data_nascimento, CURDATE())), 1) AS idade_media_pacientes,
    MIN(TIMESTAMPDIFF(YEAR, p.data_nascimento, CURDATE())) AS idade_minima,
    MAX(TIMESTAMPDIFF(YEAR, p.data_nascimento, CURDATE())) AS idade_maxima
FROM especialidade e
JOIN medico_especialidade me ON e.id_especialidade = me.id_especialidade
JOIN medico m ON me.id_medico = m.id_medico
JOIN consulta c ON m.id_medico = c.id_medico
JOIN paciente p ON c.id_paciente = p.id_paciente
WHERE me.status_principal = TRUE AND c.status_consulta = 'Realizada'
GROUP BY e.id_especialidade, e.nome_especialidade
ORDER BY total_atendimentos DESC;