load(file.path("..", "data-tests", "test_good_rep.rda"))
load(file.path("..", "data-tests", "test_bad_rep.rda"))

context("Valid AIRR format")

test_that("airr::validate_airr detects valid/invalid repertoire file format", {
    suppressWarnings(is_valid <- airr::validate_airr(test_good_rep))
    expect_true(is_valid)
    suppressWarnings(is_valid <- airr::validate_airr(test_bad_rep))
    expect_false(is_valid)
})