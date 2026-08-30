# Desafio Final WKS 26.2 - ClínicaCare

Projeto final de análise de dados da **Fábrica de Software 2026.2** que percorre todo o ciclo de uma solução de BI/Data: **modelagem de banco de dados → SQL → Python (limpeza, visualização e Machine Learning) → dashboard em Power BI**, usando como estudo de caso os dados de atendimento de uma clínica médica fictícia chamada **ClínicaCare**.

O objetivo é diagnosticar o funcionamento da clínica (faturamento, ocupação de agenda, especialidades, convênios) e prever o risco de **no-show** (paciente que agenda e não comparece à consulta), gerando recomendações de negócio a partir dos dados.

## Estrutura do repositório

```
Desafio_Final_WKS_26.2/
├── 1_Modelagem/
│   ├── Modelo_Conceitual_ER.brM3      # Diagrama ER (arquivo do brModelo)
│   ├── Modelo_Conceitual_ER.png       # Diagrama ER exportado em imagem
│   └── Modelo_Logico.txt              # Modelo lógico das tabelas (colunas, tipos, chaves)
├── 2_SQL/
│   ├── clinica_care.sql               # Script completo: DDL, inserts e consultas
│   ├── Analise_Consultas.docx         # Documento com objetivo/insights de cada consulta SQL
│   └── Resultados das consultas/      # Resultado (CSV) de cada uma das 8 consultas
├── 3_Python/
│   ├── analise_clinica.ipynb          # Notebook: EDA, visualizações e modelos de ML
│   └── dados_limpos.csv               # Base tratada usada no notebook
├── 4_Power_BI/
│   ├── Dashboard_ClinicaCare.pbix     # Dashboard interativo em Power BI
│   ├── Insights_Dashboard.docx        # Insights e recomendações extraídas do dashboard
│   └── dados.csv                      # Base usada para alimentar o dashboard
└── README.md
```

## Modelagem de dados

Modelo entidade-relacionamento da clínica com 8 entidades: `Paciente`, `Médico`, `Especialidade`, `Medico_Especialidade` (associativa N:N), `Consulta`, `Prontuário`, `Prescrição` e `Pagamento`. O modelo conceitual foi feito no **brModelo** e detalhado em um modelo lógico com tipos de dado e chaves primárias/estrangeiras.

## SQL

Script MySQL (`clinica_care.sql`) que:
- Cria o schema `clinica_care` e as 8 tabelas com suas constraints (PK, FK, UNIQUE, DEFAULT);
- Popula as tabelas com dados fictícios (pacientes, médicos, especialidades, consultas, prontuários, prescrições e pagamentos);
- Executa operações de `UPDATE` (ex.: confirmar pagamento pendente, reajustar valor de consulta);
- Traz 8 consultas de análise combinando `GROUP BY`/`HAVING`, funções de agregação (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`) e diferentes tipos de `JOIN` (`INNER` e `LEFT`), cobrindo temas como faturamento por médico, perfil etário por especialidade, formas de pagamento mais relevantes, taxa de conclusão de agenda, histórico clínico, mapeamento de especialidades e rastreabilidade de prescrições.

O documento `Analise_Consultas.docx` traz o objetivo e os principais insights de cada uma dessas 8 consultas.

## Python

Notebook `analise_clinica.ipynb` com:
- Carregamento e análise exploratória da base `dados_limpos.csv` (pandas/NumPy);
- Visualizações com Matplotlib/Seaborn: taxa de no-show por especialidade, proporção de consultas realizadas x canceladas, evolução mensal da taxa de no-show;
- Treinamento e comparação de dois modelos de classificação (**Regressão Logística** e **Árvore de Decisão**, via scikit-learn) para prever a probabilidade de um paciente faltar à consulta, avaliados por acurácia, ROC AUC e recall da classe "no-show";
- Aplicação do modelo às consultas futuras já agendadas, gerando um score de risco (Alto/Baixo Risco) por paciente.

## Power BI

Dashboard `Dashboard_ClinicaCare.pbix` com 5 painéis: receita total, taxa de no-shows por mês, faturamento por mês, distribuição de pacientes por plano de saúde e volume de consultas por especialidade. O arquivo `Insights_Dashboard.docx` resume os principais achados, como a alta dependência da receita em relação a um único convênio e a maior taxa de no-show em Pediatria, junto com recomendações de negócio para mitigar esses riscos.

## Como explorar o projeto

1. **Modelagem**: abra `Modelo_Conceitual_ER.png` para visualizar o diagrama, ou o `.brM3` no brModelo.
2. **SQL**: execute `clinica_care.sql` em um servidor MySQL para recriar o schema, os dados e rodar as consultas.
3. **Python**: abra `analise_clinica.ipynb` no Jupyter (requer `pandas`, `numpy`, `matplotlib`, `seaborn`, `scikit-learn`) e execute as células em ordem.
4. **Power BI**: abra `Dashboard_ClinicaCare.pbix` no Power BI Desktop para interagir com o dashboard.
