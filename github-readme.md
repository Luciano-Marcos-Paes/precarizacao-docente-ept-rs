# 🗺️ Repositório: Contratos Temporários e Precarização do Trabalho Pedagógico na EP Gaúcha

[![R-Language](https://img.shields.io/badge/Language-R-blue.svg)](https://www.r-project.org/)
[![Open-Science](https://img.shields.io/badge/Science-Open%20Science-green.svg)](https://en.wikipedia.org/wiki/Open_science)
[![LGPD-Compliant](https://img.shields.io/badge/Compliance-LGPD%20Compliant-brightgreen.svg)](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

Este repositório reúne os códigos-fonte (scripts em R), as bases de dados agregadas em formato CSV e os gráficos gerados para o Trabalho de Conclusão de Curso (TCC) na Especialização em Docência da EPT do Instituto Federal do Rio Grande do Sul (IFRS) — Campus Sertão [172, 415]:

> **Contratos Temporários e Precarização do Trabalho Pedagógico na Educação Profissional da Rede Estadual do Rio Grande do Sul**
> 
> **Autor:** Luciano Marcos Paes [172, 415]  
> **Orientadora:** Profa. Dra. Ana Sara Castaman [172, 416]

O estudo analisa as contradições entre as exigências teórico-pedagógicas do Referencial Curricular Gaúcho do Ensino Médio (RCGEM), aprovado em 2021 sob a gestão de Eduardo Leite [460], e a materialidade concreta das escolas estaduais de Educação Profissional, caracterizadas por uma acentuada dependência de vínculos docentes temporários e precarizados [137, 435, 457].

---

## 📂 Estrutura do Repositório

```text
├── data/
│   ├── base_rs_estadual_ept_2025.csv             # Microdados filtrados e agregados para escolas de EPT
│   ├── base_rs_estadual_completa_2025.csv        # Universo completo da rede estadual gaúcha em 2025
│   ├── distribuicao_faixas_precarizacao_2025.csv # Percentual de escolas por faixa de temporários
│   └── resumo_geral_2025.csv                     # Principais indicadores estatísticos compilados
├── scripts/
│   ├── 01_limpeza_e_filtragem.R                  # Importação de microdados brutos do INEP e filtros (CO_UF == 43)
│   ├── 02_analise_estatistica.R                  # Cruzamento de variáveis, regressões e cálculo de frequências
│   └── 03_geracao_graficos.R                     # Script de visualização de dados usando ggplot2
└── plots/
    ├── grafico_faixa_precarizacao.png            # Distribuição das escolas de EPT por faixas de contratação
    └── grafico_doc_ept_temporarios.png           # Comparação de vínculos temporários vs concursados
```

---

## 📊 Principais Descobertas Empíricas (Ano-Base: 2025)

Os microdados processados a partir do Censo Escolar da Educação Básica (INEP, 2026) revelam os seguintes indicadores estruturais na rede estadual de Educação Profissional do Rio Grande do Sul:

1. **Universo de Análise:** Foram identificadas e analisadas **386 escolas estaduais** que ofertam Educação Profissional no estado [137].
2. **Taxa Média de Precarização:** Em média, **67,04%** do corpo docente de uma escola de Educação Profissional gaúcha é composto por professores temporários, atingindo uma mediana de **68,75%** [137].
3. **Dependência Crítica:** O esvaziamento do quadro funcional de carreira e a dependência de contratos precários atingem a escala de **85,24%** de todas as escolas gaúchas de EP (com mais de 50% de seus professores sob regime temporário), sendo que em **28,50%** delas a taxa de temporários supera a marca de **75%** de todo o quadro docente [5, 137].
4. **Casos Extremos:** Instituições tradicionais estruturam-se com taxas críticas de pessoal temporário, tais como:
   * **Escola Estadual de Educação Básica Apeles Porto Alegre** (Porto Alegre): **96,67%** de vínculos temporários [136].
   * **Escola Estadual Técnica Agrícola Desidério Finamor** (Lagoa Vermelha): **95,24%** de vínculos temporários [136].

---

## 📋 Dicionário de Variáveis (Bases CSV)

As tabelas de microdados agregadas por escola na pasta `/data` utilizam a seguinte nomenclatura de variáveis:

| Variável | Descrição |
| :--- | :--- |
| `co_entidade` | Código INEP identificador único da escola [1, 136] |
| `no_entidade` | Nome oficial da instituição escolar [1, 136] |
| `no_municipio` | Município de localização da escola [1, 136] |
| `qt_doc_bas_vinculo_concur` | Quantidade de docentes públicos concursados (efetivos) na escola [136] |
| `qt_doc_bas_vinculo_contra` | Quantidade de docentes públicos contratados de forma temporária/emergencial [136] |
| `perc_temporarios` | Taxa de professores sob regime temporário (temporários / total de docentes) [136] |
| `doc_ept` | Quantidade total de docentes que atuam na Educação Profissional na unidade [136] |
| `tur_ept` | Quantidade total de turmas ativas de Educação Profissional na unidade [136] |
| `qt_doc_bas_disc_profissiona`| Quantidade de docentes alocados em disciplinas técnicas/profissionais [136] |

---

## 💻 Como Reproduzir a Análise em R

Para reproduzir os resultados estatísticos e os gráficos do estudo em seu ambiente local, certifique-se de ter o [R](https://www.r-project.org/) e o [RStudio](https://posit.co/download/rstudio-desktop/) instalados.

### 1. Clonar o Repositório
```bash
git clone [https://github.com/lucianomarcospaes/dados-tcc-ept.gi](https://github.com/Luciano-Marcos-Paes/precarizacao-docente-ept-rs
cd precarizacao-docente-ept-rs
```

### 2. Instalar Pacotes Requeridos
Abra o console do R e instale as bibliotecas necessárias:
```R
install.packages(c("tidyverse", "ggplot2", "scales"))
```

### 3. Código de Exemplo para Carregar Dados e Plotar Gráfico
Você pode executar o trecho abaixo no R para gerar a distribuição das escolas gaúchas de EPT conforme as faixas de contratação temporária:

```R
library(tidyverse)
library(scales)

# 1. Carregar os dados
base_ept <- read_csv("data/base_rs_estadual_ept_2025.csv")

# 2. Resumo geral das estatísticas descritivas
resumo_estatistico <- base_ept %>%
  summarise(
    total_escolas = n(),
    media_temporarios = mean(perc_temporarios, na-rm = TRUE),
    mediana_temporarios = median(perc_temporarios, na-rm = TRUE),
    minimo = min(perc_temporarios, na-rm = TRUE),
    maximo = max(perc_temporarios, na-rm = TRUE)
  )

print(resumo_estatistico)

# 3. Gerar o gráfico de faixas de precarização
grafico_faixas <- ggplot(base_ept, aes(x = factor(faixa_precarizacao))) +
  geom_bar(fill = "#2c3e50", color = "black", alpha = 0.85) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Distribuição das Faixas de Precarização nas Escolas de EPT (RS)",
    subtitle = "Ano-Base: 2025 | Rede Estadual Gaúcha",
    x = "Faixas de Concentração de Professores Temporários",
    y = "Número de Escolas (Unidades)",
    caption = "Fonte: Elaborado pelo autor com base nos microdados do Censo Escolar (INEP, 2026)"
  ) +
  theme_minimal(base_family = "sans") +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5, face = "italic"),
    axis.title = element_text(face = "bold", size = 10),
    panel.grid.minor = element_blank()
  )

# Salvar o gráfico gerado
ggsave("plots/grafico_faixas_reproduzido.png", plot = grafico_faixas, width = 10, height = 6, dpi = 300)
```

---

## 🔒 Proteção de Dados e Conformidade (LGPD)

Em estrita consonância com a **Lei Geral de Proteção de Dados (LGPD — Lei nº 13.709/2018)** e atendendo às políticas de segurança de dados reestruturadas pelo INEP desde 2024, **este repositório não armazena e nem processa dados microindividuais ou informações sensíveis que permitam a identificação direta ou indireta de estudantes ou professores** [227, 455]. 

Todas as bases disponíveis foram anonimizadas e agrupadas por **Unidade de Ensino (Escola)** [455], preservando integralmente o sigilo estatístico e o rigor ético-científico preconizados pela Portaria CNPq nº 2.664/2026 [382].

---

## 📜 Como Citar este Trabalho

Se este repositório, seus dados ou scripts forem úteis para a sua pesquisa acadêmica, por favor, cite a fonte original conforme a norma ABNT NBR 6023:2018:

```text
PAES, Luciano Marcos. **Contratos Temporários e Precarização do Trabalho Pedagógico na Educação Profissional da Rede Estadual do Rio Grande do Sul**. 2026. 25 f. Trabalho de Conclusão de Curso (Especialização em Docência da Educação Profissional e Tecnológica) - Instituto Federal de Educação, Ciência e Tecnologia do Rio Grande do Sul, Campus Sertão, Sertão, RS, 2026. Disponível em: [https://github.com/lucianomarcospaes/dados-tcc-ept]. Acesso em: 12 ago. 2026.
```

---

## 📄 Licença

Este repositório é distribuído sob a licença **Creative Commons Attribution 4.0 International (CC BY 4.0)**. Isso permite que você compartilhe, copie, distribua e adapte os dados e códigos aqui expostos, desde que dê o devido crédito ao autor original.
