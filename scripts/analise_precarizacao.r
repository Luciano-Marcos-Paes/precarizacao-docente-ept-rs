rm(list = ls())
graphics.off()
cat("\014")
# =========================================================
# PROJETO: Precarização do trabalho docente na EPT - RS
# BASE: Censo Escolar 2025
# VERSÃO: robusta consolidada compatível com pipe nativo |>
# =========================================================

# 1. Pacotes
pacotes <- c("tidyverse", "readr", "janitor", "writexl", "scales")
instalar <- pacotes[!pacotes %in% installed.packages()[, "Package"]]
if (length(instalar) > 0) {
  install.packages(instalar, dependencies = TRUE)
}
invisible(lapply(pacotes, library, character.only = TRUE))

# 2. Diretório padrão
setwd("C:/Users/lucia/Downloads/microdados_censo_escolar_2025/dados")
getwd()

# 3. Funções auxiliares
ler_csv_flex <- function(arquivo) {
  df <- read_delim(
    arquivo,
    delim = ";",
    locale = locale(encoding = "UTF-8"),
    show_col_types = FALSE,
    progress = FALSE
  ) |> clean_names()

  if (ncol(df) == 1) {
    df <- read_delim(
      arquivo,
      delim = ",",
      locale = locale(encoding = "UTF-8"),
      show_col_types = FALSE,
      progress = FALSE
    ) |> clean_names()
  }

  if (ncol(df) == 1) {
    df <- read_delim(
      arquivo,
      delim = "\t",
      locale = locale(encoding = "UTF-8"),
      show_col_types = FALSE,
      progress = FALSE
    ) |> clean_names()
  }

  df
}

pegar_nome <- function(nms, candidatos) {
  achado <- intersect(candidatos, nms)
  if (length(achado) == 0) return(NA_character_)
  achado[1]
}

renomear_se_existir <- function(df, novo, antigo) {
  if (!is.na(antigo) && antigo %in% names(df)) {
    df <- df |> rename(!!novo := all_of(antigo))
  }
  df
}

checar_colunas <- function(df, obrigatorias, nome_df = "objeto") {
  faltantes <- setdiff(obrigatorias, names(df))
  if (length(faltantes) > 0) {
    stop(
      paste0(
        "No objeto ", nome_df, " faltam as colunas obrigatórias: ",
        paste(faltantes, collapse = ", ")
      )
    )
  }
}

# 4. Leitura dos arquivos
escola  <- ler_csv_flex("Tabela_Escola_2025.csv")
docente <- ler_csv_flex("Tabela_Docente_2025.csv")
turma   <- ler_csv_flex("Tabela_Turma_2025.csv")

cat("Dimensões brutas:\n")
cat("escola :", dim(escola), "\n")
cat("docente:", dim(docente), "\n")
cat("turma  :", dim(turma), "\n\n")

cat("Nomes sugestivos em ESCOLA:\n")
print(grep("uf|depend|profission|itiner|entidade|municip|escolarizacao", names(escola), value = TRUE))
cat("\nNomes sugestivos em DOCENTE:\n")
print(grep("entidade|doc|vinculo|vincul|contra|concur|clt|terceir|prof|disc|instrutor", names(docente), value = TRUE))
cat("\nNomes sugestivos em TURMA:\n")
print(grep("entidade|tur|prof|iftp", names(turma), value = TRUE))

# 5. Padronização - ESCOLA
nms_e <- names(escola)
escola_pad <- escola
escola_pad <- renomear_se_existir(escola_pad, "coentidade", pegar_nome(nms_e, c("coentidade", "co_entidade")))
escola_pad <- renomear_se_existir(escola_pad, "noentidade", pegar_nome(nms_e, c("noentidade", "no_entidade")))
escola_pad <- renomear_se_existir(escola_pad, "sguf", pegar_nome(nms_e, c("sguf", "sg_uf")))
escola_pad <- renomear_se_existir(escola_pad, "couf", pegar_nome(nms_e, c("couf", "co_uf")))
escola_pad <- renomear_se_existir(escola_pad, "nomunicipio", pegar_nome(nms_e, c("nomunicipio", "no_municipio")))
escola_pad <- renomear_se_existir(escola_pad, "comunicipio", pegar_nome(nms_e, c("comunicipio", "co_municipio")))
escola_pad <- renomear_se_existir(escola_pad, "tpdependencia", pegar_nome(nms_e, c("tpdependencia", "tp_dependencia")))
escola_pad <- renomear_se_existir(escola_pad, "tplocalizacao", pegar_nome(nms_e, c("tplocalizacao", "tp_localizacao")))
escola_pad <- renomear_se_existir(escola_pad, "inregular", pegar_nome(nms_e, c("inregular", "in_regular")))
escola_pad <- renomear_se_existir(escola_pad, "ineja", pegar_nome(nms_e, c("ineja", "in_eja")))
escola_pad <- renomear_se_existir(escola_pad, "inprofissionalizante", pegar_nome(nms_e, c("inprofissionalizante", "in_profissionalizante")))
escola_pad <- renomear_se_existir(escola_pad, "tpitinerarioformativo", pegar_nome(nms_e, c("tpitinerarioformativo", "tp_itinerario_formativo")))
escola_pad <- renomear_se_existir(escola_pad, "initinerariotecnprof", pegar_nome(nms_e, c("initinerariotecnprof", "in_itinerario_tecn_prof")))
escola_pad <- renomear_se_existir(escola_pad, "inescolarizacao", pegar_nome(nms_e, c("inescolarizacao", "in_escolarizacao")))

# 6. Padronização - DOCENTE
nms_d <- names(docente)
docente_pad <- docente
docente_pad <- renomear_se_existir(docente_pad, "coentidade", pegar_nome(nms_d, c("coentidade", "co_entidade")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocbas", pegar_nome(nms_d, c("qtdocbas", "qtdoc_bas")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocbasdocente", pegar_nome(nms_d, c("qtdocbasdocente", "qtdoc_bas_docente")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocbasvinculoconcur", pegar_nome(nms_d, c("qtdocbasvinculoconcur", "qtdoc_bas_vinculo_concur")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocbasvinculocontra", pegar_nome(nms_d, c("qtdocbasvinculocontra", "qtdoc_bas_vinculo_contra")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocbasvinculoterceir", pegar_nome(nms_d, c("qtdocbasvinculoterceir", "qtdoc_bas_vinculo_terceir")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocbasvinculoclt", pegar_nome(nms_d, c("qtdocbasvinculoclt", "qtdoc_bas_vinculo_clt")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocprof", pegar_nome(nms_d, c("qtdocprof", "qtdoc_prof")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocproftec", pegar_nome(nms_d, c("qtdocproftec", "qtdoc_prof_tec")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocprofnaotec", pegar_nome(nms_d, c("qtdocprofnaotec", "qtdoc_prof_nao_tec")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocbasdiscprofissiona", pegar_nome(nms_d, c("qtdocbasdiscprofissiona", "qtdoc_bas_disc_profissiona")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocbasdiscoutras", pegar_nome(nms_d, c("qtdocbasdiscoutras", "qtdoc_bas_disc_outras")))
docente_pad <- renomear_se_existir(docente_pad, "qtdocbasinstrutorep", pegar_nome(nms_d, c("qtdocbasinstrutorep", "qtdoc_bas_instrutor_ep")))

# 7. Padronização - TURMA
nms_t <- names(turma)
turma_pad <- turma
turma_pad <- renomear_se_existir(turma_pad, "coentidade", pegar_nome(nms_t, c("coentidade", "co_entidade")))
turma_pad <- renomear_se_existir(turma_pad, "qtturbas", pegar_nome(nms_t, c("qtturbas", "qt_tur_bas")))
turma_pad <- renomear_se_existir(turma_pad, "qtturmed", pegar_nome(nms_t, c("qtturmed", "qt_tur_med")))
turma_pad <- renomear_se_existir(turma_pad, "qtturprof", pegar_nome(nms_t, c("qtturprof", "qt_tur_prof")))
turma_pad <- renomear_se_existir(turma_pad, "qtturproftec", pegar_nome(nms_t, c("qtturproftec", "qt_tur_prof_tec")))
turma_pad <- renomear_se_existir(turma_pad, "qtturprofnaotec", pegar_nome(nms_t, c("qtturprofnaotec", "qt_tur_prof_nao_tec")))
turma_pad <- renomear_se_existir(turma_pad, "qtturmediftpct", pegar_nome(nms_t, c("qtturmediftpct", "qt_tur_med_iftpct")))
turma_pad <- renomear_se_existir(turma_pad, "qtturmediftpqp", pegar_nome(nms_t, c("qtturmediftpqp", "qt_tur_med_iftpqp")))

# 8. Seleção
escola_sel <- escola_pad |>
  select(any_of(c(
    "coentidade", "noentidade", "sguf", "couf", "nomunicipio", "comunicipio",
    "tpdependencia", "tplocalizacao", "inregular", "ineja", "inprofissionalizante",
    "tpitinerarioformativo", "initinerariotecnprof", "inescolarizacao"
  )))

docente_sel <- docente_pad |>
  select(any_of(c(
    "coentidade", "qtdocbas", "qtdocbasdocente", "qtdocbasvinculoconcur",
    "qtdocbasvinculocontra", "qtdocbasvinculoterceir", "qtdocbasvinculoclt",
    "qtdocprof", "qtdocproftec", "qtdocprofnaotec", "qtdocbasdiscprofissiona",
    "qtdocbasdiscoutras", "qtdocbasinstrutorep"
  )))

turma_sel <- turma_pad |>
  select(any_of(c(
    "coentidade", "qtturbas", "qtturmed", "qtturprof", "qtturproftec",
    "qtturprofnaotec", "qtturmediftpct", "qtturmediftpqp"
  )))

# 9. Checagens
checar_colunas(escola_sel, c("coentidade", "couf", "tpdependencia"), "escola_sel")
checar_colunas(docente_sel, c("coentidade"), "docente_sel")
checar_colunas(turma_sel, c("coentidade"), "turma_sel")

cat("\nColunas finais de docente_sel:\n")
print(names(docente_sel))

# 10. Recorte RS estadual
escola_rs_estadual <- escola_sel |>
  filter(couf == 43, tpdependencia == 2)

cat("\nNúmero de escolas estaduais do RS:", nrow(escola_rs_estadual), "\n")

# 11. Junção
base_completa <- escola_rs_estadual |>
  left_join(docente_sel, by = "coentidade") |>
  left_join(turma_sel, by = "coentidade") |>
  mutate(across(where(is.numeric), ~replace_na(., 0)))

# 12. Indicadores, subconjunto e resumos
base_tratada <- base_completa

for (col_num in c(
  "qtdocbasvinculocontra", "qtdocbasvinculoconcur", "qtdocbasdocente", "qtdocprof",
  "qtdocproftec", "qtdocprofnaotec", "qtdocbasdiscprofissiona", "inprofissionalizante",
  "initinerariotecnprof", "qtturprof", "qtturproftec", "qtturprofnaotec",
  "qtturmediftpct", "qtturmediftpqp"
)) {
  if (!col_num %in% names(base_tratada)) {
    base_tratada[[col_num]] <- NA_real_
  }
}

base_tratada <- base_tratada |>
  mutate(
    doc_publicos_principais = if_else(
      !is.na(qtdocbasvinculoconcur) | !is.na(qtdocbasvinculocontra),
      coalesce(qtdocbasvinculoconcur, 0) + coalesce(qtdocbasvinculocontra, 0),
      NA_real_
    ),
    perc_temporarios = if_else(
      !is.na(doc_publicos_principais) & doc_publicos_principais > 0,
      coalesce(qtdocbasvinculocontra, 0) / doc_publicos_principais,
      NA_real_
    ),
    perc_efetivos = if_else(
      !is.na(doc_publicos_principais) & doc_publicos_principais > 0,
      coalesce(qtdocbasvinculoconcur, 0) / doc_publicos_principais,
      NA_real_
    ),
    doc_ept = case_when(
      !is.na(qtdocproftec) | !is.na(qtdocprofnaotec) ~ coalesce(qtdocproftec, 0) + coalesce(qtdocprofnaotec, 0),
      !is.na(qtdocprof) ~ qtdocprof,
      TRUE ~ NA_real_
    ),
    peso_ept_docente = if_else(
      !is.na(qtdocbasdocente) & qtdocbasdocente > 0,
      doc_ept / qtdocbasdocente,
      NA_real_
    ),
    escola_ept = if_else(
      coalesce(inprofissionalizante, 0) == 1 |
      coalesce(initinerariotecnprof, 0) == 1 |
      coalesce(doc_ept, 0) > 0 |
      coalesce(qtdocbasdiscprofissiona, 0) > 0 |
      coalesce(qtturprof, 0) > 0 |
      coalesce(qtturproftec, 0) > 0 |
      coalesce(qtturprofnaotec, 0) > 0 |
      coalesce(qtturmediftpct, 0) > 0 |
      coalesce(qtturmediftpqp, 0) > 0,
      1, 0
    ),
    faixa_precarizacao = case_when(
      is.na(perc_temporarios) ~ "Sem base de vínculo completo",
      perc_temporarios == 0 ~ "0%",
      perc_temporarios > 0 & perc_temporarios <= 0.25 ~ "até 25%",
      perc_temporarios > 0.25 & perc_temporarios <= 0.50 ~ "25% a 50%",
      perc_temporarios > 0.50 & perc_temporarios <= 0.75 ~ "50% a 75%",
      perc_temporarios > 0.75 ~ "acima de 75%",
      TRUE ~ "revisar"
    )
  )

cat("\nIndicadores criados com sucesso.\n")
print(intersect(c(
  "doc_publicos_principais", "perc_temporarios", "perc_efetivos",
  "doc_ept", "peso_ept_docente", "escola_ept", "faixa_precarizacao"
), names(base_tratada)))

base_ept_rs <- base_tratada |>
  filter(escola_ept == 1)

cat("\nNúmero de escolas estaduais do RS com EPT:", nrow(base_ept_rs), "\n")
if (nrow(base_ept_rs) == 0) {
  warning("Nenhuma escola foi classificada como EPT no recorte atual.")
}

for (col_num in c(
  "doc_ept", "doc_publicos_principais", "perc_temporarios",
  "qtdocbasdiscprofissiona", "qtturprof", "qtturproftec", "peso_ept_docente", "couf"
)) {
  if (!col_num %in% names(base_ept_rs)) {
    base_ept_rs[[col_num]] <- NA_real_
  }
}
for (col_chr in c("nomunicipio", "noentidade")) {
  if (!col_chr %in% names(base_ept_rs)) {
    base_ept_rs[[col_chr]] <- NA_character_
  }
}

resumo_geral <- base_ept_rs |>
  summarise(
    escolas = n(),
    media_temporarios = mean(perc_temporarios, na.rm = TRUE),
    mediana_temporarios = median(perc_temporarios, na.rm = TRUE),
    min_temporarios = suppressWarnings(min(perc_temporarios, na.rm = TRUE)),
    max_temporarios = suppressWarnings(max(perc_temporarios, na.rm = TRUE)),
    media_doc_publicos = mean(doc_publicos_principais, na.rm = TRUE),
    media_doc_ept = mean(doc_ept, na.rm = TRUE),
    media_doc_disc_prof = mean(qtdocbasdiscprofissiona, na.rm = TRUE),
    media_qttur_prof = mean(qtturprof, na.rm = TRUE)
  )

dist_faixa <- base_ept_rs |>
  count(faixa_precarizacao, sort = TRUE) |>
  mutate(percentual = n / sum(n))

municipios_ept <- base_ept_rs |>
  count(nomunicipio, sort = TRUE)

temporarios_municipio <- base_ept_rs |>
  group_by(nomunicipio) |>
  summarise(
    escolas = n(),
    media_temporarios = mean(perc_temporarios, na.rm = TRUE),
    mediana_temporarios = median(perc_temporarios, na.rm = TRUE),
    media_doc_ept = mean(doc_ept, na.rm = TRUE),
    media_qttur_prof = mean(qtturprof, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(media_temporarios))

ranking_escolas <- base_ept_rs |>
  select(
    coentidade, noentidade, nomunicipio, couf,
    any_of(c(
      "qtdocbasvinculoconcur", "qtdocbasvinculocontra", "doc_publicos_principais",
      "perc_temporarios", "doc_ept", "qtdocbasdiscprofissiona", "qtturprof", "qtturproftec"
    ))
  ) |>
  arrange(desc(perc_temporarios), desc(qtdocbasvinculocontra))

base_comp <- base_tratada
if (!"doc_ept" %in% names(base_comp)) {
  base_comp <- base_comp |> mutate(doc_ept = NA_real_)
}
if (!"doc_publicos_principais" %in% names(base_comp)) {
  base_comp <- base_comp |> mutate(doc_publicos_principais = NA_real_)
}
if (!"perc_temporarios" %in% names(base_comp)) {
  base_comp <- base_comp |> mutate(perc_temporarios = NA_real_)
}
if (!"qtturprof" %in% names(base_comp)) {
  base_comp <- base_comp |> mutate(qtturprof = NA_real_)
}
if (!"escola_ept" %in% names(base_comp)) {
  base_comp <- base_comp |> mutate(escola_ept = NA_real_)
}

comparacao_ept <- base_comp |>
  mutate(grupo_ept = if_else(escola_ept == 1, "Com EPT", "Sem EPT")) |>
  group_by(grupo_ept) |>
  summarise(
    escolas = n(),
    media_temporarios = mean(perc_temporarios, na.rm = TRUE),
    mediana_temporarios = median(perc_temporarios, na.rm = TRUE),
    media_doc_publicos = mean(doc_publicos_principais, na.rm = TRUE),
    media_doc_ept = mean(doc_ept, na.rm = TRUE),
    media_qttur_prof = mean(qtturprof, na.rm = TRUE),
    .groups = "drop"
  )

correlacoes <- tibble(
  variavel = c("doc_ept", "qtdocbasdiscprofissiona", "qtturprof", "qtturproftec", "peso_ept_docente"),
  correlacao_com_perc_temporarios = c(
    suppressWarnings(cor(base_ept_rs$doc_ept, base_ept_rs$perc_temporarios, use = "complete.obs")),
    suppressWarnings(cor(base_ept_rs$qtdocbasdiscprofissiona, base_ept_rs$perc_temporarios, use = "complete.obs")),
    suppressWarnings(cor(base_ept_rs$qtturprof, base_ept_rs$perc_temporarios, use = "complete.obs")),
    suppressWarnings(cor(base_ept_rs$qtturproftec, base_ept_rs$perc_temporarios, use = "complete.obs")),
    suppressWarnings(cor(base_ept_rs$peso_ept_docente, base_ept_rs$perc_temporarios, use = "complete.obs"))
  )
)

# 13. Saídas
if (!dir.exists("saida_r")) dir.create("saida_r")

write_csv(base_tratada, "saida_r/base_rs_estadual_completa_2025.csv")
write_csv(base_ept_rs, "saida_r/base_rs_estadual_ept_2025.csv")
write_csv(ranking_escolas, "saida_r/ranking_escolas_ept_temporarios_2025.csv")
write_csv(temporarios_municipio, "saida_r/municipios_temporarios_ept_2025.csv")
write_csv(comparacao_ept, "saida_r/comparacao_ept_sem_ept_2025.csv")
write_csv(dist_faixa, "saida_r/distribuicao_faixas_precarizacao_2025.csv")
write_csv(correlacoes, "saida_r/correlacoes_exploratorias_2025.csv")
write_csv(resumo_geral, "saida_r/resumo_geral_2025.csv")
write_csv(municipios_ept, "saida_r/municipios_com_escolas_ept_2025.csv")

write_xlsx(
  list(
    base_rs_estadual_completa = base_tratada,
    base_rs_estadual_ept = base_ept_rs,
    resumo_geral = resumo_geral,
    distribuicao_faixa = dist_faixa,
    municipios_com_ept = municipios_ept,
    municipios_temporarios = temporarios_municipio,
    ranking_escolas = ranking_escolas,
    comparacao_ept = comparacao_ept,
    correlacoes = correlacoes
  ),
  "saida_r/resultados_precarizacao_ept_rs_2025.xlsx"
)

# 14. Gráficos
if (nrow(base_ept_rs) > 0) {
  grafico_faixa <- base_ept_rs |>
    count(faixa_precarizacao) |>
    ggplot(aes(x = reorder(faixa_precarizacao, n), y = n)) +
    geom_col(fill = "#1f4e79") +
    coord_flip() +
    labs(
      title = "Escolas estaduais do RS com EPT por faixa de temporários",
      x = "Faixa de temporários",
      y = "Número de escolas"
    ) +
    theme_minimal()

  ggsave("saida_r/grafico_faixa_precarizacao.png", grafico_faixa, width = 10, height = 6, dpi = 300)

  grafico_disp <- base_ept_rs |>
    ggplot(aes(x = doc_ept, y = perc_temporarios)) +
    geom_point(alpha = 0.7, color = "#8b0000") +
    geom_smooth(method = "lm", se = FALSE, color = "#1f4e79") +
    scale_y_continuous(labels = percent_format(accuracy = 1)) +
    labs(
      title = "Docentes da EPT e percentual de temporários",
      x = "Número de docentes da EPT",
      y = "Percentual de temporários"
    ) +
    theme_minimal()

  ggsave("saida_r/grafico_doc_ept_temporarios.png", grafico_disp, width = 10, height = 6, dpi = 300)

  grafico_municipios <- temporarios_municipio |>
    filter(!is.na(nomunicipio)) |>
    slice_max(order_by = media_temporarios, n = min(15, n()), with_ties = FALSE) |>
    ggplot(aes(x = reorder(nomunicipio, media_temporarios), y = media_temporarios)) +
    geom_col(fill = "#4d648d") +
    coord_flip() +
    scale_y_continuous(labels = percent_format(accuracy = 1)) +
    labs(
      title = "15 municípios com maior média de temporários nas escolas estaduais com EPT",
      x = "Município",
      y = "Média de temporários"
    ) +
    theme_minimal()

  ggsave("saida_r/grafico_municipios_temporarios.png", grafico_municipios, width = 11, height = 7, dpi = 300)
}

cat("\nProcessamento concluído com sucesso.\n")
cat("Arquivos salvos em:", file.path(getwd(), "saida_r"), "\n")
cat("Planilha principal: saida_r/resultados_precarizacao_ept_rs_2025.xlsx\n")
