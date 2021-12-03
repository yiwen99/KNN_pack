test_that("knn works", {
  #expect_equal(2 * 2, 4)
  train <- matrix(c(9,2,2,3,9,0,1,9,9,8,2,3,6,9,4,2,3,6),ncol=2)
  cl <- as.factor(c("a","b","b","b","c","c","c","c","c"))
  test1 <- c(2,3.5)
  my_knn_output <- knn_func(train,test1, cl, 3, prob=TRUE)
  library(class)
  real_knn_output <- knn(train=train, test=test1, cl=cl, k=3, prob=TRUE)
  # check how knn_func is working on classifying 1 test case,
  #with prob parameter set to be TRUE
  expect_equal(my_knn_output, real_knn_output)

  #check how knn_func is working on classifying 1 test case,
  #with prob parameter set to be FALSE
  my_knn_output1 <- knn_func(train,test1, cl, 3, prob=FALSE)
  real_knn_output1 <- knn(train=train, test=test1, cl=cl, k=3, prob=FALSE)
  expect_equal(my_knn_output1, real_knn_output1)

  test <- matrix(c(2,9,3.5,7.5),ncol=2)
  my_knn_output2 <- knn_func(train, test, cl, k=3, prob=TRUE)
  real_knn_output2 <- knn(train=train, test=test, k=3, cl=cl, prob=TRUE)
  #check how knn_func is working on classifying multiple test cases,
  #with prob parameter set to be TRUE
  expect_equal(my_knn_output2, real_knn_output2)

  #check how knn_func is working on classifying multiple test cases,
  #with prob parameter set to be FALSE
  my_knn_output3 <- knn_func(train, test, cl, k=3, prob=FALSE)
  real_knn_output3 <- knn(train, test, cl, k=3, prob=FALSE)
  expect_equal(my_knn_output3, real_knn_output3)

  ##check on error messages

})
