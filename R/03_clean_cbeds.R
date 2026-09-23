# 2024-25 CBEDS: school K/TK program types and reported calendar bounds

if (!exists("read_tab_latin1")) stop("Run R/01_clean_enrollment.R first.")

cbeds_raw <- read_tab_latin1(FILES$cbeds)
cbeds <- cbeds_raw[cbeds_raw$Level == "S", , drop = FALSE]
cbeds$cds_code <- sprintf("%014s", trimws(cbeds$Cdscode))

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

school_ids <- unique(cbeds$cds_code)

classify_program <- function(id, map) {
  z <- cbeds[
    cbeds$cds_code == id &
      cbeds$Description %in% names(map) &
      truth(cbeds$Value), "Description"
  ]
  z <- unique(z)
  if (length(z) == 0) return(NA_character_)
  if (length(z) > 1) stop("Conflicting CBEDS program classifications for ", id)
  unname(map[z])
}

get_cbeds_value <- function(id, description) {
  z <- unique(cbeds[
    cbeds$cds_code == id & cbeds$Description == description, "Value"
  ])
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
