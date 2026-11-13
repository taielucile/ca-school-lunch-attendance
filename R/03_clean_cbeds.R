# 2024-25 CBEDS: school K/TK program types and reported calendar bounds

if (!exists("read_tab_latin1")) stop("Run R/01_clean_enrollment.R first.")

cbeds_raw <- read_tab_latin1(FILES$cbeds)
cbeds <- cbeds_raw[cbeds_raw$Level == "S", , drop = FALSE]

pad14 <- function(x) {
  x <- trimws(as.character(x))
  vapply(x, function(z) {
    if (is.na(z) || z == "") return(NA_character_)
    if (nchar(z) >= 14) return(z)
    paste0(strrep("0", 14 - nchar(z)), z)
  }, character(1))
}
cbeds$cds_code <- pad14(cbeds$Cdscode)

truth <- function(x) tolower(trimws(as.character(x))) == "true"

k_map <- c(
  "Kindergarten Full-day" = "Full-day",
  "Kindergarten Part-day" = "Part-day",
  "Kindergarten Both full and part day" = "Both full and part day",
  "Kindergarten None" = "None"
)
tk_map <- c(
  "Transitional Kindergarten Full-day" = "Full-day",
  "Transitional Kindergarten Part-day" = "Part-day",
  "Transitional Kindergarten Both full and part day" = "Both full and part day",
  "Transitional Kindergarten None" = "None"
)

school_ids <- unique(cbeds$cds_code[!is.na(cbeds$cds_code)])
rows_by_school <- split(seq_len(nrow(cbeds)), cbeds$cds_code)

classify_program <- function(id, map) {
  school <- cbeds[rows_by_school[[id]], , drop = FALSE]
  z <- school$Description[school$Description %in% names(map) & truth(school$Value)]
  z <- unique(z)
  if (length(z) == 0) return(NA_character_)
  if (length(z) > 1) stop("Conflicting CBEDS program classifications for ", id)
  unname(map[z])
}

get_cbeds_value <- function(id, description) {
  school <- cbeds[rows_by_school[[id]], , drop = FALSE]
  z <- unique(school$Value[school$Description == description])
  z <- z[!is.na(z) & trimws(z) != ""]
  if (length(z) == 0) return(NA_character_)
  if (length(z) > 1) stop("Conflicting CBEDS values for ", id, ": ", description)
  z
}

cbeds_clean <- data.frame(
  cds_code = school_ids,
  k_program = vapply(school_ids, classify_program, character(1), map = k_map),
  tk_program = vapply(school_ids, classify_program, character(1), map = tk_map),
  school_start_date = vapply(school_ids, get_cbeds_value, character(1),
                             description = "Start Date"),
  school_end_date = vapply(school_ids, get_cbeds_value, character(1),
                           description = "End Date"),
  stringsAsFactors = FALSE
)

if (anyDuplicated(cbeds_clean$cds_code)) stop("CBEDS clean table is not one row per CDS.")

write.csv(cbeds_clean,
          file.path(DERIVED_DIR, "cbeds_school_programs_2024_25.csv"),
          row.names = FALSE, na = "")
