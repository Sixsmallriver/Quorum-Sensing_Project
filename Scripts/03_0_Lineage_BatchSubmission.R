# load library
library(rmarkdown)

# set path
folder_path <- "../Data/Distance_Results/"

# get files
file_list <- list.files(path = folder_path, pattern = ".*distance\\.csv$", full.names = TRUE)

# print(file_list)

# length of files
total_files <- length(file_list)

# batch process
for (i in seq_along(file_list)) {
  # current one and info
  file <- file_list[i]
  file_name <- tools::file_path_sans_ext(basename(file))
  cat(sprintf("Processing file %d of %d: %s\n", i, total_files, basename(file)))
  
  # render function
  render(
    input = "05_1_lineage.Rmd",
    params = list(file = file),
    output_format = NULL,
    envir = new.env()
  )
  
  # show percentage
  cat(sprintf("Progress: %.2f%%\n", (i / total_files) * 100))
}

cat("Batch processing completed.\n")
