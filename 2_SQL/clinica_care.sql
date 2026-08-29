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

-- 1. PACIENTE (15 registros)
INSERT INTO paciente (nome_completo, cpf, data_nascimento, genero, endereco, telefone, email) VALUES
('Carlos Eduardo Silva', '111.222.333-01', '1968-03-15', 'Masculino', 'Av. Epitácio Pessoa, 1200 - João Pessoa/PB', '(83) 98811-2233', 'carlos.silva@email.com'),
('Mariana Souza Lima', '222.333.444-02', '1995-07-22', 'Feminino', 'Rua Bancário Sérgio Guerra, 450 - João Pessoa/PB', '(83) 98722-3344', 'mariana.lima@email.com'),
('Lucas Pereira Ramos', '333.444.555-03', '1982-11-05', 'Masculino', 'Av. Gov. Flávio Ribeiro Coutinho, 800 - João Pessoa/PB', '(83) 98633-4455', 'lucas.ramos@email.com'),
('Fernanda Costa Oliveira', '444.555.666-04', '2015-01-30', 'Feminino', 'Rua Manoel Arruda Cavalcanti, 102 - João Pessoa/PB', '(83) 98544-5566', 'fernanda.costa@email.com'),
('Roberto Alves Monteiro', '555.666.777-05', '1959-09-18', 'Masculino', 'Av. Cabo Branco, 2100 - João Pessoa/PB', '(83) 98455-6677', 'roberto.monteiro@email.com'),
('Juliana Barbosa Dias', '666.777.888-06', '1998-12-12', 'Feminino', 'Rua Walfredo Macedo Brandão, 305 - João Pessoa/PB', '(83) 98366-7788', 'juliana.dias@email.com'),
('Gabriel Martins Ferreira', '777.888.999-07', '1975-04-25', 'Masculino', 'Av. Esperança, 670 - João Pessoa/PB', '(83) 98277-8899', 'gabriel.martins@email.com'),
('Beatriz Nogueira Mendes', '888.999.000-08', '2004-06-14', 'Feminino', 'Rua Poeta Luiz Raimundo, 89 - João Pessoa/PB', '(83) 98188-9900', 'beatriz.mendes@email.com'),
('Thiago Rocha Cavalcanti', '999.000.111-09', '1989-08-03', 'Masculino', 'Av. Argemiro de Figueiredo, 1540 - João Pessoa/PB', '(83) 99911-0011', 'thiago.rocha@email.com'),
('Camila Farias Albuquerque', '101.202.303-10', '1993-10-20', 'Feminino', 'Rua Presidente Nilo Peçanha, 78 - João Pessoa/PB', '(83) 99822-1122', 'camila.albuquerque@email.com'),
('Antônio Moreira Guimarães', '202.303.404-11', '1962-02-17', 'Masculino', 'Av. João Maurício, 410 - João Pessoa/PB', '(83) 99733-2233', 'antonio.guimaraes@email.com'),
('Larissa Vasconcelos Brito', '303.404.505-12', '2018-05-09', 'Feminino', 'Rua Guarabira, 230 - João Pessoa/PB', '(83) 99644-3344', 'larissa.brito@email.com'),
('Rodrigo Teixeira Santos', '404.505.606-13', '1980-11-28', 'Masculino', 'Av. General Edson Ramalho, 990 - João Pessoa/PB', '(83) 99555-4455', 'rodrigo.santos@email.com'),
('Patrícia Cunha Freitas', '505.606.707-14', '1970-03-04', 'Feminino', 'Rua Professora Maria Sales, 512 - João Pessoa/PB', '(83) 99466-5566', 'patricia.freitas@email.com'),
('Bruno Cardoso Tavares', '606.707.808-15', '2001-08-19', 'Masculino', 'Av. Senador Ruy Carneiro, 300 - João Pessoa/PB', '(83) 99377-6677', 'bruno.tavares@email.com');

-- 2. MÉDICO (12 registros)
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

-- 3. ESPECIALIDADE (12 registros)
INSERT INTO especialidade (nome_especialidade, descricao, conselho_regional, tempo_medio_consulta_min, valor_base_consulta, requisito_residencia, status_ativo) VALUES
('Cardiologia', 'Diagnóstico e tratamento de patologias cardiovasculares', 'CRM', 40, 300.00, TRUE, TRUE),
('Dermatologia', 'Cuidados e tratamento de afecções dermatológicas', 'CRM', 30, 250.00, TRUE, TRUE),
('Ortopedia', 'Traumatologia e doenças do aparelho locomotor', 'CRM', 30, 280.00, TRUE, TRUE),
('Pediatria', 'Assistência integral e acompanhamento do desenvolvimento infantil', 'CRM', 45, 260.00, TRUE, TRUE),
('Neurologia', 'Diagnóstico e manejo de disfunções do sistema nervoso', 'CRM', 50, 350.00, TRUE, TRUE),
('Ginecologia e Obstetrícia', 'Saúde integral da mulher, rastreio preventivo e pré-natal', 'CRM', 40, 290.00, TRUE, TRUE),
('Endocrinologia', 'Tratamento de diabetes, obesidade e distúrbios da tireoide', 'CRM', 40, 310.00, TRUE, TRUE),
('Oftalmologia', 'Acuidade visual, refração e patologias do olho', 'CRM', 30, 270.00, TRUE, TRUE),
('Psiquiatria', 'Saúde mental, transtornos de humor e neuropsiquiátricos', 'CRM', 50, 320.00, TRUE, TRUE),
('Gastroenterologia', 'Doenças do trato gastrointestinal superior e inferior', 'CRM', 35, 290.00, TRUE, TRUE),
('Pneumologia', 'Manejo clínico de distúrbios respiratórios crônicos', 'CRM', 35, 280.00, TRUE, TRUE),
('Clínica Geral', 'Abordagem médica primária e check-up preventivo', 'CRM', 30, 200.00, FALSE, TRUE);

-- 4. MEDICO_ESPECIALIDADE (15 registros)
INSERT INTO medico_especialidade (id_medico, id_especialidade, data_obtencao_titulo, numero_rqu, instituicao_formacao, status_principal, observacao_registro) VALUES
(1, 1, '2016-01-15', 'RQU-1011', 'Hospital Universitário Lauro Wanderley (UFPB)', TRUE, 'Especialista titulado pela SBC'),
(2, 2, '2017-06-20', 'RQU-2022', 'Faculdade de Medicina da USP', TRUE, 'Membro titular da SBD'),
(3, 3, '2013-12-10', 'RQU-3033', 'Hospital das Clínicas da UFPE', TRUE, 'Especialização em trauma de joelho'),
(4, 4, '2018-03-05', 'RQU-4044', 'IMIP Recife', TRUE, 'Pediatria e neonatologia'),
(5, 5, '2011-08-30', 'RQU-5055', 'UNIFESP', TRUE, 'Neurofisiologia clínica'),
(6, 6, '2019-11-25', 'RQU-6066', 'Maternidade Cândida Vargas', TRUE, 'Ginecologia geral e pré-natal'),
(7, 7, '2015-05-18', 'RQU-7077', 'USP Ribeirão Preto', TRUE, 'Membro da SBEM'),
(8, 8, '2017-02-14', 'RQU-8088', 'Fundação Altino Ventura', TRUE, 'Cirurgia refrativa'),
(9, 9, '2010-09-08', 'RQU-9099', 'Hospital Ulysses Pernambucano', TRUE, 'Psiquiatria da infância e adulto'),
(10, 10, '2020-04-12', 'RQU-1122', 'Hospital Sírio-Libanês', TRUE, 'Endoscopia diagnóstica'),
(11, 11, '2014-07-22', 'RQU-3344', 'Hospital Otávio de Freitas', TRUE, 'Provas de função pulmonar'),
(12, 12, '2018-10-10', 'RQU-5566', 'FCM-PB', TRUE, 'Saúde preventiva'),
(1, 12, '2014-01-10', 'RQU-1012', 'UFPB', FALSE, 'Atuação complementar ambulatorial'),
(7, 12, '2013-02-20', 'RQU-7078', 'UFPE', FALSE, 'Atuação complementar ambulatorial'),
(3, 12, '2011-01-15', 'RQU-3034', 'UFPB', FALSE, 'Atuação complementar ambulatorial');

-- 5. CONSULTA (17 registros)
INSERT INTO consulta (id_paciente, id_medico, data_hora, motivo_visita, status_consulta, sala_atendimento, valor_cobrado) VALUES
(1, 1, '2026-08-01 08:30:00', 'Dor no peito e palpitações ao esforço', 'Realizada', 'Sala 101', 300.00),
(2, 2, '2026-08-01 09:15:00', 'Alergia na pele e coceira persistente', 'Realizada', 'Sala 202', 250.00),
(3, 3, '2026-08-02 10:00:00', 'Dor intensa no joelho direito pós-corrida', 'Realizada', 'Sala 105', 280.00),
(4, 4, '2026-08-03 14:00:00', 'Consulta de rotina pediátrica e febre', 'Realizada', 'Sala 301', 260.00),
(5, 5, '2026-08-04 15:30:00', 'Episódios frequentes de enxaqueca com aura', 'Realizada', 'Sala 204', 350.00),
(6, 6, '2026-08-05 08:00:00', 'Exame preventivo anual e cólicas', 'Realizada', 'Sala 108', 290.00),
(7, 7, '2026-08-06 11:00:00', 'Acompanhamento de diabetes tipo 2 e cansaço', 'Realizada', 'Sala 205', 310.00),
(8, 8, '2026-08-07 16:00:00', 'Dificuldade para enxergar de longe e vista cansada', 'Realizada', 'Sala 302', 270.00),
(9, 9, '2026-08-08 13:30:00', 'Crises de ansiedade generalizada e insônia', 'Realizada', 'Sala 210', 320.00),
(10, 10, '2026-08-10 09:00:00', 'Refluxo gastroesofágico e azia pós-refeições', 'Realizada', 'Sala 106', 290.00),
(11, 11, '2026-08-11 10:30:00', 'Falta de ar noturna e tosse seca crônica', 'Realizada', 'Sala 207', 280.00),
(12, 12, '2026-08-12 14:30:00', 'Check-up geral de rotina e fadiga', 'Realizada', 'Sala 102', 200.00),
(13, 1, '2026-08-13 11:15:00', 'Avaliação de picos hipertensivos matinais', 'Realizada', 'Sala 101', 300.00),
(14, 2, '2026-08-14 16:20:00', 'Erupção cutânea com prurido após cosmético', 'Realizada', 'Sala 202', 250.00),
(15, 3, '2026-08-15 09:40:00', 'Lombalgia súbita com irradiação', 'Cancelada', 'Sala 105', 280.00),
(1, 1, '2026-08-30 08:00:00', 'Retorno de rotina cardiológica', 'Agendada', 'Sala 101', 300.00),
(2, 2, '2026-08-30 10:00:00', 'Revisão pós-tratamento de pele', 'Agendada', 'Sala 202', 250.00);

-- 6. PRONTUÁRIO (14 registros das consultas 1 a 14)
INSERT INTO prontuario (id_consulta, id_paciente, data_registro, diagnostico, historico_doencas, alergias_relatadas, observacoes_clinicas) VALUES
(1, 1, '2026-08-01 09:10:00', 'Hipertensão Arterial Sistêmica Estágio 1 (CID I10)', 'Histórico familiar de IAM', 'Nenhuma conhecida', 'PA 145/95 mmHg. Solicitado ECG e MAPA.'),
(2, 2, '2026-08-01 09:45:00', 'Dermatite de Contato Alérgica (CID L23)', 'Rinite alérgica sazonal', 'Sulfa', 'Lesões eritematosas em membros superiores.'),
(3, 3, '2026-08-02 10:35:00', 'Tendinite Patelar Aguda (CID M76.5)', 'Cirurgia de menisco prévia', 'Dipirona', 'Edema periarticular moderado. Prescrito anti-inflamatório.'),
(4, 4, '2026-08-03 14:40:00', 'Infecção de Vias Aéreas Superiores (CID J06.9)', 'Sem histórico relevante', 'Nenhuma', 'Curva térmica em declínio após medicação sintomática.'),
(5, 5, '2026-08-04 16:15:00', 'Enxaqueca sem Aura Refratária (CID G43.0)', 'Hipertensão leve controlada', 'Penicilina', 'Crises com frequência semanal e fotofobia intensa.'),
(6, 6, '2026-08-05 08:45:00', 'Dismenorreia Primária Funcional (CID N94.4)', 'Sem comorbidades crônicas', 'Nenhuma', 'Exame físico sem massas anexiais aparentes.'),
(7, 7, '2026-08-06 11:45:00', 'Diabetes Mellitus Tipo 2 Descompensado (CID E11.9)', 'Dislipidemia mista', 'AINEs', 'HbA1c recente em 8.4%. Ajustado esquema posológico oral.'),
(8, 8, '2026-08-07 16:30:00', 'Astigmatismo Miopico Composto (CID H52.2)', 'Sem antecedentes clínicos', 'Nenhuma', 'Refração ocular bilateral concluída.'),
(9, 9, '2026-08-08 14:20:00', 'Transtorno de Ansiedade Generalizada (CID F41.1)', 'Insônia inicial crônica', 'Nenhuma', 'Paciente com queixa de tensão muscular contínua.'),
(10, 10, '2026-08-10 09:35:00', 'Doença do Refluxo Gastroesofágico (CID K21.9)', 'Gastrite superficial prévia', 'Tartrazina', 'Pirose retroesternal com queimação pós-prandial.'),
(11, 11, '2026-08-11 11:10:00', 'Asma Brônquica Moderada Persistente (CID J45.0)', 'Rinite alérgica perene', 'Iodo', 'Presença de sibilos expiratórios discretos à ausculta.'),
(12, 12, '2026-08-12 15:00:00', 'Exame Clínico Preventivo Geral (CID Z00.0)', 'Sem histórico mórbido prévio', 'Nenhuma', 'Ausência de queixas focais. Solicitado check-up laboratorial.'),
(13, 13, '2026-08-13 11:45:00', 'Hipertensão Arterial Estágio 2 (CID I10)', 'Tabagismo pregressso', 'AAS', 'PA 160/100 mmHg aferida em repouso no consultório.'),
(14, 14, '2026-08-14 16:50:00', 'Urticária Alérgica Aguda (CID L50.0)', 'Atopia cutânea familiar', 'Sulfa', 'Pápulas pruriginosas disseminadas em tronco.');

-- 7. PRESCRIÇÃO (16 registros)
INSERT INTO prescricao (id_consulta, data_emissao, medicamento, dosagem, via_administracao, frequencia_intervalo, instrucoes_uso) VALUES
(1, '2026-08-01', 'Losartana Potássica', '50mg', 'Oral', '1 comprimido ao acordar', 'Tomar com água em jejum'),
(1, '2026-08-01', 'Hidroclorotiazida', '25mg', 'Oral', '1 vez ao dia pela manhã', 'Associar com a Losartana'),
(2, '2026-08-01', 'Desloratadina', '5mg', 'Oral', '1 comprimido à noite por 10 dias', 'Evitar exposição prolongada ao sol'),
(2, '2026-08-01', 'Hidrocortisona Creme', '10mg/g', 'Tópica', 'Aplicar 2x ao dia por 7 dias', 'Lavar o local antes de passar'),
(3, '2026-08-02', 'Cetoprofeno', '150mg', 'Oral', '1 comprimido ao dia por 5 dias', 'Tomar após refeição pesada'),
(4, '2026-08-03', 'Paracetamol Gotas', '200mg/ml', 'Oral', '1 gota/kg a cada 6 horas se febre', 'Não exceder 5 doses diárias'),
(5, '2026-08-04', 'Topiramato', '25mg', 'Oral', '1 comprimido ao deitar', 'Manter boa ingestão hídrica'),
(6, '2026-08-05', 'Ácido Mefenâmico', '500mg', 'Oral', '1 comp de 8 em 8 horas se dor', 'Iniciar no primeiro dia de cólica'),
(7, '2026-08-06', 'Metformina Cloridrato XR', '850mg', 'Oral', '1 comprimido após o jantar', 'Não partir nem mastigar o comp'),
(7, '2026-08-06', 'Gliclazida MR', '30mg', 'Oral', '1 comprimido no café da manhã', 'Aferir glicemia em jejum'),
(8, '2026-08-07', 'Carmelose Sódica Colírio', '5mg/ml', 'Oftálmica', '1 gota em cada olho 4x ao dia', 'Uso contínuo para lubrificação'),
(9, '2026-08-08', 'Escitalopram Oxalato', '10mg', 'Oral', '1 comprimido pela manhã', 'Não interromper sem orientação'),
(10, '2026-08-10', 'Esomeprazol Magnésico', '40mg', 'Oral', '1 cápsula em jejum por 28 dias', 'Tomar 30 min antes do café'),
(11, '2026-08-11', 'Budesonida + Formoterol', '200/6mcg', 'Inalatória', '1 dose de 12 em 12 horas contínuo', 'Enxaguar a boca após a inalação'),
(12, '2026-08-12', 'Colecalciferol (Vit D3)', '50.000 UI', 'Oral', '1 cápsula semanal por 8 semanas', 'Tomar junto com refeição rica em gordura'),
(13, '2026-08-13', 'Amlodipino Besilato', '5mg', 'Oral', '1 comprimido à tarde', 'Adicionado para controle tensional');

-- 8. PAGAMENTO (16 registros)
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
(13, 13, 300.00, '2026-08-13 11:50:00', 'Cartão de Crédito', 'Aprovado', 'NFE-20260813-0013'),
(14, 14, 250.00, '2026-08-14 16:55:00', 'PIX', 'Aprovado', 'NFE-20260814-0014'),
(16, 1, 300.00, '2026-08-28 10:00:00', 'PIX', 'Pendente', NULL),
(17, 2, 250.00, '2026-08-28 10:30:00', 'Cartão de Crédito', 'Pendente', NULL);

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

-- 1. Faturamento total e quantidade de atendimentos realizados por médico
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

-- 2. Estatísticas de idade (Média, Mínima e Máxima) dos pacientes atendidos por especialidade
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

-- 3. Total arrecadado por método de pagamento com filtro de relevância
SELECT 
    p.metodo_pagamento,
    COUNT(p.id_pagamento) AS quantidade_transacoes,
    SUM(p.valor_total) AS total_arrecadado
FROM pagamento p
WHERE p.status_pagamento = 'Aprovado'
GROUP BY p.metodo_pagamento
HAVING SUM(p.valor_total) > 1000.00
ORDER BY total_arrecadado DESC;

-- 4. Distribuição de consultas por status e contagem de pacientes distintos
SELECT 
    c.status_consulta,
    COUNT(c.id_consulta) AS quantidade_consultas,
    COUNT(DISTINCT c.id_paciente) AS pacientes_distintos,
    ROUND(AVG(c.valor_cobrado), 2) AS ticket_medio
FROM consulta c
GROUP BY c.status_consulta;

-- ==================
-- Operações de JOIN
-- ==================

-- 5. Histórico clínico detalhado do atendimento
-- Retorna paciente, médico responsável, horário da consulta e dados do prontuário
SELECT 
    c.id_consulta,
    c.data_hora,
    p.nome_completo AS paciente,
    p.cpf AS cpf_paciente,
    m.nome_completo AS medico,
    m.crm,
    pr.diagnostico,
    pr.observacoes_clinicas
FROM consulta c
INNER JOIN paciente p ON c.id_paciente = p.id_paciente
INNER JOIN medico m ON c.id_medico = m.id_medico
INNER JOIN prontuario pr ON c.id_consulta = pr.id_consulta
ORDER BY c.data_hora DESC;

-- 6. Relatório de médicos e suas especialidades cadastradas
-- Retorna todos os médicos, inclusive aqueles sem especialidade formal registrada
SELECT 
    m.id_medico,
    m.nome_completo AS medico,
    m.crm,
    COALESCE(e.nome_especialidade, 'Nenhuma cadastrada') AS especialidade,
    COALESCE(me.numero_rqu, 'Sem RQU') AS rqu,
    me.status_principal
FROM medico m
LEFT JOIN medico_especialidade me ON m.id_medico = me.id_medico
LEFT JOIN especialidade e ON me.id_especialidade = e.id_especialidade
ORDER BY m.nome_completo;

-- 7. Rastreamento de pacientes e consultas
-- Lista todos os pacientes da base e identifica quem já possui consulta e quem ainda não agendou
SELECT 
    p.id_paciente,
    p.nome_completo AS paciente,
    p.telefone,
    c.id_consulta,
    c.data_hora,
    COALESCE(c.status_consulta, 'Sem agendamentos') AS situacao_consulta
FROM paciente p
LEFT JOIN consulta c ON p.id_paciente = c.id_paciente
ORDER BY p.id_paciente;

-- 8. Detalhamento de prescrições emitidas por paciente e médico
-- Une prescrição, consulta, paciente e médico para rastrear a receita emitida
SELECT 
    pr.id_prescricao,
    pr.data_emissao,
    p.nome_completo AS paciente,
    m.nome_completo AS medico_prescritor,
    pr.medicamento,
    pr.dosagem,
    pr.frequencia_intervalo,
    pr.instrucoes_uso
FROM prescricao pr
INNER JOIN consulta c ON pr.id_consulta = c.id_consulta
INNER JOIN paciente p ON c.id_paciente = p.id_paciente
INNER JOIN medico m ON c.id_medico = m.id_medico
ORDER BY pr.data_emissao DESC;