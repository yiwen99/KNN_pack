test_that("knn1 works", {
  library(class)
  expect_equal(2 * 2, 4)
  train <- matrix(c(9,2,2,3,9,0,1,9,9,8,2,3,6,9,4,2,3,6),ncol=2)
  cl <- as.factor(c("a","b","b","b","c","c","c","c","c"))
  test1 <- c(2,3.5)

  #check how knn1_func is working on classifying one test case
  my_knn1_output <- knn1_func(train, test1, cl)
  real_knn1_output <- knn1(train, test1, cl)
  expect_equal(my_knn1_output, real_knn1_output)

  #check on randomness of knn1_func when there are two observations
  #in the training set that are both the closest
  set.seed(1)
  train_new <- train
  train_new[8,] <- c(2,2)
  random_1 <- knn1_func(train_new, c(2,2),cl)
  expected_1 <- factor(c("b"),levels=c("a","b","c"))
  expect_equal(random_1, expected_1)

  set.seed(0)
  random_2 <- knn1_func(train_new, c(2,2),cl)
  expected_2 <- factor(c("c"),levels=c("a","b","c"))
  expect_equal(random_2, expected_2)

  #test on error messages


})
