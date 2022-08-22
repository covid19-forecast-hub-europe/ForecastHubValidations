tdir <- fs::path(tempdir(), "failed_fh_validations")
fs::dir_create(tdir)
withr::defer(fs::dir_delete(tdir), teardown_env())

fs::dir_copy(
  fs::path_package("HubValidations", "testdata"),
  tdir
)
withr::with_dir(tdir, {
  fs::file_move("testdata/model-metadata/example-model2.yml",
                "testdata/model-metadata/example-model-fail.yml")
  df <- read.csv("testdata/data-processed/example-model/2021-07-19-example-model.csv")
  df$location[1] <- "XXX"
  write.csv(df, "testdata/data-processed/example-model/2021-07-19-example-model.csv", row.names = FALSE)
})

tdir2 <- fs::path(tempdir(), "error_fh_validations")
fs::dir_create(tdir2)
withr::defer(fs::dir_delete(tdir2), teardown_env())

fs::dir_copy(
  fs::path_package("HubValidations", "testdata"),
  tdir2
)

file_to_break <- fs::path(tdir2, "testdata", "schema-data.yml")

d <- readLines(file_to_break)
d[1] <- paste0(d[1], ":")
write(d, file_to_break)

