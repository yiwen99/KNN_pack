knn1_func <- function(train, test, cl){

  ## check for missing values in the input

  if(sum(is.na(train))!=0){
    stop("no missing values are allowed")
  }
  if(sum(is.na(test))!=0){
    stop("no missing values are allowed")
  }
  if(sum(is.na(cl))!=0){
    stop("no missing values are allowed")
  }
  cl <- factor(cl)
  my_levels <- levels(cl)

  if(is.null(dim(test))){
    test <- t(matrix(test))
  }

  n_test <- nrow(test)
  n_train <- nrow(train)

  #define a function that computes the Euclidean distance between two observations

  distance <- function(a,b){ #a and b are indices of observations, a corresponds to the ath row of test dataset, b corresponds to the bth row of the train dataset
    if(n_test==1){
      diff <- test-train[b,]
      euc_dis <- (sqrt(sum(diff^2)))
      return (euc_dis)
    }
    else{
      diff <- test[a,]-train[b,]
      euc_dis <- (sqrt(sum(diff^2)))
      return (euc_dis)
    }
  }

  vdis <- Vectorize(distance) #make a customized distance function that can do vectorized operations

  #define a function that finds the nearest 1 observation in the training set
  #for each observation in the test set
  find_nearest_1 <- function(dists){
    smallest_dist <- min(dists)

    ind_nearest_k <- which(dists %in% smallest_dist)

    if(length(ind_nearest_k)!=1){
      ind_nearest_k<- sample(ind_nearest_k,1)
    }
    nearest <- cl[ind_nearest_k]
    return (nearest)
  }

  if(n_test==1){ #the input test case is a row vector
    distances_vec <- outer(1, 1:n_train, vdis)

    class_result <- find_nearest_1(distances_vec)
    return (class_result)

  }
  else{#the input test case is a matrix with multiple observations
    distances_mat <- outer(1:n_test, 1:n_train, vdis) #each row i corresponds to distances of that test case i to all points in training test

    class_result <- apply(distances_mat,1,find_nearest_1)
    return (class_result)
  }


}
